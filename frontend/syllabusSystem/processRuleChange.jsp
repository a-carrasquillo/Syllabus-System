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
		String currentPage = "processRuleChange.jsp";
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
					session.setAttribute("currentPage", "processRuleChange.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					// Retrieve parameters from the form and remove
					// the unnecessary spaces from the start and end
					String ruleId = request.getParameter("ruleId").trim();
					String ruleName = request.getParameter("ruleName").trim();
					String ruleDescription = request.getParameter("ruleDescription").trim();

					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

					// Try to add the information to the system
					if(appDBMnger.updateRuleInfo(ruleId, ruleName, ruleDescription)) {
						// Success
						// Delete session variables related to error information
						session.setAttribute("errorModRule", null);
						session.setAttribute("ruleId", null);
						session.setAttribute("ruleName", null);
						session.setAttribute("ruleDescription", null);
						%>
						<!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=listRules.jsp">
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
							<h1>La regla fue actualizada satisfactoriamente.</h1>
						  </body>
			        	</html>
						<%
					} else {
						// Fail
						// Indicate the error in the session variable
						session.setAttribute("errorModRule", "true");
						// Set the error related information in session variable
						session.setAttribute("ruleId", ruleId);
						session.setAttribute("ruleName", ruleName);
						session.setAttribute("ruleDescription", ruleDescription);
						%>
						<!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=modifyRules.jsp">
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
							<h1 id="error">La regla no se pudo actualizar. Favor de intentar m\u00e1s tarde. Si el problema persiste, comuniquese con la persona designada.</h1>
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