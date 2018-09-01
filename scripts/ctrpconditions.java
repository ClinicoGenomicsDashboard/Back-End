import java.util.*;
import java.io.*;
import java.net.*;
public class ctrpscrape {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(new File("fullctrpids.csv"));
    PrintWriter out = new PrintWriter(new File("ctrpconds.csv"));
    String useless = in.nextLine();
    int count = 0;
    while(in.hasNext()) {
      System.out.println(count);
      count++;
      String id = in.nextLine();
      String source = getURLSource("https://www.clinicaltrials.gov/ct2/show/record/"+id+"?term="+id+"&rank=1");
      int index = source.indexOf("<td", source.indexOf("Condition&nbsp"));
      int end = source.indexOf("/td", index);
      if (index > 0) {
        ArrayList<Integer> startinds = new ArrayList<Integer>();
        ArrayList<Integer> endinds = new ArrayList<Integer>();
        while (index > 0 && index < end) {
          if (source.charAt(index+2) != '<') {
            startinds.add(index);
            endinds.add(source.indexOf("<", index));
          }
          index = source.indexOf("\">", index+1);
        }
        ArrayList<String> strings = new ArrayList<String>();
        for (int i = 0; i < startinds.size(); i++) strings.add(source.substring(startinds.get(i) + 2, endinds.get(i)).replaceAll("\"", "").replaceAll("\r\n", "").replaceAll("\n\r", ""));
        out.print(id + ",");
        for (int i = 0; i < strings.size(); i++) {
          out.print("\"" + strings.get(i) + "\"");
          if (i < strings.size() - 1) out.print(",");
        }
        out.println();
      }
    }
    in.close();
    out.close();
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
