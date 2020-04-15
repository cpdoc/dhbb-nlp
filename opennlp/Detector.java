
import opennlp.tools.sentdetect.*;
import java.io.*;
import java.nio.file.Files;
import org.apache.commons.io.*;
import java.nio.charset.*;

class Detector {
    public static void main( String []args ) {

	try (FileInputStream modelIn = new FileInputStream("/Users/ar/work/apache-opennlp-1.9.2/models/pt-sent.bin")) {
	    SentenceModel model = new SentenceModel(modelIn);

	    SentenceDetectorME sentenceDetector = new SentenceDetectorME(model);

	    File[] files = new File(args[0]).listFiles();
	    for (File file : files) {
		if(file.getName().endsWith(".tmp")){
		    System.out.println("Reading " + file.getName()); 
			
		    String text = FileUtils.readFileToString(file, StandardCharsets.UTF_8);
		    String sentences[] = sentenceDetector.sentDetect(text);

		    String fnout = file.getName().replace(".tmp",".sent");
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
	    // le um dado diretorio
	    // loop pelos arquivos .raw deste diretorio
	    // chamando o sentDetect para cada file
	    

	} catch(Exception e) {
	    System.out.println("Erro");
	}
    }
}
