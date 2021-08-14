<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>
<%// Import the package required to use ArrayList and other Collection related methods%>
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
		String currentPage = "processAddedProgramCourses.jsp";
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
					session.setAttribute("currentPage", "processAddedProgramCourses.jsp");
					
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
					String academicGrade = request.getParameter("grado").trim();
					String courseProgram = request.getParameter("programs").trim();
					String coursesList = request.getParameter("course_list").trim();

					// Separate the course list by lines
					String[] arrayCoursesList = coursesList.split("\n");

					// Define ArrayLists for the comparison of courses in a program
					ArrayList<String> courseArrayList = new ArrayList<String>(Arrays.asList(arrayCoursesList));
					ArrayList<String> currentCoursesInProgram = new ArrayList<String>();

					// Create an applicationDBManager object
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

					// Search the current courses that the program has
					res = appDBMnger.listCoursesOfProgram(courseProgram);

					// Put the information in an ArrayList to compare ArrayList with ArrayList
					while(res.next())
						currentCoursesInProgram.add(res.getString(1));

					// Sort both ArrayLists
					Collections.sort(courseArrayList);
        			Collections.sort(currentCoursesInProgram);

					// Remove from the courseArrayList the elements that
					// are in currentCoursesInProgram
					courseArrayList.removeAll(currentCoursesInProgram);

					for(int i=0; i<courseArrayList.size(); i++) {
						courseArrayList.set(i, courseArrayList.get(i).trim().replaceAll(System.lineSeparator(),""));
					}

					// If all the courses are already in the program, notify this error
					if(!courseArrayList.isEmpty()) {
						// Try to perform the insert with the remaining courses
						if(appDBMnger.addCoursesToProgram(courseProgram, courseArrayList)) {
							// Success
							// Delete session variables related to error information
							session.setAttribute("errorAddingCoursesToProgram", null);
							session.setAttribute("academicGrade", null);
							session.setAttribute("courseProgram", null);
							session.setAttribute("coursesList", null);
							// HTML code to generate a message indicating the info status
							%>
							<!DOCTYPE html>
				            <html lang="es">
				              <head>
				                <title>Redireccionando...</title>
				                <meta http-equiv="Refresh" content="8;url=welcomeMenu.jsp">
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
								<h1>Los cursos fueron a&ntilde;adidos satisfactoriamente al programa.</h1>
							  </body>
				        	</html>
							<%
						} else {
							// Fail
							// Indicate the error in the session variable
							session.setAttribute("errorAddingCoursesToProgram", "true");
							// Set the error related information in session variables
							session.setAttribute("academicGrade", academicGrade);
							session.setAttribute("courseProgram", courseProgram);
							session.setAttribute("coursesList", coursesList);
							// HTML code to generate a message indicating the info status
							%>
							<!DOCTYPE html>
				            <html lang="es">
				              <head>
				                <title>Redireccionando...</title>
				                <meta http-equiv="Refresh" content="8;url=addCourseToProgram.jsp">
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
								<h1 id="error">Los cursos no se pudieron a&ntilde;adir al programa. Intente m&aacute;s tarde, si el problema persiste comuniquese con la persona designada. </h1>
							  </body>
				        	</html>
							<%
						}
					} else {
						// Error
						System.out.println("The program has all the courses in the list...");
						// Indicate the error in the session variable
						session.setAttribute("errorAddingCoursesToProgram", "true");
						// Set the error related information in session variables
						session.setAttribute("academicGrade", academicGrade);
						session.setAttribute("courseProgram", courseProgram);
						session.setAttribute("coursesList", coursesList);
						// HTML code to generate a message indicating the info status
						%>
						<!DOCTYPE html>
			            <html lang="es">
			              <head>
			                <title>Redireccionando...</title>
			                <meta http-equiv="Refresh" content="8;url=addCourseToProgram.jsp">
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
							<h1 id="error">Todos los cursos en la lista ya existen en el programa. A&ntilde;ada al programa cursos que no posee.</h1>
						  </body>
			        	</html>
						<%
					}
					// Close connection to the DB
					appDBMnger.close();
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