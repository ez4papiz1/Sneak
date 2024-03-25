<%@ page import="java.io.IOException, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <title>Administrator Page</title>
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
        input[type="text"], input[type="number"], textarea {
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
<!--List all orders-->
<h2>Order List</h2>
<%
    try {
        getConnection();
        String sql = "SELECT orderDate, SUM(totalAmount) AS total FROM ordersummary GROUP BY orderDate";
        Statement stmt = con.createStatement();
        ResultSet rst = stmt.executeQuery(sql);

        while (rst.next()) {
            String orderDate = rst.getString("orderDate");
            double total = rst.getDouble("total");
            out.println("Order Date: " + orderDate + ", Total Amount: " + total + "<br>");
        }
        rst.close();
        stmt.close();
    } catch (SQLException ex) {
        out.println("SQL Error: " + ex.getMessage());
    } finally {
        closeConnection();
    }
%>
<br>
<!--User exists error handling-->
<%
            if (request.getParameter("error") != null) {
        %>
            <p class="error-message">Error: Please choose a different username.</p>
        <%
            }
        %>

<!--Forms for admin features-->
<h2>Add New Product</h2>
<form action="" method="post">
    <label for="productName">Product Name:</label>
    <input type="text" id="productName" name="productName" required><br>

    <label for="productPrice">Product Price:</label>
    <input type="number" step="0.01" id="productPrice" name="productPrice" required><br>

    <label for="productDesc">Product Description:</label>
    <textarea id="productDesc" name="productDesc" rows="4" required></textarea><br>

    <label for="categoryId">Category ID:</label>
    <input type="number" id="categoryId" name="categoryId" required><br>

    <input type="submit" value="Add Product">
</form>

<hr>

<h2>Delete Product</h2>
<form action="" method="post">
    <label for="productIdToDelete">Product ID to Delete:</label>
    <input type="number" id="productIdToDelete" name="productIdToDelete" required><br>

    <input type="submit" value="Delete Product">
</form>

<hr>

<h2>Update Product</h2>
<form action="" method="post">
    <label for="productIdToUpdate">Product ID to Update:</label>
    <input type="number" id="productIdToUpdate" name="productIdToUpdate" required><br>

    <label for="updatedProductName">Updated Product Name:</label>
    <input type="text" id="updatedProductName" name="updatedProductName" required><br>

    <label for="updatedProductPrice">Updated Product Price:</label>
    <input type="number" step="0.01" id="updatedProductPrice" name="updatedProductPrice" required><br>

    <label for="updatedProductDesc">Updated Product Description:</label>
    <textarea id="updatedProductDesc" name="updatedProductDesc" rows="4" required></textarea><br>

    <label for="updatedCategoryId">Updated Category ID:</label>
    <input type="number" id="updatedCategoryId" name="updatedCategoryId" required><br>

    <input type="submit" value="Update Product">
</form>

<h2>Add New Warehouse</h2>
<form action="" method="post">
    <label for="warehouseName">Warehouse Name:</label>
    <input type="text" id="warehouseName" name="warehouseName" required><br>

    <input type="submit" value="Add Warehouse">
</form>

<hr>

<h2>Edit Warehouse</h2>
<form action="" method="post">
    <label for="editWarehouseId">Warehouse ID to Edit:</label>
    <input type="number" id="editWarehouseId" name="editWarehouseId" required><br>

    <label for="editedWarehouseName">Updated Warehouse Name:</label>
    <input type="text" id="editedWarehouseName" name="editedWarehouseName" required><br>

    <input type="submit" value="Edit Warehouse">
</form>

<hr>

<h2>Add New Customer</h2>
<form action="addCustomer.jsp" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" class="form-field" required><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" class="form-field" required><br>

    <label for="firstName">First Name:</label>
    <input type="text" id="firstName" name="firstName" class="form-field" required><br>

    <label for="lastName">Last Name:</label>
    <input type="text" id="lastName" name="lastName" class="form-field" required><br>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" class="form-field" required><br>

    <label for="phone">Phone:</label>
    <input type="text" id="phone" name="phone" class="form-field" required><br>

    <label for="address">Address:</label>
    <input type="text" id="address" name="address" class="form-field" required><br>

    <label for="city">City:</label>
    <input type="text" id="city" name="city" class="form-field" required><br>

    <label for="state">State:</label>
    <input type="text" id="state" name="state" class="form-field" required><br>

    <label for="postalCode">Postal Code:</label>
    <input type="text" id="postalCode" name="postalCode" class="form-field" required><br>

    <label for="country">Country:</label>
    <input type="text" id="country" name="country" class="form-field" required><br>

    <input type="submit" value="Add Customer">
</form>


<hr>

<h2>Update Customer</h2>
<form action="updateCustomer.jsp" method="post">
    <label for="customerIdToUpdate">Customer ID to Update:</label>
    <input type="number" id="customerIdToUpdate" name="customerIdToUpdate" class="form-field" required><br>

    <label for="username">Username:</label>
    <input type="text" id="username" name="username" class="form-field"><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" class="form-field"><br>

    <label for="firstName">First Name:</label>
    <input type="text" id="firstName" name="firstName" class="form-field"><br>

    <label for="lastName">Last Name:</label>
    <input type="text" id="lastName" name="lastName" class="form-field"><br>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" class="form-field"><br>

    <label for="phone">Phone:</label>
    <input type="text" id="phone" name="phone" class="form-field"><br>

    <label for="address">Address:</label>
    <input type="text" id="address" name="address" class="form-field"><br>

    <label for="city">City:</label>
    <input type="text" id="city" name="city" class="form-field"><br>

    <label for="state">State:</label>
    <input type="text" id="state" name="state" class="form-field"><br>

    <label for="postalCode">Postal Code:</label>
    <input type="text" id="postalCode" name="postalCode" class="form-field"><br>

    <label for="country">Country:</label>
    <input type="text" id="country" name="country" class="form-field"><br>

    <input type="submit" value="Update Customer">
</form>

<hr>
<a href="loaddata.jsp" class="restore-button">Database Restore</a>&nbsp;&nbsp;&nbsp;
<a href="viewCustomers.jsp" class="restore-button">View Customer Information</a> <!-- New link added -->

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Add Product
        if (request.getParameter("productName") != null) {
            String productName = request.getParameter("productName");
            double productPrice = Double.parseDouble(request.getParameter("productPrice"));
            String productDesc = request.getParameter("productDesc");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            String insertSql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";

            try {
                getConnection();
                PreparedStatement pstmt = con.prepareStatement(insertSql);
                pstmt.setString(1, productName);
                pstmt.setDouble(2, productPrice);
                pstmt.setString(3, productDesc);
                pstmt.setInt(4, categoryId);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<script>alert('Product added successfully.');</script>");
                } else {
                    out.println("<script>alert('Failed to add product.');</script>");
                }

                pstmt.close();
            } catch (SQLException ex) {
                out.println("Error: " + ex.getMessage());
            } finally {
                closeConnection();
            }
        }
        //Delete Product
        if (request.getParameter("productIdToDelete") != null) {
                int productIdToDelete = Integer.parseInt(request.getParameter("productIdToDelete"));
        
                String deleteInventorySql = "DELETE FROM productinventory WHERE productId = ?";
                String deleteProductSql = "DELETE FROM product WHERE productId = ?";
        
                try {
                    getConnection();
                    PreparedStatement pstmtInventory = con.prepareStatement(deleteInventorySql);
                    pstmtInventory.setInt(1, productIdToDelete);
                    pstmtInventory.executeUpdate();
                    pstmtInventory.close();
        
                    PreparedStatement pstmtProduct = con.prepareStatement(deleteProductSql);
                    pstmtProduct.setInt(1, productIdToDelete);
                    int rowsAffected = pstmtProduct.executeUpdate();
        
                    if (rowsAffected > 0) {
                        out.println("Product deleted successfully.");
                    } else {
                        out.println("Failed to delete product. Product ID not found.");
                    }
                    pstmtProduct.close();
                } catch (SQLException ex) {
                    out.println("Error: " + ex.getMessage());
                } finally {
                    closeConnection();
                }
        }
        //Update Product
        if (request.getParameter("productIdToUpdate") != null) {
            int productIdToUpdate = Integer.parseInt(request.getParameter("productIdToUpdate"));
            String updatedProductName = request.getParameter("updatedProductName");
            double updatedProductPrice = Double.parseDouble(request.getParameter("updatedProductPrice"));
            String updatedProductDesc = request.getParameter("updatedProductDesc");
            int updatedCategoryId = Integer.parseInt(request.getParameter("updatedCategoryId"));

            String updateSql = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";

            try {
                getConnection();
                PreparedStatement pstmt = con.prepareStatement(updateSql);
                pstmt.setString(1, updatedProductName);
                pstmt.setDouble(2, updatedProductPrice);
                pstmt.setString(3, updatedProductDesc);
                pstmt.setInt(4, updatedCategoryId);
                pstmt.setInt(5, productIdToUpdate);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("Product updated successfully.");
                } else {
                    out.println("Failed to update product. Product ID not found.");
                }

                pstmt.close();
            } catch (SQLException ex) {
                out.println("Error: " + ex.getMessage());
            } finally {
                closeConnection();
            }   
        }
        // Add new warehouse
        if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("warehouseName") != null) {
            String newWarehouseName = request.getParameter("warehouseName");
            try {
                getConnection();
                String addWarehouseQuery = "INSERT INTO warehouse (warehouseName) VALUES (?)";
                PreparedStatement addWarehouseStmt = con.prepareStatement(addWarehouseQuery, Statement.RETURN_GENERATED_KEYS);
                addWarehouseStmt.setString(1, newWarehouseName);

                int rowsAffected = addWarehouseStmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("Warehouse added successfully.");

                    ResultSet generatedKeys = addWarehouseStmt.getGeneratedKeys();
                    int warehouseId = 0;
                    if (generatedKeys.next()) {
                        warehouseId = generatedKeys.getInt(1);

                        String updateProductInventoryQuery = "INSERT INTO productinventory (productId, warehouseId, quantity) " +
                                                            "SELECT productId, ?, 0 FROM product";
                        PreparedStatement updateProductInventoryStmt = con.prepareStatement(updateProductInventoryQuery);
                        updateProductInventoryStmt.setInt(1, warehouseId);

                        updateProductInventoryStmt.executeUpdate();
                    }

                    addWarehouseStmt.close();
                } else {
                    out.println("Failed to add warehouse.");
                }

            } catch (SQLException ex) {
                out.println("SQLException: " + ex.getMessage());
                ex.printStackTrace();
            } finally {
                closeConnection();
            }
        }
        // Edit Warehouse
        if (request.getMethod().equalsIgnoreCase("POST")) {
            if (request.getParameter("editWarehouseId") != null && request.getParameter("editedWarehouseName") != null) {
                int editWarehouseId = Integer.parseInt(request.getParameter("editWarehouseId"));
                String editedWarehouseName = request.getParameter("editedWarehouseName");
    
                String updateWarehouseSql = "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?";
    
                try {
                    getConnection();
                    PreparedStatement pstmt = con.prepareStatement(updateWarehouseSql);
                    pstmt.setString(1, editedWarehouseName);
                    pstmt.setInt(2, editWarehouseId);
    
                    int rowsAffected = pstmt.executeUpdate();
    
                    if (rowsAffected > 0) {
                        out.println("<script>alert('Warehouse updated successfully.');</script>");
                    } else {
                        out.println("<script>alert('Failed to update warehouse. Warehouse ID not found.');</script>");
                    }
    
                    pstmt.close();
                } catch (SQLException ex) {
                    out.println("Error: " + ex.getMessage());
                } finally {
                    closeConnection();
                }
            }
        }
    }
%>
</div>
<% 
    String restoreMessage = request.getParameter("restore");

    if ("success".equals(restoreMessage)) {
    %>
        <p style="color: green;">Database restore was successful.</p>
    <%
    }
    %>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
		$(document).ready(function() {
			// Always hide the "Admin Portal" link initially using inline CSS
			$('#adminPortalLink').css('display', 'none');
		
			// Check isAdmin status when the page loads
			checkAdminStatus();
		
			function checkAdminStatus() {
				// Make an Ajax request to a server-side script (e.g., checkAdminStatus.jsp)
				$.ajax({
					url: 'checkAdminStatus.jsp',
					type: 'GET',
					success: function(response) {
						// Check if the response contains "true" (case insensitive)
						var isAdmin = /true/i.test(response);
		
						// Log isAdmin value to the console
						console.log('isAdmin:', isAdmin);
		
						// Show the "Admin Portal" link only if isAdmin is true
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

    

