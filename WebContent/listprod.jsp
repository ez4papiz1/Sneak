<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Sneak</title>
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

    h1 {
        text-align: center;
        font-size: 28px;
        color: #000;
        margin: 40px 0;
    }

	.hot-pick-tag {
    	display: inline-block;
    	background-color: #ff4500; 
    	color: white;
    	padding: 5px 10px;
    	border-radius: 5px;
    	font-weight: bold;
    	font-size: 0.9em;
    	position: absolute;
    	top: 10px; 
    	left: 10px; 
    	z-index: 1;
	}

	.product-box:hover .hot-pick-tag {
   		 background-color: #e63900; 
	}	

    .product-box {
		position: relative;
        background-color: #fff;
        border-radius: 8px;
        padding: 15px;
        margin: 15px;
        width: calc(25% - 30px);
        display: inline-block;
        vertical-align: top;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        transition: box-shadow 0.3s ease;
    }

    .product-box:hover {
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }

    .product-box img {
        width: 100%;
        height: auto;
        border-radius: 5px;
    }

    .product-name {
        font-size: 18px;
        margin: 10px 0;
    }

    .product-price {
        color: #e1a07a;
        font-weight: bold;
        font-size: 16px;
    }
	.product-sales {
            font-size: 14px;
            color: #666;
    }
	input[type="text"], select {
    font-size: 16px;
    color: #333;
	}

	input[type="submit"], input[type="reset"] {
    font-size: 16px;
    transition: background-color 0.3s ease;
	}

	input[type="submit"]:hover, input[type="reset"]:hover {
    background-color: #333;
	}


	@media (max-width: 768px) {
    form {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    input[type="text"], input[type="submit"], input[type="reset"], select {
        width: 100%;
        margin: 5px 0;
    }
	}


    a, a:hover {
        color: inherit;
    }

    @media (max-width: 1200px) {
        .product-box {
            width: calc(33.3333% - 30px);
        }
    }

    @media (max-width: 768px) {
        .product-box {
            width: calc(50% - 30px);
        }

        nav {
            flex-direction: column;
            align-items: flex-start;
        }
    }

    @media (max-width: 480px) {
        .product-box {
            width: calc(100% - 30px);
        }
    }
	p.search-results {
		text-align: center;
		font-size: 16px;
		color: #666;
		margin-bottom: 20px;
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

<h1>Discover the Latest Trends</h1>

<% String searchResult = request.getParameter("productName"); %>
    <% if (searchResult != null && !searchResult.isEmpty()) { %>
        <p class="search-results">Showing results for "<%= searchResult %>"</p>
    <% } %>
<!--Search, submit, reset forms-->
<form method="get" action="listprod.jsp" style="text-align: center; margin: 40px 0;">
    <input type="text" name="productName" size="50" placeholder="Search for products" style="padding: 10px; border-radius: 5px; border: 1px solid #ddd; margin-right: 10px;">
    <input type="submit" value="Submit" style="padding: 10px 20px; background-color: #000; color: #fff; border: none; border-radius: 5px; cursor: pointer;">
    <input type="reset" value="Reset" style="padding: 10px 20px; background-color: #e1a07a; color: #fff; border: none; border-radius: 5px; cursor: pointer; margin-left: 10px;" onclick="resetForm()">
    <br><br>
	<label for="sort" style="font-weight: bold;">Sort by:</label>
	<select name="sort" id="sort" style="padding: 10px; border-radius: 5px; border: 1px solid #ddd; margin-left: 10px;">
		<option value="" <%= ("".equals(request.getParameter("sort"))) ? "selected" : "" %>>Best Sellers</option> 
		<option value="name_asc" <%= ("name_asc".equals(request.getParameter("sort"))) ? "selected" : "" %>>Name (A-Z)</option>
		<option value="name_desc" <%= ("name_desc".equals(request.getParameter("sort"))) ? "selected" : "" %>>Name (Z-A)</option>
		<option value="price_asc" <%= ("price_asc".equals(request.getParameter("sort"))) ? "selected" : "" %>>Price (Low to High)</option>
		<option value="price_desc" <%= ("price_desc".equals(request.getParameter("sort"))) ? "selected" : "" %>>Price (High to Low)</option>
	</select>
	<!--Catefory form-->
	<label for="category" style="font-weight: bold;">Category:</label>
	<select name="category" id="category" style="padding: 10px; border-radius: 5px; border: 1px solid #ddd; margin-left: 10px;">
		<option value="" <%= ("".equals(request.getParameter("category"))) ? "selected" : "" %>>All Categories</option>
		<option value="1" <%= ("1".equals(request.getParameter("category"))) ? "selected" : "" %>>Nike</option>
		<option value="2" <%= ("2".equals(request.getParameter("category"))) ? "selected" : "" %>>Yeezy</option>
		<option value="3" <%= ("3".equals(request.getParameter("category"))) ? "selected" : "" %>>Off White</option>
		<option value="4" <%= ("4".equals(request.getParameter("category"))) ? "selected" : "" %>>Jordan</option>
		<option value="5" <%= ("5".equals(request.getParameter("category"))) ? "selected" : "" %>>New Balance</option>
	</select>	
</form>
<script>
    function resetForm() {
        window.location.href = "listprod.jsp";
    }
</script>

<div style="display: flex; flex-wrap: wrap; justify-content: center;">
	<!--Display the products based on the forms-->
	<%
	String name = request.getParameter("productName") != null ? request.getParameter("productName") : "";
	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    String sql = "SELECT p.productName, p.productId, p.productPrice, p.productImageURL, ISNULL(SUM(op.quantity), 0) as totalSold " +
             "FROM product p LEFT JOIN orderproduct op ON p.productId = op.productId " +
             "WHERE p.productName LIKE ? ";


	String catId = request.getParameter("category");
	if (catId != null && !catId.isEmpty()) {
		sql += "AND p.categoryId = ? ";
	}

	sql += "GROUP BY p.productName, p.productId, p.productPrice, p.productImageURL, p.categoryId ";

	if (catId != null && !catId.isEmpty()) {
		sql += "HAVING p.categoryId = ? ";
	}

	String sortBy = request.getParameter("sort");
	if (sortBy != null && !sortBy.isEmpty()) {
		sql += " ORDER BY " + (sortBy.equals("name_asc") ? "productName ASC" : sortBy.equals("name_desc") ? "productName DESC" : sortBy.equals("price_asc") ? "productPrice ASC" : "productPrice DESC");
	} else {
		sql += " ORDER BY totalSold DESC"; // Default sorting by total sales
	}
	
	try (Connection con = DriverManager.getConnection(url, uid, pw); PreparedStatement pstmt = con.prepareStatement(sql)) {
		pstmt.setString(1, "%" + name + "%");
		if (catId != null && !catId.isEmpty()) {
            int categoryId = Integer.parseInt(catId);
            pstmt.setInt(2, categoryId);
            pstmt.setInt(3, categoryId);
        }
		try (ResultSet rst = pstmt.executeQuery()) {
			while (rst.next()) {
				String productName = rst.getString("productName");
				int productId = rst.getInt("productId");
				double productPrice = rst.getDouble("productPrice");
				String imageurl = rst.getString("productImageURL");
				int totalSold = rst.getInt("totalSold"); // Sales quantity
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				
	%>
	<!--Displaying products-->
	<div class="product-box" onclick="window.location.href='product.jsp?id=<%= productId %>';">
		<% if (totalSold > 3) { %>
			<div class="hot-pick-tag">Hot Pick!</div>
		<% } %>
		<img src="<%= imageurl %>" alt="Product Image">
		<div class="product-name"><%= productName %></div>
		<div class="product-price"><%= currFormat.format(productPrice) %></div>
		<div class="product-sales">Sold: <%= totalSold %></div>
	</div>
	<%
			}
		}
	} catch (SQLException e) {
		out.println("SQLException: " + e);
	}
	%>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
	});
	</script>
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