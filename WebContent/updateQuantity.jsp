<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    //Update quantity of given an item in a given warehouse
    try {
        String warehouseId = request.getParameter("warehouseId");
        String productId = request.getParameter("productId");
        String newQuantity = request.getParameter("newQuantity");

        out.println("warehouseId: " + warehouseId);
        out.println("productId: " + productId);
        out.println("newQuantity: " + newQuantity);

        String sql = "UPDATE productinventory SET quantity = ? WHERE warehouseId = ? AND productId = ?";
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, Integer.parseInt(newQuantity));
            pst.setInt(2, Integer.parseInt(warehouseId));
            pst.setInt(3, Integer.parseInt(productId));

            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
                out.println("Quantity updated successfully!");
            } else {
                out.println("Failed to update quantity.");
            }

        } catch (SQLException e) {
            out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
        }
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
        e.printStackTrace();
    }
%>
