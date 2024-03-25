<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%@ include file="jdbc.jsp" %>

<%
    Object isAdminAttribute = session.getAttribute("isAdmin");

    boolean isAdmin = isAdminAttribute != null && isAdminAttribute instanceof Boolean && (Boolean) isAdminAttribute;

    System.out.println("isAdmin: " + isAdmin);

    out.print(String.valueOf(isAdmin));
%>
