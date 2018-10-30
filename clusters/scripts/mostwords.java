import java.util.*;
import java.io.*;
public class mostwords {
	public static void main(String[] args) throws Exception {
		for (int i = 0; i < 300; i++) {
			Scanner in = new Scanner(new File("./final340numclusters/clust_" + i + ".txt"));
			PrintWriter out = new PrintWriter(new File("./commonwords340/words_" + i + ".txt"));
			Map<String, Integer> instances = new HashMap<String, Integer>();
			while (in.hasNext()) {
				
			}
			in.close();
			out.close();
		}
	}
}
