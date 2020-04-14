
import opennlp.tools.sentdetect.*;
import java.io.*;

class Detector {
    public static void main( String []args ) {

	try (FileInputStream modelIn = new FileInputStream("/Users/ar/work/apache-opennlp-1.9.2/models/pt-sent.bin")) {
	    SentenceModel model = new SentenceModel(modelIn);

	    SentenceDetectorME sentenceDetector = new SentenceDetectorME(model);

	    // le um dado diretorio
	    // loop pelos arquivos .raw deste diretorio
	    // chamando o sentDetect para cada file
	    
	    String sentences[] = sentenceDetector.sentDetect("  First sentence. Second sentence. ");
	    
	    for (String i : sentences) {
		System.out.println(i);
	    }

	} catch(Exception e) {
	    System.out.println("Erro");
	}
    }
}
