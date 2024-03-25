<%@ page import="java.io.IOException, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%@ include file="jdbc.jsp" %>

<% 
    if (request.getMethod().equalsIgnoreCase("POST")) {
        //revrieve info from form
        int customerIdToUpdate = Integer.parseInt(request.getParameter("customerIdToUpdate"));
        String updatedUsername = request.getParameter("username");
        String updatedPassword = request.getParameter("password");
        String updatedFirstName = request.getParameter("firstName");
        String updatedLastName = request.getParameter("lastName");
        String updatedEmail = request.getParameter("email");
        String updatedPhoneNum = request.getParameter("phone");
        String updatedAddress = request.getParameter("address");
        String updatedCity = request.getParameter("city");
        String updatedState = request.getParameter("state");
        String updatedPostalCode = request.getParameter("postalCode");
        String updatedCountry = request.getParameter("country");

        //If the new username isn't taken, allow to update all the fields that were used in the form in admin.jsp
        try {
            getConnection();
            String sql = "SELECT customerId FROM customer WHERE userid = ? AND customerId != ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, updatedUsername);
            stmt.setInt(2, customerIdToUpdate);

            ResultSet rst = stmt.executeQuery();
            if (rst.next()) {
                response.sendRedirect("admin.jsp?error=exists");
            } else {
                String sql2 = "UPDATE customer SET " +
                        "userid = COALESCE(NULLIF(?, ''), userid), " +
                        "password = COALESCE(NULLIF(?, ''), password), " +
                        "firstName = COALESCE(NULLIF(?, ''), firstName), " +
                        "lastName = COALESCE(NULLIF(?, ''), lastName), " +
                        "email = COALESCE(NULLIF(?, ''), email), " +
                        "phoneNum = COALESCE(NULLIF(?, ''), phoneNum), " +
                        "address = COALESCE(NULLIF(?, ''), address), " +
                        "city = COALESCE(NULLIF(?, ''), city), " +
                        "state = COALESCE(NULLIF(?, ''), state), " +
                        "postalCode = COALESCE(NULLIF(?, ''), postalCode), " +
                        "country = COALESCE(NULLIF(?, ''), country) " +
                        "WHERE customerId = ?";

                PreparedStatement stmt2 = con.prepareStatement(sql2);
                stmt2.setString(1, updatedUsername);
                stmt2.setString(2, updatedPassword);
                stmt2.setString(3, updatedFirstName);
                stmt2.setString(4, updatedLastName);
                stmt2.setString(5, updatedEmail);
                stmt2.setString(6, updatedPhoneNum);
                stmt2.setString(7, updatedAddress);
                stmt2.setString(8, updatedCity);
                stmt2.setString(9, updatedState);
                stmt2.setString(10, updatedPostalCode);
                stmt2.setString(11, updatedCountry);
                stmt2.setInt(12, customerIdToUpdate);

                int rowsAffected = stmt2.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("admin.jsp?error=update");
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
    }
%>

</body>
</html>
