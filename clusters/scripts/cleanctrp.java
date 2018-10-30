import java.util.*;
import java.io.*;
public class cleanctrp {
	public static void main(String[] args) throws Exception {
		Scanner bin = new Scanner(new File("ctrpinds.csv"));
		PrintWriter out = new PrintWriter(new File("cleanctrpinds.csv"));
		while (bin.hasNext()) {
			String line = bin.nextLine();
			int count = 0;
			String id = "";
			String cur = "";
			boolean breaker = false;
			int i = 0;
			for ( ; i < line.length(); i++) {
				if (line.charAt(i) == ',') {
					id = cur;
					breaker = true;
				}
				else cur = cur + line.charAt(i);
				if (breaker) break;
			}
			int dex = i;
			int trudex = line.indexOf(",true", dex);
			int faldex = line.indexOf(",false", dex);
			while (trudex != -1 || faldex != -1) {
				dex = faldex;
				int toAdd = 1;
				if (faldex == -1 || trudex < faldex && trudex != -1) {
					dex = trudex;
					toAdd = 0;
				}
				out.println(id + "," + line.substring(i+1, dex + 5 + toAdd));
				i = dex + 5 + toAdd;
				trudex = line.indexOf(",true", i);
				faldex = line.indexOf(",false", i);
			}
		}
		bin.close();
		out.close();
	}
}
