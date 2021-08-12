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
		String currentPage = "addNewCourse.jsp";
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
					// Get the user complete name and role
					String userActualName = res.getString(3);
					String userRole = res.getString(1);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "addNewCourse.jsp");
					
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
					        <link rel = "stylesheet" type="text/css" href="css/addNewCourse.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>A&ntilde;adir Curso</title>
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
			        <%// End of menu loading
			        // Define the variables that will hold the information in case of error
			        String courseName = "";
			        String courseCode = "";
			        String courseType = "";
			        String courseModality = "";
			        // Check for error and load the information
			        if(session.getAttribute("errorNewCourse")!=null && (previousPage.equals("help.jsp") || previousPage.equals("processNewCourse.jsp"))) {
			        	// Load information from session variables
			        	courseName = session.getAttribute("courseName").toString().trim();
			        	courseCode = session.getAttribute("courseCode").toString().trim();
			        	courseType = session.getAttribute("courseType").toString().trim();
			        	courseModality = session.getAttribute("courseModality").toString().trim();
			        } else {
			        	// Delete the session variables
			        	session.setAttribute("errorNewCourse", null);
			        	session.setAttribute("courseName", null);
			        	session.setAttribute("courseCode", null);
			        	session.setAttribute("courseType", null);
			        	session.setAttribute("courseModality", null);
			        }

			        %>
			        		<div class = "cuadro_centro">
					            <form action = 'processNewCourse.jsp' method="post">
					                <div id = "course_tag">Nombre del Curso:</div>
					                <div><input type="text" id="course_name" name="course_name" placeholder="Introduzca el nombre del curso" maxlength="100" value="<%=courseName%>" required></div>
					                
					                <div id = "code_tag">C&oacute;digo del Curso:</div>
					                <div><input type="text" id="course_code" name="course_code" placeholder="Introduzca el c&oacute;digo del curso" maxlength="10" value="<%=courseCode%>" required></div>
					                
					                <div id = "course_type_tag">Tipo de Curso:</div>
					                <select name="tipo" id="tipo" required>
					                    <option value="">Seleccione un tipo de curso</option>
					                    <%
					                    	// Verify if there was a course type selected, happens when an
					                    	// error occurs while processing this page on submit
						                    if(courseType.equals("A-Conferencia")) {
						                    	%>
						                    	<option value="A-Conferencia" selected>A-Conferencia</option>
					                   			<option value="P-Pr&aacute;ctica">P-Pr&aacute;ctica</option>
						                    	<%
						                    } else if(courseType.equals("P-Pr\u00e1ctica")) {
						                    	%>
						                    	<option value="A-Conferencia">A-Conferencia</option>
					                   			<option value="P-Pr&aacute;ctica" selected>P-Pr&aacute;ctica</option>
						                    	<%
						                    } else {
						                    	// There was no error detected
						                    	%>
						                    	<option value="A-Conferencia">A-Conferencia</option>
					                   			<option value="P-Pr&aacute;ctica">P-Pr&aacute;ctica</option>
						                    	<%
						                    }
						                    %>
					                </select>
					                
					                <div id = "modalidad_tag">Modalidad:</div>
					                <select name="modalidad" id="moda" required>
					                    <option value="">Seleccione una modalidad</option>
					                    <%
					                    	// Verify if there was a modality selected, happens when an
					                    	// error occurs while processing this page on submit
						                    if(courseModality.equals("Presencial")) {
						                    	%>
						                    	<option value="Presencial" selected>Presencial</option>
							                    <option value="En l&iacute;nea">En l&iacute;nea</option>
							                    <option value="H&iacute;brido">H&iacute;brido</option>
						                    	<%
						                    } else if(courseModality.equals("En l\u00ednea")) {
						                    	%>
						                    	<option value="Presencial">Presencial</option>
							                    <option value="En l&iacute;nea" selected>En l&iacute;nea</option>
							                    <option value="H&iacute;brido">H&iacute;brido</option>
						                    	<%
						                    } else if(courseModality.equals("H\u00edbrido")) {
						                    	%>
						                    	<option value="Presencial">Presencial</option>
							                    <option value="En l&iacute;nea">En l&iacute;nea</option>
							                    <option value="H&iacute;brido" selected>H&iacute;brido</option>
						                    	<%
						                    } else {
						                    	// No error was detected
						                    	%>
						                    	<option value="Presencial">Presencial</option>
							                    <option value="En l&iacute;nea">En l&iacute;nea</option>
							                    <option value="H&iacute;brido">H&iacute;brido</option>
						                    	<%
						                    }
						                    %>
					                </select>
					                
					                <button id ="cancel" type="button" onclick="window.location.href='cancelNewCourse.jsp';">Cancelar</button>
					                <button id ="submit" type="submit">Someter</button>
					            </form>
					        </div>
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