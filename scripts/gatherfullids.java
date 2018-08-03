import java.util.*;
import java.io.*;
import java.net.*;
public class gatherfullids {
  public static void main(String[] args) throws Exception {
    PrintWriter out = new PrintWriter(new File("fullctrpinds.csv"));
    for (int i = 0; i < 9455; i+=50) {
      String source = getURLSource("https://clinicaltrialsapi.cancer.gov/v1/clinical-trials?size=50&from=" + i + "&study_protocol_type=interventional&include=nct_id");
      int index = source.indexOf("NCT");
      while (index != -1) {
        out.println(source.substring(index, index + 11));
        index = source.indexOf("NCT", index+1);
      }
    }
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
