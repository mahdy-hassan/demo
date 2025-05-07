<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="com.car.tuneshift.models.Car" %>
<%@ page import="com.car.tuneshift.models.Service" %>
<%@ page import="com.car.tuneshift.utils.ServiceUtil" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Service</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f6fa;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        select, input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            font-size: 16px;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .service-info {
            margin-top: 10px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            border-left: 4px solid #3498db;
        }

        .price {
            color: #27ae60;
            font-weight: bold;
            font-size: 18px;
        }

        .duration {
            color: #7f8c8d;
            margin-top: 5px;
        }

        .description {
            color: #34495e;
            margin-top: 10px;
            line-height: 1.5;
        }

        .no-cars-message {
            text-align: center;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .nav-links {
            margin-top: 20px;
            text-align: center;
        }

        .nav-links a {
            margin: 0 10px;
            text-decoration: none;
            color: #3498db;
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

    // Get user's cars
    List<Car> userCars = new ArrayList<>();
    String carsFilePath = System.getProperty("user.home") + "/Desktop/tuneshift/data/cars.txt";
    File carsFile = new File(carsFilePath);

    if (carsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 4 && parts[0].equals(user.getUsername())) {
                    userCars.add(new Car(parts[0], parts[1], parts[2], parts[3]));
                }
            }
        }
    }

    // Get available services
    List<Service> services = ServiceUtil.getAllServices();
%>

<div class="container">
    <h1>Book a Service</h1>

    <% if (userCars.isEmpty()) { %>
        <div class="no-cars-message">
            <p>You need to add a car before booking a service.</p>
            <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary">Add Car</a>
        </div>
    <% } else { %>
        <form action="<%= request.getContextPath() %>/BookServiceServlet" method="post">
            <div class="form-group">
                <label for="carId">Select Your Car:</label>
                <select id="carId" name="carId" required>
                    <% for (Car car : userCars) { %>
                        <option value="<%= car.getModel() %>|<%= car.getYear() %>|<%= car.getPlateNumber() %>">
                            <%= car.getModel() %> (<%= car.getYear() %>) - <%= car.getPlateNumber() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label for="serviceId">Select Service:</label>
                <select id="serviceId" name="serviceId" required onchange="updateServiceInfo()">
                    <option value="">Select a service</option>
                    <% for (Service service : services) { %>
                        <option value="<%= service.getServiceId() %>" 
                                data-price="<%
                                    try {
                                        double price = Double.parseDouble(String.valueOf(service.getPrice()));
                                        out.print(String.format("%.2f$", price));
                                    } catch (Exception e) {
                                        out.print(service.getPrice() + "$" );
                                    }
                                %>"
                                data-duration="<%= service.getDuration() %>"
                                data-description="<%= service.getDescription() %>">
                            <%= service.getServiceName() %> - <%
                                try {
                                    double price = Double.parseDouble(String.valueOf(service.getPrice()));
                                    out.print(String.format("%.2f$", price));
                                } catch (Exception e) {
                                    out.print(service.getPrice() + "$" );
                                }
                            %>
                        </option>
                    <% } %>
                </select>
                <div id="serviceInfo" class="service-info" style="display: none;">
                    <div class="price">Price: $<span id="selectedPrice">0.00</span></div>
                    <div class="duration">Duration: <span id="selectedDuration">0</span> minutes</div>
                    <div class="description" id="selectedDescription"></div>
                </div>
            </div>

            <div class="form-group">
                <label for="date">Date:</label>
                <input type="date" id="date" name="date" required>
            </div>

            <div class="form-group">
                <label for="time">Time:</label>
                <input type="time" id="time" name="time" required>
            </div>

            <button type="submit" class="btn btn-primary">Book Service</button>
        </form>
    <% } %>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/services.jsp">View All Services</a>
        <a href="<%= request.getContextPath() %>/pages/profile.jsp">Back to Profile</a>
    </div>
</div>

<script>
    function updateServiceInfo() {
        const select = document.getElementById('serviceId');
        const serviceInfo = document.getElementById('serviceInfo');
        const selectedPrice = document.getElementById('selectedPrice');
        const selectedDuration = document.getElementById('selectedDuration');
        const selectedDescription = document.getElementById('selectedDescription');
        
        const selectedOption = select.options[select.selectedIndex];
        if (selectedOption.value) {
            serviceInfo.style.display = 'block';
            selectedPrice.textContent = selectedOption.getAttribute('data-price');
            selectedDuration.textContent = selectedOption.getAttribute('data-duration');
            selectedDescription.textContent = selectedOption.getAttribute('data-description');
        } else {
            serviceInfo.style.display = 'none';
        }
    }

    // Set minimum date to today
    document.getElementById('date').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>