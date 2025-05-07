<%@ page import="com.car.tuneshift.models.Booking" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Booking</title>
</head>
<body>

<h1>Edit Booking</h1>

<%
    String method = request.getMethod();

    if ("POST".equalsIgnoreCase(method)) {
        // --- PROCESS BOOKING UPDATE ---

        String originalUsername = request.getParameter("originalUsername");
        String originalDate = request.getParameter("originalDate");
        String originalTime = request.getParameter("originalTime");

        String updatedServiceType = request.getParameter("serviceType");
        String updatedCarModel = request.getParameter("carModel");
        String updatedVehicleYear = request.getParameter("vehicleYear");
        String updatedLicensePlate = request.getParameter("licensePlate");
        String updatedDate = request.getParameter("date");
        String updatedTime = request.getParameter("time");

        String dataDirPath = application.getRealPath("/data");
        String filePath = dataDirPath + File.separator + "bookings.txt";
        File bookingsFile = new File(filePath);

        List<Booking> updatedBookings = new ArrayList<>();

        if (bookingsFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    Booking booking = Booking.fromFileString(line);
                    if (booking != null) {
                        if (booking.getUsername().equals(originalUsername) &&
                                booking.getDate().equals(originalDate) &&
                                booking.getTime().equals(originalTime)) {

                            // Update fields
                            booking.setServiceType(updatedServiceType);
                            booking.setCarModel(updatedCarModel);
                            booking.setVehicleYear(updatedVehicleYear);
                            booking.setLicensePlate(updatedLicensePlate);
                            booking.setDate(updatedDate);
                            booking.setTime(updatedTime);
                        }
                        updatedBookings.add(booking);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Rewrite updated data
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(bookingsFile))) {
            for (Booking b : updatedBookings) {
                bw.write(b.toFileString());
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
        return; // Stop further rendering
    }
%>

<%
    // GET Request: Load form with existing data
    String username = request.getParameter("username");
    String date = request.getParameter("date");
    String time = request.getParameter("time");

    if (username == null || date == null || time == null) {
%>
<p>Invalid booking details provided.</p>
<%
} else {
    String dataDirPath = application.getRealPath("/data");
    String filePath = dataDirPath + File.separator + "bookings.txt";
    File bookingsFile = new File(filePath);

    Booking targetBooking = null;

    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                Booking booking = Booking.fromFileString(line);
                if (booking != null &&
                        booking.getUsername().equals(username) &&
                        booking.getDate().equals(date) &&
                        booking.getTime().equals(time)) {

                    targetBooking = booking;
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    if (targetBooking == null) {
%>
<p>Booking not found.</p>
<%
} else {
%>

<form method="post" action="">
    <input type="hidden" name="originalUsername" value="<%= username %>">
    <input type="hidden" name="originalDate" value="<%= date %>">
    <input type="hidden" name="originalTime" value="<%= time %>">

    <label>Service Type:</label><br>
    <select name="serviceType" required>
        <option value="Regular Maintenance" <%= targetBooking.getServiceType().equals("Regular Maintenance") ? "selected" : "" %>>Regular Maintenance</option>
        <option value="Engine Repair" <%= targetBooking.getServiceType().equals("Engine Repair") ? "selected" : "" %>>Engine Repair</option>
        <option value="Electrical Systems" <%= targetBooking.getServiceType().equals("Electrical Systems") ? "selected" : "" %>>Electrical Systems</option>
        <option value="Car Wash and Detailing" <%= targetBooking.getServiceType().equals("Car Wash and Detailing") ? "selected" : "" %>>Car Wash and Detailing</option>
    </select><br><br>

    <label>Car Model:</label><br>
    <input type="text" name="carModel" value="<%= targetBooking.getCarModel() %>" required><br><br>

    <label>Vehicle Year:</label><br>
    <input type="text" name="vehicleYear" value="<%= targetBooking.getVehicleYear() %>" required><br><br>

    <label>License Plate:</label><br>
    <input type="text" name="licensePlate" value="<%= targetBooking.getLicensePlate() %>" required><br><br>

    <label>Date:</label><br>
    <input type="date" name="date" value="<%= targetBooking.getDate() %>" required><br><br>

    <label>Time:</label><br>
    <input type="time" name="time" value="<%= targetBooking.getTime() %>" required><br><br>

    <input type="submit" value="Update Booking">
</form>

<%
        }
    }
%>

</body>
</html>
