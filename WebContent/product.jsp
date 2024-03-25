<%@ page import="java.sql.*,java.net.URLEncoder,java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat,java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 0;
            color: #333;
        }
        header, .product-content {
            background-color: #fff;
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
         display: flex;
         justify-content: space-between;
        }

        .product-container {
        flex: 0 0 75%;
        padding: 20px;
        }

        .related-products-container {
        flex: 0 0 15%;
        padding: 20px; 
        }

        .related-products-container h2 {
        font-size: 16px;
        text-align: center; 
        padding-right: 0px; 
        margin-right: 0px; 
        }

        .related-products {
        display: flex;
        flex-direction: column;
        gap: 10px;
         }
        .product-header h1 {
            color: #333;
            font-size: 32px;
            font-weight: 600;
            text-align: center;
        }
        .product-image-container {
            text-align: center;
        }
        .product-image {
            max-width: 80%;
            height: auto;
            border-radius: 8px;
        }
        .product-details {
            padding: 20px;
        }
        .product-desc {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .action-buttons {
            display: flex;
            justify-content: start;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }
        .action-buttons a {
            text-decoration: none;
            display: inline-block;
            padding: 10px 20px;
            color: #fff;
            background-color: #000;
            text-align: center;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .action-buttons a:hover {
            background-color: #555;
        }
        .size-select {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
            margin-right: 15px;
        }
        .link-button, .continue-shopping {
            background-color: #000;
            color: #fff;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            display: inline-block;
            margin: 10px 5px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .link-button:hover, .continue-shopping:hover {
            background-color: #333;
        }

        .related-product {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .related-product img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
        .related-product-name {
            font-weight: bold;
            margin: 10px 0;
            text-align: center;
        }

        /* Add styles for reviews */
        .product-reviews {
            margin-top: 20px;
            padding: 20px;
            background-color: #f7f7f7;
            border-radius: 8px;
        }
        .product-review {
            border-bottom: 1px solid #ddd;
            padding: 10px 0;
        }
        .add-review-form {
            margin-top: 20px;
            padding: 20px;
            background-color: #f7f7f7;
            border-radius: 8px;
        }
        .add-review-form h2 {
            margin-bottom: 10px;
        }
        .add-review-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .add-review-form input[type="submit"] {
            padding: 10px 20px;
            background-color: #000;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .add-review-form input[type="submit"]:hover {
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

    <div class="container">
        <% 
        String productId = request.getParameter("id");
        String errorMessage = request.getParameter("error"); // Retrieve the error parameter
        String sql = "SELECT productId, productName, productImage, productImageURL, productPrice, productDesc, CategoryName FROM product JOIN category ON product.categoryId = category.categoryId WHERE productId = ?";
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
            PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, productId);
            ResultSet rst = pst.executeQuery();
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            if (rst.next()) {
                %>
                <div class="product-container">
                    <div class="product-image-container">
                        <img src="<%= rst.getString("productImageURL") %>" alt="<%= rst.getString("productName") %>" class="product-image">
                    </div>
                    <div class="product-details">
                        <h1><%= rst.getString("productName") %></h1>
                        <div class="product-price">Price: <%= currFormat.format(rst.getDouble("productPrice")) %></div>
                        <div class="product-desc"><%= rst.getString("productDesc") %></div>
                        <div class="action-buttons">
                            <select class="size-select">
                                <option>Select Size</option>
                                <option value="7.0">Size 7</option>
                                <option value="7.5">Size 7.5</option>
                                <option value="8.0">Size 8</option>
                                <option value="8.5">Size 8.5</option>
                                <option value="9.0">Size 9</option>
                                <option value="9.5">Size 9.5</option>
                                <option value="10.0">Size 10</option>
                                <option value="10.5">Size 10.5</option>
                                <option value="11.0">Size 11</option>
                                <option value="11.5">Size 11.5</option>
                                <option value="12.0">Size 12</option>
                                <option value="12.5">Size 12.5</option>
                                <option value="13.0">Size 13</option>
                            </select>
                            
                            <a href='addcart.jsp?id=<%= rst.getString("productId") %>&name=<%= rst.getString("productName") %>&quantity=1&price=<%= rst.getDouble("productPrice") %>' class="link-button">Add to Bag</a>
                        </div>
                    </div>
                    <div class="product-inventory">
                        <h2>Product Inventory</h2>
                        <%
                        String sql1 = "SELECT pi.warehouseId, w.warehouseName, pi.quantity " +
                                            "FROM productinventory pi " +
                                            "JOIN warehouse w ON pi.warehouseId = w.warehouseId " +
                                            "WHERE pi.productId = ?";
                        try (PreparedStatement stmt1 = con.prepareStatement(sql1)) {
                            stmt1.setInt(1, Integer.parseInt(productId));
                            ResultSet rst1 = stmt1.executeQuery();

                            while (rst1.next()) {
                        %>
                        <div class="inventory-item" data-warehouse-id="<%= rst1.getInt("warehouseId") %>">
                            <strong>Warehouse: <%= rst1.getString("warehouseName") %></strong><br>
                                    Quantity: <%= rst1.getInt("quantity") %><br>
                                </div>
                        <%
                            }
                        } catch (SQLException ex) {
                            out.println("SQLException: " + ex.getMessage());
                            ex.printStackTrace();
                        }
                        %>
                    </div>
                    <div class="product-reviews">
                        <h2>Product Reviews</h2>
                        <% 

                        if ("reviewexists".equals(errorMessage)) {
                        %>
                            <p style="color: red;">You have already left a review for this product.</p>
                        <%
                        } else if ("notbought".equals(errorMessage)) {
                        %>
                            <p style="color: red;">You haven't bought this product, so you cannot leave a review.</p>
                        <%
                        }

                        String sql2 = "SELECT userid, reviewComment FROM review r JOIN customer c ON r.customerId = c.customerId WHERE productId = ?";
                        try (PreparedStatement stmt2 = con.prepareStatement(sql2)) {
                            stmt2.setInt(1, Integer.parseInt(productId));
                            ResultSet rst2 = stmt2.executeQuery();

                            while (rst2.next()) {
                        %>
                                <div class="product-review">
                                    <strong><%= rst2.getString("userid") %>:</strong>
                                    <%= rst2.getString("reviewComment") %>
                                </div>
                        <%
                            }
                        } catch (SQLException ex) {
                            out.println("SQLException: " + ex.getMessage());
                            ex.printStackTrace();
                        }
                        %>
                    </div>
                    <!--Review form-->
                    <div class="add-review-form">
                        <h2>Add a Review</h2>
                        <% if (session.getAttribute("authenticatedUser") != null) { %>
                            <form action="addReview.jsp" method="post">
                                <input type="hidden" name="productId" value="<%= productId %>">
                                <textarea name="reviewText" rows="4" placeholder="Write your review..." required></textarea>
                                <input type="submit" value="Submit Review">
                            </form>
                        <% } else { %>
                            <p>Please <a href="login.jsp">login</a> to leave a review.</p>
                        <% } %>
                    </div>
                </div>
                <!--Related products-->
                <div class="related-products-container">
                    <h2>Related Products by <%= rst.getString("categoryName") %></h2>
                    <div class="related-products">
                        <%
                        String sql3 = "SELECT productId, productName, productImageURL, productPrice FROM product WHERE categoryId = (SELECT categoryId FROM product WHERE productId = ?)";
                        try (PreparedStatement stmt3 = con.prepareStatement(sql3)) {
                            stmt3.setString(1, productId);
                            ResultSet rst3 = stmt3.executeQuery();
                    
                            while (rst3.next()) {
                        %>
                            <div class="related-product">
                                <a href='product.jsp?id=<%= rst3.getString("productId") %>'>
                                    <img src="<%= rst3.getString("productImageURL") %>" alt="<%= rst3.getString("productName") %>">
                                </a>
                                <div class="related-product-name"><%= rst3.getString("productName") %></div>
                                <div class="related-product-price">Price: <%= currFormat.format(rst3.getDouble("productPrice")) %></div>
                            </div>
                        <%
                            }
                        } catch (SQLException ex) {
                            out.println("SQLException: " + ex.getMessage());
                            ex.printStackTrace();
                        }
                        %>
                    </div>
                </div>
                <%
            }
        } catch (SQLException e) {
            out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
        }
        %>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
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
        
                            $('.product-inventory .inventory-item').each(function() {
                                console.log('Current inventory item:', this);
        
                                var warehouseId = $(this).data('warehouse-id');
                                var currentQuantity = $(this).find('.quantity').text();
                                console.log('Warehouse ID:', warehouseId);
        
                                var updateQuantityForm = $('<form>', {
                                    action: 'updateQuantity.jsp',
                                    method: 'post'
                                });
        
                                $('<input>').attr({
                                    type: 'hidden',
                                    name: 'warehouseId',
                                    value: warehouseId
                                }).appendTo(updateQuantityForm);
        
                                $('<input>').attr({
                                    type: 'hidden',
                                    name: 'productId',
                                    value: '<%= productId %>'
                                }).appendTo(updateQuantityForm);
        
                                $('<input>', {
                                    type: 'number',
                                    name: 'newQuantity',
                                    placeholder: 'Enter new quantity',
                                    class: 'size-select'
                                }).appendTo(updateQuantityForm);
        

                                $('<input>', {
                                    type: 'submit',
                                    value: 'Update Quantity',
                                    class: 'link-button'
                                }).appendTo(updateQuantityForm);
        

                                $(this).append(updateQuantityForm);
        

                                updateQuantityForm.on('submit', function(e) {
                                    e.preventDefault();
                                    var formData = $(this).serialize();

                                    $.ajax({
                                        url: 'updateQuantity.jsp',
                                        type: 'POST',
                                        data: formData,
                                        success: function(response) {

                                            console.log('Update Quantity Response:', response);
                                            location.reload();
                                        },
                                        error: function(error) {
                                            console.error('Error updating quantity:', error);
                                        }
                                    });
                                });
                            });
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
