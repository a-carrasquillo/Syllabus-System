// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// Import required classes
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import com.documents4j.api.DocumentType;
import com.documents4j.api.IConverter;
import com.documents4j.job.LocalConverter;

/**
	This class helps to generate a PDF file based on a Word (DOCX) document.

	REMARK: This class requires the Word document to be created first using
	the GenerateWordDoc class. This requirement is settled in the JSP called
	downloadPDF, where we first generate the Word document. Lastly, requires
	that the machine running the source code have Microsoft Word.

	@author a-carrasquillo
*/
public class WordToPDFConverter {
	/**
		<h1>convertWordToPDF Method</h1>
			This method converts the word (DOCX) document to a PDF document.
			@param courseCode - code of the course, will be used to locate
								the source file and produce the name of the
								output file
			@return boolean value indicating if the PDF file was generated.
					true - generated, false - not generated
	*/
	public boolean convertWordToPDF(String courseCode) {
		// Return value
		boolean result = false;
		// Word Document location
		String sourceLocation = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps";
		sourceLocation += "\\ROOT\\syllabusSystem\\syllabusesDocuments\\prontuario-" + courseCode + ".docx";
		// PDF save location
		String outputLocation = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps";
		outputLocation += "\\ROOT\\syllabusSystem\\syllabusesDocuments\\prontuario-" + courseCode + ".pdf";
		// Define abstract names for the WORD and PDF files in their
		// respective directories
		File inputWord = new File(sourceLocation);
	    File outputFile = new File(outputLocation);
	    try {
	    	// Define input stream to read the data
	    	InputStream docxInputStream = new FileInputStream(inputWord);
	    	// Define output stream to write the data
	        OutputStream outputStream = new FileOutputStream(outputFile);
	        // Define the converter to be used to convert the WORD document
	        // into a PDF document
	        IConverter converter = LocalConverter.builder().build(); 
	        System.out.println("Converting Word Document to PDF...");        
	        converter.convert(docxInputStream).as(DocumentType.DOCX).to(outputStream).as(DocumentType.PDF).execute();
	        // Close objects to avoid leaks
	        outputStream.close();
	        converter.shutDown();
	        docxInputStream.close();
	        // Define that the conversion was a success
	        result = true;
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	// Return the result of the conversion
	    	return result;
	    }
	}

	/**
		<h1>Debugging method</h1>
			@param args[]: String array 
	*/
	public static void main(String[] args) {
		WordToPDFConverter converter = new WordToPDFConverter();
		if(converter.convertWordToPDF("CPEN-412"))
			System.out.println("The PDF was created successfully...");
		else
			System.out.println("The PDF can not be created...");
	}
}