<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Your Shopping Cart</title>
		<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
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
			.product-table {
				width: 100%;
				border-collapse: collapse;
				margin: 0 auto;
			}
			.product-table th, .product-table td {
				border: 1px solid #ddd;
				padding: 8px;
				text-align: left;
			}
			.product-table th {
				background-color: #f2f2f2;
			}
			.quantity {
				display: flex;
				align-items: center;
				justify-content: center;
				margin-bottom: 10px;
			}
			
			.quantity input {
				width: 40px;
				height: 30px;
				text-align: center;
				font-size: 16px;
				border: 1px solid #ddd;
				border-radius: 4px;
				margin: 0 5px;
			}
			
			.quantity button {
				width: 30px;
				height: 30px;
				background-color: #000;
				color: white;
				border: none;
				border-radius: 4px;
				cursor: pointer;
			}
	
			.quantity button:focus {
				outline: none;
			}

			.checkout-button, .continue-shopping {
				background-color: #333; 
				color: #fff;
				text-decoration: none;
				padding: 15px 30px;
				border-radius: 5px;
				font-weight: 600;
				transition: background-color 0.3s ease, transform 0.3s ease;
				margin: 20px auto;
				display: block;
				text-align: center;
				width: 150px; 
				box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); 
			}

			.checkout-button:hover, .continue-shopping:hover {
				background-color: #444; 
				transform: translateY(-3px); 
				box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); 
			}

			input[type='number']::-webkit-inner-spin-button,
			input[type='number']::-webkit-outer-spin-button {
				-webkit-appearance: none;
				margin: 0;
			}
		</style>
		<script>
			function updateQuantity(productId, isIncrement) {
				var inputField = document.getElementById('quantity-' + productId);
				var currentValue = parseInt(inputField.value, 10);
				var newValue = isIncrement ? currentValue + 1 : currentValue - 1;
				newValue = newValue < 1 ? 1 : newValue; // Prevent negative quantities
				inputField.value = newValue;
				document.getElementById('update-form-' + productId).submit();
			}
		</script>
	</head>
<body>

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

<%

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

	// Check if user is logged in
	String authenticatedUser = (String) session.getAttribute("authenticatedUser");
	if (authenticatedUser == null) {
		out.println("<H2>Please <a href='login.jsp'>log in</a> to view your shopping cart.</H2>");
	} else {
		@SuppressWarnings({"unchecked"})
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
	
		String action = request.getParameter("action");
		if ("remove".equals(action)) {
			String productIdToRemove = request.getParameter("productId");
			if (productIdToRemove != null) {
				productList.remove(productIdToRemove);
				session.setAttribute("productList", productList);
			}
		} else if ("update".equals(action)) {
			String productIdToUpdate = request.getParameter("productId");
			int updatedQuantity = Integer.parseInt(request.getParameter("quantity"));
			
			try {
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				Connection con = DriverManager.getConnection(url, uid, pw);
				String query = "SELECT quantity FROM productinventory WHERE productId = ?";
				PreparedStatement pstmt = con.prepareStatement(query);
				pstmt.setInt(1, Integer.parseInt(productIdToUpdate));
				ResultSet rs = pstmt.executeQuery();
	
				if (rs.next()) {
					int availableQuantity = rs.getInt("quantity");
					if (updatedQuantity <= availableQuantity) {
						ArrayList<Object> productDetails = productList.get(productIdToUpdate);
						productDetails.set(3, updatedQuantity); 
						session.setAttribute("productList", productList);
					} else {
						// Handle insufficient inventory
						out.println("<script>alert('Insufficient inventory for product ID: " + productIdToUpdate + "');</script>");
						ArrayList<Object> productDetails = productList.get(productIdToUpdate);
							productDetails.set(3, availableQuantity); 
							session.setAttribute("productList", productList);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} 
		}
    if (productList == null || productList.isEmpty()) {
        out.println("<H1>Your shopping cart is empty!</H1>");
    } else {

		// Checking quantity, so it doesnt surpass the available stock.
		for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
			String productId = entry.getKey();
			ArrayList<Object> productDetails = entry.getValue();
			int sessionQuantity = (Integer) productDetails.get(3);
			Connection con = DriverManager.getConnection(url, uid, pw);;
			String query = "SELECT quantity FROM productinventory WHERE productId = ?";
			PreparedStatement pstmt =  con.prepareStatement(query);
			pstmt.setInt(1, Integer.parseInt(productId));
			ResultSet rs = pstmt.executeQuery();
			//Display error alert, when quantity exceeds stock
			if (rs.next()) {
				int availableQuantity = rs.getInt("quantity");
				if (sessionQuantity > availableQuantity) {
					productDetails.set(3, availableQuantity); // Update quantity to available stock
					out.println("<script>alert('NO MORE STOCK :()');</script>");
				}
			}
		}
		session.setAttribute("productList", productList); // Save any updates back to the session

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        out.println("<h1>Your Shopping Cart</h1>");
        out.println("<table class='product-table'>");
        out.print("<tr><th>Product Id</th><th>Product Name</th><th>Price</th><th>Quantity</th>");
        out.println("<th>Subtotal</th></tr>");

		//Checks the quantity and doesn't allow it to exceed the stock
        double total = 0;
        for (ArrayList<Object> product : productList.values()) {
            out.print("<tr><td>" + product.get(0) + "</td>");
            out.print("<td>" + product.get(1) + "</td>");
            double price = Double.parseDouble(product.get(2).toString());
            int quantity = Integer.parseInt(product.get(3).toString());
            out.print("<td align=\"right\">" + currFormat.format(price) + "</td>");
            	out.print("<td align=\"center\">");
				out.print("<div class=\"quantity\">");
				out.print("<button type=\"button\" onclick=\"updateQuantity('" + product.get(0) + "', false)\">-</button>");
				out.print("<form id=\"update-form-" + product.get(0) + "\" action='showcart.jsp' method='post'>");
				out.print("<input type=\"number\" id=\"quantity-" + product.get(0) + "\" name=\"quantity\" value=\"" + product.get(3) + "\" min=\"1\" readonly />");
				out.print("<input type=\"hidden\" name=\"action\" value=\"update\" />");
				out.print("<input type=\"hidden\" name=\"productId\" value=\"" + product.get(0) + "\" />");
				out.print("</form>");
				out.print("<button type=\"button\" onclick=\"updateQuantity('" + product.get(0) + "', true)\">+</button>");
				out.print("</div>");
				out.print("</td>");
            double subtotal = price * quantity;
            out.print("<td align=\"right\">" + currFormat.format(subtotal) + "</td>");
			out.print("<td>");
			out.print("<form action='showcart.jsp' method='post'>");
			out.print("<input type='hidden' name='action' value='remove' />");
			out.print("<input type='hidden' name='productId' value='" + product.get(0) + "' />");
			out.print("<input type='submit' value='Remove' />");
			out.print("</form>");
			out.print("</td>");
			out.print("</tr>");
            total += subtotal;
            out.print("</tr>");
		}

		out.println("<tr><td colspan='5' class='order-total'><b>Order Total: " + currFormat.format(total) + "</b></td></tr>");
		out.println("</table>");

        String checkoutUrl = "checkout.jsp?username=" + URLEncoder.encode(authenticatedUser, "UTF-8");
        out.println("<h2><a href=\"" + checkoutUrl + "\" class='checkout-button'>Check Out</a></h2>");
    }

    out.println("<h2><a href=\"listprod.jsp\" class='continue-shopping'>Continue Shopping</a></h2>");
}
%>
<script>
	$(document).ready(function() {
		$('.product-box').hover(
			function() {
				$(this).css({'transform': 'scale(1.1)', 'transition': 'transform 0.5s ease'});
			}, 
			function() {
				$(this).css({'transform': 'scale(1)', 'transition': 'transform 0.5s ease'});
			}
		);
	
		$('#adminPortalLink').css('display', 'none');
	
		checkAdminStatus();
	
		function checkAdminStatus() {
			$.ajax({
				url: 'checkAdminStatus.jsp',
				type: 'GET',
				success: function(response) {
					var isAdmin = /true/i.test(response);
					console.log('isAdmin:', isAdmin);
					if (isAdmin) {
						$('#adminPortalLink').show();
					}
				},
				error: function(error) {
					console.error('Error checking admin status:', error);
				}
			});
		}
	});	
</script>	
</body>
</html>