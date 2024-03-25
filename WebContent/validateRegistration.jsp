<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
    String registeredUser = null;

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phoneNum = request.getParameter("phoneNum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    if (username == null || password == null || firstName == null || lastName == null || email == null ||
        phoneNum == null || address == null || city == null || state == null || postalCode == null || country == null ||
        username.isEmpty() || password.isEmpty() || firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() ||
        phoneNum.isEmpty() || address.isEmpty() || city.isEmpty() || state.isEmpty() || postalCode.isEmpty() || country.isEmpty()) {
        response.sendRedirect("registration.jsp?error=empty"); // Redirect with an error message
    } else {
        try {
            getConnection(); // Assuming this method sets up 'con' as a Connection object

            String sql = "SELECT userid, customerId FROM customer WHERE userid = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, username);

            ResultSet rst = stmt.executeQuery()
            //If username taken, return with error. Else, insert the new customer into the database
            if (rst.next()) {
                response.sendRedirect("registration.jsp?error=exists");
            } else {
                String sql2 = "INSERT INTO customer (userid, password, firstName, lastName, email, phoneNum, address, city, state, postalCode, country) " +
                                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt2 = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
                stmt2.setString(1, username);
                stmt2.setString(2, password);
                stmt2.setString(3, firstName);
                stmt2.setString(4, lastName);
                stmt2.setString(5, email);
                stmt2.setString(6, phoneNum);
                stmt2.setString(7, address);
                stmt2.setString(8, city);
                stmt2.setString(9, state);
                stmt2.setString(10, postalCode);
                stmt2.setString(11, country);

                int rowsAffected = stmt2.executeUpdate();
                if (rowsAffected > 0) {
                    registeredUser = username; // Registration successful
                    ResultSet generatedKeys = stmt2.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int customerId = generatedKeys.getInt(1);

                        session.setAttribute("authenticatedUser", registeredUser);
                        session.setAttribute("customerId", customerId);
                        session.setAttribute("isAdmin", false);
                    }
                }
                stmt2.close();
            }
            rst.close();
            stmt.close();
        } catch (SQLException ex) {
            out.println("SQLException: " + ex.getMessage());
        } finally {
            closeConnection();
        }
        if (registeredUser != null) {
            // Registration successful
            response.sendRedirect("listprod.jsp");
        } else {
           
        }
    }
%>
