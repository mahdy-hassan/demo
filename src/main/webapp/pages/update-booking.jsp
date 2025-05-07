<%@ page import="com.car.tuneshift.models.Booking" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Step 1: Get the form parameters
  String originalUsername = request.getParameter("originalUsername");
  String originalDate = request.getParameter("originalDate");
  String originalTime = request.getParameter("originalTime");

  // New booking data
  String serviceType = request.getParameter("serviceType");
  String carModel = request.getParameter("carModel");
  String newDate = request.getParameter("date");
  String newTime = request.getParameter("time");

  // Define the path to the bookings file
  String dataDirPath = application.getRealPath("/data");
  String filePath = dataDirPath + File.separator + "bookings.txt";
  File bookingsFile = new File(filePath);

  // List to store all the bookings
  List<Booking> allBookings = new ArrayList<>();

  if (bookingsFile.exists()) {
    try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
      String line;
      while ((line = br.readLine()) != null) {
        Booking booking = Booking.fromFileString(line);
        if (booking != null) {
          // If the booking matches the original booking details, update it
          if (booking.getUsername().equals(originalUsername) &&
                  booking.getDate().equals(originalDate) &&
                  booking.getTime().equals(originalTime)) {
            booking.setServiceType(serviceType);
            booking.setCarModel(carModel);
            booking.setDate(newDate);
            booking.setTime(newTime);
          }
          allBookings.add(booking);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  // Step 2: Overwrite the bookings file with updated data
  try (BufferedWriter bw = new BufferedWriter(new FileWriter(bookingsFile))) {
    for (Booking booking : allBookings) {
      bw.write(booking.toFileString());
      bw.newLine();
    }
  } catch (IOException e) {
    e.printStackTrace();
  }

  // Redirect the user to the "My Bookings" page
  response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
%>
