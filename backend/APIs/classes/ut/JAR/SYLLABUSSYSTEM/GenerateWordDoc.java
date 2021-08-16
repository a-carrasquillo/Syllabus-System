// This class belongs to the ut.JAR.SYLLABUSSYSTEM package
package ut.JAR.SYLLABUSSYSTEM;

// General Imports
import java.io.File;
import java.io.FileOutputStream;
import org.apache.poi.xwpf.usermodel.*;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTPageMar;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectPr;
import java.util.ArrayList;
// Image related imports
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigInteger;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.util.Units;

/** 
	This class manage the word document generation based on 
	a syllabus information.
	@author a-carrasquillo
*/
public class GenerateWordDoc {
	// Data field
	XWPFDocument document;

	/**
		<h1>Default constructor</h1>
			Generate an empty word document with an specific size
	*/
	public GenerateWordDoc() {
		document = new XWPFDocument();
		// Change the page margins
		CTSectPr sectPr = document.getDocument().getBody().addNewSectPr();
	    CTPageMar pageMar = sectPr.addNewPgMar();
	    pageMar.setLeft(BigInteger.valueOf(820L));
	    pageMar.setRight(BigInteger.valueOf(820L));
	    pageMar.setTop(BigInteger.valueOf(1040L));
	    pageMar.setBottom(BigInteger.valueOf(1040L));
	}

	/**
		<h1>closeDocument Method</h1>
			This method close the document to avoid leaks.
	*/
	public void closeDocument() {
		try {
			document.close();
		} catch(Exception e) {
			System.out.println("Exception generated when closing the document object...");
			e.printStackTrace();
		}
	}
	
	/**
		<h1>setRun Support Method</h1>
			This method helps to format a paragraph based on a run object.
			@param run - object used to add a region of text to the paragraph.
			@param fontFamily - string indicating the style of the text.
								For example, Times New Roman.
			@param fontSize - integer indicating the size of the text.
			@param colorRGB - string indicating the color of the text,
							  a hexadecimal format is used. 
			@param text - the text to be added to the paragraph.
			@param bold - boolean value indicating if the text is going to
						  be bold. Values: true - bold, false - normal.
			@param addBreak - specifies if a break shall be placed at the
							  current location in the run content.
	*/
	private void setRun(XWPFRun run, String fontFamily, int fontSize, String colorRGB, String text, boolean bold, boolean addBreak) {
		run.setFontFamily(fontFamily);
        run.setFontSize(fontSize);
        run.setColor(colorRGB);
        run.setText(text);
        run.setBold(bold);
        if(addBreak)
        	run.addBreak();
	}

	/**
		<h1>addImageToWordDocument Support Method</h1>
			Method that adds an image and a predefined text below it to a document.
			@param pictureLocation - location/path of the picture in the system
	*/
	private void addImageToWordDocument(String pictureLocation)
			   throws IOException, InvalidFormatException {
		// Create a paragraph
		XWPFParagraph paragraph = document.createParagraph();
	    XWPFRun r = paragraph.createRun();
	    // Indicate image location
	    File image = new File(pictureLocation);
		// Get image file name
		String imgFile = image.getName(); 
		// Get image format
		int imgFormat = getImageFormat(imgFile); 
		// Adding image and text with the help of below functions
		r.addPicture(new FileInputStream(image), imgFormat, imgFile, Units.toEMU(253), Units.toEMU(70));
		r.addBreak();
		// Add the text, change as needed
		setRun(r, "Times New Roman", 14, "000000", "Divisi\u00F3n de Educaci\u00F3n", true, true);
		// Set the picture and the text below it to the center 
		paragraph.setAlignment(ParagraphAlignment.CENTER);
	}
	
	/**
    	<h1>getImageFormat Support Method</h1>
	    	This method helps to determine the image file format.
	    	@param imgFileName - name of the image
	    	@return predetermined integer indicating the format of the picture.
	    			If 0, the format was not found.
    */
	private int getImageFormat(String imgFileName) {
		int format;
		// Determine the image format
		if (imgFileName.endsWith(".emf"))
			format = XWPFDocument.PICTURE_TYPE_EMF;
		else if (imgFileName.endsWith(".wmf"))
			format = XWPFDocument.PICTURE_TYPE_WMF;
		else if (imgFileName.endsWith(".pict"))
			format = XWPFDocument.PICTURE_TYPE_PICT;
		else if (imgFileName.endsWith(".jpeg") || imgFileName.endsWith(".jpg"))
			format = XWPFDocument.PICTURE_TYPE_JPEG;
		else if (imgFileName.endsWith(".png"))
			format = XWPFDocument.PICTURE_TYPE_PNG;
		else if (imgFileName.endsWith(".dib"))
			format = XWPFDocument.PICTURE_TYPE_DIB;
		else if (imgFileName.endsWith(".gif"))
			format = XWPFDocument.PICTURE_TYPE_GIF;
		else if (imgFileName.endsWith(".tiff"))
			format = XWPFDocument.PICTURE_TYPE_TIFF;
		else if (imgFileName.endsWith(".eps"))
			format = XWPFDocument.PICTURE_TYPE_EPS;
		else if (imgFileName.endsWith(".bmp"))
			format = XWPFDocument.PICTURE_TYPE_BMP;
		else if (imgFileName.endsWith(".wpg"))
			format = XWPFDocument.PICTURE_TYPE_WPG;
		else {
			format = 0;
		}
		return format;
 }
	
	/**
		<h1>createHeaderSection Support Method</h1>
			This method helps to create a header section for the syllabus.
			@param text - the text of the header
	*/
	private void createHeaderSection(String text) {
		// Create paragraph
		XWPFParagraph paragraph = document.createParagraph();
		// Code to set the shade
		if (paragraph.getCTP().getPPr()==null) 
			paragraph.getCTP().addNewPPr();
		if (paragraph.getCTP().getPPr().getShd()!=null) 
			paragraph.getCTP().getPPr().unsetShd();
		paragraph.getCTP().getPPr().addNewShd();
		paragraph.getCTP().getPPr().getShd().setVal(org.openxmlformats.schemas.wordprocessingml.x2006.main.STShd.CLEAR);
		paragraph.getCTP().getPPr().getShd().setColor("auto");
		// Color of the shade is light-grey, change as needed
		paragraph.getCTP().getPPr().getShd().setFill("BFBFBF");
		// Set the text with spaces in the top and bottom to expand the area of shade
		setRun(paragraph.createRun(), "Times New Roman", 8, "000000", " ", false, true);
		setRun(paragraph.createRun(), "Times New Roman", 12, "000000", " " + text, true, true);
		setRun(paragraph.createRun(), "Times New Roman", 6, "000000", " ", false, false);
	}
	
	/**
		<h1>createSimpleContent Support Method</h1>
			This method helps to add a text into the document.
			@param text - text to be added
	*/
	private void createSimpleContent(String text) {
		// Create the paragraph
		XWPFParagraph paragraph = document.createParagraph();
		// Set the content of the paragraph
	    setRun(paragraph.createRun(), "Times New Roman", 12, "000000", text, false, false);
	    // Set the left indentation of the entire paragraph
	    paragraph.setIndentationLeft(350);
	}
	
	/**
		<h1>createTable Support Method</h1>
			This method helps to create a table containing the objectives with
			their respective alignments.
			@param objectives - object containing the objectives with their
								respective alignments
	*/
	private void createTable(ArrayList<ObjectiveClass> objectives) {
	    // Create table
	    XWPFTable table = document.createTable();
	    
	    // Create first row
	    XWPFTableRow rowOne = table.getRow(0);
	    // The following line of code is only needed for the first cell
	    // of the first row, this will avoid an empty row
	    rowOne.getCell(0).removeParagraph(0);
	    // Define the content of the cells
        XWPFParagraph paragraphTable = rowOne.getCell(0).addParagraph();
        setRun(paragraphTable.createRun(), "Times New Roman", 12, "000000", "Objetivos del Curso", true, false);
        // Set the text alignment to the center
        paragraphTable.setAlignment(ParagraphAlignment.CENTER);
        // This column specify the agency name, if more agencies are
        // added later, then a decision structure is needed to evaluate
        // which agencies applies and then generate the appropriate columns
        paragraphTable = rowOne.addNewTableCell().addParagraph();
        setRun(paragraphTable.createRun(), "Times New Roman", 12, "000000", "CAEP", true, false);
        // Set the text alignment to the center
        paragraphTable.setAlignment(ParagraphAlignment.CENTER);
	    
        
        // Rows for the objectives content
        XWPFTableRow row = null;
        // String variables to hold the content of the objective
        // description and its alignment
        String objectiveDetail = "";
        String objectiveAlignment = "";
        // Iterate over the objectives and its alignments
        for(int i = 0; i<objectives.size(); i++) {
        	// Create a row
        	row = table.createRow();
        	// Define the content of the cells for the objective description
        	paragraphTable = row.getCell(0).addParagraph();
        	objectiveDetail = objectives.get(i).getId() + ". " + objectives.get(i).getDescription();
        	setRun(paragraphTable.createRun(), "Times New Roman", 12, "000000", objectiveDetail, false, false);
        	// Avoid that the text get to close to the table borders
        	paragraphTable.setIndentationLeft(150);
        	paragraphTable.setIndentationRight(150);
        	
        	paragraphTable = row.getCell(1).addParagraph();
        	// Extract the objective alignment
        	// NOTE: Remember that if more agencies are added, the agency id
        	// needs to be verified and perform proper operations
        	objectiveAlignment = "";
        	for(int j = 0; j<objectives.get(i).getObjectiveAlignment().size(); j++) {
        		if(j!=(objectives.get(i).getObjectiveAlignment().size()-1))
				    objectiveAlignment += objectives.get(i).getObjectiveAlignment().get(j).getObjectiveId() + ", ";
				else
				    objectiveAlignment += objectives.get(i).getObjectiveAlignment().get(j).getObjectiveId();
        	}
        	// Define the content of the cells corresponding to the objectives alignment
            setRun(paragraphTable.createRun(), "Times New Roman", 12, "000000", objectiveAlignment, false, false);
            // Avoid that the text get to close to the table borders
            paragraphTable.setIndentationLeft(100);
            paragraphTable.setIndentationRight(150);
            // Set the text alignment to the center
            paragraphTable.setAlignment(ParagraphAlignment.CENTER);
        }
        // Create the paragraph for an empty space at the bottom of the table
      	XWPFParagraph paragraph = document.createParagraph();
      	setRun(paragraph.createRun(), "Times New Roman", 12, "000000", "", false, false);
	}

	/**
		<h1>addRuleContent Support Method</h1>
			This method helps add the rules information to the word document.
			@param rules - object containing the rules titles and descriptions
	*/
	private void addRuleContent(ArrayList<RulesInfo> rules) {
		XWPFParagraph paragraph = null;
		// Iterate over the rules' information
		for(int i=0; i<rules.size(); i++) {
			// Create the paragraph
			paragraph = document.createParagraph();
			// Set the content of the paragraph
		    setRun(paragraph.createRun(), "Times New Roman", 12, "000000", rules.get(i).getTitle(), true, false);
		    // Set the left indentation of the entire paragraph
		    paragraph.setIndentationLeft(350);
		    // Create a second paragraph
		    paragraph = document.createParagraph();
			// Set the content of the paragraph
		    setRun(paragraph.createRun(), "Times New Roman", 12, "000000", rules.get(i).getDescription(), false, true);
		    // Set the left indentation of the entire paragraph
		    paragraph.setIndentationLeft(350);
		}
	}

	/**
		<h1>formatDate support method</h1>
			Method that help us to format the date used in the
			creation and edition fields.
			@param dateTime - string to be formatted
			@return formatted date
	*/
	private static String formatDate(String dateTime) {
        // Extract only the date from date-time
	    String[] dateTimeSplit = dateTime.split(" ");
	    // Split the day, month and year
	    String[] dateSplit = dateTimeSplit[0].split("-");
	    String month = dateSplit[1];
	    switch(month) {
		    case "01":
				month = "Enero";
				break;
			case "02":
				month = "Febrero";
				break;
			case "03":
				month = "Marzo";
				break;
			case "04":
				month = "Abril";
				break;
			case "05":
			    month = "Mayo";
				break;
			case "06":
				month = "Junio";
				break;
			case "07":
				month = "Julio";
				break;
			case "08":
				month = "Agosto";
				break;
			case "09":
				month = "Septiembre";
				break;
			case "10":
				month = "Octubre";
				break;
			case "11":
				month = "Noviembre";
				break;
			default:
			month = "Diciembre";
		}
		return dateSplit[2]+"/"+month+"/"+dateSplit[0];
    }
	
	@SuppressWarnings("finally")
	/**
		<h1>generateDocument Method</h1>
			This method create the content of the word document based
			on a syllabus information
			@param syllabus - syllabus information
			@return boolean value indicating if the word document 
					creation was a success
	*/
	public boolean generateDocument(SyllabusInfo syllabus) {
		// Define and initialize the return variable
		boolean fileCreated = false;
		// Verify that the course code is not empty
		if(!syllabus.getCode().equals("")) {
			try {
				// Message indicating the beginning of the process
				System.out.println("Beginning Word Document Generation...");
				// Define the location where the file will be save and the file name
				String fileLocation = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\";
				fileLocation += "webapps\\ROOT\\syllabusSystem\\syllabusesDocuments\\";
				fileLocation += "prontuario-" +  syllabus.getCode() + ".docx";
				FileOutputStream out = new FileOutputStream(new File(fileLocation));
				
				// Add an image and a text below it, location may be changed as needed
			    addImageToWordDocument("C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\ROOT\\syllabusSystem\\images_icons\\uni-logo.png");
				
			    // Create the header for the course code section
			    createHeaderSection("C\u00F3digo del Curso:");
			    // Add the content for the course code
			    createSimpleContent(syllabus.getCode());
			      
			    // Create the header for the course title section
			    createHeaderSection("T\u00edtulo del Curso:");
			    // Add the content for the course title
			    createSimpleContent(syllabus.getTitle());
			      
			    // Create the header for the course type section
			    createHeaderSection("Tipo de Curso:");
			    // Add the content for the course type
			    createSimpleContent(syllabus.getType());
			      
			    // Create the header for the modality section
			    createHeaderSection("Modalidad:");
			    // Add the content for the modality
			    createSimpleContent(syllabus.getModality());
			      
			    // Create the header for the academic level section
			    createHeaderSection("Nivel:");
			    // Add the content for the academic level
			    createSimpleContent(syllabus.getLevel().substring(0, 1).toUpperCase() + syllabus.getLevel().substring(1));
			      
			    // Create the header for the prerequisites section
			    createHeaderSection("Prerequesito/s:");
			    // Variable to hold the prerequisites
			    String prerequisites = "";

			    // Verify if there are prerequisites
			    if(!syllabus.getPrerequisites().isEmpty()) {
			       	// Iterate over the information and extract the prerequisites
			       	// information from the syllabus object
			       	for(int i = 0; i < syllabus.getPrerequisites().size(); i++) {
			       		// Verify that is not the last prerequisite
			       		if(i!=(syllabus.getPrerequisites().size()-1))
			       			prerequisites += syllabus.getPrerequisites().get(i) + ", ";
			       		else
			     			prerequisites += syllabus.getPrerequisites().get(i);
			       	}
			    } else {
			       	prerequisites = "N/A";
			    }
			    // Add the content for the prerequisites
			    createSimpleContent(prerequisites);
			      
			    // Create the header for the co-requisites section
			    createHeaderSection("Correquesito/s:");
			    // Variable to hold the co-requisites
			    String corequisites = "";
			    // Verify if there are co-requisites
			    if(!syllabus.getCorequisites().isEmpty()) {
			        // Extract the co-requisites information from the syllabus object
			        for(int i = 0; i < syllabus.getCorequisites().size(); i++) {
			        	// Verify that is not the last co-requisite
			            if(i!=(syllabus.getCorequisites().size()-1))
			                corequisites += syllabus.getCorequisites().get(i) + ", ";
			            else
			                corequisites += syllabus.getCorequisites().get(i);
			        }
			    } else {
			        corequisites = "N/A";
			    }
			    // Add the content for the co-requisites
			    createSimpleContent(corequisites);
			      
			    // Create the header for the duration section
			    createHeaderSection("Duraci\u00F3n:");
			    // Add the content for the duration
			    createSimpleContent(syllabus.getDuration());
			      
			    // Create the header for the credits section
			    createHeaderSection("Cr\u00E9ditos:");
			    // Add the content for the credits
			    createSimpleContent(syllabus.getCredits());
			      
			    // Create the header for the course description section
			    createHeaderSection("Descripci\u00F3n del Curso:");
			    // Add the content for the course description
			    createSimpleContent(syllabus.getDescription());
			    
			    // Create the header for the justification section
			    createHeaderSection("Justificaci\u00F3n:");
			    // Add the content for the justification
			    createSimpleContent(syllabus.getJustification());
			    
			    // Create the header for the course objectives section
			    createHeaderSection("Objetivos Del Curso:");
			    // Add the introduction for the course objectives
			    createSimpleContent("Al culminar el curso, el estudiante debe:");
			    // Create Table
			    createTable(syllabus.getObjectives());
			    
			    // Create the header for the thematic content section
			    createHeaderSection("Contenido Tem\u00E1tico:");
			    // Add the information for the thematic content
			    for(int i=0; i<syllabus.getThematicContent().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getThematicContent().get(i));
			    
			    // Create the header for the teaching strategies section
			    createHeaderSection("Estrategias de Ense\u00F1anza:");
			    // Add the content for the teaching strategies
			    for(int i=0; i<syllabus.getTeachingStrategies().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getTeachingStrategies().get(i));
			    
			    // Create the header for the assessment strategies section
			    createHeaderSection("Estrategias de Assessment:");
			    // Add the content for the assessment strategies
			    for(int i=0; i<syllabus.getAssessmentStrategies().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getAssessmentStrategies().get(i));
			    
			    // Create the header for the grade system section
			    createHeaderSection("Sistemas de notas:");
			    // Add the information for the grade system
			    createSimpleContent("Sistema Est\u00E1ndar (A, B, C, D, F)");
			    
			    // Create the header for the textbook section
			    createHeaderSection("Libro de Texto:");	    
			    // Add the content for the textbook
			    for(int i=0; i<syllabus.getTextbooks().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getTextbooks().get(i));
			    
			    // Create the header for the bibliography section
			    createHeaderSection("Bibliograf\u00EDa:");
			    // Add the content for the bibliography
			    for(int i=0; i<syllabus.getBibliography().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getBibliography().get(i));
			    
			    // Create the header for the online resources section
			    createHeaderSection("Recursos en L\u00EDnea:");
			    // Add the content for the online resources
			    for(int i=0; i<syllabus.getOnlineResources().size(); i++)
			    	createSimpleContent((i+1) + ". " + syllabus.getOnlineResources().get(i));
			    
			    // Create the header for the rules section
			    createHeaderSection("Reglas:");
			    // Add the content of the rules section
			    addRuleContent(syllabus.getRuleFullInfo());
			    
			    // Create the header for the author section
			    createHeaderSection("Creado Por:");
			    // Add the information for the author
			    createSimpleContent(syllabus.getAuthorName() + ", " + formatDate(syllabus.getCreationDate()));
			    
			    // Create the header for the editor section
			    createHeaderSection("Revisado Por:");
			    String editorInfo = "N/A";
			    if(!syllabus.getEditorName().isEmpty()) {
					// Set the editor information
					editorInfo = syllabus.getEditorName() + ", " + formatDate(syllabus.getEditionDate());
			    }
			    // Add the information of the editor
			    createSimpleContent(editorInfo);
			    
			    // Write the information in the document
				document.write(out);
				// Close object to avoid leaks
			    out.close();
			    // Set the return variable to true, indicating that the document creation was a success
			    fileCreated = true;
			} catch(Exception e) {
				System.out.println("Exception...");
				e.printStackTrace();
			} finally {
				return fileCreated;
			}
		}
		return fileCreated;
	}

	/**
		<h1>Debugging method</h1>
			@param args[]: String array 
	*/
	public static void main(String[] args) {
		System.out.println("Testing formatDate method...");
		System.out.println(formatDate("2021-08-09 10:10:10"));
	}
}