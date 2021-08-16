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
		String currentPage = "welcomeMenu.jsp";
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
					session.setAttribute("currentPage", "welcomeMenu.jsp");
					
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
					        <link rel = "stylesheet" type="text/css" href="css/welcomeMenu.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>Home</title>
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
					        <div class="custom-padding">
					          <nav>
					            <ul class="menu-area">
					                <b>
					                    <li><a href="welcomeMenu.jsp" id="activo">Home</a></li>
					<%
					// Verify the role of the user to load the webpage display
					if(appDBAuth.isAdministrator(userRole) || appDBAuth.isSubManager(userRole)) {
						// Load the admin display
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
						// These options are still to be implemented,
						// the last one need to be adapted from the admins version
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
									<li><a href="help.jsp">Ayuda</a></li>
			                    <li><a href="signout.jsp">Logout</a></li>
			                </b>
			            </ul>
			          </nav>
			        </div>
			        <div class = "blankpage">
			            <h1>B&uacute;squeda de Prontuarios:</h1>
			                <!--Search Bar Section-->
			                <div class="search_bar">
							    <form id="search" action="searchCourseCode.jsp" method="post">
			                        <input type="text" placeholder="Buscar..." name="search" class="search" required>
			                        <button type="submit" class="search_button" accesskey="enter"><i class="fa fa-search"></i></button>
			                    </form>
			                </div>
			            <!-- Control buttons -->     
			            <div id="myBtnContainer">
			              <button class="btn active" onclick="filterSelection('all')"> Mostrar Todos </button>
			              <button class="btn" onclick="filterSelection('bachillerato')"> Bachillerato </button>
			              <button class="btn" onclick="filterSelection('maestria')"> Maestr&iacute;a </button>
			              <button class="btn" onclick="filterSelection('doctorado')"> Doctorado </button>
			            </div>
					<%
					// Look for all the programs
					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
					// Search all programs
		            ResultSet result = appDBMnger.listAllPrograms();
		            // Verify that the result set is not empty
		            if(!result.isAfterLast()) {
		            	// There is at least one program
						%>
						<!-- The filterable elements. Note that some have multiple class names (this can be used if they belong to multiple categories)--> 
				        <div class="container">
						<%
						// Iterate over the programs
						while(result.next()) {
			            	%>
				                <div class="filterDiv <%=result.getString(1)%>">
				                    <form action="searchProgramCourses.jsp" method="post">
				                        <input type="hidden" name="idPrograma" value="<%=result.getString(2)%>">
				                        <input type="hidden" name="programName" value="<%=result.getString(3)%>">
				                        <button type="submit" class="programa"><%=result.getString(3)%></button>
				                    </form>
				                </div>
			            	<%
			            }
			            %>
			            </div><!--program container closing div tag-->
			            <%
					} else {//there is no program available
						if(appDBAuth.isAdministrator(userRole) || appDBAuth.isSubManager(userRole)) {
							// Is an admin
							%>
							<h2>No hay programas disponibles, favor de a&ntilde;adir los programas en la p&aacute;gina designada.</h2>
							<%
						} else {
							// Is a non-admin
							%>
							<h2>No hay programas disponibles, favor de notificarlo a los administradores.</h2>
							<%
						}
					}
		            // Close the result set and database connection
		            result.close();
					appDBMnger.close();
					%>
					</div><!--Blankpage closing div tag-->
						<script>
					        filterSelection("all")
					        function filterSelection(c) {
					            var x, i;
					            x = document.getElementsByClassName("filterDiv");
					            if (c == "all") c = "";
					            for (i = 0; i < x.length; i++) {
					                w3RemoveClass(x[i], "show");
					                if (x[i].className.indexOf(c) > -1)
					                	w3AddClass(x[i], "show");
					            }
					        }
							function w3AddClass(element, name) {
					            var i, arr1, arr2;
					            arr1 = element.className.split(" ");
					            arr2 = name.split(" ");
					            for (i = 0; i < arr2.length; i++) {
					            	if(arr1.indexOf(arr2[i]) == -1)
					            		element.className += " " + arr2[i];
					            }
					        }
							function w3RemoveClass(element, name) {
					            var i, arr1, arr2;
					            arr1 = element.className.split(" ");
					            arr2 = name.split(" ");
					            for (i = 0; i < arr2.length; i++) {
					                while (arr1.indexOf(arr2[i]) > -1)
					                  arr1.splice(arr1.indexOf(arr2[i]), 1);     
					            }
					            element.className = arr1.join(" ");
					        }

					        // Add active class to the current button (highlight it)
					        var btnContainer = document.getElementById("myBtnContainer");
					        var btns = btnContainer.getElementsByClassName("btn");
					        for (var i = 0; i < btns.length; i++) {
					            btns[i].addEventListener("click", function(){
					                var current = document.getElementsByClassName("active");
					                current[0].className = current[0].className.replace(" active", "");
					                this.className += " active";
					              });
					        }
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