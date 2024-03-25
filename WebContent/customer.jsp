<%@ page import="java.io.IOException, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f4f4f4;
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

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        input[type="submit"] {
            background-color: #000;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #333;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }

		.form-field {
			width: 100%;
			padding: 10px;
			margin-bottom: 10px;
			border: 1px solid #ddd;
			border-radius: 4px;
		}

		.form-field[type="text"],
		.form-field[type="password"],
		.form-field[type="email"],
		.form-field[type="number"],
		.form-field[type="tel"],
		.form-field[type="text"] {
			/* Adjust font size, color, and other properties */
			font-size: 16px;
			color: #333;
		}

		.form-field[type="text"]:focus,
		.form-field[type="password"]:focus,
		.form-field[type="email"]:focus,
		.form-field[type="number"]:focus,
		.form-field[type="tel"]:focus,
		.form-field[type="text"]:focus {
			outline: none;
			border-color: #555;
			box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
		}

		/* Apply the existing styles for input[type="submit"] to .form-field */
		.form-field[type="submit"] {
			background-color: #000;
			color: #fff;
			padding: 10px 20px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			transition: background-color 0.3s ease;
		}

		.form-field[type="submit"]:hover {
			background-color: #333;
		}

    </style>
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

    <%@ include file="auth.jsp" %>
    <%@ include file="jdbc.jsp" %>

    <div class="container">
        <h2>Your Orders</h2>
        <%
    try {
        int customerId = (int) session.getAttribute("customerId");

        getConnection();

        String sql = "SELECT orderDate, SUM(totalAmount) AS total FROM ordersummary WHERE customerId = ? GROUP BY orderDate";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, customerId);
            ResultSet rst = pstmt.executeQuery();

            while (rst.next()) {
                String orderDate = rst.getString("orderDate");
                double total = rst.getDouble("total");
                out.println("Order Date: " + orderDate + ", Total Amount: " + total + "<br>");
            }
        }
    } catch (SQLException ex) {
        out.println("SQL Error: " + ex.getMessage());
    } finally {
        closeConnection();
    }
%>

<!--This is a comment. Comments are not displayed in the browser-->
	<h2>Update Your Information</h2>
	<form action="updateCustomer.jsp" method="post">
		<input type="hidden" id="customerIdToUpdate" name="customerIdToUpdate"
			value="<%= session.getAttribute("customerId") %>">

		<label for="username">Username:</label>
		<input type="text" class="form-field" id="username" name="username"><br>

		<label for="password">Password:</label>
		<input type="password" class="form-field" id="password" name="password"><br>

		<label for="firstName">First Name:</label>
		<input type="text" class="form-field" id="firstName" name="firstName"><br>

		<label for="lastName">Last Name:</label>
		<input type="text" class="form-field" id="lastName" name="lastName"><br>

		<label for="email">Email:</label>
		<input type="email" class="form-field" id="email" name="email"><br>

		<label for="phone">Phone:</label>
		<input type="text" class="form-field" id="phone" name="phone"><br>

		<label for="address">Address:</label>
		<input type="text" class="form-field" id="address" name="address"><br>

		<label for="city">City:</label>
		<input type="text" class="form-field" id="city" name="city"><br>

		<label for="state">State:</label>
		<input type="text" class="form-field" id="state" name="state"><br>

		<label for="postalCode">Postal Code:</label>
		<input type="text" class="form-field" id="postalCode" name="postalCode"><br>

		<label for="country">Country:</label>
		<input type="text" class="form-field" id="country" name="country"><br>

		<input type="submit" value="Update Information">
	</form>

	<%
		if (request.getParameter("error") != null) {
	%>
	<p class="error-message">Error: Please choose a different username.</p>
	<%
		}
	%>
</div>
	

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#adminPortalLink').css('display', 'none');

            checkAdminStatus();

            function checkAdminStatus() {
                $.ajax({
                    url: 'checkAdminStatus.jsp',
                    type: 'GET',
                    success: function (response) {
                        var isAdmin = /true/i.test(response);

                        console.log('isAdmin:', isAdmin);

                        if (isAdmin) {
                            $('#adminPortalLink').show();
                        }
                    },
                    error: function (error) {
                        console.error('Error checking admin status:', error);
                    }
                });
            }
        });
    </script>
</body>

</html>
