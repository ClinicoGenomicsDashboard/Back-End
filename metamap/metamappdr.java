import java.util.*;
import java.io.*;
import gov.nih.nlm.nls.skr.*;
public class metamappdr {
  static GenericObject gj = new GenericObject();
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(new File("cleaned_pdr_data.csv"));
    PrintWriter out = new PrintWriter(new File("outputpdr.csv"));
    while (in.hasNext()) {
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
      out.print(terms.get(0) + "," + terms.get(1) + "," + terms.get(2) + ",\"[");
      ArrayList<String> indications = new ArrayList<String>();
      String indication = "";
      for (int i = 1; i < terms.get(3).length()-1; i++) {
        if (terms.get(3).charAt(i) != ',' || inApos) {
          if (terms.get(3).charAt(i) == '\'') inApos = !inApos;
          else indication = indication + terms.get(3).charAt(i);
        }
        else {
          if (!inApos) {indications.add(indication); indication = "";}
        }
      }
      indications.add(indication);
      for (String ind : indications) {
        PrintWriter tmp = new PrintWriter(new File("input.txt"));
        tmp.print(ind);
        tmp.close();
        out.print('\'' + getMetamap() + "\',");
      }
      out.print("]\",\"[");
      inApos = false;
      ArrayList<String> contrainds = new ArrayList<String>();
      String contraind = "";
      for (int i = 1; i < terms.get(4).length()-1; i++) {
        if (terms.get(4).charAt(i) != ',' || inApos) {
          if (terms.get(4).charAt(i) == '\'') inApos = !inApos;
          else contraind = contraind + terms.get(4).charAt(i);
        }
        else {
          if (!inApos) {contrainds.add(contraind); contraind = "";}
        }
      }
      contrainds.add(contraind);
      for (int i = 0; i < contrainds.size(); i++) {
        PrintWriter tmp = new PrintWriter(new File("input.txt"));
        tmp.print(contrainds.get(i));
        tmp.close();
        out.print('\'' + getMetamap() + "\'");
        if (i < contrainds.size() - 1) out.print(",");
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
}
