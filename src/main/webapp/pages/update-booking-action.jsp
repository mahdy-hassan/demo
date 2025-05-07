<%@ page import="com.car.tuneshift.models.Booking" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Booking</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* Your styling */
  </style>
</head>
<body>
<nav class="navbar">
  <a href="../index.jsp" class="logo">TuneShift</a>
  <div class="nav-links">
    <a href="../index.jsp" class="nav-link">Home</a>
    <a href="book-service.jsp" class="nav-link">New Booking</a>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link logout">Logout</a>
  </div>
</nav>

<div class="profile-container">
  <div class="profile-header">
    <h1>Edit Your Booking</h1>
  </div>

  <%
    // Get parameters from URL
    String username = request.getParameter("username");
    String carModel = request.getParameter("carModel");
    String serviceType = request.getParameter("serviceType");
    String date = request.getParameter("date");
    String time = request.getParameter("time");

    // Pre-fill the form with the existing booking details
  %>

  <form method="POST" action="update-booking-action.jsp">
    <input type="hidden" name="username" value="<%= username %>">
    <input type="hidden" name="oldCarModel" value="<%= carModel %>">
    <input type="hidden" name="oldServiceType" value="<%= serviceType %>">
    <input type="hidden" name="oldDate" value="<%= date %>">
    <input type="hidden" name="oldTime" value="<%= time %>">

    <label for="carModel">Car Model:</label>
    <input type="text" id="carModel" name="carModel" value="<%= carModel %>" required><br>

    <label for="serviceType">Service Type:</label>
    <input type="text" id="serviceType" name="serviceType" value="<%= serviceType %>" required><br>

    <label for="date">Date:</label>
    <input type="date" id="date" name="date" value="<%= date %>" required><br>

    <label for="time">Time:</label>
    <input type="time" id="time" name="time" value="<%= time %>" required><br>

    <button type="submit">Update Booking</button>
  </form>
</div>

</body>
</html>
