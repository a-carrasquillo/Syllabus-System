<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods%>
<%@ page import="java.sql.*"%>
<%// Import the java.util package to use ArrayList related methods%>
<%@ page import="java.util.*"%>

<%
	// Perform the authentication process
	if((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)) {
		// Deleting session variables
		session.invalidate();
		// Return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username
		// and the previous page from the session variables
		String currentPage = "createSyllabus.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database using the applicationDBAuthentication class
		try {
			// Create the appDBAuth object
			applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
				
			// Verify if the user has access to this page
			if(appDBAuth.verifyUserPageAccess(userName, currentPage)) {
				// The user have access to the current page
				
				ResultSet res = appDBAuth.verifyUserPageFlow(userName, currentPage, previousPage);
				// Verify that the user is following the page flow
				if(res.next()) {
					// The user was authenticated					
					// Create the current page attribute
					session.setAttribute("currentPage", "createSyllabus.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					%>
					<!doctype html>
					<html lang="es">
					    <head>
					        <!--Indicates the encoding of the characters-->
					        <meta charset="utf-8">
					        <!--Authors of the web page-->
					        <meta name="author" content="a-carrasquillo, arivesan">
					        <!--Importing the CSS style-sheet-->
					        <link rel = "stylesheet" type="text/css" href="css/createSyllabus.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>Creaci&oacute;n de Prontuarios</title>
					        <!--CSS required for the background picture-->
					        <style type="text/css">
					            body {
					              background-image: url(images_icons/esc_educacion2.JPG);
					              -webkit-background-size:cover;
					              background-size:cover;
					              background-position: center center;
					              height: 100vh;
					              background-repeat: no-repeat;
					              background-attachment: fixed;  
					            }
					        </style>
					    </head>
					    <body>
					        <img class ="logo" src="images_icons/uni-logo.png" alt="Logo Ana G. Mendez">
					<%
					// Beginning of menu
					%>
						<div class="custom-padding">
						<nav>
					        <ul class="menu-area">
					            <b>
					                <li><a href="welcomeMenu.jsp">Home</a></li>
					<%
					// Bring the menu from the database based on the username
					res = appDBAuth.menuElements(userName);
					String previousTitle = "";
					// Counter to determine if it is the first iteration
					int counter = 0;
					// Verify that the result set is not empty
					if(!res.isAfterLast()) {
						// Iterate through the result set
						while(res.next()) {
							// Verify that the title (menu category) is different
							// from the previous one
							if(!previousTitle.equals(res.getString(2)) && (counter==0)) {
								%>
								<li>
				                    <div class="dropdown">
				    	                <button class="dropbtn"><%=res.getString(2)%>
										<i class="fa fa-caret-down"></i>
                           				</button>
                        			<div class="dropdown-content">
								<%
							} else if(!previousTitle.equals(res.getString(2)) && (counter!=0)) {
								%>
										</div>
				                    </div>
				                </li>
				                <li>
				                    <div class="dropdown">
				                        <button class="dropbtn"><%=res.getString(2)%>
										<i class="fa fa-caret-down"></i>
                            			</button>
                            			<div class="dropdown-content">
								<%
							}
							
							%>
							<a href="<%=res.getString(1)%>"><%=res.getString(3)%></a>						
							<%
							// Update the previous title variable for the next iteration
							previousTitle = res.getString(2);
							counter++;
						}
						%>
								</div>
				            </div>
				        </li>
						<%
					} else {
						System.out.println("The user does not have a menu option...");
						// Deleting session variables
						session.invalidate();
						// Return to the login page
						response.sendRedirect("login.jsp");
					}
					%>
									<li><a href="help.jsp">Ayuda</a></li>
			                    <li><a href="signout.jsp">Logout</a></li>
			                </b>
			            </ul>
			          </nav>
			        </div>
			        <%// End of menu loading

					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

			        String courseCode = "";
			        if(session.getAttribute("errorSyllabusCreation")==null || previousPage.equals("searchNewCourse.jsp")) {
				        if(previousPage.equals("searchNewCourse.jsp")) {
				        	// Retrieve parameters from the form and remove the
				        	// unnecessary spaces from the start and end
				        	courseCode = request.getParameter("courseCode").trim();

				        	// Set a session variable to retrieve the course code
				        	// when we come from the help page
				        	session.setAttribute("courseCode", courseCode);

				        	// Clear error related session variables
				        	session.setAttribute("errorSyllabusCreation", null);
				        	session.setAttribute("syllabus", null);
				        } else {
				        	// Comes from help page
				        	// Retrieve the course code from the session variable
				        	courseCode = session.getAttribute("courseCode").toString();
				        }

			        	// Search basic information of the course
						res = appDBMnger.searchCourseInfo(courseCode);
						// Verify if there was a result for the search
						if(res.next()) {
							%>
							<div class = "cuadro_centro">
					            <form action="processSyllabusInfo.jsp" method="post">               
					                <!--Section of course code-->
					                <div id = "course_code">
					                    <span id= course_code_tag>C&oacute;digo del Curso:</span>
					                    <input type="text"  name="course_code" id="course_code_info" value="<%=res.getString(1)%>" readonly>
					                </div>
					                
					                <!--Section of course title-->
					                <div id="course_title">
					                    <span id = "title_tag">T&iacute;tulo del curso:</span>
					                    <input type="text" id="course_title_info" name="course_title" value="<%=res.getString(2)%>" readonly>
					                </div>
					                
					                <!--Section of course type-->
					                <div id="course_type">
					                    <span id = "course_type_tag">Tipo de Curso:</span>
					                    <input type="text" id="course_type_info" name="course_type" value="<%=res.getString(3)%>" readonly>
					                </div>
					                
					                <!--Section of modality-->
					                <div id="modality">
					                    <span id = "modality_tag">Modalidad:</span>
					                    <input type="text" id="modality_info" name="modality" value="<%=res.getString(4)%>" readonly>
					                </div>
					                
					                <!--Section of course level-->
					                <div id="level">
					                    <span id = "level_tag">Nivel:</span>
					                    <input type="text" id="nivel" name="nivel" value="<%=res.getString(5).substring(0, 1).toUpperCase() + res.getString(5).substring(1)%>" readonly>
					                </div>

					                <!--Section of course prerequisite-->
					                <div id="prerequisite">
					                    <span id = "prerequisite_tag">Prerrequisito/s:</span>
					                    <input type="text" id="prerequisite_info" name="prerequisite" placeholder="Introduzca el/los prerrequisito/s separados por comas">
					                </div>
					                
					                <!--Section of course corequisite-->
					                <div id="corequisite">
					                    <span id = "corequisite_tag">Correquisito/s:</span>
					                    <input type="text" id="corequisite_info" name="corequisite" placeholder="Introduzca el/los correquisito/s separados por comas">
					                </div>
					                
					                <!--Section of course duration-->
					                <div id="duration">
					                    <span id="duration_tag">Duraci&oacute;n:</span>
					                    <input type="text" id="duration_info" name="duration" placeholder="Introduzca la duraci&oacute;n del curso" required>
					                </div>
					                
					                <!--Section of credits-->
					                <div id="credits">
					                    <span id = "credits_tag">Cr&eacute;ditos:</span>
					                    <input type="text" id="credits_info" name="credits" placeholder="Introduzca la cantidad de cr&eacute;ditos del curso" required>
					                </div>
					                
					                <!--Section of Course description-->
					                <div id="description">
					                    <span id="description_tag">Descripci&oacute;n del Curso:</span>
					                    <textarea id="description_info" name="description" placeholder="Introduzca la descripci&oacute;n del curso" rows="4" required></textarea>
					                </div>
					                
					                <!--Section of Course Justification -->
					                <div id="justification">
					                    <span id="justification_tag">Justificaci&oacute;n: </span>
					                    <textarea id="justification_info" name="justification" placeholder="Introduzca la justificaci&oacute;n del curso" rows="4" required></textarea>
					                </div>
					                
					                <!--Section of Objectives-->
					                <div id="objectives">
					                    <div id="objectives_tag">Objetivos Generales:</div>
					                    <!--Section for selecting the agencies that apply to a particular syllabus-->
					                    <fieldset id="agencias">
					                        <legend>Agencias que aplican</legend>
					                        <!--Here are going the check-boxes with the names of the agencies-->
					                        <input type="checkbox" name="caep" id="caep" value="caep" onclick="addCaep()"/> CAEP
					                    </fieldset>
					                    
					                    <!--hidden field to know the amount of objectives to be collected from the processing JSP, value should change with JavaScript-->
					                    <input type="hidden" name="amountObjectives" id="amountObjectives" value="1">
					                    
					                    <div class="objective">
					                        <span class="objective_tag">Objetivo 1: </span>
					                        <span><textarea class="objective_info" name="objective_1" placeholder="Introduzca la descripci&oacute;n del objetivo 1" rows="3" required></textarea></span>
					                    </div>
					                        
					                    <div class="align_tag">Alineado con:</div>
					                    
					                    <!--Other agencies-->
					                    <div id="add_caep"><!--JavaScript will insert the HTML if needed--></div>
					                    
					                <!--Add objective button-->
					                <div id="new_objective"><!--JavaScript will insert the HTML if needed--></div>
					                <button id="remove_objective" type="button" onclick="removeObjective()">Remover Objetivo</button>
					                <button id="add_objective" type="button" onclick="addObjective()">A&ntilde;adir Objetivo</button>
					                </div>
					                
					                <!--Section thematic content-->
					                <!--hidden field to know the amount of thematic content to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountThematicContent" id="amountThematicContent" value="1">
					                <div>
					                    <div id="thematic_content_1"><span>Contenido tem&aacute;tico: 1. </span><input type="text" class="thematic_info" name="thematic_info_1" placeholder="Introduzca el contenido tem&aacute;tico" required></div>
					                    <!--New thematic content text input will be added here-->
					                    <div id="new_thematic_content">
					                        <!--JavaScript will insert the HTML if needed-->
					                        
					                    </div>
					                <!--Button to add text inputs for thematic content-->
					                <button id="remove_thematic_content" type="button" onclick="removeThematicCont()">Remover Contenido tem&aacute;tico</button>
					                <button id="add_thematic_content" type="button" onclick="addThematicCont()">A&ntilde;adir Contenido tem&aacute;tico</button>  
					                </div>
					                
					                <!--Section of teaching strategies-->
					                <!--hidden field to know the amount of teaching strategies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountTeachingStrategies" id="amountTeachingStrategies" value="1">
					                <div>
					                    <div id="teaching_strat_1">
					                        <span>Estrategias de ense&ntilde;anza: 1.</span>
					                        <%
					                        // Search all types of teaching strategies currently store in the db
					                        res = appDBMnger.listAllTypesOfStrategies();
					                        // Verify if there is at least one result
					                        if(res.next()) {
					                        	// There is at least one result
					                        	// Reset the pointer
					                        	res.beforeFirst();
					                        	%>
					                        	<input type="text" name="teaching_strat_1" class="teaching_strat_info" placeholder="Seleccione o introduzca una estrategia de ense&ntilde;anza" required list="teaching_strats" />
					                        		<datalist id="teaching_strats">
					                        	<%
					                        		// Iterate over the types of teaching strategies
						                        	while(res.next()) {
						                        		%><option><%=res.getString(2)%></option><%
						                        	}
						                        %>
						                        	</datalist>
						                        <%
					                        } else {
					                        	// No result found, (mainly happens when system runs for first time)
					                        	%>
					                        	<input type="text" name="teaching_strat_1" class="teaching_strat_info" placeholder="Introduzca una estrategia de ense&ntilde;anza" required>
					                        	<%
					                        }
					                        %>
					                    </div>
					                    
					                    <div id="new_teaching_strat">
					                        <!--JavaScript will insert the HTML if needed-->
					                    </div>
					                    
					                    <!--Button to add text inputs for teaching strategies-->
					                    <button id="remove_teaching_strat" type="button" onclick="removeTeachingStrat()">Remover estrategia</button>
					                    <button id="add_teaching_strat" type="button" onclick="addTeachingStrat()">A&ntilde;adir estrategia</button>
					                </div>
					                
					                <!--Section of Assessment strategies-->
					                <!--hidden field to know the amount of Assessment strategies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountAssessmentStrategies" id="amountAssessmentStrategies" value="1">
					                <div>
					                    <div id="assessment_strat_1">
					                        <span>Estrategias de assessment: 1.</span>
					                        <%
					                        // Search all types of assessment strategies currently store in the DB
					                        res = appDBMnger.listAllTypesOfAssessment();
					                        // Verify if there is at least one result
					                        if(res.next()) {
					                        	// There is at least one result
					                        	// Reset the pointer
					                        	res.beforeFirst();
					                        	%>
					                        	<input type="text" name="assessment_strat_1" class="assessment_strat_info" placeholder="Seleccione o introduzca una estrategia de assessment" required list="assessment_strats" /> 
					                        		<datalist id="assessment_strats">
					                        	<%
					                        		// Iterate over the types of assessment strategies
						                        	while(res.next()) {
						                        		%><option><%=res.getString(2)%></option><%
						                        	}
						                        %>
						                        	</datalist>
						                        <%
					                        } else {
					                        	// No result found, (mainly happens when system runs for first time)
					                        	%>
					                        	<input type="text" name="assessment_strat_1" class="assessment_strat_info" placeholder="Introduzca una estrategia de assessment" required> 
					                        	<%
					                        }
					                        %>
					                    </div>
					                    
					                    <div id="new_assessment_strat">
					                        <!--JavaScript will insert the HTML if needed-->
					                    </div>
					                    
					                    <!--Button to add text inputs for Assessment strategies-->
					                    <button id="remove_assessment_strat" type="button" onclick="removeAssessmentStrat()">Remover assessment</button>
					                    <button id="add_assessment_strat" type="button" onclick="addAssessmentStrat()">A&ntilde;adir assessment</button>
					                </div>              
					                
					                <!--Section of grades-->
					                <div id="grades">
					                    <div id="grades_tag">Sistema de Notas: Sistema Est&aacute;ndar (A, B, C, D, F)</div>
					                </div>
					                
					                <!--Section of Textbook-->
					                <!--hidden field to know the amount of Textbooks to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountTextbooks" id="amountTextbooks" value="1">
					                <div>
					                    <div id="textbook_1"><span>Libro de texto: 1. </span><input type="text" class="textbook_info" name="textbook_info_1" placeholder="Introduzca el libro de texto" required></div>
					                    <!--New Textbook text input will be added here-->
					                    <div id="new_textbook">
					                        <!--JavaScript will insert the HTML if needed-->
					                        
					                    </div>
					                	<!--Button to add text inputs for thematic content-->
					                	<button id="remove_textbook" type="button" onclick="removeTextbook()">Remover libro de texto</button>
					                	<button id="add_textbook" type="button" onclick="addTextbook()">A&ntilde;adir libro de texto</button>  
					                </div>
					                
					                <!--Section of Bibliography-->
					                <!--hidden field to know the amount of Bibliographies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountBibliographies" id="amountBibliographies" value="1">
					                <div>
					                    <div id="bibliography_1"><span>Bibliograf&iacute;a: 1. </span><input type="text" class="bibliography_info" name="bibliography_info_1" placeholder="Introduzca la bibliograf&iacute;a" required></div>
					                    <!--New bibliography text input will be added here-->
					                    <div id="new_bibliography">
					                        <!--JavaScript will insert the HTML if needed-->
					                    </div>
					                	<!--Button to add text inputs for thematic content-->
					                	 <button id="remove_bibliography" type="button" onclick="removeBibliography()">Remover bibliograf&iacute;a</button>
					                    <button id="add_bibliography" type="button" onclick="addBibliography()">A&ntilde;adir bibliograf&iacute;a</button>  
					                </div>
					                
					                <!--Section of Online Resources-->
					                <!--hidden field to know the amount of Online Resources to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountOnlineResources" id="amountOnlineResources" value="1">
					                <div>
					                    <div id="online_res_1"><span>Recursos en l&iacute;nea: 1. </span><input type="text" class="online_res_info" name="online_res_info_1" placeholder="Introduzca el recurso" required></div>
					                    <!--New online resource text input will be added here-->
					                    <div id="new_online_res">
					                        <!--JavaScript will insert the HTML if needed-->
					                    </div>
					                	<!--Button to add text inputs for thematic content-->
					                	<button id="remove_online_res" type="button" onclick="removeOnlineRes()">Remover recurso </button>
					                    <button id="add_online_res" type="button" onclick="addOnlineRes()">A&ntilde;adir recurso </button>  
					                </div>
					                    
					                
					                <%
					                // Search the rules in the system
					                res = appDBMnger.listAllRules();
					                // Verify if there is at least one result
					                if(!res.isAfterLast()) {
					                	// There is at least one result
					                    %>
					                    <!--Reglas-->
					                	<div id="reglas"><div>Reglas que aplican:</div>
					                		<table class="regla">
					                			<%
					                			counter = 0;
					                			// Iterate over the rules
					                			while(res.next()) {
					                				// Structure to make sure that the rules are
					                				// organize into two columns
					                				if(counter%2 == 0) {
					                					%>
					                					<tr>
						                            		<td><input type="checkbox" name="regla" value="<%=res.getString(1)%>"/> <%=res.getString(2)%></td>
					                					<%	
					                				} else {
					                					%>
						                					<td><input type="checkbox" name="regla" value="<%=res.getString(1)%>"/> <%=res.getString(2)%></td>
							                        	</tr>
					                					<%
					                				}
					                				counter++;
					                			}
					                			%>   
					                    	</table>              
					                	</div>
					                    <%
					                } else {
					                	// No result found, 
					                    System.out.println("There are no rules in the system. Add the required rules to access the syllabus creation page.");
					                    // Return to the searchNewCourse page
										response.sendRedirect("searchNewCourse.jsp");
					                }
					                %>                   
					                <!--End Buttons-->
					                <div id="buttons">
					                    <button id ="cancel" type="button" onclick="window.location.href='searchNewCourse.jsp';">Cancelar</button>
					                    <button id ="submit" type="submit">Someter</button>
					                </div>
					            </form>
					        </div>
					        <div id="bottom_padding"></div>
					        <script>                                                        
					            function addCaep() {
					                "use strict";
					                var amountObjectivesLoc = document.getElementById("amountObjectives");
					                var amountObjectives = Number(amountObjectivesLoc.value);
					                var selection = document.getElementById("caep");
					                if(amountObjectives==1) {
					                    if (selection.checked) {
					                    document.getElementById("add_caep").innerHTML += "<div class=\"caep_stds\"><span>CAEP:</span><input type=\"text\" name=\"caep_stds_1\" class=\"caep_stds_info\" readonly> <div class=\"botones_objetivos\">                                <button class=\"add\" name=\"caep_stds_add_1\" type=\"button\" onclick=\"addCaepStdToInputField(this.name)\">A\u00f1adir</button><br><button class=\"remove\" name=\"caep_stds_remove_1\" type=\"button\" onclick=\"removeCaepStdFromInputField(this.name)\">Remover</button></div><select name=\"all_caep_stds_1\" class=\"all_caep_stds\"><option value=\"\">Seleccione un est\u00e1ndar</option><option value=\"1.1\" title=\"Candidates demonstrate an understanding of the 10 InTASC standards at the appropriate progression level(s) in the following categories: the learner and learning; content; instructional practice; and professional responsibility.\">1.1</option> <option value=\"1.2\" title=\"Providers ensure that candidates use research and evidence to develop an understanding of the teaching profession and use both to measure their P-12 students’ progress and their own professional practice.\">1.2</option> <option value=\"1.3\" title=\"Providers ensure that candidates apply content and pedagogical knowledge as reflected in outcome assessments in response to standards of Specialized Professional Associations (SPA), the National Board for Professional Teaching Standards (NBPTS), states, or other accrediting bodies (e.g., National Association of Schools of Music – NASM).\">1.3</option><option value=\"1.4\" title=\"Providers ensure that candidates demonstrate skills and commitment that afford all P-12 students access to rigorous college- and career-ready standards (e.g., Next Generation Science Standards, National Career Readiness Certificate, Common Core State Standards).\">1.4</option><option value=\"1.5\" title=\"Providers ensure that candidates model and apply technology standards as they design, implement and assess learning experiences to engage students and improve learning; and enrich professional practice.\">1.5</option> <option value=\"2.1\" title=\"Partners co-construct mutually beneficial P-12 school and community arrangements, including technology-based collaborations, for clinical preparation and share responsibility for continuous improvement of candidate preparation. Partnerships for clinical preparation can follow a range of forms, participants, and functions. They establish mutually agreeable expectations for candidate entry, preparation, and exit; ensure that theory and practice are linked; maintain coherence across clinical and academic components of preparation; and share accountability for candidate outcomes.\">2.1</option> <option value=\"2.2\" title=\"Partners co-select, prepare, evaluate, support, and retain high-quality clinical educators, both provider- and school-based, who demonstrate a positive impact on candidates’ development and P-12 student learning and development. In collaboration with their partners, providers use multiple indicators and appropriate technology-based applications to establish, maintain, and refine criteria for selection, professional development, performance evaluation, continuous improvement, and retention of clinical educators in all clinical placement settings.\">2.2</option> <option value=\"2.3\" title=\"The provider works with partners to design clinical experiences of sufficient depth, breadth, diversity, coherence, and duration to ensure that candidates demonstrate their developing effectiveness and positive impact on all students’ learning and development. Clinical experiences, including technology-enhanced learning opportunities, are structured to have multiple performance-based assessments at key points within the program to demonstrate candidates’ development of the knowledge, skills, and professional dispositions, as delineated in Standard 1, that are associated with a positive impact on the learning and development of all P-12 students.\">2.3</option> <option value=\"3.1\" title=\"The provider presents plans and goals to recruit and support completion of high-quality candidates from a broad range of backgrounds and diverse populations to accomplish their mission. The admitted pool of candidates reflects the diversity of America’s P-12 students. The provider demonstrates efforts to know and address community, state, national, regional, or local needs for hard-to-staff schools and shortage fields, currently, STEM, English-language learning, and students with disabilities.\">3.1</option> <option value=\"3.2\" title=\"The provider meets CAEP minimum criteria or the state’s minimum criteria for academic achievement, whichever are higher, and gathers disaggregated data on the enrolled candidates whose preparation begins during an academic year. The CAEP minimum criteria are a grade point average of 3.0 and a group average performance on nationally normed assessments or substantially equivalent statenormed assessments of mathematical, reading and writing achievement in the top 50 percent of those assessed...\">3.2</option> <option value=\"3.3\" title=\"Educator preparation providers establish and monitor attributes and dispositions beyond academic ability that candidates must demonstrate at admissions and during the program. The provider selects criteria, describes the measures used and evidence of the reliability and validity of those measures, and reports data that show how the academic and non-academic factors predict candidate performance in the program and effective teaching.\">3.3</option> <option value=\"3.4\" title=\"The provider creates criteria for program progression and monitors candidates’ advancement from admissions through completion. All candidates demonstrate the ability to teach to college- and career-ready standards. Providers present multiple forms of evidence to indicate candidates’ developing content knowledge, pedagogical content knowledge, pedagogical skills, and the integration of technology in all of these domains.\">3.4</option> <option value=\"3.5\" title=\"Before the provider recommends any completing candidate for licensure or certification, it documents that the candidate has reached a high standard for content knowledge in the fields where certification is sought and can teach effectively with positive impacts on P-12 student learning and development.\">3.5</option> <option value=\"3.6\" title=\"Before the provider recommends any completing candidate for licensure or certification, it documents that the candidate understands the expectations of the profession, including codes of ethics, professional standards of practice, and relevant laws and policies. CAEP monitors the development of measures that assess candidates’ success and revises standards in light of new results.\">3.6</option> <option value=\"4.1\" title=\"The provider documents, using multiple measures that program completers contribute to an expected level of student-learning growth. Multiple measures shall include all available growth measures (including value-added measures, student-growth percentiles, and student learning and development objectives) required by the state for its teachers and available to educator preparation providers, other state-supported P-12 impact measures, and any other measures employed by the provider.\">4.1</option> <option value=\"4.2\" title=\"The provider demonstrates, through structured validated observation instruments and/or student surveys, that completers effectively apply the professional knowledge, skills, and dispositions that the preparation experiences were designed to achieve.\">4.2</option> <option value=\"4.3\" title=\"The provider demonstrates, using measures that result in valid and reliable data and including employment milestones such as promotion and retention, that employers are satisfied with the completers’ preparation for their assigned responsibilities in working with P-12 students.\">4.3</option> <option value=\"4.4\" title=\"The provider demonstrates, using measures that result in valid and reliable data, that program completers perceive their preparation as relevant to the responsibilities they confront on the job, and that the preparation was effective.\">4.4</option> <option value=\"5.1\" title=\"The provider’s quality assurance system is comprised of multiple measures that can monitor candidate progress, completer achievements, and provider operational effectiveness. Evidence demonstrates that the provider satisfies all CAEP standards.\">5.1</option> <option value=\"5.2\" title=\"The provider’s quality assurance system relies on relevant, verifiable, representative, cumulative and actionable measures, and produces empirical evidence that interpretations of data are valid and consistent.\">5.2</option> <option value=\"5.3\" title=\"The provider regularly and systematically assesses performance against its goals and relevant standards, tracks results over time, tests innovations and the effects of selection criteria on subsequent progress and completion, and uses results to improve program elements and processes.\">5.3</option> <option value=\"5.4\" title=\"Measures of completer impact, including available outcome data on P-12 student growth, are summarized, externally benchmarked, analyzed, shared widely, and acted upon in decision-making related to programs, resource allocation, and future direction.\">5.4</option> <option value=\"5.5\" title=\"The provider assures that appropriate stakeholders, including alumni, employers, practitioners, school and community partners, and others defined by the provider, are involved in program evaluation, improvement, and identification of models of excellence. (see caepnet.org)\">5.5</option> </select></div>";
					                    } else {
					                        document.getElementById("add_caep").innerHTML = "";
					                    }
					                } else {
					                    selection.checked = true; 
					                }                
					            }
					            function addObjective() {
					                /*Here we add the variables required to verify the selection of the check boxes*/
					                var amountObjectivesLoc = document.getElementById("amountObjectives");
					                var amountObjectives = Number(amountObjectivesLoc.value);
					                amountObjectives += 1; 
					                amountObjectivesLoc.value = amountObjectives.toString();
					                var caep = document.getElementById("caep");

					                var general = "<div class=\"objective\"><span class=\"objective_tag\">Objetivo " + amountObjectives + ": </span><span><textarea class=\"objective_info\" name=\"objective_" + amountObjectives + "\"  placeholder=\"Introduzca la descripci\u00f3n del objetivo " + amountObjectives + "\" rows=\"3\"></textarea></span></div><div class=\"align_tag\">Alineado con:</div>";

					                var caep_strg = "<div class=\"caep_stds\"><span>CAEP:</span><input type=\"text\" name=\"caep_stds_" + amountObjectives + "\" class=\"caep_stds_info\" readonly required><div class=\"botones_objetivos\"><button class=\"add\" name=\"caep_stds_add_" + amountObjectives + "\" type=\"button\" onclick=\"addCaepStdToInputField(this.name)\">A\u00f1adir</button><br><button class=\"remove\" name=\"caep_stds_remove_" + amountObjectives + "\" type=\"button\" onclick=\"removeCaepStdFromInputField(this.name)\">Remover</button></div><select name=\"all_caep_stds_" + amountObjectives + "\" class=\"all_caep_stds\"><option value=\"\">Seleccione un est\u00e1ndar</option> <option value=\"1.1\" title=\"Candidates demonstrate an understanding of the 10 InTASC standards at the appropriate progression level(s) in the following categories: the learner and learning; content; instructional practice; and professional responsibility.\">1.1</option> <option value=\"1.2\" title=\"Providers ensure that candidates use research and evidence to develop an understanding of the teaching profession and use both to measure their P-12 students’ progress and their own professional practice.\">1.2</option> <option value=\"1.3\" title=\"Providers ensure that candidates apply content and pedagogical knowledge as reflected in outcome assessments in response to standards of Specialized Professional Associations (SPA), the National Board for Professional Teaching Standards (NBPTS), states, or other accrediting bodies (e.g., National Association of Schools of Music – NASM).\">1.3</option><option value=\"1.4\" title=\"Providers ensure that candidates demonstrate skills and commitment that afford all P-12 students access to rigorous college- and career-ready standards (e.g., Next Generation Science Standards, National Career Readiness Certificate, Common Core State Standards).\">1.4</option><option value=\"1.5\" title=\"Providers ensure that candidates model and apply technology standards as they design, implement and assess learning experiences to engage students and improve learning; and enrich professional practice.\">1.5</option> <option value=\"2.1\" title=\"Partners co-construct mutually beneficial P-12 school and community arrangements, including technology-based collaborations, for clinical preparation and share responsibility for continuous improvement of candidate preparation. Partnerships for clinical preparation can follow a range of forms, participants, and functions. They establish mutually agreeable expectations for candidate entry, preparation, and exit; ensure that theory and practice are linked; maintain coherence across clinical and academic components of preparation; and share accountability for candidate outcomes.\">2.1</option> <option value=\"2.2\" title=\"Partners co-select, prepare, evaluate, support, and retain high-quality clinical educators, both provider- and school-based, who demonstrate a positive impact on candidates’ development and P-12 student learning and development. In collaboration with their partners, providers use multiple indicators and appropriate technology-based applications to establish, maintain, and refine criteria for selection, professional development, performance evaluation, continuous improvement, and retention of clinical educators in all clinical placement settings.\">2.2</option> <option value=\"2.3\" title=\"The provider works with partners to design clinical experiences of sufficient depth, breadth, diversity, coherence, and duration to ensure that candidates demonstrate their developing effectiveness and positive impact on all students’ learning and development. Clinical experiences, including technology-enhanced learning opportunities, are structured to have multiple performance-based assessments at key points within the program to demonstrate candidates’ development of the knowledge, skills, and professional dispositions, as delineated in Standard 1, that are associated with a positive impact on the learning and development of all P-12 students.\">2.3</option> <option value=\"3.1\" title=\"The provider presents plans and goals to recruit and support completion of high-quality candidates from a broad range of backgrounds and diverse populations to accomplish their mission. The admitted pool of candidates reflects the diversity of America’s P-12 students. The provider demonstrates efforts to know and address community, state, national, regional, or local needs for hard-to-staff schools and shortage fields, currently, STEM, English-language learning, and students with disabilities.\">3.1</option> <option value=\"3.2\" title=\"The provider meets CAEP minimum criteria or the state’s minimum criteria for academic achievement, whichever are higher, and gathers disaggregated data on the enrolled candidates whose preparation begins during an academic year. The CAEP minimum criteria are a grade point average of 3.0 and a group average performance on nationally normed assessments or substantially equivalent statenormed assessments of mathematical, reading and writing achievement in the top 50 percent of those assessed...\">3.2</option> <option value=\"3.3\" title=\"Educator preparation providers establish and monitor attributes and dispositions beyond academic ability that candidates must demonstrate at admissions and during the program. The provider selects criteria, describes the measures used and evidence of the reliability and validity of those measures, and reports data that show how the academic and non-academic factors predict candidate performance in the program and effective teaching.\">3.3</option> <option value=\"3.4\" title=\"The provider creates criteria for program progression and monitors candidates’ advancement from admissions through completion. All candidates demonstrate the ability to teach to college- and career-ready standards. Providers present multiple forms of evidence to indicate candidates’ developing content knowledge, pedagogical content knowledge, pedagogical skills, and the integration of technology in all of these domains.\">3.4</option> <option value=\"3.5\" title=\"Before the provider recommends any completing candidate for licensure or certification, it documents that the candidate has reached a high standard for content knowledge in the fields where certification is sought and can teach effectively with positive impacts on P-12 student learning and development.\">3.5</option> <option value=\"3.6\" title=\"Before the provider recommends any completing candidate for licensure or certification, it documents that the candidate understands the expectations of the profession, including codes of ethics, professional standards of practice, and relevant laws and policies. CAEP monitors the development of measures that assess candidates’ success and revises standards in light of new results.\">3.6</option> <option value=\"4.1\" title=\"The provider documents, using multiple measures that program completers contribute to an expected level of student-learning growth. Multiple measures shall include all available growth measures (including value-added measures, student-growth percentiles, and student learning and development objectives) required by the state for its teachers and available to educator preparation providers, other state-supported P-12 impact measures, and any other measures employed by the provider.\">4.1</option> <option value=\"4.2\" title=\"The provider demonstrates, through structured validated observation instruments and/or student surveys, that completers effectively apply the professional knowledge, skills, and dispositions that the preparation experiences were designed to achieve.\">4.2</option> <option value=\"4.3\" title=\"The provider demonstrates, using measures that result in valid and reliable data and including employment milestones such as promotion and retention, that employers are satisfied with the completers’ preparation for their assigned responsibilities in working with P-12 students.\">4.3</option> <option value=\"4.4\" title=\"The provider demonstrates, using measures that result in valid and reliable data, that program completers perceive their preparation as relevant to the responsibilities they confront on the job, and that the preparation was effective.\">4.4</option> <option value=\"5.1\" title=\"The provider’s quality assurance system is comprised of multiple measures that can monitor candidate progress, completer achievements, and provider operational effectiveness. Evidence demonstrates that the provider satisfies all CAEP standards.\">5.1</option> <option value=\"5.2\" title=\"The provider’s quality assurance system relies on relevant, verifiable, representative, cumulative and actionable measures, and produces empirical evidence that interpretations of data are valid and consistent.\">5.2</option> <option value=\"5.3\" title=\"The provider regularly and systematically assesses performance against its goals and relevant standards, tracks results over time, tests innovations and the effects of selection criteria on subsequent progress and completion, and uses results to improve program elements and processes.\">5.3</option> <option value=\"5.4\" title=\"Measures of completer impact, including available outcome data on P-12 student growth, are summarized, externally benchmarked, analyzed, shared widely, and acted upon in decision-making related to programs, resource allocation, and future direction.\">5.4</option> <option value=\"5.5\" title=\"The provider assures that appropriate stakeholders, including alumni, employers, practitioners, school and community partners, and others defined by the provider, are involved in program evaluation, improvement, and identification of models of excellence. (see caepnet.org)\">5.5</option> </select></div>";

					                if (caep.checked) {
					                    document.getElementById("new_objective").innerHTML += "<div>" + general + caep_strg + "</div>";
					                }
					            }
					            function removeObjective() {
					                var amountObjectivesLoc = document.getElementById("amountObjectives");
					                var amountObjectivesCont = Number(amountObjectivesLoc.value);
					                if(amountObjectivesCont>1) {
					                    var div = document.getElementById("new_objective");
					                    div.removeChild(div.lastChild);
					                    amountObjectivesCont -= 1;
					                    amountObjectivesLoc.value = amountObjectivesCont.toString();
					                }
					            }
					            function addThematicCont() {
					                var amountThematicContLoc = document.getElementById("amountThematicContent");
					                var amountThematicCont = Number(amountThematicContLoc.value);
					                amountThematicCont += 1;
					                amountThematicContLoc.value = amountThematicCont.toString();
					                document.getElementById("new_thematic_content").innerHTML += "<div class=\"thematic_content\">                            <span>" + amountThematicCont + ". </span><input type=\"text\" class=\"thematic_info\" name=\"thematic_info_" + amountThematicCont + "\" placeholder=\"Introduzca el contenido tem\u00e1tico\" required></div>";
					            }
					            function removeThematicCont() {
					                var amountThematicContLoc = document.getElementById("amountThematicContent");
					                var amountThematicCont = Number(amountThematicContLoc.value);
					                if(amountThematicCont>1) {
					                    var div = document.getElementById("new_thematic_content");
					                    div.removeChild(div.lastChild);
					                    amountThematicCont -= 1;
					                    amountThematicContLoc.value = amountThematicCont.toString();
					                }
					            }
					            function addTeachingStrat() {
					                var amountTeachingStratLoc = document.getElementById("amountTeachingStrategies");
					                var amountTeachingStrat = Number(amountTeachingStratLoc.value);
					                amountTeachingStrat += 1;
					                amountTeachingStratLoc.value = amountTeachingStrat.toString();
					                document.getElementById("new_teaching_strat").innerHTML += "<div class=\"teaching_strat\">                  <span>" + amountTeachingStrat + ". </span><input type=\"text\" name=\"teaching_strat_" + amountTeachingStrat + "\" class=\"teaching_strat_info\" required list=\"teaching_strats\" /></div>";
					            }
					            function removeTeachingStrat() {
					                var amountTeachingStratLoc = document.getElementById("amountTeachingStrategies");
					                var amountTeachingStrat = Number(amountTeachingStratLoc.value);
					                if(amountTeachingStrat>1) {
					                    var div = document.getElementById("new_teaching_strat");
					                    div.removeChild(div.lastChild);
					                    amountTeachingStrat -= 1;
					                    amountTeachingStratLoc.value = amountTeachingStrat.toString();
					                }                
					            }
					            function addAssessmentStrat() {
					                var amountAssessmentStratLoc = document.getElementById("amountAssessmentStrategies");
					                var amountAssessmentStrat = Number(amountAssessmentStratLoc.value);
					                amountAssessmentStrat += 1;
					                amountAssessmentStratLoc.value = amountAssessmentStrat.toString();
					                document.getElementById("new_assessment_strat").innerHTML += "<div class=\"assessment_strat\">             <span>" + amountAssessmentStrat + ". </span><input type=\"text\" name=\"assessment_strat_" + amountAssessmentStrat + "\"  class=\"assessment_strat_info\" required list=\"assessment_strats\"/></div>";                
					            }
					            function removeAssessmentStrat() {
					                var amountAssessmentStratLoc = document.getElementById("amountAssessmentStrategies");
					                var amountAssessmentStrat = Number(amountAssessmentStratLoc.value);
					                if(amountAssessmentStrat>1) {
					                    var div = document.getElementById("new_assessment_strat");
					                    div.removeChild(div.lastChild);
					                    amountAssessmentStrat -= 1;
					                    amountAssessmentStratLoc.value = amountAssessmentStrat.toString();
					                }             
					            }
					            function addTextbook() {
					                var amountTextbookLoc = document.getElementById("amountTextbooks");
					                var amountTextbook = Number(amountTextbookLoc.value);
					                amountTextbook += 1;
					                amountTextbookLoc.value = amountTextbook.toString();
					                document.getElementById("new_textbook").innerHTML += "<div class=\"textbook_content\">                            <span>" + amountTextbook + ". </span><input type=\"text\" class=\"textbook_info\" name=\"textbook_info_" + amountTextbook + "\" placeholder=\"Introduzca el libro de texto\" required></div>"; 
					            }
					            function removeTextbook() {
					                var amountTextbookLoc = document.getElementById("amountTextbooks");
					                var amountTextbook = Number(amountTextbookLoc.value);
					                if(amountTextbook>1) {
					                    var div = document.getElementById("new_textbook");
					                    div.removeChild(div.lastChild);
					                    amountTextbook -= 1;
					                    amountTextbookLoc.value = amountTextbook.toString();
					                } 
					            }
					            function addBibliography() {
					                var amountBibliographyLoc = document.getElementById("amountBibliographies");
					                var amountBibliography = Number(amountBibliographyLoc.value);
					                amountBibliography += 1;
					                amountBibliographyLoc.value = amountBibliography.toString();
					                document.getElementById("new_bibliography").innerHTML += "<div class=\"bibliography_content\">                            <span>" + amountBibliography + ". </span><input type=\"text\" class=\"bibliography_info\" name=\"bibliography_info_" + amountBibliography + "\" placeholder=\"Introduzca la bibliograf\u00eda\" required></div>";
					            }
					            function removeBibliography() {
					                var amountBibliographyLoc = document.getElementById("amountBibliographies");
					                var amountBibliography = Number(amountBibliographyLoc.value);
					                if(amountBibliography>1) {
					                    var div = document.getElementById("new_bibliography");
					                    div.removeChild(div.lastChild);
					                    amountBibliography -= 1;
					                    amountBibliographyLoc.value = amountBibliography.toString();
					                }
					            }
					            function addOnlineRes() {
					                var amountOnlineResLoc = document.getElementById("amountOnlineResources");
					                var amountOnlineRes = Number(amountOnlineResLoc.value);
					                amountOnlineRes += 1;
					                amountOnlineResLoc.value = amountOnlineRes.toString();
					                document.getElementById("new_online_res").innerHTML += "<div class=\"online_res_content\">                            <span>" + amountOnlineRes + ". </span><input type=\"text\" class=\"online_res_info\" name=\"online_res_info_" + amountOnlineRes + "\" placeholder=\"Introduzca el recurso\" required></div>";
					            }
					            function removeOnlineRes() {
					                var amountOnlineResLoc = document.getElementById("amountOnlineResources");
					                var amountOnlineRes = Number(amountOnlineResLoc.value);
					                if(amountOnlineRes>1) {
					                    var div = document.getElementById("new_online_res");
					                    div.removeChild(div.lastChild);
					                    amountOnlineRes -= 1;
					                    amountOnlineResLoc.value = amountOnlineRes.toString();
					                }
					            }
					            function addCaepStdToInputField(buttonName) {
					                //get the number from the name 
					                var matches = buttonName.match(/(\d+)/); 
					                var number;
					                if (matches) { 
					                    number = matches[0];
					                    //search the drop-down based on the number discover and name that is known
					                    var dropdown = document.getElementsByName("all_caep_stds_"+number);
					                    //search the input field based on the number discover and name that is known
					                    var inputField = document.getElementsByName("caep_stds_" + number);
					                    //move the value from the drop-down to the input field
					                    if(inputField[0].value == "" && dropdown[0].value != "") {
					                        inputField[0].value = dropdown[0].value; 
					                    } else {
					                        //search if the value is already in the field
					                        if(inputField[0].value.search(dropdown[0].value) == -1) {
					                            //not found  
					                            inputField[0].value = inputField[0].value + " " + dropdown[0].value;
					                        } else {
					                            //found
					                            alert("El objetivo ya se encuentra en la lista.");
					                        }
					                    }
					                } else {
					                    alert("Error, number not found...");
					                }
					            }
					            function removeCaepStdFromInputField(buttonName) {
					                //get the number from the name 
					                var matches = buttonName.match(/(\d+)/); 
					                var number;
					                if (matches) { 
					                    number = matches[0];
					                    //search the drop-down based on the number discover and name that is known
					                    var dropdown = document.getElementsByName("all_caep_stds_"+number);
					                    //search the input field based on the number discover and name that is known
					                    var inputField = document.getElementsByName("caep_stds_" + number);
					                    //move the value from the drop-down to the input field
					                    if(inputField[0].value == "" && dropdown[0].value != "") {
					                        alert("No hay objetivo para remover!"); 
					                    } else {
					                        //search if the value is already in the field
					                        if(inputField[0].value.search(dropdown[0].value) == -1) {
					                            //not found  
					                            alert("El objetivo no se encuentra en la lista!");
					                        } else {
					                            //found
					                            //variable to hold individual objectives
					                            var objectives = inputField[0].value.split(" ");
					                            var location = objectives.indexOf(dropdown[0].value);
					                            //eliminate the objective from the array
					                            objectives.splice(location, 1);
					                            //write the information in the input field
					                            inputField[0].value = objectives.join(' ');
					                        }
					                    }
					                } else {
					                    alert("Error, number not found...");
					                }
					            }
			        		</script>
					    </body>
						</html>
							<%
						} else {
							// Error
							System.out.println("Error: Course code not found...");
							// Deleting session variables
							session.invalidate();
							// Return to the login page
							response.sendRedirect("login.jsp");
						}
			        } else {
			        	// Define a SyllabusInfo object to help store the information
						SyllabusInfo syllabus = new SyllabusInfo();
			        	// Load information from session variables
			        	syllabus = (SyllabusInfo) session.getAttribute("syllabus");

			        	// Extract the course code from the object
			        	courseCode = syllabus.getCode();

			        	// Search basic information of the course
						res = appDBMnger.searchCourseInfo(courseCode);
						// Verify if a result was found
						if(res.next()) {
							%>
							<div class = "cuadro_centro">
					            <form action="processSyllabusInfo.jsp" method="post">               
					                <!--Section of course code-->
					                <div id = "course_code">
					                    <span id= course_code_tag>C&oacute;digo del Curso:</span>
					                    <input type="text"  name="course_code" id="course_code_info" value="<%=res.getString(1)%>" readonly>
					                </div>
					                
					                <!--Section of course title-->
					                <div id="course_title">
					                    <span id = "title_tag">T&iacute;tulo del curso:</span>
					                    <input type="text" id="course_title_info" name="course_title" value="<%=res.getString(2)%>" readonly>
					                </div>
					                
					                <!--Section of course type-->
					                <div id="course_type">
					                    <span id = "course_type_tag">Tipo de Curso:</span>
					                    <input type="text" id="course_type_info" name="course_type" value="<%=res.getString(3)%>" readonly>
					                </div>
					                
					                <!--Section of modality-->
					                <div id="modality">
					                    <span id = "modality_tag">Modalidad:</span>
					                    <input type="text" id="modality_info" name="modality" value="<%=res.getString(4)%>" readonly>
					                </div>
					                
					                <!--Section of course level-->
					                <div id="level">
					                    <span id = "level_tag">Nivel:</span>
					                    <input type="text" id="nivel" name="nivel" value="<%=res.getString(5).substring(0, 1).toUpperCase() + res.getString(5).substring(1)%>" readonly>
					                </div>

					                <%

					                // Define an string variable to hold all the prerequisites
					                String prerequisites = "";
					                // Extract the prerequisites from the syllabus object
					                for(int i = 0; i<syllabus.getPrerequisites().size(); i++) {
					                	// Verify if it is the first iteration
					                	if(i==0)
					                		prerequisites = syllabus.getPrerequisites().get(i);
					                	else
					                		prerequisites += ", " + syllabus.getPrerequisites().get(i);
					                }

					                %>

					                <!--Section of course prerequisite-->
					                <div id="prerequisite">
					                    <span id = "prerequisite_tag">Prerrequisito/s:</span>
					                    <input type="text" id="prerequisite_info" name="prerequisite" placeholder="Introduzca el/los prerrequisito/s separados por comas" value="<%=prerequisites%>">
					                </div>
					                
					                <%

					                // Define an string variable to hold all the co-requisites
					                String corequisites = "";
					                // Extract the co-requisites from the syllabus object
					                for(int i = 0; i<syllabus.getCorequisites().size(); i++) {
					                	// Verify if it is the first iteration
					                	if(i==0) 
					                		corequisites = syllabus.getCorequisites().get(i);
					                	else
					                		corequisites += ", " + syllabus.getCorequisites().get(i);
					                }

					                %>

					                <!--Section of course co-requisite-->
					                <div id="corequisite">
					                    <span id = "corequisite_tag">Correquisito/s:</span>
					                    <input type="text" id="corequisite_info" name="corequisite" placeholder="Introduzca el/los correquisito/s separados por comas" value="<%=corequisites%>">
					                </div>

					                
					                <!--Section of course duration-->
					                <div id="duration">
					                    <span id="duration_tag">Duraci&oacute;n:</span>
					                    <input type="text" id="duration_info" name="duration" placeholder="Introduzca la duraci&oacute;n del curso" required value="<%=syllabus.getDuration()%>">
					                </div>
					                
					                <!--Section of credits-->
					                <div id="credits">
					                    <span id = "credits_tag">Cr&eacute;ditos:</span>
					                    <input type="text" id="credits_info" name="credits" placeholder="Introduzca la cantidad de cr&eacute;ditos del curso" required value="<%=syllabus.getCredits()%>">
					                </div>
					                
					                <!--Section of Course description-->
					                <div id="description">
					                    <span id="description_tag">Descripci&oacute;n del Curso:</span>
					                    <textarea id="description_info" name="description" placeholder="Introduzca la descripci&oacute;n del curso" rows="4" required><%=syllabus.getDescription()%></textarea>
					                </div>

					                <!--Section of Course Justification -->
					                <div id="justification">
					                    <span id="justification_tag">Justificaci&oacute;n: </span>
					                    <textarea id="justification_info" name="justification" placeholder="Introduzca la justificaci&oacute;n del curso" rows="4" required><%=syllabus.getJustification()%></textarea>
					                </div>
					                
					                <!--Section of Objectives-->
					                <div id="objectives">
					                    <div id="objectives_tag">Objetivos Generales:</div>
					                    <!--Section for selecting the agencies that apply to a particular syllabus-->
					                    <fieldset id="agencias">
					                        <legend>Agencias que aplican</legend>
					                        <%/*If more agencies are available, decision structure is
					                            needed to add the "checked" property to the appropriate agencies*/%>
					                        <!--Here are going the check-boxes with the names of the agencies-->
					                        <input type="checkbox" name="caep" id="caep" value="caep" checked/> CAEP
					                    </fieldset>
					                    
					                    <!--hidden field to know the amount of objectives to be collected from the processing JSP, value should change with JavaScript-->
					                    <input type="hidden" name="amountObjectives" id="amountObjectives" value="<%=syllabus.getObjectives().size()%>">
					                    
					                    <div class="objective">
					                        <span class="objective_tag">Objetivo 1: </span>
					                        <span><textarea class="objective_info" name="objective_1" placeholder="Introduzca la descripci&oacute;n del objetivo 1" rows="3" required><%=syllabus.getObjectives().get(0).getDescription()%></textarea></span>
					                    </div>
					                        
					                    <div class="align_tag">Alineado con:</div>
					                    
					                    <%

					                    String caepStds = "";
					                    // Determine the amount of alignments elements for the first objective
					                    int alignmentSize = syllabus.getObjectives().get(0).getObjectiveAlignment().size();
					                    // Iterate over the alignment ids
					                    for(int i=0; i<alignmentSize; i++) {
					                    	/* If more agencies are added, we need to verify the agency id,
					                    	   to know to which agency the objectives belongs to. For now,
					                    	   this is not needed*/
					                    	caepStds += syllabus.getObjectives().get(0).getObjectiveAlignment().get(i).getObjectiveId() + " ";
					                    }

					                    %>

					                    <div id="add_caep">
					                    	<div class="caep_stds">
					                    		<span>CAEP:</span><input type="text" name="caep_stds_1" class="caep_stds_info" readonly value="<%=caepStds%>">
					                    	</div>
					                    </div>
					                    
					               	 	<%// Add the other objectives inside this div tag%>
					                	<div id="new_objective">
					                		<%
					                		// Iterate from the second objective forward
					                		for(int i=1; i<syllabus.getObjectives().size(); i++) {
					                			%>
					                			<div class="objective">
						                			<span class="objective_tag">Objetivo <%=i+1%>: </span>
						                			<span><textarea class="objective_info" name="objective_<%=i+1%>" placeholder="Introduzca la descripci\u00f3n del objetivo <%=i+1%>" rows="3"><%=syllabus.getObjectives().get(i).getDescription()%></textarea></span>
						                		</div>
					                			<%

					                			caepStds = "";
					                			// Determine the amount of alignment elements
							                    alignmentSize = syllabus.getObjectives().get(i).getObjectiveAlignment().size();
							                    // Iterate over the alignment ids
							                    for(int j=0; j<alignmentSize; j++) {
							                    	/*If more agencies are added, we need to verify the agency id,
							                    	  to know to which agency the objectives belongs to. For now,
							                    	  this is not needed*/
							                    	caepStds += syllabus.getObjectives().get(0).getObjectiveAlignment().get(j).getObjectiveId() + " ";
							                    }

							                    %>
							                    <div class="align_tag">Alineado con:</div>
						                		<div class="caep_stds">
						                			<span>CAEP:</span><input type="text" name="caep_stds_<%=i+1%>" class="caep_stds_info" readonly required value="<%=caepStds%>">
						                		</div>
							                    <%
					                		}
					                		%>
					                	</div>
					                </div>
					                
					                <!--Section thematic content-->
					                <!--hidden field to know the amount of thematic content to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountThematicContent" id="amountThematicContent" value="<%=syllabus.getThematicContent().size()%>">
					                <div>
					                    <div id="thematic_content_1">
					                    	<span>Contenido tem&aacute;tico: 1. </span><input type="text" class="thematic_info" name="thematic_info_1" placeholder="Introduzca el contenido tem&aacute;tico" required value="<%=syllabus.getThematicContent().get(0)%>">
					                    </div>
					                    <!--New thematic content text input will be added here-->
					                    <div id="new_thematic_content">
					                        <%
					                        // Iterate the thematic content from the second one forward
					                        for(int i=1; i<syllabus.getThematicContent().size(); i++) {
					                        	%>
					                        	<div class="thematic_content">
						                            <span><%=i+1%>. </span><input type="text" class="thematic_info" name="thematic_info_<%=i+1%>" placeholder="Introduzca el contenido tem\u00e1tico" required value="<%=syllabus.getThematicContent().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div>
					                </div>
					                
					                <!--Section of teaching strategies-->
					                <!--hidden field to know the amount of teaching strategies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountTeachingStrategies" id="amountTeachingStrategies" value="<%=syllabus.getTeachingStrategies().size()%>">
					                <div>
					                    <div id="teaching_strat_1">
					                        <span>Estrategias de ense&ntilde;anza: 1.</span>
					                        <input type="text" name="teaching_strat_1" class="teaching_strat_info" placeholder="Introduzca una estrategia de ense&ntilde;anza" required value="<%=syllabus.getTeachingStrategies().get(0)%>">   
					                    </div>
					                    
					                    <div id="new_teaching_strat">
					                        <%
					                        // Iterate the teaching strategies from the second one forward
					                        for(int i=1; i<syllabus.getTeachingStrategies().size(); i++) {
					                        	%>
					                        	<div class="teaching_strat">
						                            <span><%=i+1%>. </span><input type="text" name="teaching_strat_<%=i+1%>" class="teaching_strat_info" required value="<%=syllabus.getTeachingStrategies().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div>
					                </div>
					                
					                <!--Section of Assessment strategies-->
					                <!--hidden field to know the amount of Assessment strategies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountAssessmentStrategies" id="amountAssessmentStrategies" value="<%=syllabus.getAssessmentStrategies().size()%>">
					                <div>
					                    <div id="assessment_strat_1">
					                        <span>Estrategias de assessment: 1.</span>
					                        	<input type="text" name="assessment_strat_1" class="assessment_strat_info" placeholder="Introduzca una estrategia de assessment" required value="<%=syllabus.getAssessmentStrategies().get(0)%>"> 
					                    </div>
					                    
					                    <div id="new_assessment_strat">
					                        <%
					                        // Iterate the assessment strategies from the second one forward
					                        for(int i=1; i<syllabus.getAssessmentStrategies().size(); i++) {
					                        	%>
					                        	<div class="assessment_strat">
						                        	<span><%=i+1%>. </span><input type="text" name="assessment_strat_<%=i+1%>"  class="assessment_strat_info" required value="<%=syllabus.getAssessmentStrategies().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div>
					                </div>              
					                
					                <!--Section of grades-->
					                <div id="grades">
					                    <div id="grades_tag">Sistema de Notas: Sistema Est&aacute;ndar (A, B, C, D, F)</div>
					                </div>
					                
					                <!--Section of Textbook-->
					                <!--hidden field to know the amount of Textbooks to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountTextbooks" id="amountTextbooks" value="<%=syllabus.getTextbooks().size()%>">
					                <div>
					                    <div id="textbook_1">
					                    	<span>Libro de texto: 1. </span><input type="text" class="textbook_info" name="textbook_info_1" placeholder="Introduzca el libro de texto" required value="<%=syllabus.getTextbooks().get(0)%>">
					                    </div>
					                    <!--New Textbook text input will be added here-->
					                    <div id="new_textbook">
					                        <%
					                        // Iterate the textbooks from the second one forward
					                        for(int i=1; i<syllabus.getTextbooks().size(); i++) {
					                        	%>
					                        	<div class="textbook_content">
						                        	<span><%=i+1%>. </span><input type="text" class="textbook_info" name="textbook_info_<%=i+1%>" placeholder="Introduzca el libro de texto" required value="<%=syllabus.getTextbooks().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div>
					                </div>
					                
					                <!--Section of Bibliography-->
					                <!--hidden field to know the amount of Bibliographies to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountBibliographies" id="amountBibliographies" value="<%=syllabus.getBibliography().size()%>">
					                <div>
					                    <div id="bibliography_1">
					                    	<span>Bibliograf&iacute;a: 1. </span><input type="text" class="bibliography_info" name="bibliography_info_1" placeholder="Introduzca la bibliograf&iacute;a" required value="<%=syllabus.getBibliography().get(0)%>">
					                    </div>
					                    <!--New bibliography text input will be added here-->
					                    <div id="new_bibliography">
					                        <%
					                        // Iterate the bibliographies from the second one forward
					                        for(int i=1; i<syllabus.getBibliography().size(); i++) {
					                        	%>
					                        	<div class="bibliography_content">
						                        	<span><%=i+1%>. </span><input type="text" class="bibliography_info" name="bibliography_info_<%=i+1%>" placeholder="Introduzca la bibliograf\u00eda" required value="<%=syllabus.getBibliography().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div> 
					                </div>
					                
					                <!--Section of Online Resources-->
					                <!--hidden field to know the amount of Online Resources to be collected from the processing JSP, value should change with JavaScript-->
					                <input type="hidden" name="amountOnlineResources" id="amountOnlineResources" value="<%=syllabus.getOnlineResources().size()%>">
					                <div>
					                    <div id="online_res_1">
					                    	<span>Recursos en l&iacute;nea: 1. </span><input type="text" class="online_res_info" name="online_res_info_1" placeholder="Introduzca el recurso" required value="<%=syllabus.getOnlineResources().get(0)%>">
					                    </div>
					                    <!--New online resource text input will be added here-->
					                    <div id="new_online_res">
					                        <%
					                        // Iterate the online resources from the second one forward
					                        for(int i=1; i<syllabus.getOnlineResources().size(); i++) {
					                        	%>
					                        	<div class="online_res_content">
						                        	<span><%=i+1%>. </span><input type="text" class="online_res_info" name="online_res_info_<%=i+1%>" placeholder="Introduzca el recurso" required value="<%=syllabus.getOnlineResources().get(i)%>">
						                        </div>
					                        	<%
					                        }
					                        %>
					                    </div>
					                </div>
					                <%
					                // Search the rules in the system
					                res = appDBMnger.listAllRules();
					                String checked = "";
					                // Verify if there is at least one result
					                if(!res.isAfterLast()) {
					                	// There is at least one result
					                    %>
					                    <!--Reglas-->
					                	<div id="reglas"><div>Reglas que aplican:</div>
					                		<table class="regla">
					                			<%
					                			counter = 0;
					                			// Iterate over the rules
					                			while(res.next()) {
					                				// Verify if the rule is in the array list to add the checked attribute
					                				if(syllabus.getRules().indexOf(res.getString(1))==-1) {
					                					// Rule is not in the list
					                					checked = "";
					                				} else {
					                					// Rule is in the list
					                					checked = "checked";
					                				}
					                				// Structure that makes sure that the rules are organize into two columns
					                				if(counter%2 == 0) {
					                					%>
					                					<tr>
						                            		<td><input type="checkbox" name="regla" value="<%=res.getString(1)%>"/> <%=res.getString(2)%></td>
					                					<%	
					                				} else {
					                					%>
						                					<td><input type="checkbox" name="regla" value="<%=res.getString(1)%>"/> <%=res.getString(2)%></td>
							                        	</tr>
					                					<%
					                				}
					                				counter++;
					                			}
					                			%>   
					                    	</table>              
					                	</div>
					                    <%
					                } else {
					                	// No result found, 
					                    System.out.println("There are no rules in the system. Add the required rules to access the syllabus creation page.");
					                    // Return to the searchNewCourse page
										response.sendRedirect("searchNewCourse.jsp");
					                }
					                %>                   
					                <!--End Buttons-->
					                <div id="buttons">
					                    <button id ="cancel" type="button" onclick="window.location.href='searchNewCourse.jsp';">Cancelar</button>
					                    <button id ="submit" type="submit">Someter</button>
					                </div>
					            </form>
					        </div>
					        <div id="bottom_padding"></div>
					    </body>
					</html>
							<%
						} else {
							// Error
							System.out.println("Error: Course code not found...");
							// Deleting session variables
							session.invalidate();
							// Return to the login page
							response.sendRedirect("login.jsp");
						}
			        }
			        // Close DB connection
					appDBMnger.close();
				} else {
					// The user can not be authenticated
					// Deleting session variables
					session.invalidate();
					// Return to the login page
					response.sendRedirect("login.jsp");
				}
				// Close the result set
				res.close();
				// Close the connection to the database
				appDBAuth.close();
			} else {
				// The user does not have access to the current page
				// Deleting session variables
				session.invalidate();
				// Return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
			%>
			Nothing to show!
			<%
			e.printStackTrace();
			// Deleting session variables
			session.invalidate();
			// Return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>