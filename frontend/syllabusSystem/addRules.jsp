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
		String currentPage = "addRules.jsp";
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
				
				ResultSet res=appDBAuth.verifyUserPageFlow(userName, currentPage, previousPage);
				// Verify that the user is following the page flow
				if(res.next()) {
					// The user was authenticated
					// Get the user complete name and role
					String userActualName = res.getString(3);
					String userRole = res.getString(1);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "addRules.jsp");
					
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
					        <link rel = "stylesheet" type="text/css" href="css/addRules.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Website title-->
					        <title>A&ntilde;adir Regla</title>
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
					// Specify the menu type of this page
					String menuType = "Reglas";
					// Counter to determine if it is the first iteration
					int counter = 0;
					// Verify that the result set is not empty
					if(!res.isAfterLast()) {
						// Iterate through the result set
						while(res.next()) {
							// Verify that the title (menu category) is different from
							// the previous one
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
							// Verify is the extracted page from the DB is the same as the current page
							// so we can add an active id to it
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
			                    <li><a href="signout.jsp">Logout</a></li>
			                </b>
			            </ul>
			          </nav>
			        </div>
			        <%// End of menu loading
			        // Define the variables that will hold the information in case of error
			        String ruleName = "";
			        String ruleDescription = "";
			        // Check for error and load the information
			        if(session.getAttribute("error")!=null) {
			        	// Load information from session variables
			        	ruleName = session.getAttribute("ruleName").toString().trim();
			        	ruleDescription = session.getAttribute("ruleDescription").toString().trim();
			        	// Clear session variables to avoid errors when moving between
			        	// menu without correcting errors
			        	session.setAttribute("error", null);
			        	session.setAttribute("ruleName", null);
						session.setAttribute("ruleDescription", null);
			        }
			        %>
			        		<div class = "cuadro_centro">
					            <form action = 'processNewRule.jsp' method="post">
					                <div id = "addRules_tag">Nombre de la Regla:</div>
					                <div><input type="text" id="addRules_name" name="rule_name" placeholder="Introduzca el nombre de la regla" maxlength="255" value="<%=ruleName%>" required></div>
					                
					                <div id = "desc_tag">Descripci&oacute;n:</div>
					                <textarea type="text" id="desc_name" name="desc_regla" rows = "4" cols = "75" placeholder="Introduzca la descripci&oacute;n de la regla" required><%=ruleDescription%></textarea>
					                
					                <button id ="cancel" type="button" onclick="window.location.href='welcomeMenu.jsp';">Cancelar</button>
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