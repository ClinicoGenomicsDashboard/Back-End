import java.util.*;
import java.io.*;
public class participants {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("ctrpdata.csv"));
		PrintWriter out = new PrintWriter(new File("ctrpparts.csv"));
		while (in.hasNext()) {
			String[] terms = in.nextLine().split(",");
			out.println(terms[0] + "," + terms[1]);
		}
		in.close();
		out.close();
	}
}
