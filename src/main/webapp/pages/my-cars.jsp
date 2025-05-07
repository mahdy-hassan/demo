<%@ page import="java.io.File, java.io.FileReader, java.io.BufferedReader, java.io.IOException" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.car.tuneshift.models.User, com.car.tuneshift.models.Car" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Cars</title>
  <style>
    :root {
      --primary: #FF6B35;
      --dark: #2A2A2A;
      --light: #F8F9FA;
      --border: #e0e0e0;
      --danger: #dc3545;
    }
    body {
      background: var(--light);
      color: var(--dark);
      padding-top: 60px;
      font-family: 'Poppins', sans-serif;
      margin: 0;
    }
    .container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 20px;
    }
    .section-title {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border);
    }
    .section-title h2 {
      font-size: 22px;
      font-weight: 700;
      color: var(--primary);
    }
    .btn {
      padding: 10px 20px;
      border-radius: 4px;
      text-decoration: none;
      color: white;
      font-weight: 500;
      border: none;
      cursor: pointer;
      background: var(--primary);
      transition: background 0.3s;
      font-size: 15px;
      margin-right: 10px;
      display: inline-block;
    }
    .btn:hover {
      background: #e65a2b;
    }
    .btn-danger {
      background: var(--danger);
    }
    .btn-danger:hover {
      background: #c82333;
    }
    .car-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
      margin-top: 30px;
    }
    .car-card {
      background: white;
      border: 1px solid var(--border);
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      padding: 0;
      overflow: hidden;
      transition: box-shadow 0.3s, transform 0.3s;
    }
    .car-card:hover {
      box-shadow: 0 8px 24px rgba(0,0,0,0.10);
      transform: translateY(-4px);
    }
    .car-header {
      background: var(--primary);
      color: white;
      padding: 18px;
      font-size: 20px;
      font-weight: 600;
      border-bottom: 1px solid var(--border);
    }
    .car-body {
      padding: 18px;
    }
    .car-info-item {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #eee;
      font-size: 15px;
    }
    .car-info-label {
      color: #666;
      font-weight: 500;
    }
    .car-info-value {
      font-weight: 600;
    }
    .car-actions {
      margin-top: 18px;
      display: flex;
      gap: 10px;
    }
    .empty-state {
      text-align: center;
      padding: 60px 0;
      color: #888;
    }
    .empty-state i {
      font-size: 48px;
      color: #ccc;
      margin-bottom: 15px;
    }
    .back-link {
      margin-bottom: 20px;
      display: inline-block;
    }
  </style>
</head>
<body>

<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    return;
  }

  String carsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\cars.txt";
  List<Car> userCars = new ArrayList<>();

  File carsFile = new File(carsFilePath);
  if (carsFile.exists()) {
    try (BufferedReader reader = new BufferedReader(new FileReader(carsFile))) {
      String line;
      while ((line = reader.readLine()) != null) {
        String[] parts = line.split("\\|");
        if (parts.length == 4 && parts[0].equals(user.getUsername())) {
          Car car = new Car(parts[0], parts[1], parts[2], parts[3]);
          userCars.add(car);
        }
      }
    } catch (IOException e) {
      e.printStackTrace();
      out.println("<p style='color:red;'>Error reading car data. Please try again later.</p>");
    }
  }
%>

<div class="container">
  <div class="back-link">
    <a href="<%= request.getContextPath() %>/pages/profile.jsp" class="btn" style="background: #6c757d;">&larr; Back to Profile</a>
  </div>
  <div class="section-title">
    <h2><i class="fas fa-car"></i> My Cars</h2>
    <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn">
      <i class="fas fa-plus"></i> Add New Car
    </a>
  </div>
  <% if (userCars.isEmpty()) { %>
    <div class="empty-state">
      <i class="fas fa-car"></i>
      <h3>You haven't added any cars yet</h3>
      <p>Add your car to book services and manage maintenance</p>
      <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn">
        Add Your First Car
      </a>
    </div>
  <% } else { %>
    <div class="car-grid">
      <% for (Car car : userCars) { %>
      <div class="car-card">
        <div class="car-header">
          <%= car.getModel() %>
        </div>
        <div class="car-body">
          <div class="car-info-item">
            <span class="car-info-label">Year</span>
            <span class="car-info-value"><%= car.getYear() %></span>
          </div>
          <div class="car-info-item">
            <span class="car-info-label">License Plate</span>
            <span class="car-info-value"><%= car.getPlateNumber() %></span>
          </div>
          <div class="car-actions">
            <a href="<%= request.getContextPath() %>/pages/edit-car.jsp?carModel=<%= URLEncoder.encode(car.getModel(), "UTF-8") %>&year=<%= URLEncoder.encode(car.getYear(), "UTF-8") %>&licensePlate=<%= URLEncoder.encode(car.getPlateNumber(), "UTF-8") %>" class="btn" style="background: #6c757d;">
              <i class="fas fa-edit"></i> Edit
            </a>
            <a href="<%= request.getContextPath() %>/pages/delete-car.jsp?model=<%= URLEncoder.encode(car.getModel(), "UTF-8") %>&year=<%= URLEncoder.encode(car.getYear(), "UTF-8") %>&plate=<%= URLEncoder.encode(car.getPlateNumber(), "UTF-8") %>" class="btn btn-danger">
              <i class="fas fa-trash"></i> Delete
            </a>
          </div>
        </div>
      </div>
      <% } %>
    </div>
  <% } %>
</div>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</body>
</html>