import java.util.*;
import java.io.*;
import java.net.*;
public class webscraping {
  public static void main(String[] args) throws Exception {
    HashSet<String> rawsources = new HashSet<String>();
    for (int i = 1901; i <= 2682; i++) {
      String k = getURLSource("http://www.pdr.net/drug-information/?druglabelid=" + i);
      if (!k.equals("")) rawsources.add(k);
    }
    HashSet<String> summaryurls = new HashSet<String>();
    for (String source : rawsources) {
      int index = source.indexOf("title=\"Drug Summary\"");
      if (index >= 0) {
        ArrayList<Integer> indices = new ArrayList<Integer>();
        int ind = source.indexOf("<li><a href=\"");
        while (ind >= 0) {
          indices.add(ind);
          ind = source.indexOf("<li><a href=\"", ind+1);
        }
        int findex = 0;
        if (indices.size() > 0) {
          int prev = 0;
          for (int j : indices) {
            if (j > index) break;
            else prev = j;
          }
          findex = prev;
        }
        summaryurls.add(source.substring(findex + 13, index-2));
      }
    }
    HashSet<String> summarysources = new HashSet<String>();
    for (String url : summaryurls) {
      String k = getURLSource(url);
      if (!k.equals("")) summarysources.add(k);
    }//summarysources.add(getURLSource(url));
    Scanner in = new Scanner(new File("cleanedcsv.csv"));
    HashMap<String, String> nametoid = new HashMap<String, String>();
    while (in.hasNext()) {
      String[] line = parse(in.nextLine());
      if (line.length > 1 && line[1] != null) nametoid.put(line[1].toLowerCase(), line[0]);
    }
    PrintWriter out = new PrintWriter(new File("pdrdata1901-2682.csv"));
    for (String source : summarysources) {
      int index = source.indexOf("<title>");
      int lindex = source.indexOf("dose");
      String drugname = source.substring(index+8, lindex-2);
      int paren = drugname.indexOf("(");
      String name = drugname.substring(paren+1);
      String[] parts = name.split(" ");
      String id = "";
      for (int i = 0; i < parts.length && id.equals(""); i++) {
        String check = "";
        for (int j = 0; j <= i; j++) check = parts[parts.length - j - 1] + check;
        if (nametoid.containsKey(check)) id = nametoid.get(check);
      }
      if (id.equals("") && parts[0].contains("/")) {
        String[] slash = parts[0].split("/");
        if (nametoid.containsKey(slash[0])) id = nametoid.get(slash[0]);
        if (nametoid.containsKey(slash[1])) id = id + nametoid.get(slash[1]);
      }
      ArrayList<Integer> indices = new ArrayList<Integer>();
      ArrayList<Integer> endindices = new ArrayList<Integer>();
      int ind = source.indexOf("<strong>For");
      while (ind >= 0) {
        indices.add(ind);
        endindices.add(source.indexOf("</strong>", ind+1));
        ind = source.indexOf("<strong>For", ind+1);
      }
      String indications = "";
      for (int i = 0; i < indices.size(); i++) indications = indications + "***" + source.substring(indices.get(i)+8, endindices.get(i)-1);
      int contraindex = source.indexOf("<h3 class=\"drugSummary\">CONTRAINDICATIONS / PRECAUTIONS</h3>");
      int contraind = source.indexOf("<strong>", contraindex);
      int endind = source.indexOf(" </div", contraind);
      ArrayList<Integer> contraindices = new ArrayList<Integer>();
      ArrayList<Integer> contraend = new ArrayList<Integer>();
      while (contraind >= 0 && contraind < endind) {
        contraindices.add(contraind);
        contraend.add(source.indexOf("</strong>", contraind+1));
        contraind = source.indexOf("<strong>", contraind+1);
      }
      String contraindications = "";
      for (int i = 0; i < contraindices.size(); i++) contraindications = contraindications + "***" + source.substring(contraindices.get(i)+8, contraend.get(i));
      out.println(id + "," + name + ",\"" + indications + "\"" + ",\"" + contraindications + "\"");
    }
    in.close();
    out.close();
  }
  static String[] parse(String in) {
    boolean inQuotes=false;
    int size = 1;
    for (int i = 0; i < in.length(); i++) {
      char j = in.charAt(i);
      if (j == '\"') {
        inQuotes=!inQuotes;
      }
      if (!inQuotes && j == ',') size++;
    }
    String[] out = new String[size];
    String cur = "";
    int index = 0;
    for (int i = 0; i < in.length(); i++) {
      char j = in.charAt(i);
      if (j == '\"') {
        inQuotes=!inQuotes;
      }
      else if (!inQuotes && j == ',') {
        out[index] = cur;
        index++;
        cur = "";
      }
      else cur = cur + j;
    }
    return out;
  }
  public static String getURLSource(String url) throws IOException
    {
        URL urlObject = new URL(url);
        URLConnection urlConnection = urlObject.openConnection();
        urlConnection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11");
        try {
        return toString(urlConnection.getInputStream());}catch(Exception e) {return "";}
    }
  private static String toString(InputStream inputStream) throws IOException
    {
        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8")))
        {
            String inputLine;
            StringBuilder stringBuilder = new StringBuilder();
            while ((inputLine = bufferedReader.readLine()) != null)
            {
                stringBuilder.append(inputLine);
            }

            return stringBuilder.toString();
        }
    }
}
