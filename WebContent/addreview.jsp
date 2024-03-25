<%@ page import="java.sql.*,java.text.SimpleDateFormat,java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.net.URLEncoder" %>

<%
String productId = request.getParameter("productId");
String reviewComment = request.getParameter("reviewText");
int customerId = -1; // Default value for customerId

Object cidObj = session.getAttribute("customerId");

if (cidObj != null) {
    try {
        customerId = Integer.parseInt(cidObj.toString());
    } catch (NumberFormatException e) {
        e.printStackTrace();
        response.sendRedirect("product.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&error=invalidcustomer");
        return;
    }
} else {
    response.sendRedirect("product.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&error=missingcustomer");
    return;
}

if (productId != null && reviewComment != null && customerId > 0) {
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT o.orderId " + "FROM ordersummary o " + "JOIN orderproduct op ON o.orderId = op.orderId " + "WHERE o.customerId = ? AND op.productId = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, Integer.parseInt(productId));

            ResultSet rst = stmt.executeQuery();
            //If customer has bought this product...
            if (rst.next()) {
                String sql2 = "SELECT * FROM review WHERE productId = ? AND customerId = ?";
                try (PreparedStatement stmt2 = con.prepareStatement(sql2)) {
                    stmt2.setInt(1, Integer.parseInt(productId));
                    stmt2.setInt(2, customerId);

                    ResultSet rst2 = stmt2.executeQuery();
                    //And if the customer hasn't left a review for this product...
                    if (!rst2.next()) {
                        //Upload the review
                        String sql3 = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement stmt3 = con.prepareStatement(sql3)) {
                            stmt3.setInt(1, 0);

                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            String reviewDate = sdf.format(new Date());
                            stmt3.setString(2, reviewDate);

                            stmt3.setInt(3, customerId);
                            stmt3.setInt(4, Integer.parseInt(productId));
                            stmt3.setString(5, reviewComment);

                            int rowsAffected = stmt3.executeUpdate();
                            if (rowsAffected > 0) {
                                response.sendRedirect("product.jsp?id=" + URLEncoder.encode(productId, "UTF-8"));
                            }
                        }
                    } else {
                        response.sendRedirect("product.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&error=reviewexists");
                    }
                }
            } else {
                //Return with an error
                response.sendRedirect("product.jsp?id=" + URLEncoder.encode(productId, "UTF-8") + "&error=notbought");
            }
        }
    } catch (SQLException ex) {
        out.println("SQLException: " + ex.getMessage());
        ex.printStackTrace();
    }
}
%>
