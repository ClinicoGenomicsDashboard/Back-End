import java.util.*;
import java.io.*;
public class addquotes {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("./clustall9k/1.txt"));
		PrintWriter out = new PrintWriter(new File("./quotes1.txt"));
		while (in.hasNext()) {
			out.println("\"" + in.nextLine() + "\"");
		}
		in.close();
		out.close();
	}
}
