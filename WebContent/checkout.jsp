<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
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

    </style>
<title>Sneak CheckOut Line</title>
</head>
<body>

    <header>
		<div class="brand-logo">Sneak</div>
		<nav>
			<a href="listprod.jsp">New Arrivals</a>
			<a href="showcart.jsp">Shopping Cart</a>
			<% if (session.getAttribute("authenticatedUser") == null) { %>
				<a href="login.jsp">Login</a>
			<% } else { %>
				<span>Welcome, <%= session.getAttribute("authenticatedUser") %></span>
				<a href="logout.jsp">Logout</a>
			<% } %>
		</nav>
	</header>

    <h1>Enter your payment method details:</h1>

    <%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
        response.sendRedirect("login.jsp");
    } else {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection(url, uid, pw);
            String sql = "SELECT * FROM customer WHERE userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, authenticatedUser);
            ResultSet rs = pstmt.executeQuery();
    
            if (rs.next()) {
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                String address = rs.getString("address");
                String city = rs.getString("city");
                String state = rs.getString("state");
                String postalCode = rs.getString("postalCode");
                String country = rs.getString("country");
                String password = rs.getString("password");
    
    %>
    <h2>Customer Details:</h2>
    <p><strong>Name:</strong> <%= firstName %> <%= lastName %></p>
    <p><strong>Address:</strong> <%= address %>, <%= city %>, <%= state %>, <%= postalCode %>, <%= country %></p>
    
    <!--Form for processing the order. Asking only for payment info, the rest is used for order.jsp-->
    <form action="order.jsp" method="post">
        <label for="paymentType">Payment Type:</label>
        <input type="text" id="paymentType" name="paymentType" required><br>
        <label for="paymentNumber">Payment Number:</label>
        <input type="text" id="paymentNumber" name="paymentNumber" required><br>
        <label for="paymentExpiryDate">Expiry Date (MM/YY):</label>
        <input type="text" id="paymentExpiryDate" name="paymentExpiryDate" pattern="\d{2}/\d{2}" required><br>
        <input type="hidden" id="customerId" name="customerId" value="<%= session.getAttribute("customerId") %>">
        <input type="hidden" id="firstName" name="firstName" value="<%= firstName %>">
        <input type="hidden" id="lastName" name="lastName" value="<%= lastName %>">
        <input type="hidden" id="address" name="address" value="<%= address %>">
        <input type="hidden" id="city" name="city" value="<%= city %>">
        <input type="hidden" id="state" name="state" value="<%= state %>">
        <input type="hidden" id="postalCode" name="postalCode" value="<%= postalCode %>">
        <input type="hidden" id="country" name="country" value="<%= country %>">
        <input type="hidden" id="password" name="password" value="<%= password %>">
        <input type="submit" value="Submit Payment">
    </form>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    %>
    </body>
    </html>