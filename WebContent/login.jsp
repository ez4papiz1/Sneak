<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .login-container {
            width: 300px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h3 {
            text-align: center;
            color: #000;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        
		.register-button {
			width: 100%;
			padding: 10px;
			margin-top: 20px;
			background-color: #000;
			color: #fff;
			border: none;
			border-radius: 5px;
			cursor: pointer;
			text-decoration: none;
			text-align: center;
			font-family: 'Montserrat', sans-serif;
			font-size: 16px;
			box-sizing: border-box;
		}
		
		.register-button:hover {
			background-color: #333;
		}
		
    </style>
</head>
<body>

<div class="login-container">
    <h3>Login</h3>
    <% if (session.getAttribute("loginMessage") != null) { %>
        <p><%= session.getAttribute("loginMessage").toString() %></p>
    <% } %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="submit" name="Submit2" class="register-button" value="Log In">
		<a href="registration.jsp" class="register-button">Register</a>
    </form>
</div>


</body>
</html>