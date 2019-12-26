import java.util.*;
import java.io.*;
public class clustall {
	public static void main(String[] args) throws Exception {
		Scanner cent = new Scanner(new File("./centers_tagged_neworderHariEditableForTemplates.txt"));
		HashSet<Integer> used = new HashSet<Integer>();
		while(cent.hasNext()) {
			String next = removeClust(cent.nextLine(), 1);
			PrintWriter out = new PrintWriter(new File("./clustall/" + next.substring(0,next.length()/2) + ".txt"));
			String k = cent.nextLine();
			while (!k.equals("")) {
				int j  = Integer.parseInt(k.split(" ")[1].substring(0, k.split(" ")[1].length()-1));
				System.out.println(j);
				used.add(j);
				Scanner txt = new Scanner(new File("./orderedclusters_old/clust_" + j + ".txt"));
				while (txt.hasNext()) out.println(txt.nextLine());
				k = cent.nextLine();
			}
			out.close();
		}
		System.out.println("---------");
		for (int i = 0; i < 300; i++) if (!used.contains(i)) System.out.println(i);
		cent.close();
	}
	static String removeClust(String input, int len) {
		String[] terms = input.split(" ");
		String out = terms[len];
		for (int i = len; i < terms.length; i++) out = out + " " + terms[i];
		return out;
	}
}
