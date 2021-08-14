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
		String currentPage = "modifyRules.jsp";
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
					session.setAttribute("currentPage", "modifyRules.jsp");
					
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
					        <link rel = "stylesheet" type="text/css" href="css/modifyRules.css">
					        <!--Importing JS required-->
					        <script src="https://kit.fontawesome.com/7ea556f8eb.js" crossorigin="anonymous"></script>
					        <!--Webpage title-->
					        <title>Modificar Regla</title>
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
			        // Define the variables that will hold the information in case of error
			        String ruleId = "";
			        String ruleTitle = "";
			        String ruleDescription = "";
			       
			        // Check for error and load the information
			        if((session.getAttribute("errorModRule")!=null && (previousPage.equals("help.jsp") || previousPage.equals("processRuleChange.jsp"))) || previousPage.equals("help.jsp")) {
			        	// Comes from the processRuleChange page so the rule id is in
			        	// a session variable
			        	// Load information from session variables
			        	ruleId = session.getAttribute("ruleId").toString().trim();
			        	ruleTitle = session.getAttribute("ruleName").toString().trim();
			        	ruleDescription = session.getAttribute("ruleDescription").toString().trim();
			        } else if(previousPage.equals("listRules.jsp")) {
			        	// Comes from the listRules page so the rule id is inside a request
			        	ruleId = request.getParameter("ruleId").trim();
			        	session.setAttribute("errorModRule", null);
			        	
			        }
			        
			        // Create an applicationDBManager object to connect to the DB
					applicationDBManager appDBMan = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMan.toString());
					// Perform the search to retrieve the info of the rule
					res = appDBMan.searchRule(ruleId);
					// Variables that will hold the current information of the rule
					String currentRuleTitle = "";
					String currentRuleDescription = "";
					// If the result set have a result, retrieve the information 
					if(res.next()) {
						// Rule information was found
						// Extract the information from the result set
						currentRuleTitle = res.getString(1);
						currentRuleDescription = res.getString(2);
						// Set session variables to hold the rule information
						session.setAttribute("ruleId", ruleId);
						session.setAttribute("ruleName", currentRuleTitle);
						session.setAttribute("ruleDescription", currentRuleDescription);
					} else {
						// Rule information was not found in the system due to manipulation
						// of the HTML code or bad coding
						System.out.println("Error!!! Rule not found due to manipulation of the HTML code or bad coding... Redirecting to login page...");
						// Deleting session variables
						session.invalidate();
						// Return to the login page
						response.sendRedirect("login.jsp");
					}
					// Verify if there was no error
					if(session.getAttribute("errorModRule")==null) {
						// No error, first time loading the page
						ruleTitle = currentRuleTitle;
						ruleDescription = currentRuleDescription;
					}
			        %>
					        <div class = "cuadro_centro">
					            <form action = 'processRuleChange.jsp' method="post" autocomplete="off">
					                <input type="hidden" name="ruleId" value="<%=ruleId%>">
					                <div id = "modRules_tag">Nombre de la Regla:</div>
					                <div><input type="text" id="modRules_name" name="ruleName" placeholder="<%=currentRuleTitle%>" value="<%=ruleTitle%>" required></div>
					                
					                <div id = "desc_tag">Descripci&oacute;n:</div>
					                <textarea type="text" id="desc_name" name="ruleDescription" rows = "4" cols = "75" placeholder="<%=currentRuleDescription%>" required><%=ruleDescription%></textarea>
					                
					                <button id ="cancel" type="button" onclick="window.location.href='welcomeMenu.jsp';">Cancel</button>
					                <button id ="submit" type="submit">Someter</button>
					            </form>
					        </div>
					    </body>
					</html>
					<%
					// Close the connection to the DB
				    appDBMan.close();
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