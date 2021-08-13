<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

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
		String currentPage = "courseSyllabusPreview.jsp";
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
					// Get the user role
					String userRole = res.getString(1);	
					
					// Create the current page attribute
					session.setAttribute("currentPage", "courseSyllabusPreview.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					%>
					<!DOCTYPE html>
					<html lang="es">
					    <head>
					        <!--Indicates the encoding of the characters-->
					        <meta charset="utf-8">
					        <!--Authors of the web page-->
					        <meta name="author" content="a-carrasquillo, arivesan">
					        <!--Importing the CSS style-sheet-->
					        <link rel = "stylesheet" type="text/css" href="css/courseSyllabusPreview.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>Preview del Prontuario</title>
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
					// Verify the role of the user to load the appropriate menu
					if(appDBAuth.isAdministrator(userRole) || appDBAuth.isSubManager(userRole)) {
						// Load the admin menu
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
					} else if(appDBAuth.isProfessor(userRole)) {
						// Load professor display
						// These options are still to be implemented, the last one
						// need to be adapted from the admins version
						/*%>
						<li><a href="pendingRequestStatus.jsp">Estado de solicitudes</a></li>
	                    <li><a href="holdList.jsp">Lista de prontuarios retenidos</a></li>
	                    <li><a href="searchNewCourse.jsp">Lista de Cursos sin prontuarios</a></li>
						<%*/
					} else if(appDBAuth.isEmployee(userRole)) {
						// Let in blank on purpose to avoid a error detection
					} else {
						// Error in the role value
						System.out.println("The role value is not recognize");
						// Deleting session variables
						session.invalidate();
						// Return to the login page
						response.sendRedirect("login.jsp");
					}
					%>
			                    <li><a href="signout.jsp">Logout</a></li>
			                </b>
			            </ul>
			          </nav>
			        </div>
			        <%// End of menu loading
			        // Parameters definition
			        String courseCode = "";
			        /* Verify if the previous page is the searchCourseCode or
			           searchProgramCourses, then retrieve parameters from the
			           form else, retrieve the parameters from session variables */
			        if(previousPage.equals("searchCourseCode.jsp") || previousPage.equals("searchProgramCourses.jsp")) {
			        	// Retrieve parameters from the form and remove the unnecessary
			        	// spaces from the start and end
						courseCode = request.getParameter("courseCode").trim();
						// Set session variables
						session.setAttribute("courseCode", courseCode);
			        } else {
			        	// Retrieve parameters from session variables and remove
			        	// the unnecessary spaces from the start and end
						courseCode = session.getAttribute("courseCode").toString().trim();
			        }
					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

					// Search the syllabus information of the course
					SyllabusInfo syllabus = appDBMnger.searchSyllabusInfo(courseCode);

					// Create a session variable for the syllabus info in case the user
					// wants to download it
					session.setAttribute("syllabus", syllabus);
					%>
			        <div class = "cuadro_centro">
			            <form action="editSyllabus.jsp" method="post">
			                <div class="container">
			                    <div><img class ="logo" src="images_icons/uni-logo.png" alt="Logo Ana G. Mendez"></div>
			                    <div><h2>Divisi&oacute;n de Educaci&oacute;n</h2></div>
			                    
			                    <input type="hidden" name="courseCode" value="<%=syllabus.getCode()%>">
			                    
			                    <input type="text" class="tag" value="C&oacute;digo del Curso:" readonly>
			                    <p class="info"><%=syllabus.getCode()%></p>
			                    
			                    <input type="text" class="tag" value="T&iacute;tulo del Curso:" readonly>
			                    <p class="info"><%=syllabus.getTitle()%></p>
			                    
			                    <input type="text" class="tag" value="Tipo de Curso:" readonly>
			                    <p class="info"><%=syllabus.getType()%></p>
			                    
			                    <input type="text" class="tag" value="Modalidad:" readonly>
			                    <p class="info"><%=syllabus.getModality()%></p>
			                    
			                    <input type="text" class="tag" value="Nivel:" readonly>
			                    <p class="info"><%=syllabus.getLevel().substring(0, 1).toUpperCase() + syllabus.getLevel().substring(1)%></p>

			                    <%
			                    // Variable to hold the prerequisites
			                    String prerequisites = "";

			                    // Verify if there are prerequisites
			                    if(!syllabus.getPrerequisites().isEmpty()) {
			                    	// Iterate over the information
			                    	for(int i=0; i<syllabus.getPrerequisites().size(); i++) {
			                    		// Verify that is not the last prerequisite
			                    		if(i!=(syllabus.getPrerequisites().size()-1))
			                    			prerequisites += syllabus.getPrerequisites().get(i) + ", ";
			                    		else
			                    			prerequisites += syllabus.getPrerequisites().get(i);
			                    	}
			                    } else {
			                    	prerequisites = "N/A";
			                    }
			                    %>

			                    <input type="text" class="tag" value="Prerequesito/s:" readonly>
			                    <p class="info"><%=prerequisites%></p>

			                    <%
			                    // Variable to hold the co-requisites
			                    String corequisites = "";
			                    // Verify if there are co-requisites
			                    if(!syllabus.getCorequisites().isEmpty()) {
			                    	// Iterate over the information
			                    	for(int i=0; i<syllabus.getCorequisites().size(); i++) {
			                    		// Verify that is not the last co-requisite
			                    		if(i!=(syllabus.getCorequisites().size()-1))
			                    			corequisites += syllabus.getCorequisites().get(i) + ", ";
			                    		else
			                    			corequisites += syllabus.getCorequisites().get(i);
			                    	}
			                    } else {
			                    	corequisites = "N/A";
			                    }
			                    %>
			                    
			                    <input type="text" class="tag" value="Correquesito/s:" readonly>
			                    <p class="info"><%=corequisites%></p>
			                    
			                    <input type="text" class="tag" value="Duraci&oacute;n:" readonly>
			                    <p class="info"><%=syllabus.getDuration()%></p>
			                    
			                    <input type="text" class="tag" value="Cr&eacute;ditos:" readonly>
			                    <p class="info"><%=syllabus.getCredits()%></p>
			                    
			                    <input type="text" class="tag" value="Descripci&oacute;n del Curso:" readonly>
			                    <p class="info"><%=syllabus.getDescription()%></p>
			                    
			                    <input type="text" class="tag" value="Justificaci&oacute;n:" readonly>
			                    <p class="info"><%=syllabus.getJustification()%></p>

			                    <input type="text" class="tag" value="Objetivos Del Curso:" readonly>
			                    <p class="info">Al culminar el curso, el estudiante debe:</p>
			                    
			                    <table>
			                        <tr>
			                            <th>Objetivos del Curso</th>
			                            <th>CAEP</th><%// Remember that CAEP id = 0%>
			                        </tr>
			                        <%/* Remember that if more agencies are added, more code is needed
			                        to determine to which agency belongs each of the alignments*/%>

			                        <%
			                        // Iterate over the objectives
			                        for(int i=0; i<syllabus.getObjectives().size(); i++) {
			                        	%>
			                        	<tr>
				                            <td class="obj"><%=syllabus.getObjectives().get(i).getId()%>. <%=syllabus.getObjectives().get(i).getDescription()%></td>
				                            <%
				                            // Extract the objective alignment with CAEP
				                            String caepAlignment = "";
				                            for(int j=0; j<syllabus.getObjectives().get(i).getObjectiveAlignment().size(); j++) {
				                            	// Verify that is not the last alignment
				                            	if(j!=(syllabus.getObjectives().get(i).getObjectiveAlignment().size()-1)) {
				                            		// Verify the agency that the objective alignment belongs to
				                            		if(syllabus.getObjectives().get(i).getObjectiveAlignment().get(j).getId().equals("0"))
				                            			caepAlignment += syllabus.getObjectives().get(i).getObjectiveAlignment().get(j).getObjectiveId() + ", ";
				                            	} else {
				                            		// Is the last alignment
				                            		// Verify the agency that the objective alignment belongs to
				                            		if(syllabus.getObjectives().get(i).getObjectiveAlignment().get(j).getId().equals("0"))
				                            			caepAlignment += syllabus.getObjectives().get(i).getObjectiveAlignment().get(j).getObjectiveId();
				                            	}
				                            }
				                            %>
				                            <td><%=caepAlignment%></td>
				                        </tr>
			                        	<%
			                        }
			                        %>
			                    </table>
			                    
			                    <input type="text" class="tag" value="Contenido Tem&aacute;tico:" readonly>
			                    <%
			                    // Iterate over the thematic content
			                    for(int i=0; i<syllabus.getThematicContent().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getThematicContent().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                  
			                    <input type="text" class="tag" value="Estrategias de Ense&ntilde;anza:" readonly>
			                    <%
			                    // Iterate over the teaching strategies
			                    for(int i=0; i<syllabus.getTeachingStrategies().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getTeachingStrategies().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                  
			                    <input type="text" class="tag" value="Estrategias de Assessment:" readonly>
			                    <%
			                    // Iterate over the assessment strategies
			                    for(int i=0; i<syllabus.getAssessmentStrategies().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getAssessmentStrategies().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                    
			                    <input type="text" class="tag" value="Sistemas de notas:" readonly>
			                    <p class="info">Sistema Est&aacute;ndar (A, B, C, D, F)</p>
			                    
			                    <input type="text" class="tag" value="Libro de Texto:" readonly>
			                    <%
			                    // Iterate over the textbooks
			                    for(int i=0; i<syllabus.getTextbooks().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getTextbooks().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                    
			                    <input type="text" class="tag" value="Bibliograf&iacute;a:" readonly>
			                    <%
			                    // Iterate over the bibliographies
			                    for(int i=0; i<syllabus.getBibliography().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getBibliography().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                     
			                    <input type="text" class="tag" value="Recursos en L&iacute;nea:" readonly>
			                    <%
			                    // Iterate over the online resources
			                    for(int i=0; i<syllabus.getOnlineResources().size(); i++) {
			                    	%>
			                    	<p class="info"><%=i+1%>. <%=syllabus.getOnlineResources().get(i)%></p>
			                    	<%
			                    }
			                    %>
			                    
			                    <input type="text" class="tag" value="Reglas:" readonly>
			                    <%
			                    // Iterate over the rules
			                    for(int i=0; i<syllabus.getRuleFullInfo().size(); i++) {
			                    	%>
			                    	<p class="info"><b><%=syllabus.getRuleFullInfo().get(i).getTitle()%></b>
		                        	<br><%=syllabus.getRuleFullInfo().get(i).getDescription()%></p>
			                    	<%
			                    }
			                    %>
			                    
			                    <input type="text" class="tag" value="Creado Por:" readonly>
			                    <%// Extract only the date from date-time
			                    String[] dateTimeSplit = syllabus.getCreationDate().split(" ");
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
			                    %>
			                    <p class="info"><%=syllabus.getAuthorName()%>, <%=dateSplit[2]%>/<%=month%>/<%=dateSplit[0]%></p>
			                    
			                    <input type="text" class="tag" value="Revisado Por:" readonly>
			                    <%
			                    // Verify if the syllabus was edited
			                    if(!syllabus.getEditorName().isEmpty()) {
			                    	// Extract only the date from date-time
				                    dateTimeSplit = syllabus.getEditionDate().split(" ");
				                    // Split the day, month and year
				                    dateSplit = dateTimeSplit[0].split("-");
				                    month = dateSplit[1];
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
									%>
									<p class="info"><%=syllabus.getEditorName()%>, <%=dateSplit[2]%>/<%=month%>/<%=dateSplit[0]%></p>
									<%
			                    } else {
			                    	%>
									<p class="info">N/A</p>
									<%
			                    }
			                    %>  
			                </div>
			                
			                <button type="button" class="backBtn" onclick="window.location.href='<%=previousPage%>';">Go Back</button>
			                
			                <%
			                // Verify the role of the user to determine if the file
			                // will be a WORD document or a PDF
			                if(appDBAuth.isAdministrator(userRole) || appDBAuth.isSubManager(userRole)) {
			                	%>
			                	<button type="submit" class="editBtn" title="Editar"><i class="fa fa-edit"></i></button>
			                	<button type="button" class="downloadBtn" title="Download" onclick="window.open('download.jsp','_blank');"><i class="fa fa-download">
			                	<%
			                } else if(appDBAuth.isProfessor(userRole) || appDBAuth.isEmployee(userRole)) {
			                	%>
			                	<button type="button" class="downloadBtn" title="Download" onclick="window.open('downloadPDF.jsp','_blank');"><i class="fa fa-download">
			                	<%
			                } else {
			                	// Error in the role value
								System.out.println("The role value is not recognize");
								// Deleting session variables
								session.invalidate();
								// Return to the login page
								response.sendRedirect("login.jsp");	
			                }
			                %>
			              </form>
			        </div>
			    </body>
			</html>
					<%
					// Close connection to the DB
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