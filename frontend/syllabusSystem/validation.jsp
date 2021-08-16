<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

<%
	// Retrieve variables
	String userName = request.getParameter("uname").trim();
	String userPass = request.getParameter("userpass");
	
	// Try to connect the database using the applicationDBAuthentication class
	try {
		// Create the appDBAuth object
		applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
		System.out.println("Connecting...");
		System.out.println(appDBAuth.toString());
			
		// Call the authenticate method to determine if the credentials
		// match and have access to the system
		ResultSet res = appDBAuth.authenticate(userName, userPass);
			
		// Verify if the user has been authenticated
		if(res.next()) {		
			// Create the current page attribute
			session.setAttribute("currentPage", "validation.jsp");
			// Delete the error message flag for the login
			session.setAttribute("loginError", null);
			// Create a session variable
			if(session.getAttribute("userName")==null) {
				// Create the session variable
				session.setAttribute("userName", userName);
			} else {
				// Update the session variable
				session.setAttribute("userName", userName);
			}
			System.out.println(userName + " authenticated... Redirecting to welcomeMenu");
			// Redirect to the welcome page
			response.sendRedirect("welcomeMenu.jsp");	
		} else {
			// Close any session associated with the user
			session.setAttribute("userName", null);
			// Create the error message flag for the login
			session.setAttribute("loginError", "true");
			System.out.println(userName + " not authenticated... Redirecting to login");
			// Return to the login page
			response.sendRedirect("login.jsp");
		}
		// Close result set
		res.close();
		// Close the connection to the database
		appDBAuth.close();
			
	} catch(Exception e) {
		System.out.println("Exception while validating " + userName + "...");
		e.printStackTrace();
		// Return to the login page
		response.sendRedirect("login.jsp");
	} finally {
		System.out.println("");
	}
%>