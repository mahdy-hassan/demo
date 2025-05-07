<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .status-pending {
            color: orange;
            font-weight: bold;
        }

        .status-completed {
            color: green;
            font-weight: bold;
        }

        .status-cancelled {
            color: red;
            font-weight: bold;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .no-bookings {
            text-align: center;
            margin: 40px 0;
            color: #666;
        }

        .nav-links {
            margin-top: 20px;
            text-align: center;
        }

        a.button {
            display: inline-block;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
        }

        a.button:hover {
            background-color: #0056b3;
        }

        a.cancel-button {
            display: inline-block;
            padding: 5px 10px;
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.8em;
        }

        a.cancel-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // Display success message if available
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        out.println("<div class='success-message'>" + successMessage + "</div>");
        session.removeAttribute("successMessage");
    }

    // Display error message if available
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        out.println("<div class='error-message'>" + errorMessage + "</div>");
        session.removeAttribute("errorMessage");
    }

    // Class to store booking information
    class Booking {
        private String bookingId;
        private String carModel;
        private String carYear;
        private String carPlate;
        private String serviceType;
        private String servicePrice;
        private String serviceName;
        private String time;
        private String date;
        private String status;

        public Booking(String bookingId, String carModel, String carYear, String carPlate,
                       String serviceType, String servicePrice, String serviceName, String time, String date, String status) {
            this.bookingId = bookingId;
            this.carModel = carModel;
            this.carYear = carYear;
            this.carPlate = carPlate;
            this.serviceType = serviceType;
            this.servicePrice = servicePrice;
            this.serviceName = serviceName;
            this.time = time;
            this.date = date;
            this.status = status;
        }

        // Getters
        public String getBookingId() { return bookingId; }
        public String getCarModel() { return carModel; }
        public String getCarYear() { return carYear; }
        public String getCarPlate() { return carPlate; }
        public String getServiceType() { return serviceType; }
        public String getServicePrice() { return servicePrice; }
        public String getServiceName() { return serviceName; }
        public String getTime() { return time; }
        public String getDate() { return date; }
        public String getStatus() { return status; }
    }

    // Read bookings from file
    List<Booking> userBookings = new ArrayList<>();
    String filePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    File bookingsFile = new File(filePath);

    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 11 && parts[0].equals(user.getUsername())) {
                    userBookings.add(new Booking(
                            parts[1], // bookingId
                            parts[2], // carModel
                            parts[3], // carYear
                            parts[4], // carPlate
                            parts[5], // serviceType
                            parts[7], // servicePrice (was parts[6])
                            parts[6], // serviceName (was parts[7])
                            parts[8], // time
                            parts[9], // date
                            parts[10]  // status
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Sort bookings by date (newest first)
    Collections.sort(userBookings, new Comparator<Booking>() {
        @Override
        public int compare(Booking b1, Booking b2) {
            // First by status (Pending first, then Completed, then Cancelled)
            int statusCompare = getStatusPriority(b1.getStatus()) - getStatusPriority(b2.getStatus());
            if (statusCompare != 0) {
                return statusCompare;
            }

            // Then by date (latest first)
            return b2.getDate().compareTo(b1.getDate());
        }

        private int getStatusPriority(String status) {
            if ("Pending".equals(status)) return 0;
            if ("Completed".equals(status)) return 1;
            if ("Cancelled".equals(status)) return 2;
            return 3;
        }
    });
%>

<h1>My Service Bookings</h1>

<% if (userBookings.isEmpty()) { %>
<div class="no-bookings">
    <p>You have no service bookings yet.</p>
    <p><a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="button">Book a Service</a></p>
</div>
<% } else { %>
<table>
    <tr>
        <th>Booking ID</th>
        <th>Car</th>
        <th>Service Name</th>
        <th>Price</th>
        <th>Date</th>
        <th>Time</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    <% for (Booking booking : userBookings) { %>
    <tr>
        <td><%= booking.getBookingId() %></td>
        <td><%= booking.getCarModel() %> (<%= booking.getCarYear() %>) - <%= booking.getCarPlate() %></td>
        <td><%= booking.getServiceName() %></td>
        <td><%
            try {
                double price = Double.parseDouble(booking.getServicePrice());
                out.print(String.format("%.2f$", price));
            } catch (Exception e) {
                out.print(booking.getServicePrice() + "$" );
            }
        %></td>
        <td><%= booking.getDate() %></td>
        <td><%= booking.getTime() %></td>
        <td class="status-<%= booking.getStatus().toLowerCase() %>"><%= booking.getStatus() %></td>
        <td>
            <% if (booking.getStatus().equals("Pending")) { %>
            <a href="<%= request.getContextPath() %>/CancelBookingServlet?id=<%= booking.getBookingId() %>"
               class="cancel-button"
               onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel</a>
            <% } %>
        </td>
    </tr>
    <% } %>
</table>
<% } %>

<div class="nav-links">
    <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="button">Book a Service</a>
    <a href="<%= request.getContextPath() %>/pages/profile.jsp" class="button">Back to Profile</a>
</div>

</body>
</html>