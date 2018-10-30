import java.util.*;
import java.io.*;
public class cleanfiles {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("cleanctrpinds.csv"));
		PrintWriter out = new PrintWriter(new File("cleanedctrpinds.csv"));
		while(in.hasNext()) out.println(in.nextLine().replaceAll("[^\\p{ASCII}]", "").replaceAll("0", "").replaceAll("1", "").replaceAll("2", "").replaceAll("3", "").replaceAll("4", "").replaceAll("5", "").replaceAll("6", "").replaceAll("7", "").replaceAll("8", "").replaceAll("9", ""));
		in.close();
		out.close();
	}
}
