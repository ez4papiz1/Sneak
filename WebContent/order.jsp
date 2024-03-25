<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sneak</title>
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            color: #333;
        }

        header {
            background-color: #000;
            color: #fff;
            padding: 20px 0;
        }

        nav {
            display: flex;
            justify-content: flex-end;
            padding: 0 30px;
        }

        nav a {
            color: #fff;
            text-decoration: none;
            margin: 0 20px;
            font-weight: 500;
            letter-spacing: 1px;
            transition: color 0.3s ease;
        }

        nav a:hover {
            color: #f0f0f0;
        }

        .brand-logo {
            font-size: 24px;
            color: #fff;
            font-weight: bold;
            padding-left: 30px;
            text-transform: uppercase;
        }

        h1 {
            text-align: center;
            font-size: 28px;
            color: #000;
            margin: 40px 0;
        }

        .success-message {
            text-align: center;
            font-size: 20px;
            color: #4CAF50;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<% 
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
String address = request.getParameter("shiptoAddress");
String city = request.getParameter("shiptoCity");
String state = request.getParameter("shiptoState");
String postal = request.getParameter("shiptoPostalCode");
String country = request.getParameter("shiptoCountry");
String paymentType = request.getParameter("paymentType");
String paymentNumber = request.getParameter("paymentNumber");
String paymentExpiryDate = request.getParameter("paymentExpiryDate");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (custId == null || productList == null || productList.isEmpty()) {
    out.println("Invalid customer id or empty shopping cart. Please go back and try again.");
} else {
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
    String sql1 = "SELECT * FROM customer WHERE customerId = ? AND password = ?";
	try (Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pst = con.prepareStatement(sql1)) {
        pst.setString(1, custId);
        pst.setString(2, password);
        ResultSet rst = pst.executeQuery();
		//Insert information about the order in orderproduct, ordersummary, productinventory, paymentmethod
	if(rst.next()){
	String sql = "INSERT INTO ordersummary (customerId, orderDate) VALUES (?, GETDATE())";
	try{
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		pstmt.setString(1, custId);
		pstmt.executeUpdate();			
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);	
		try{
			String sql2 = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();

				PreparedStatement pstmt2 = con.prepareStatement(sql2);
				pstmt2.setInt(1, orderId);
				pstmt2.setString(2, productId);
				pstmt2.setInt(3, qty);
				pstmt2.setDouble(4, pr);
				pstmt2.executeUpdate();
				String sql5 = "UPDATE productinventory SET quantity = quantity - ? " + "WHERE productId = ? AND warehouseId = (SELECT TOP 1 warehouseId FROM productinventory WHERE productId = ? ORDER BY quantity DESC)";
    			try (PreparedStatement stmt5 = con.prepareStatement(sql5)) {
       				stmt5.setInt(1, qty);
        			stmt5.setString(2, productId);
        			stmt5.setString(3, productId);
        			stmt5.executeUpdate();
				} catch (SQLException e) {
					out.println("SQLException: " + e);
				}

			}
			String sql3 = "UPDATE ordersummary SET totalAmount = (SELECT SUM(quantity * price) FROM orderproduct WHERE orderId = ?), shiptoAddress = ?, shiptoCity = ?, shiptoState = ?, shiptoPostalCode = ?, shiptoCountry = ? WHERE orderId = ?";
			PreparedStatement pstmt3 = con.prepareStatement(sql3);
			pstmt3.setInt(1, orderId);
			pstmt3.setString(2, address);
			pstmt3.setString(3, city);
			pstmt3.setString(4, state);
			pstmt3.setString(5, postal);
			pstmt3.setString(6, country);
			pstmt3.setInt(7, orderId);
			pstmt3.executeUpdate();

			String sql4 = "UPDATE paymentmethod SET paymentType = ?, paymentNumber = ?, paymentExpiryDate = ? WHERE customerId = ?";
			PreparedStatement pstmt4 = con.prepareStatement(sql4);
			pstmt4.setString(1, paymentType);
			pstmt4.setString(2, paymentNumber);
			pstmt4.setString(3, paymentExpiryDate);
			pstmt4.setString(4, custId);

			%>
<header>
    <div class="brand-logo">Sneak</div>
    <nav>
        <a href="listprod.jsp">New Arrivals</a>
        <a href="admin.jsp" id="adminPortalLink">Admin Portal</a>
        <a href="showcart.jsp">Shopping Cart</a>
        <% if (session.getAttribute("authenticatedUser") == null) { %>
            <a href="login.jsp">Login</a>
        <% } else { %>
            <a href="customer.jsp">Welcome, <%= session.getAttribute("authenticatedUser") %></a>
            <a href="logout.jsp">Logout</a>
        <% } %>
    </nav>
</header>

<h1>Thank you for shopping with us!</h1>
<div class="success-message">
    Order placed successfully!<br>
    Order ID: <%= orderId %>
</div>

<%

			session.removeAttribute("productList");
		} catch (SQLException e) {
			out.println("SQLException: " + e);
		}
		} catch (SQLException e) {
			out.println("SQLException: " + e);
		}
	} else {
		out.println("Incorrect password. Please go back and try again.");
	} 
} catch (SQLException e) {
	out.println("SQLException: " + e);
}
}
%>
</BODY>
</HTML>

