import java.util.*;
import java.io.*;
public class organize9kclusters {
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
		int count = 0;
		PrintWriter centers = new PrintWriter(new File("./ordered9kclusters/centers.txt"));
		for (int i = 0; i < 600; i++) {
			Scanner ord = new Scanner(new File("./center9kclusters/clust_" + i + ".txt"));
			while (ord.hasNext()) {
				String k = ord.nextLine();
				//k = k.substring(0, k.length()-1);
				System.out.println(k + "fji");
				for (String x : map.keySet()) if (x.split(" ")[0].equals("nervous")) System.out.println(x);
				int j  = map.get(k);
				centers.println("Cluster " + count + ": " + k);
				Scanner clust = new Scanner(new File("./final9knumclusters/clust_" + j + ".txt"));
				PrintWriter out = new PrintWriter(new File("./ordered9kclusters/clust_" + count + ".txt"));
				while (clust.hasNext()) out.println(clust.nextLine());
				count++;
				clust.close();
				out.close();
			}
			ord.close();
		}
		in.close();
		centers.close();
	}
}
