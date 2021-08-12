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
		String currentPage="addCourseToProgram.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect to the database using the applicationDBAuthentication class
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
					session.setAttribute("currentPage", "addCourseToProgram.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null)
						session.setAttribute("userName", userName); 
					else
						session.setAttribute("userName", userName);

					%>
					<!doctype html>
					<html lang="es">
					    <head>
					        <!--Indicates the encoding of the characters-->
					        <meta charset="utf-8">
					        <!--Authors of the web page-->
					        <meta name="author" content="a-carrasquillo, arivesan">
					        <!--Importing the CSS style-sheet-->
					        <link rel = "stylesheet" type="text/css" href="css/addCourseToProgram.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
					        <!--Website title-->
					        <title>A&ntilde;adir Cursos a Programa</title>
					        <!--CSS required for background photo-->
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
					// Specify the menu type of this page
					String menuType = "A\u00f1adir";
					// Counter to determine if it is the first iteration
					int counter = 0;
					// Verify that the result set is not empty
					if(!res.isAfterLast()) {
						// Iterate through the result set
						while(res.next()) {
							// Verify that the title (menu category) is different
							// from the previous one
							if(!previousTitle.equals(res.getString(2)) && (counter==0) && !menuType.equals(res.getString(2))) {
								%>
								<li>
				                    <div class="dropdown">
				    	                <button class="dropbtn"><%=res.getString(2)%>
										<i class="fa fa-caret-down"></i>
                           				</button>
                        			<div class="dropdown-content">
								<%
							} else if(!previousTitle.equals(res.getString(2)) && (counter!=0) && !menuType.equals(res.getString(2))) {
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
							} else if(!previousTitle.equals(res.getString(2)) && (counter==0) && menuType.equals(res.getString(2))) {
								%>
								<li>
				                    <div class="dropdown">
				    	                <button class="dropbtn" id="activo"><%=res.getString(2)%>
										<i class="fa fa-caret-down"></i>
                           				</button>
                        			<div class="dropdown-content">
								<%
							} else if(!previousTitle.equals(res.getString(2)) && (counter!=0) && menuType.equals(res.getString(2))) {
								%>
										</div>
				                    </div>
				                </li>
				                <li>
				                    <div class="dropdown">
				                        <button class="dropbtn" id="activo"><%=res.getString(2)%>
										<i class="fa fa-caret-down"></i>
                            			</button>
                            			<div class="dropdown-content">
								<%
							}
							// Verify if the page extracted from the DB is 
							// the one we are currently on
							if(currentPage.equals(res.getString(1))) {
								%>
								<a href="<%=res.getString(1)%>" id="activo"><%=res.getString(3)%></a>						
								<%
							} else {
								%>
								<a href="<%=res.getString(1)%>"><%=res.getString(3)%></a>						
								<%
							}
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
			        <%//End of menu loading
			        
			        // Define the variables that will hold the information in case of error
			        String academicGrade = "";
			        String courseProgram = "";
			        String coursesList = "";
			       
			        // Check for error and load the information
			        if(session.getAttribute("errorAddingCoursesToProgram")!=null && (previousPage.equals("help.jsp") || previousPage.equals("processAddedProgramCourses.jsp"))) {
			        	// Load information from session variables
			        	academicGrade = session.getAttribute("academicGrade").toString().trim();
			        	courseProgram = session.getAttribute("courseProgram").toString().trim();
			        	coursesList = session.getAttribute("coursesList").toString().trim();
			        } else {
			        	// Clear session variables
			        	session.setAttribute("errorAddingCoursesToProgram", null);
			        	session.setAttribute("academicGrade", null);
			        	session.setAttribute("courseProgram", null);
			        	session.setAttribute("coursesList", null);
			        }
			        
			        %>
			        <div class = "cuadro_centro">
			            <form action = 'processAddedProgramCourses.jsp' method="post" autocomplete="off">
			                <!--Academic Grade/Level Section-->
			                <div id = "academic_grade_tag">Grado Acad&eacute;mico:</div>
			                <select id = "academic_grade" name="grado" required>
			                    <option value="">Seleccione un grado acad&eacute;mico</option>
			                    <%
			                    // Verify if there was a selected academic grade
			                    if(academicGrade.equals("bachillerato")) {
			                    	%>
			                    	<option value="bachillerato" selected>Bachillerato</option>
				                    <option value="maestria">Maestria</option>
				                    <option value="doctorado">Doctorado</option>
			                    	<%
			                    } else if(academicGrade.equals("maestria")) {
			                    	%>
			                    	<option value="bachillerato">Bachillerato</option>
				                    <option value="maestria" selected>Maestria</option>
				                    <option value="doctorado">Doctorado</option>
			                    	<%
			                    } else if(academicGrade.equals("doctorado")) {
			                    	%>
			                    	<option value="bachillerato">Bachillerato</option>
				                    <option value="maestria">Maestria</option>
				                    <option value="doctorado" selected>Doctorado</option>
			                    	<%
			                    } else {
			                    	// There was no error, hence, no academic grade was selected
			                    	%>
			                    	<option value="bachillerato">Bachillerato</option>
				                    <option value="maestria">Maestria</option>
				                    <option value="doctorado">Doctorado</option>
			                    	<%
			                    }
			                    %>
			                </select>
			                <!--Course Program Section-->
			                <div id = "course_program_tag">Programa:</div>
			                <select id = "course_program" name="programs" onclick="isAcademicLevelSelected()" required>
			                    <option value="">Seleccione un programa</option>
			                    <%
								// Create a applicationDBManager object
								applicationDBManager appDBMnger = new applicationDBManager();
								System.out.println("Connecting...");
								System.out.println(appDBMnger.toString());
								// Search all programs
					            ResultSet result = appDBMnger.listAllPrograms();
					            // Iterate over the result set
					            while(result.next()) {
					            	// Verify if the course program is the same as the one
					            	// extracted from the DB, this will happen in case of error
					            	if(courseProgram.equals(result.getString(2))) {
					            		%>
						                	<option value="<%=result.getString(2)%>" class="filter <%=result.getString(1)%>" selected><%=result.getString(3)%></option>
					            		<%
					            	} else {
					            		// There was no error detected
					            		%>
						                	<option value="<%=result.getString(2)%>" class="filter <%=result.getString(1)%>"><%=result.getString(3)%></option>
					            		<%
					            	}
					            }
			                    %>
			                </select>
			                <!--Course List Section-->
			                <div id = "course_list_tag">Cursos:</div>
			                <textarea id="course_list" name="course_list" placeholder="Seleccione los cursos del encasillado y al a&ntilde;adirlos se mostrar&aacute;n aqu&iacute;..." required rows="4" readonly><%=coursesList%></textarea>
			                <div id="coursebtns">
			                    <button id ="remove" type="button" onclick="removeCourse()">Remover</button>
			                    <button id ="add" type="button" onclick="addCourse()">A&ntilde;adir</button>
			                </div>
			                <select id = "courses" name="courses" onclick="isProgramSelected()">
			                    <option value="">Seleccione el curso deseado</option>
			                    <%
			                    // Search all course codes
			                    result = appDBMnger.listAllCourseCodes();
			                    // Iterate over the result set and extract the course codes
			                    while(result.next()) {
					            	%><option value="<%=result.getString(1)%>"><%=result.getString(1)%></option><%
					            }
					            // Close the result set and database connection
					            result.close();
								appDBMnger.close();
			                    %>
			                </select>
			                
			                <button id ="cancel" type="button" onclick="window.location.href='welcomeMenu.jsp';">Cancelar</button>
			                <button id ="submit" type="submit">Someter</button>
			            </form>
			        </div>
			        <script>
			            function isAcademicLevelSelected() {
			                if(document.getElementById('academic_grade').value == '') {
			                    alert('Primero necesita seleccionar un grado acad\u00e9mico!');
			                    document.getElementById('academic_grade').focus();
			                }
			            }
			            function isProgramSelected() {
			                if(document.getElementById('course_program').value== '') {
			                    alert('Primero debe seleccionar un programa!');
			                    document.getElementById('course_program').focus();
			                }
			            }
			            function addCourse() {
			                if(document.getElementById('courses').value== '') {
			                    alert('Selecione un curso!');
			                    document.getElementById('courses').focus();
			                } else {
			                    var course = document.getElementById('courses').value;
			                    var courseList = document.getElementById('course_list');
			                    if(courseList.value == '') {
			                        courseList.value = course + '\n';
			                    } else {
			                        if(courseList.value.search(course) == -1) {
			                            courseList.value = courseList.value + course + '\n';
			                        } else {
			                            alert('El curso ya existe en la lista!');
			                        }
			                    }
			                }
			            }
			            function removeCourse() {
			                if(document.getElementById('courses').value== '') {
			                    alert('Selecione un curso!');
			                    document.getElementById('courses').focus();
			                } else {
			                    var course = document.getElementById('courses').value;
			                    var courseList = document.getElementById('course_list');
			                    if(courseList.value == '') {
			                        alert('La lista esta vacia!');
			                    } else {
			                        if(courseList.value.search(course) == -1) {
			                            alert('El curso no existe en la lista!');
			                        } else {
			                            var removeval = document.getElementById('course_list').value;
			                            removeval = removeval.trim();
			                            var n = removeval.split("\n");
			                            var location = n.indexOf(course);
			                            delete n[location];
			                            var newval = n.join('\n');
			                            document.getElementById('course_list').value = newval.replace(/^\s*[\r\n]/gm, '') + '\n';
			                        }
			                    }
			                }
			            }
			            // JS for showing or hiding select options based on education level
			            $(function() {
			                $('#academic_grade').change(function(){
			                    $('#course_program').val('');
			                    $('#courses').val('');
			                    $('#course_list').val('');
			                    $('.filter').hide();
			                    $('.' + $(this).val()).show();
			                });
			                $('#course_program').change(function(){
			                    $('#courses').val('');
			                    $('#course_list').val('');
			                });
			            });
			        </script>
			    </body>
			</html>
				<%
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