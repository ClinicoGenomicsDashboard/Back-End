import java.util.*;
import java.io.*;
import java.net.*;
import gov.nih.nlm.nls.skr.*;
public class ctmetamaptest {
  static GenericObject gj = new GenericObject();
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(new File("example_ct.csv"));
    PrintWriter out = new PrintWriter(new File("sample_output_full.csv"));
    String useless = in.nextLine();
    while(in.hasNext()) {
      String[] terms = in.nextLine().split(",");
      String source = getURLSource(terms[2]);
      int index = source.indexOf("display_order");
      if (index > 0) {
        ArrayList<Integer> indices = new ArrayList<Integer>();
        ArrayList<Integer> startinds = new ArrayList<Integer>();
        ArrayList<Integer> endinds = new ArrayList<Integer>();
        while (index > 0) {
          indices.add(index);
          startinds.add(source.indexOf("description", index));
          endinds.add(source.indexOf("}", index));
          index = source.indexOf("display_order", index+1);
        }
        ArrayList<String> strings = new ArrayList<String>();
        for (int i = 0; i < startinds.size(); i++) strings.add(source.substring(startinds.get(i) + 14, endinds.get(i)-1));
        out.print(terms[0] + "," + terms[1] + ",\"[");
        for (int i = 0; i < strings.size(); i++) {
          PrintWriter tmp = new PrintWriter(new File("input.txt"));
          tmp.print(strings.get(i));
          tmp.close();
          out.print("\'" + getMetamap() + "\'");
          if (i < strings.size() - 1) out.print(",");
        }
        out.println();
      }
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
