import java.util.*;
import java.io.*;
public class clustall9k {
	public static void main(String[] args) throws Exception {
		for (int i = 0; i < 600; i++) {
			Scanner cent = new Scanner(new File("./mega9kclust/mgclust_" + i + ".txt"));
			PrintWriter out = new PrintWriter(new File("./clustall9k/" + i + ".txt"));
			while (cent.hasNext()) {
				String k = cent.nextLine();
				int j  = Integer.parseInt(k.split(" ")[1].substring(0, k.split(" ")[1].length()-1));
				System.out.println(j);
				Scanner txt = new Scanner(new File("./final9knumclusters/clust_" + j + ".txt"));
				while (txt.hasNext()) out.println(txt.nextLine());
			}
			out.close();
			cent.close();
		}
	}
	static String removeClust(String input, int len) {
		String[] terms = input.split(" ");
		String out = terms[len];
		for (int i = len; i < terms.length; i++) out = out + " " + terms[i];
		return out;
	}
}
