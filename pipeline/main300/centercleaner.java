import java.util.*;
import java.io.*;
public class centercleaner {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("3009knumclusters/centers.txt"));
		PrintWriter out = new PrintWriter(new File("clean3009kcenters.txt"));
		while (in.hasNext()) {
			String[] terms = in.nextLine().split(" ");
			System.out.println(terms[0] + " " + terms[1] + " " + terms[2]);
			for (int i = 2; i < terms.length; i++) out.print(terms[i] + " ");
			out.println();
		}
		in.close();
		out.close();
	}
}
