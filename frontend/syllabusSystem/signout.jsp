<%@ page import="java.lang.*"%>

<%
    // Deleting session variables
	session.invalidate();
    // Redirecting to the login page
	response.sendRedirect("login.jsp");
%>