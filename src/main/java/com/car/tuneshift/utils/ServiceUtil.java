package com.car.tuneshift.utils;

import com.car.tuneshift.models.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ServiceUtil {
    private static final Logger logger = Logger.getLogger(ServiceUtil.class.getName());
    private static final String FILE_PATH = System.getProperty("user.home") + "/Desktop/tuneshift/data/services.txt";

    // Read all services from file
    public static List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        File file = new File(FILE_PATH);

        try {
            // Create directory and file if they don't exist
            file.getParentFile().mkdirs();
            if (!file.exists()) {
                file.createNewFile();
                logger.info("Created new services file at: " + FILE_PATH);
                return services; // Return empty list for new file
            }

            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    try {
                        String[] parts = line.split("\\|");
                        if (parts.length == 5) {
                            Service service = new Service(
                                    parts[0],  // serviceId
                                    parts[1],  // serviceName
                                    parts[2],  // description
                                    Double.parseDouble(parts[3]),  // price
                                    Integer.parseInt(parts[4])     // duration
                            );
                            services.add(service);
                        } else {
                            logger.warning("Invalid service data format: " + line);
                        }
                    } catch (NumberFormatException e) {
                        logger.warning("Error parsing service data: " + line + " - " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            logger.severe("Error reading services file: " + e.getMessage());
            throw new RuntimeException("Failed to read services file", e);
        }

        return services;
    }

    // Get a specific service by ID
    public static Service getServiceById(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Service ID cannot be null or empty");
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 5 && parts[0].equals(id)) {
                    return new Service(
                            parts[0],  // serviceId
                            parts[1],  // serviceName
                            parts[2],  // description
                            Double.parseDouble(parts[3]),  // price
                            Integer.parseInt(parts[4])     // duration
                    );
                }
            }
        } catch (IOException e) {
            logger.severe("Error reading service by ID: " + e.getMessage());
            throw new RuntimeException("Failed to read service by ID", e);
        }

        return null;
    }

    // Save a new service to file
    public static void saveService(Service service) {
        if (service == null) {
            throw new IllegalArgumentException("Service cannot be null");
        }

        File file = new File(FILE_PATH);
        try {
            file.getParentFile().mkdirs();
            if (!file.exists()) {
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
                writer.write(service.toFileString());
                writer.newLine();
                logger.info("Saved new service: " + service.getServiceName());
            }
        } catch (IOException e) {
            logger.severe("Error saving service: " + e.getMessage());
            throw new RuntimeException("Failed to save service", e);
        }
    }

    // Update an existing service
    public static void updateService(Service service) {
        if (service == null) {
            throw new IllegalArgumentException("Service cannot be null");
        }

        List<Service> services = getAllServices();
        boolean found = false;
        
        for (int i = 0; i < services.size(); i++) {
            if (services.get(i).getServiceId().equals(service.getServiceId())) {
                services.set(i, service);
                found = true;
                break;
            }
        }

        if (!found) {
            throw new IllegalArgumentException("Service not found with ID: " + service.getServiceId());
        }

        // Write all services back to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Service s : services) {
                writer.write(s.toFileString());
                writer.newLine();
            }
            logger.info("Updated service: " + service.getServiceName());
        } catch (IOException e) {
            logger.severe("Error updating service: " + e.getMessage());
            throw new RuntimeException("Failed to update service", e);
        }
    }

    // Delete a service by ID
    public static void deleteService(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("Service ID cannot be null or empty");
        }

        List<Service> services = getAllServices();
        boolean removed = services.removeIf(service -> service.getServiceId().equals(id));

        if (!removed) {
            throw new IllegalArgumentException("Service not found with ID: " + id);
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Service service : services) {
                writer.write(service.toFileString());
                writer.newLine();
            }
            logger.info("Deleted service with ID: " + id);
        } catch (IOException e) {
            logger.severe("Error deleting service: " + e.getMessage());
            throw new RuntimeException("Failed to delete service", e);
        }
    }
}