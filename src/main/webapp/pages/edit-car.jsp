<%@ page import="com.car.tuneshift.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Car</title>
  <style>
    form {
      max-width: 500px;
      margin: 40px auto;
      padding: 20px;
      border: 1px solid #ccc;
      border-radius: 8px;
    }

    label, input {
      display: block;
      width: 100%;
      margin-bottom: 15px;
    }

    input[type="submit"] {
      width: auto;
      background-color: #28a745;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    input[type="submit"]:hover {
      background-color: #218838;
    }
  </style>
</head>
<body>

<%
  // Redirect to login if user is not logged in
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    return;
  }

  // Retrieve car details from request parameters
  String oldCarModel = request.getParameter("carModel");
  String oldYear = request.getParameter("year");
  String oldLicensePlate = request.getParameter("licensePlate");

  if (oldCarModel == null || oldYear == null || oldLicensePlate == null) {
%>
<h2 style="text-align:center;color:red;">Invalid car data. Please go back and try again.</h2>
<div style="text-align:center;">
  <a href="<%= request.getContextPath() %>/pages/my-cars.jsp">Back to My Cars</a>
</div>
<%
    return;
  }
%>

<h2 style="text-align:center;">Edit Car</h2>

<form action="<%= request.getContextPath() %>/UpdateCarServlet" method="post">
  <!-- Hidden fields to track old values -->
  <input type="hidden" name="oldCarModel" value="<%= oldCarModel %>">
  <input type="hidden" name="oldYear" value="<%= oldYear %>">
  <input type="hidden" name="oldLicensePlate" value="<%= oldLicensePlate %>">

  <label for="carModel">Car Model:</label>
  <input type="text" id="carModel" name="carModel" value="<%= oldCarModel %>" required>

  <label for="year">Year:</label>
  <input type="text" id="year" name="year" value="<%= oldYear %>" required>

  <label for="licensePlate">License Plate:</label>
  <input type="text" id="licensePlate" name="licensePlate" value="<%= oldLicensePlate %>" required>

  <input type="submit" value="Update Car">
</form>

</body>
</html>
