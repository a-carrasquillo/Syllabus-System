<%@ page import="java.lang.*"%>
<%// Import the package where the APIs are located%>
<%@ page import="ut.JAR.SYLLABUSSYSTEM.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>
<%
	// Retrieve parameters from the form and remove the unnecessary
    // spaces from the start and end
	String name = request.getParameter("name").trim();
	String lastName = request.getParameter("lastName").trim();
	String userName = request.getParameter("userName").trim();
	String psw = request.getParameter("psw");
	String psw_repeat = request.getParameter("psw_repeat");
	String selectPos = request.getParameter("selectPos").trim();

	// Perform Server-side validation
	// 1. Verify if the username already exists
	try {
        // Create the appDBAuth object
        applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());
        // Call the appropriate method to verify if the username already exists
        boolean res = appDBAuth.usernameExists(userName);
        
        // Verify if the username exists
        if(res) {
            // The username already exists in the system
            // Create a session variable to indicate that there has been an error
            session.setAttribute("error", "usernameExists");
            // Create and fill the parameters of the user information before redirecting
            session.setAttribute("name", name);
            session.setAttribute("lastName", lastName);
            session.setAttribute("userName", userName);
            session.setAttribute("jobPosition", selectPos);
            // Redirect to the signup page
            response.sendRedirect("signup.jsp");
        } else {
            // The username does not exists in the system
            // 2. Verify if password and password confirmation are the same
            if(!psw.equals(psw_repeat)) {
                // The password and password confirmation are not the same
            	// Create a session variable to indicate that there has been an error
            	session.setAttribute("error", "passwordsNotMatch");
            	// Create and fill the parameters of the user information before redirecting
	            session.setAttribute("name", name);
	            session.setAttribute("lastName", lastName);
	            session.setAttribute("userName", userName);
	            session.setAttribute("jobPosition", selectPos);
	            // Redirect to the signup page
	            response.sendRedirect("signup.jsp");
            } else {
                // All validations where completed successfully
            	// Try to add the user to the system
          		if(appDBAuth.addUser(name, lastName, userName, psw, selectPos)) {
                    // The new user was added successfully
          			// Delete all session variables related to an error
          			session.setAttribute("error", null);
                    session.setAttribute("name", null);
                    session.setAttribute("lastName", null);
                    session.setAttribute("userName", null);
                    session.setAttribute("jobPosition", null);
                    // HTML code to generate a message indicating the user status
                    %>
                    <!DOCTYPE html>
                    <html lang="es">
                        <head>
                            <title>Redireccionando...</title>
                            <meta http-equiv="Refresh" content="8;url=login.jsp">
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
		                  <h1>Usuario creado satisfactoriamente, redireccionando hacia la p&aacute;gina de login, favor de usar sus nuevas credenciales para iniciar sesi&oacute;n...</h1>
                        </body>
                    </html>
					<%
          		} else {
                    // The new user was not added successfully
					// Create a session variable to indicate that there has been an error
	            	session.setAttribute("error", "unexpectedError");
	            	// Create and fill the parameters of the user information before redirecting
		            session.setAttribute("name", name);
		            session.setAttribute("lastName", lastName);
		            session.setAttribute("userName", userName);
		            session.setAttribute("jobPosition", selectPos);
                    // HTML code to generate a message indicating the user status
                    %>
                    <!DOCTYPE html>
                    <html lang="es">
                        <head>
                            <title>Redireccionando...</title>
                            <meta http-equiv="Refresh" content="8;url=login.jsp">
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
                            <h1 id="error">Usuario NO pudo ser creado, redireccionando hacia la p&aacute;gina de signup, favor de intentar m&aacute;s tarde. Si el problema persiste comuniquese con la persona correspondiente.</h1>
                        </body>
                    </html>
                <%
          		}
            }
        } 
          // Close the connection to the database
          appDBAuth.close();
    } catch(Exception e) {
        %>
        Nothing to show!
        <%
        System.out.println("Exception...");
        e.printStackTrace();
    } finally {
        System.out.println("");
    }
%>