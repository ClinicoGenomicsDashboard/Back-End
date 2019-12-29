import java.util.*;
import java.io.*;

public class TemplateMaker {
	public static void main(String[] args) throws FileNotFoundException{
		Scanner in = new Scanner(new File("booltemps"));
		String s;
		PrintWriter out = new PrintWriter(new File("tmp.txt"));
		while (in.hasNextLine()) {
			s = in.nextLine();
			if (s.equals("SEPARATOR123")) {
				s = in.nextLine();
				out.close();
				out = new PrintWriter(new File("../" + s + ".txt"));
			} else {
				out.println(s);
			}
		}
		out.close();
		in.close();
	}
}
