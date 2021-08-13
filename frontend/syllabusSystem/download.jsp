<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>

<%
	%>
	<!DOCTYPE html>
	<html lang="es">
	    <head>
	        <!--Indicates the encoding of the characters-->
	        <meta charset="utf-8">
	        <!--Authors of the web page-->
	        <meta name="author" content="a-carrasquillo">
	        <!--Website title-->
	        <title>Descargar el Prontuario</title>
	        <!--CSS code-->
	        <style type="text/css">
	            h1 { text-align: center; }
	            p { text-align: center; font-size: 25px; }
	        </style>
	    </head>
	    <body>
	<%
	// Retrieve parameters from the form and remove the unnecessary
	// spaces from the start and end
	SyllabusInfo syllabus = (SyllabusInfo) session.getAttribute("syllabus");
	// Create an object of the class that allows us to create the WORD document
	GenerateWordDoc wordDoc = new GenerateWordDoc();
	// Generate the WORD document and verify if it was a success
	if(wordDoc.generateDocument(syllabus)) {
		System.out.println("Word document created successfully");
		%>
		<h1>El archivo ha sido creado satisfactoriamente</h1>
		<a href="syllabusesDocuments/prontuario-<%=syllabus.getCode()%>.docx" download onclick="setTimeout(function(){window.close();},5000);">
			<p>Presione para descargar el documento</p>
	    </a>
	    <p>Nota: Si no se le permite seleccionar donde desea guardar el documento, el mismo por default se guardar&aacute; en el folder de "Downloads".</p>
		<%
	} else {
		System.out.println("Word document was not created");
		%>
		<h1>El archivo no pudo ser creado, notifique a la persona indicada.</h1>
		<%
	}
	// Close WORD document to avoid leaks
	wordDoc.closeDocument();
	%>
	    </body>
	</html>
	<%
%>