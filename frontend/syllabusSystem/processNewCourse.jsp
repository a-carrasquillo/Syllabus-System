<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods%>
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
		String currentPage = "processNewCourse.jsp";
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
					session.setAttribute("currentPage", "processNewCourse.jsp");
					
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
					String courseName = request.getParameter("course_name").trim();
					String courseCode = request.getParameter("course_code").trim();
					String courseType = request.getParameter("tipo").trim();
					String courseModality = request.getParameter("modalidad").trim();
					// Create a applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
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
					// Try to add the information to the system
					if(appDBMnger.addCourse(courseCode, courseName, courseType, courseModality, userName)) {
						// Success
						// Delete session variables related to error information
						session.setAttribute("errorNewCourse", null);
						session.setAttribute("courseName", null);
						session.setAttribute("courseCode", null);
						session.setAttribute("courseType", null);
			        	session.setAttribute("courseModality", null);
	            		%>
							<h1>El curso fue a&ntilde;adido satisfactoriamente.</h1>
						<%
					} else {
						// Fail
						// Indicate the error in the session variable
						session.setAttribute("errorNewCourse", "true");
						// Set the error related information in session variable
						session.setAttribute("courseName", courseName);
						session.setAttribute("courseCode", courseCode);
						session.setAttribute("courseType", courseType);
			        	session.setAttribute("courseModality", courseModality);
	            		%>
							<h1 id="error">El curso no pudo ser a&ntilde;adido. Lo m&aacute;s probable es que el c&oacute;digo de curso ya existe. Cambielo e intente de nuevo. Si el problema persiste, contacte con las personas designadas.</h1>
						<%
					}
					%>
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