<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	response.sendRedirect("listprod.jsp");
%>

