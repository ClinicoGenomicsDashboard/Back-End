import java.util.*;
import java.io.*;
public class cleaninds {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("ctrpinds.csv"));
		PrintWriter out = new PrintWriter(new File("cleanctrpinds.csv"));
		while (in.hasNext()) {
			String line = in.nextLine();
			int count = 0;
			String id = "";
			String link = "";
			String cur = "";
			boolean breaker = false;
			int i = 0;
			for ( ; i < line.length(); i++) {
				if (line.charAt(i) == ',') {
					if (id.equals("")) id = cur;
					else {
						link = cur;
						breaker = true;
					}
					cur = "";
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
				System.out.println(trudex + " " + faldex + " " + i + " " + dex + " " + line);
				out.println(id + "," + link + "," + line.substring(i+1, dex + 5 + toAdd));
				i = dex + 5 + toAdd;
				trudex = line.indexOf(",true", i);
				faldex = line.indexOf(",false", i);
			}
		}
		in.close();
		out.close();
	}
}
