
import opennlp.tools.sentdetect.*;
import java.io.*;
import java.nio.file.Files;
import org.apache.commons.io.*;
import java.nio.charset.*;

class Detector {
    public static void main( String []args ) {

	try (FileInputStream modelIn = new FileInputStream(args[0])) {

	    System.out.println("model: [" + args[0] + "]");
	    System.out.println("Directory: [" + args[1] + "]");
	    System.out.println("Extension output: [" + args[2] + "]");
	    System.out.println("Extension  input: [" + args[3] + "]");
	    
	    SentenceModel model = new SentenceModel(modelIn);
	    SentenceDetectorME sentenceDetector = new SentenceDetectorME(model);

	    File[] files = new File(args[1]).listFiles();
	    for (File file : files) {
		if(file.getName().endsWith(args[2])){
		    System.out.println("Reading " + file.getName()); 
			
		    String text = FileUtils.readFileToString(file, StandardCharsets.UTF_8);
		    String sentences[] = sentenceDetector.sentDetect(text);

		    String fnout = file.getName().replace(args[2],args[3]);
		    System.out.println("Writing " + fnout); 
		    File fout = new File(fnout);
		    FileOutputStream fos = new FileOutputStream(fout);
		    BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
		    
		    for (String i : sentences) {
			bw.write(i);
			bw.newLine();
		    }
		    bw.close();
		}
	    }

	} catch(Exception e) {
	    System.out.println("Erro!");
	}
    }
}
