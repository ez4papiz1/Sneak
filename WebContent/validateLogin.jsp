<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println(e);
    }

    if (authenticatedUser != null) {
        response.sendRedirect("listprod.jsp"); // Successful login
    } else {
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message
    }
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null;
        }

        try {
            getConnection(); // Assuming this method sets up 'con' as a Connection object

            String sql = "SELECT userid, customerId, isAdmin FROM customer WHERE userid = ? AND password = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                retStr = username; // User is authenticated

                // Set customerId and isAdmin in the session
                int customerId = rs.getInt("customerId");
                boolean isAdmin = rs.getInt("isAdmin") == 1;
                session.removeAttribute("loginMessage");
                session.setAttribute("authenticatedUser", username);
                session.setAttribute("customerId", customerId);
                session.setAttribute("isAdmin", isAdmin);
            }

            rs.close();
            pstmt.close();
        } catch (SQLException ex) {
            out.println("SQLException: " + ex.getMessage());
        } finally {
            closeConnection(); // Close the database connection
        }

        if (retStr == null) {
            session.setAttribute("loginMessage", "Invalid username or password.");
        }

        return retStr;
    }
%>
