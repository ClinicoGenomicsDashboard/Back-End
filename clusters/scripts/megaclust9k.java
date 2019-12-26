import java.util.*;
import java.io.*;
public class megaclust9k {
	public static void main(String[] args) throws Exception {
		Scanner in = new Scanner(new File("./final9knumclusters/centers.txt"));
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		while (in.hasNext()) {
			String[] parts = in.nextLine().split(" ");
			int num = Integer.parseInt(parts[1].substring(0,parts[1].length()-1));
			String text = parts[2];
			for (int i = 3; i < parts.length; i++) text = text + " " + parts[i];
			map.put(text, num);
			System.out.println(text + "FJIOSJFIOJDAJIO" + num);
		}
		System.out.println("--------------------------------------------------------------------");
		for (int i = 0; i < 600; i++) {
			Scanner ord = new Scanner(new File("./center9kclusters/clust_" + i + ".txt"));
			PrintWriter out = new PrintWriter(new File("./mega9kclust/mgclust_" + i + ".txt"));
			while (ord.hasNext()) {
				String k = ord.nextLine();
				System.out.println(k.substring(0,k.length()-1)  + "fji");
				int j  = map.get(k.substring(0,k.length()-1));
				System.out.println(j);
				out.println("Cluster " + j + ": " + k);
			}
			ord.close();
			out.close();
		}
		in.close();
	}
}
