import java.util.*;
import java.io.*;
import java.net.*;
public class ctfullscrape {
  public static void main(String[] args) throws Exception {
    PrintWriter out = new PrintWriter(new File("ctinds2.csv"));
    int count = 0;
    int idnum = 17000000;
    while(idnum <= 99999999) {
      System.out.println(idnum);
      count++;
      String id = toId(idnum);
      idnum++;
      String source = getURLSource("https://clinicaltrialsapi.cancer.gov/v1/clinical-trials?nct_id=" + id);
      if (source.equals("{\"total\":0,\"trials\":[]}")) {
        System.out.println("oh no");
        continue;
      }
      else System.out.println("yay!");
      int index = source.indexOf("display_order");
      if (index > 0) {
        ArrayList<Integer> indices = new ArrayList<Integer>();
        ArrayList<Integer> startinds = new ArrayList<Integer>();
        ArrayList<Integer> endinds = new ArrayList<Integer>();
        ArrayList<Integer> indinds = new ArrayList<Integer>();
        while (index > 0) {
          indices.add(index);
          startinds.add(source.indexOf("description", index));
          endinds.add(source.indexOf("}", index));
          indinds.add(source.indexOf("inclusion_indicator", index));
          index = source.indexOf("display_order", index+1);
        }
        ArrayList<String> strings = new ArrayList<String>();
        ArrayList<Boolean> ind = new ArrayList<Boolean>();
        for (int i = 0; i < startinds.size(); i++) strings.add(source.substring(startinds.get(i) + 14, endinds.get(i)-1).replaceAll("\"", "").replaceAll("\r\n", "").replaceAll("\n\r", ""));
        for (int i = 0; i < indinds.size(); i++) {
          if (source.charAt(indinds.get(i) + 21) == 't') ind.add(true);
          else ind.add(false);
        }
        out.print(id + ",");
        for (int i = 0; i < strings.size(); i++) {
          out.print("\"" + strings.get(i) + "\"," + ind.get(i));
          if (i < strings.size() - 1) out.print(",");
        }
        out.println();
      }
    }
    out.close();
  }
  public static String toId(int idnum) {
    String x = idnum + "";
    while(x.length()<8) x = "0" + x;
    return "NCT" + x;
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

