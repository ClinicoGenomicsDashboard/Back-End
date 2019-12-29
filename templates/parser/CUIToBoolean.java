/*
The patient data should be formatted as follows:
VARIABLE, VALUE
VARIABLE1, VALUE1, VARIABLE2, VALUE2
.
.
.

All units should be UCUM standard units

The qualifications should be in standard booleanized form with CUI codes and UCUM units

For both files, there should be spaces surrounding every boolean operator:
ex. (C0000000 * 0.5) = C0000001
*/

import java.io.*;
import java.util.*;
import java.net.*;

public class CUIToBoolean {

	final static int CUILength = 8;
	final static String[] nonUnits = {
		"not",
		"or",
		"and",
		"True",
		"False",
		"*",
		"/",
		"+",
		"-",
		">=",
		"<=",
		"=",
		">",
		"<",
		""
	};

	public static void main(String[] args) throws Exception {
		// Scanner stdin = new Scanner(System.in);
		// System.out.println("Enter the location of the file containing patient data.");
		// Scanner dataFile = new Scanner(new File(stdin.nextLine()));
		Scanner dataFile = new Scanner(new File(args[0]));
		// System.out.println("Enter the location of the file containing the qualifications.");
		// Scanner qualsFile = new Scanner(new File(stdin.nextLine()));
		Scanner qualsFile = new Scanner(new File(args[1]));

		List<String> data = new ArrayList<>();
		while (dataFile.hasNextLine()) data.add(dataFile.nextLine());
		dataFile.close();

		String quals = "";
		while (qualsFile.hasNextLine()) quals += qualsFile.nextLine();
		qualsFile.close();

		int prev = -1;
		
		for (int i = 0; i < quals.length(); i++) {
			if (quals.charAt(i) == '=') { // if evaluating an equality statement
				String a = nextCUI(quals, i + 2);
				String b = prevCUI(quals, i - 2);
				if (a.charAt(0) == 'C' && b.charAt(0) == 'C') {
					if (b.length() < 1) break;

					// Search for a CUI code that matches in the later terms
					if (prev != -1) {
						if (data.get(prev).indexOf(a + " = " + b) != -1 || data.get(prev).indexOf(b + " = " + a) != -1) {
							quals = quals.substring(0, i - CUILength - 1) + " True " + quals.substring(quals.indexOf('C', i + 1) + CUILength);
							continue;
						}
					}

					boolean foundCUI = false;

					// Search for a CUI code that matches in the first terms
					for (int j = 0; j < data.size(); j++) { // search for a CUI code that matches in the first term
						if (data.get(j).substring(0, CUILength).equals(a) || data.get(j).substring(0, CUILength).equals(b)) { // if the CUI codes are equal
							if (data.get(j).indexOf(a + " = " + b) != -1 || data.get(j).indexOf(b + " = " + a) != -1) {
								prev = j;
								quals = quals.substring(0, i - CUILength - 1) + " True " + quals.substring(quals.indexOf('C', i + 1) + CUILength);
								foundCUI = true;
								break;
							}
						}
					}

					if (foundCUI) continue;

					quals = quals.substring(0, i - CUILength - 1) + " False " + quals.substring(quals.indexOf('C', i + 1) + CUILength);	
				}

			} else if (quals.charAt(i) == 'C' && (i + CUILength + 3 >= quals.length() || quals.charAt(i + CUILength + 3) != 'C' || quals.charAt(i + CUILength + 1) != '=')) {
				String a = nextCUI(quals, i);

				boolean foundCUI = false;

				if (prev != -1) {
					if (data.get(prev).indexOf(a) != -1) {
						for (int x = 0; x < data.get(prev).length() - CUILength; x++) {
							if (data.get(prev).substring(x, x + CUILength).equals(a) && isNumber(data.get(prev).substring(x + CUILength + 3))) {
								String num = nextCUI(data.get(prev), x + CUILength + 3);
								quals = quals.substring(0, i) + num + " " + nextCUI(data.get(prev), x + CUILength + 3 + num.length() + 1);
								foundCUI = true;
								break;
							}
						}
					}
				}

				if (foundCUI) continue;

				for (int j = 0; j < data.size(); j++) {
					if (data.get(j).substring(0, CUILength).equals(a)) {
						prev = j;
						String num = nextCUI(data.get(prev), CUILength + 3);
						quals = quals.substring(0, i) + num + " " + nextCUI(data.get(prev), CUILength + 3 + num.length() + 1) + quals.substring(i + CUILength);
						foundCUI = true;
						break;
					}
				}

				if (!foundCUI) {
					System.out.println("Error: CUI not found in patient data");
					return;
				}

			}

		}

		quals = quals.replaceAll("!", " not ");
		quals = quals.replaceAll("AND", " and ");
		quals = quals.replaceAll("OR", " or ");

		String[] words = quals.split(" ");
		
		int prevIndex = -1;
		for (int i = 0; i < words.length; i++) {
			if (isUnit(words[i])) {
				if (prevIndex == -1) {
					prevIndex = i;
				} else {
					int[] firstIndexes = getUnitBounds(words[prevIndex]);
					int[] secondIndexes = getUnitBounds(words[i]);
					words[prevIndex] = words[prevIndex].substring(0, firstIndexes[0]) + " * " + convert(words[prevIndex], words[i]) + words[prevIndex].substring(firstIndexes[1]);
					words[i] = words[i].substring(0, secondIndexes[0]) + words[i].substring(secondIndexes[1]);
					prevIndex = -1;
				}
			}
		}

		quals = String.join(" ", words);

		System.out.println(quals);

	}

	// Checks if a given String is a unit
	static boolean isUnit(String s) {
		String s1 = s.replaceAll("[()]", "");
		for (String n : nonUnits) {
			if (s1.equals(n)) return false;
		}
		if (isNumber(s1)) return false;
		System.out.println(s1);
		return true;
	}
	
	// Returns {start index of unit, end index of unit} in a String
	static int[] getUnitBounds(String s) {
		int a, b;
		for (a = 0; a < s.length(); a++) {
			if ("()".indexOf(s.charAt(a)) == -1) break;
		}
		for (b = s.length(); b > 0; b--) {
			if ("()".indexOf(s.charAt(b - 1)) == -1) break;
		}
		int[] res = {a, b};
		return res;
	}

	// Gets the HTML source code of a website with a given url
	static String getHTML(String urlString) throws Exception {
		URL url = new URL(urlString);
		Scanner in = new Scanner(new InputStreamReader(url.openStream()));
		String res = "";
		while (in.hasNextLine()) {
			res += in.nextLine();
		}
		in.close();
		return res;
	}

	// Converts the standard UCUM string start to another unit defined by to
	static String convert(String start, String to) throws Exception {
		String html = getHTML("https://ucum.nlm.nih.gov/ucum-service/v1/ucumtransform/from/" + start + "/to/" + to);
		System.out.println("https://ucum.nlm.nih.gov/ucum-service/v1/ucumtransform/from/" + start + "/to/" + to);
		int index = html.indexOf("</ResultQuantity>") - 1;
		String res = "";
		while (html.charAt(index) != '>') {
			res = html.charAt(index) + res;
			index--;
		}
		return(res);
	}

	// Checks if a String is a number
	static boolean isNumber(String s) {
		try {
			Integer.parseInt(s);
		} catch (NumberFormatException | NullPointerException nfe) {
			return false;
		}
		return true;
	}

	// Gets the next CUI code/word in a String after index (inclusive)
	static String nextCUI(String s, int index) {
		for (int i = index + 1; i < s.length(); i++) {
			if (" ()".indexOf(s.charAt(i)) != -1) return s.substring(index, i);
		}
		return s.substring(index);
	}

	// Gets the previous CUI code/word in a String before index (inclusive)
	static String prevCUI(String s, int index) {
		for (int i = index; i >= 0; i--) {
			if (" ()".indexOf(s.charAt(i)) != -1) return s.substring(i + 1, index + 1);
		}
		return s.substring(0, index + 1);
	}
	
}

