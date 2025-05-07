package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Booking;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.FileReader;


@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int index = Integer.parseInt(request.getParameter("index"));

        String dataDir = getServletContext().getRealPath("/data");
        File bookingsFile = new File(dataDir, "bookings.txt");
        List<Booking> bookings = new ArrayList<>();

        // Read all bookings
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                Booking booking = Booking.fromFileString(line);
                if(booking != null) bookings.add(booking);
            }
        }

        // Remove booking
        if(index >= 0 && index < bookings.size()) {
            bookings.remove(index);
        }

        // Save back to file
        try (FileWriter fw = new FileWriter(bookingsFile)) {
            for(Booking b : bookings) {
                fw.write(b.toFileString() + "\n");
            }
        }

        response.sendRedirect("my-bookings.jsp");
    }
}