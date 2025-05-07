<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    return;
  }

  String error = request.getParameter("error");
  if (error != null) {
%>
<p style="color:red;">Error: <%= error %></p>
<%
  }
%>
 
<h1>Add a New Car</h1>
 
<form action="<%= request.getContextPath() %>/AddCarServlet" method="post">
  <label>Car Model:</label>
  <input type="text" name="carModel" required><br><br>

  <label>Year:</label>
  <input type="number" name="year" required><br><br>

  <label>License Plate:</label>
  <input type="text" name="licensePlate" required><br><br>

  <input type="submit" value="Add Car">
</form>
 
<br>
<a href="<%= request.getContextPath() %>/pages/my-cars.jsp">Back to My Cars</a>
