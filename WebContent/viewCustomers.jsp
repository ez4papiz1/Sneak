<%@ page language="java" import="java.sql.*,java.io.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Customers</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>All Customers</h2>

    <table>
        <tr>
            <th>Customer ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>City</th>
            <th>State</th>
            <th>Postal Code</th>
            <th>Country</th>
            <th>Username</th>
            <th>Password</th>
            <th>Is Admin</th>
        </tr>
        
        <% 
            try {
                getConnection();

                String sql = "SELECT * FROM customer";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getInt("customerId") %></td>
                        <td><%= rs.getString("firstName") %></td>
                        <td><%= rs.getString("lastName") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("phonenum") %></td>
                        <td><%= rs.getString("address") %></td>
                        <td><%= rs.getString("city") %></td>
                        <td><%= rs.getString("state") %></td>
                        <td><%= rs.getString("postalCode") %></td>
                        <td><%= rs.getString("country") %></td>
                        <td><%= rs.getString("userid") %></td>
                        <td><%= rs.getString("password") %></td>
                        <td><%= rs.getInt("isAdmin") %></td>
                    </tr>
        <%
                }

                rs.close();
                stmt.close();
            } catch (SQLException ex) {
                out.println("SQL Error: " + ex.getMessage());
            } finally {
                closeConnection();
            }
        %>
    </table>
</body>
</html>
