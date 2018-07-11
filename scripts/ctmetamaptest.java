import java.util.*;
import java.io.*;
import gov.nih.nlm.nls.skr.*;
public class ctmetamaptest {
  static GenericObject gj = new GenericObject();
  public static void main(String[] args) throws Exception {
    Scanner predat = new Scanner(new File("InclusionExclusionBulletPoint.tsv"));
    HashMap<String, ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
    for (int i = 0; i < 5; i++) {String useless = predat.nextLine();}
    while(predat.hasNext()) {
      String[] parts = predat.nextLine().split("\t");
      if (parts.length < 4) continue;
      if (!map.containsKey(parts[0])) map.put(parts[0], new ArrayList<String>());
      map.get(parts[0]).add(parts[3]);
    }
    System.out.println(map.keySet().size());
    predat.close();
    Scanner in = new Scanner(new File("example_ct.csv"));
    PrintWriter out = new PrintWriter(new File("sample_output.csv"));
    useless = in.nextLine();
    while(in.hasNext()) {
      String[] terms = in.nextLine().split(",");
      if (terms.length == 0) continue;
      if (map.containsKey(terms[0])) {
        out.print(terms[0] + ",\"[");
        for (int i = 0; i < map.get(terms[0]).size(); i++) {
          PrintWriter tmp = new PrintWriter(new File("input.txt"));
          tmp.print(map.get(terms[0]).get(i));
          tmp.close();
          out.print("\'" + getMetamap() + "\'");
          if (i < map.get(terms[0]).size()-1) out.print(",");
        }
        out.print("]\"");
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
}
