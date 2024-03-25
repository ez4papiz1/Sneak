<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<html>
<body>
	<table border="1">
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Price</th>
			<th>Quantity</th>
		</tr>
		<%
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
		if (productList == null) {
			productList = new HashMap<String, ArrayList<Object>>();
		}
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String price = request.getParameter("price");
		Integer quantity = new Integer(1);
		ArrayList<Object> product = new ArrayList<Object>();
		product.add(id);
		product.add(name);
		product.add(price);
		product.add(quantity);
		if (productList.containsKey(id)) {
			product = (ArrayList<Object>) productList.get(id);
			int curAmount = ((Integer) product.get(3)).intValue();
			product.set(3, new Integer(curAmount+1));
		} else {
			productList.put(id, product);
		}
		session.setAttribute("productList", productList);
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			String productId = entry.getKey();
			ArrayList<Object> productDetails = entry.getValue();
		%>
			<tr>
				<td><%= productId %></td>
				<td><%= productDetails.get(1) %></td>
				<td><%= productDetails.get(2) %></td>
				<td><%= productDetails.get(3) %></td>
			</tr>
		<%
		}
		%>
	</table>
</body>
</html>
<jsp:forward page="showcart.jsp" />