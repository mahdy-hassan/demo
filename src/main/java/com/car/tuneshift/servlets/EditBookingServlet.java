package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Booking;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {

    // Handle POST request to update the booking
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int index = Integer.parseInt(request.getParameter("index"));
        String carModel = request.getParameter("carModel");
        String serviceType = request.getParameter("serviceType");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        String dataDir = getServletContext().getRealPath("/data");
        File bookingsFile = new File(dataDir, "bookings.txt");
        List<Booking> bookings = new ArrayList<>();

        // Read all bookings from the file
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                Booking booking = Booking.fromFileString(line);
                if (booking != null) bookings.add(booking);
            }
        }

        // Check if the index is valid
        if (index < 0 || index >= bookings.size()) {
            request.setAttribute("errorMessage", "Booking not found or invalid index!");
            request.getRequestDispatcher("/pages/my-bookings.jsp").forward(request, response);
            return;
        }

        // Update the booking
        Booking oldBooking = bookings.get(index);
        bookings.set(index, new Booking(
                oldBooking.getUsername(),
                serviceType,
                carModel,
                oldBooking.getVehicleYear(),
                oldBooking.getLicensePlate(),
                date,
                time
        ));


        // Save the updated bookings list back to the file
        try (FileWriter fw = new FileWriter(bookingsFile)) {
            for (Booking b : bookings) {
                fw.write(b.toFileString() + "\n");
            }
        }

        // Redirect to my-bookings.jsp after updating
        response.sendRedirect("pages/my-bookings.jsp");
    }

    // Handle GET request to show the booking for editing
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int index = Integer.parseInt(request.getParameter("index"));
        String dataDir = getServletContext().getRealPath("/data");
        File bookingsFile = new File(dataDir, "bookings.txt");
        List<Booking> bookings = new ArrayList<>();

        // Read all bookings from the file
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                Booking booking = Booking.fromFileString(line);
                if (booking != null) bookings.add(booking);
            }
        }

        // Check if the index is valid
        if (index < 0 || index >= bookings.size()) {
            request.setAttribute("errorMessage", "Booking not found or invalid index!");
            request.getRequestDispatcher("/pages/my-bookings.jsp").forward(request, response);
            return;
        }

        // Set the bookings list and index as request attributes to pass to the JSP
        request.setAttribute("bookings", bookings);
        request.setAttribute("index", index);

        // Forward to the edit booking page
        request.getRequestDispatcher("/pages/edit-booking.jsp").forward(request, response);
    }
}
