import java.util.*;
import java.io.*;
import gov.nih.nlm.nls.skr.*;
public class ctsamplemetamap {
  static GenericObject gj = new GenericObject();
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(new File("ctsampleinds.csv"));
    PrintWriter out = new PrintWriter(new File("sample_output_full.csv"));
    int count = 0;
    for (int i = 0; i < 339; i++) {
      System.out.println(count);
      count++;
      String line = in.nextLine();
      boolean inQuotes = false;
      boolean inApos = false;
      ArrayList<String> terms = new ArrayList<String>();
      String term = "";
      for (int i = 0; i < line.length(); i++) {
        if (line.charAt(i) != ',' || inQuotes) {
          if (line.charAt(i) == '\"') inQuotes = !inQuotes;
          else term = term + line.charAt(i);
        }
        else {
          if (!inQuotes) {terms.add(term); term = "";}
        }
      }
      terms.add(term);
      out.print(terms.get(0) + "," + terms.get(1) + ",\"[");
      ArrayList<String> indications = new ArrayList<String>();
      String indication = "";
      for (int i = 1; i < terms.get(2).length()-1; i++) {
        if (terms.get(2).charAt(i) != ',' || inApos) {
          if (terms.get(2).charAt(i) == '\'') inApos = !inApos;
          else indication = indication + terms.get(2).charAt(i);
        }
        else {
          if (!inApos) {indications.add(indication); indication = "";}
        }
      }
      indications.add(indication);
      for (int i = 0; i < indications.size(); i++) {
        String ind = indications.get(i);
        PrintWriter tmp = new PrintWriter(new File("input.txt"));
        tmp.print(ind);
        tmp.close();
        out.print('\'' + getMetamap() + "\'");
        if (i < indications.size()-1) out.print(",");
      }
      out.print("]\"");
      out.println();
    }
    in.close();
    out.close();
  }
  static String getMetamap() {
    gj.setField("Email_Address", "neilmalur@hotmail.com");
    gj.setFileField("UpLoad_File", "./input.txt");
    //gj.setField("APIText", input);
    //gj.setField("Batch_Command", "MTI -opt1L_DCMS -E");
    gj.setField("Batch_Command", "metamap -pcI");
    gj.setField("BatchNotes", "SKR Web API test");
    gj.setField("SilentEmail", true);
    return gj.handleSubmission();
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
