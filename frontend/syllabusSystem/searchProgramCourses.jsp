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
		String currentPage = "searchProgramCourses.jsp";
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
					session.setAttribute("currentPage", "searchProgramCourses.jsp");
					
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
					        <link rel = "stylesheet" type="text/css" href="css/searchProgramCourses.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>Resultados de la B&uacute;squeda</title>
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
								// Verify that the title (menu category) is different from
								// the previous one
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
						// These options are still to be implemented, the last one need
						// to be adapted from the admins version
						/*%>
						<li><a href="pendingRequestStatus.jsp">Estado de solicitudes</a></li>
	                    <li><a href="holdList.jsp">Lista de prontuarios retenidos</a></li>
	                    <li><a href="searchNewCourse.jsp">Lista de Cursos sin prontuarios</a></li>
						<%*/
					} else if(appDBAuth.isEmployee(userRole)) {
						// Let in blank on purpose to avoid false error detection
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
			        String idPrograma = "";
					String programName = "";

			        // Verify if the previous page is the welcomeMenu, then retrieve
			        // parameters from the form, else, retrieve the parameters from
			        // session variables
			        if(previousPage.equals("welcomeMenu.jsp")) {
			        	// Retrieve parameters from the form and remove the unnecessary
			        	// spaces from the start and end
						idPrograma = request.getParameter("idPrograma").trim();
						programName = request.getParameter("programName").trim();
						// Set session variables
						session.setAttribute("idPrograma", idPrograma);
						session.setAttribute("programName", programName);
			        } else {
			        	// Retrieve parameters from session variables and remove
			        	// the unnecessary spaces from the start and end
						idPrograma = session.getAttribute("idPrograma").toString().trim();
						programName = session.getAttribute("programName").toString().trim();
			        }

					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

					// Perform the program's courses search in the DB
					res = appDBMnger.searchProgramCourses(idPrograma);

					%>
					<div class = "blankpage">
						<h1>Cursos del Programa <%=programName%>:</h1>
					<%

					// Verify that the result set is not empty
					if(res.next()) {
						// Reset the result set pointer
						res.previous();
						// Iterate through the result set
						while(res.next()) {
							%>
							<form action="courseSyllabusPreview.jsp" method="post">
				                <input type="hidden" name="courseCode" value="<%=res.getString(1)%>">
				                <button type="submit" class="course"><%=res.getString(1)%>: <%=res.getString(2)%></button>
				            </form>
							<%
						}
					} else {
						// There is no result
						%>
						<h2>No hay resultados para este programa. Notif&iacute;quelo a la persona o personas designadas.</h2>
						<%
					}
					// Close connection to the DB
					appDBMnger.close();
			        %>
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