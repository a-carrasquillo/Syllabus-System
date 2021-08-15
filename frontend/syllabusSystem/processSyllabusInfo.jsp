<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>
<%// Import the java.util package to use ArrayList related methods %>
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
		String currentPage = "processSyllabusInfo.jsp";
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
					session.setAttribute("currentPage", "processSyllabusInfo.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					// Retrieve parameters from the form and remove the
					// unnecessary spaces from the start and end
					String courseCode = request.getParameter("course_code").trim();
					String prerequisite = request.getParameter("prerequisite").trim();
					String corequisite = request.getParameter("corequisite").trim();
					String duration = request.getParameter("duration").trim();
					String credits = request.getParameter("credits").trim();
					String description = request.getParameter("description").trim();
					String justification = request.getParameter("justification").trim();

					// Define a SyllabusInfo object to help store the information
					SyllabusInfo syllabus = new SyllabusInfo();
					// Insert the course code in the syllabus object
					syllabus.setCode(courseCode);

					// Verify if the course have prerequisites
					if(!prerequisite.isEmpty() && !prerequisite.toUpperCase().equals("N/A")) {
						// Split the prerequisites field to obtain individual course codes
						String[] preReqCourseCodes = prerequisite.split(",");
						// Define an array list to insert the information 
						ArrayList<String> preReqArrayList = new ArrayList<>();
						// Insert the information into an ArrayList
						for(int i=0; i<preReqCourseCodes.length; i++)
							preReqArrayList.add(preReqCourseCodes[i].trim());
						
						// Insert the prerequisites ArrayList in the SyllabusInfo object
						syllabus.setPrerequisites(preReqArrayList);
					}

					// Verify if the course have co-requisites
					if(!corequisite.isEmpty() && !corequisite.toUpperCase().equals("N/A")) {
						// Split the co-requisites field to obtain individual course codes
						String[] coReqCourseCodes = corequisite.split(",");
						// Define an array list to insert the information 
						ArrayList<String> coReqArrayList = new ArrayList<>();
						// Insert the information into an ArrayList
						for(int i=0; i<coReqCourseCodes.length; i++)
							coReqArrayList.add(coReqCourseCodes[i].trim());
						
						// Insert the co-requisites ArrayList in the SyllabusInfo object
						syllabus.setCorequisites(coReqArrayList);
					}

					// Insert the duration into the SyllabusInfo object
					syllabus.setDuration(duration);

					// Insert the credits into the SyllabusInfo object
					syllabus.setCredits(credits);

					// Insert the description into the SyllabusInfo object
					syllabus.setDescription(description);

					// Insert the justification into the SyllabusInfo object
					syllabus.setJustification(justification);

					// Verify which agencies have been selected for the alignment,
					// for now, it is just CAEP
					String caep = request.getParameter("caep").trim();
					// Verify that CAEP was selected
					if(caep.equals("caep")) {
						// Retrieve the amount of objectives
						int amountObjectives = Integer.parseInt(request.getParameter("amountObjectives").trim());
						// Define variables that will help in the objective processing
						String objectiveDesc;
						String alignment;
						String[] alignmentSplit;
						ArrayList<ObjectiveClass> objectives = new ArrayList<>();
						ArrayList<AgencyInfo> objectiveAlignment;
						// Iterate over the objectives
						for(int i=1; i<=amountObjectives; i++) {
							// Initialize a new instance for every objective i,
							// so the previous info is deleted
							objectiveAlignment = new ArrayList<>();
							// Extract the i objective description
							objectiveDesc = request.getParameter("objective_"+i).trim();
							// Extract the CAEP i list of objective i alignment
							alignment = request.getParameter("caep_stds_"+i).trim();
							// Split the list into the CAEP objectives codes
							alignmentSplit = alignment.split(" ");
							// Iterate over the objective alignment split and insert
							// the information into objectiveAlignment
							for(int j=0; j<alignmentSplit.length; j++) {
								// CAEP is represented by the agency id=0
								objectiveAlignment.add(new AgencyInfo("0", alignmentSplit[j].trim()));
							}
							// Insert the objective information into objectives array list
							objectives.add(new ObjectiveClass(String.valueOf(i), objectiveDesc, objectiveAlignment));
						}
						// Insert the objectives information into the SyllabusInfo object
						syllabus.setObjectives(objectives);

						// Retrieve the amount of thematic content to be collected
						int amountThematicContent = Integer.parseInt(request.getParameter("amountThematicContent").trim());
						// Define a String array list to hold the thematic content information
						ArrayList<String> thematicContentList = new ArrayList<>();
						String thematicContent;
						// Iterate over the thematic content
						for(int i=1; i<=amountThematicContent; i++) {
							// Retrieve the i thematic content
							thematicContent = request.getParameter("thematic_info_"+i).trim();
							// Insert the information into the array list
							thematicContentList.add(thematicContent);
						} 
						// Insert the thematic content information into the SyllabusInfo object
						syllabus.setThematicContent(thematicContentList);

						// Retrieve the amount of teaching strategies to be collected
						int amountTeachingStrategies = Integer.parseInt(request.getParameter("amountTeachingStrategies").trim());
						// Define a String array list to hold the teaching strategies information
						ArrayList<String> teachingStrategiesList = new ArrayList<>();
						String teachingStrategies;
						// Iterate over the teaching strategies
						for(int i=1; i<=amountTeachingStrategies; i++) {
							// Retrieve the i teaching strategy
							teachingStrategies = request.getParameter("teaching_strat_"+i).trim();
							// Insert the information into the array list
							teachingStrategiesList.add(teachingStrategies);
						}
						// Insert the teaching strategies information into the SyllabusInfo object
						syllabus.setTeachingStrategies(teachingStrategiesList);

						// Retrieve the amount of assessment strategies to be collected
						int amountAssessmentStrategies = Integer.parseInt(request.getParameter("amountAssessmentStrategies").trim());
						// Define a String array list to hold the assessment strategies information
						ArrayList<String> assessmentStrategiesList = new ArrayList<>();
						String assessmentStrategies;
						// Iterate over the assessment strategies
						for(int i=1; i<=amountAssessmentStrategies; i++) {
							// Retrieve the i assessment strategy
							assessmentStrategies = request.getParameter("assessment_strat_"+i).trim();
							// Insert the information into the array list
							assessmentStrategiesList.add(assessmentStrategies);
						}
						// Insert the assessment strategies information into the SyllabusInfo object
						syllabus.setAssessmentStrategies(assessmentStrategiesList);
						
						// Retrieve the amount of textbooks to be collected
						int amountTextbooks = Integer.parseInt(request.getParameter("amountTextbooks").trim());
						// Define a String array list to hold the textbooks information
						ArrayList<String> textbooksList = new ArrayList<>();
						String textbook;
						// Iterate over the textbooks
						for(int i=1; i<=amountTextbooks; i++) {
							// Retrieve the i textbook
							textbook = request.getParameter("textbook_info_"+i).trim();
							// Insert the information into the array list
							textbooksList.add(textbook);
						}
						// Insert the textbooks information into the SyllabusInfo object
						syllabus.setTextbooks(textbooksList);

						// Retrieve the amount of bibliographies to be collected
						int amountBibliographies = Integer.parseInt(request.getParameter("amountBibliographies").trim());
						// Define a String array list to hold the bibliographies information
						ArrayList<String> bibliographiesList = new ArrayList<>();
						String bibliography;
						// Iterate over the bibliographies
						for(int i=1; i<=amountBibliographies; i++) {
							// Retrieve the i bibliography
							bibliography = request.getParameter("bibliography_info_"+i).trim();
							// Insert the information into the array list
							bibliographiesList.add(bibliography);
						}
						// Insert the bibliographies information into the SyllabusInfo object
						syllabus.setBibliography(bibliographiesList);

						// Retrieve the amount of online resources to be collected
						int amountOnlineResources = Integer.parseInt(request.getParameter("amountOnlineResources").trim());
						// Define a String array list to hold the online resources information
						ArrayList<String> onlineResourcesList = new ArrayList<>();
						String onlineResource;
						// Iterate over the online resources
						for(int i=1; i<=amountOnlineResources; i++) {
							// Retrieve the i online resource
							onlineResource = request.getParameter("online_res_info_"+i).trim();
							// Insert the information into the array list
							onlineResourcesList.add(onlineResource);
						}
						// Insert the online resources information into the SyllabusInfo object
						syllabus.setOnlineResources(onlineResourcesList);

						// Retrieve the rules' list
						// Here we use the method getParameterValues since there are several 
						// parameters with the same name (several check-boxes), this way it brings 
						// all of the parameters as an array
						String[] rules = request.getParameterValues("regla");
						
						// Define an array list to insert the information 
						ArrayList<String> rulesList = new ArrayList<>();
						// Insert the information into an ArrayList
						for(int i=0; i<rules.length; i++)
							rulesList.add(rules[i].trim());
						
						// Insert the rules ArrayList in the SyllabusInfo object
						syllabus.setRules(rulesList);

						// Create a applicationDBManager object
						applicationDBManager appDBMnger = new applicationDBManager();
						System.out.println("Connecting...");
						System.out.println(appDBMnger.toString());
						// Try to perform the insert, here only the admins are considered,
						// if in a future there are more roles able to edit, we need to
						// evaluate who is performing the edition to use the appropriate method
						int insertResult = appDBMnger.addAdminSyllabus(userName, syllabus);
						// Evaluate the result of the insert
						if(insertResult == 0) {
							// Success
							// Delete error related session variables
							session.setAttribute("errorSyllabusCreation", null);
			        		session.setAttribute("syllabus", null);
							// HTML code to generate a message indicating the information status
		            		%>
				            <!DOCTYPE html>
				            <html lang="es">
				              <head>
				                <title>Redireccionando...</title>
				                <meta http-equiv="Refresh" content="8;url=searchNewCourse.jsp">
				                <style type="text/css">
				                  h1 {
				                      position: relative;
				                      margin-top: 25%;
				                      text-align: center;
				                  }
				                  body {
				                      background-color: rgb(59, 191, 151);
				                  }
				                </style>
				              </head>
				              <body>
								<h1>La informaci&oacute;n pudo ser a&ntilde;adida satisfactoriamente!</h1>
			          		  </body>
					        </html>
			          		<%
						} else {
							// Some type of error
							// Define some session variables to indicate an error and
							// store the syllabus information
							session.setAttribute("errorSyllabusCreation", "true");
			        		session.setAttribute("syllabus", syllabus);
							// HTML code to generate a message indicating the error status
			          		%>
				            <!DOCTYPE html>
				            <html lang="es">
				              <head>
				                <title>Redireccionando...</title>
				                <meta http-equiv="Refresh" content="8;url=createSyllabus.jsp">
				                <style type="text/css">
				                  h1 {
				                      position: relative;
				                      margin-top: 25%;
				                      text-align: center;
				                  }
				                  h1#error {
				                  	  color: red;
				                  }
				                  body {
				                      background-color: rgb(59, 191, 151);
				                  }
				                </style>
				              </head>
				              <body>
				            <%
				            // Evaluate the type of error
				            if(insertResult == 1) {
				            	%>
									<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 1. Informar a la persona designada.</h1>
		          				<%
				            } else if(insertResult == 2) {
				            	%>
									<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 2. Lo m&aacute;s probable es que hay un c&oacute;digo de curso mal en los prerequisitos, o no los estan separando por comas (,)</h1>
		          				<%
				            } else if(insertResult == 3) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 3. Lo m&aacute;s probable es que hay un c&oacute;digo de curso mal en los corequisitos, o no los estan separando por comas (,)</h1>
				            	<%
				            } else if(insertResult == 4) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 4. Informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 5) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 5. Informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 6) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 6. Informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 7) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 7. Informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 8) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 8. Informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 9) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 9. Recuerde que debe seleccionar al menos una regla. Si el problema persiste, informar a la persona designada.</h1>
				            	<%
				            } else if(insertResult == 10) {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 10. Informar a la persona designada.</h1>
				            	<%
				            } else {
				            	%>
				            		<h1 id="error">Error al insertar la informaci&oacute;n. C&oacute;digo de error: 11. Informar a la persona designada.</h1>
				            	<%
				            }
				            %>
				          		</body>
						    </html>
		          			<%
						}
						// Close connection to DB
						appDBMnger.close();
					} else {
						// Error
						%>
			            <!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=createSyllabus.jsp">
			                <style type="text/css">
			                  h1 {
			                      position: relative;
			                      margin-top: 25%;
			                      text-align: center;
			                  }
			                  h1#error {
			                  	  color: red;
			                  }
			                  body {
			                      background-color: rgb(59, 191, 151);
			                  }
			                </style>
			              </head>
			              <body>
							<h1 id="error">El encasillado de CAEP no fue seleccionado!</h1>
		          			</body>
				        </html>
		          		<%
					}
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