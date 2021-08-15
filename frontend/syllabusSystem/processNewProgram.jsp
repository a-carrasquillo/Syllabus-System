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
		String currentPage = "processNewProgram.jsp";
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
					session.setAttribute("currentPage", "processNewProgram.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// Create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}

					// Retrieve parameters from the form and remove the unnecessary
					// spaces from the start and end
					String programName = request.getParameter("program_name").trim();
					String gradeLevel = request.getParameter("grado").trim();
					String programCode = request.getParameter("program_code").trim();

					// Process the gradeLevel information
					if(gradeLevel.equals("bachillerato"))
						gradeLevel = "0";
					else if(gradeLevel.equals("maestria"))
						gradeLevel = "1";
					else
						gradeLevel = "2";
					
					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
					// Try to add the information to the system
					if(appDBMnger.addProgram(programCode, gradeLevel, programName)) {
						// Success
						// Clear the error session variable
						session.setAttribute("errorAddingNewProgram", null);
						// Clear session variables related to the error
						session.setAttribute("programCode", null);
						session.setAttribute("gradeLevel", null);
						session.setAttribute("programName", null);
						// HTML code to generate a message indicating the info status
	            		%>
			            <!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=addNewCourse.jsp">
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
							<h1>El programa fue a&ntilde;adido satisfactoriamente.</h1>
						  </body>
			        	</html>
						<%
					} else {
						// Error
						// Indicate the error in a session variable
						session.setAttribute("errorAddingNewProgram", "true");
						// Put the information in session variables
						session.setAttribute("programCode", programCode);
						session.setAttribute("gradeLevel", gradeLevel);
						session.setAttribute("programName", programName);

						// HTML code to generate a message indicating the info status
	            		%>
			            <!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=addProgram.jsp">
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
							<h1 id="error">El programa no pudo ser a&ntilde;adido. Lo m&aacute;s probable es que el c&oacute;digo de programa ya existe. Cambielo e intente de nuevo. Si el problema persiste, contacte con las personas designadas.</h1>
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