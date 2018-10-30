import java.util.*;
import java.io.*;
public class centercleaner {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("final340numclusters/centers.txt"));
		PrintWriter out = new PrintWriter(new File("cleancenters.txt"));
		while (in.hasNext()) {
			String[] terms = in.nextLine().split(" ");
			for (int i = 2; i < terms.length; i++) out.print(terms[i] + " ");
			out.println();
		}
		in.close();
		out.close();
	}
}
