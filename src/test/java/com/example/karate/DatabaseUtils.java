package com.example.karate;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Utility class for PostgreSQL database operations
 * This class provides methods to execute queries and validate database data
 */
public class DatabaseUtils {
    
    private static Connection connection;
    
    /**
     * Establishes a connection to PostgreSQL database
     * @param url Database URL (e.g., jdbc:postgresql://localhost:5432/testdb)
     * @param username Database username
     * @param password Database password
     * @return Connection object
     */
    public static Connection getConnection(String url, String username, String password) {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(url, username, password);
            }
            return connection;
        } catch (Exception e) {
            throw new RuntimeException("Failed to connect to database: " + e.getMessage(), e);
        }
    }
    
    /**
     * Executes a SELECT query and returns results as a List of Maps
     * @param query SQL SELECT query
     * @return List of Maps where each Map represents a row
     */
    public static List<Map<String, Object>> executeQuery(String query) {
        List<Map<String, Object>> results = new ArrayList<>();
        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnName(i);
                    Object value = rs.getObject(i);
                    row.put(columnName, value);
                }
                results.add(row);
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            throw new RuntimeException("Failed to execute query: " + e.getMessage(), e);
        }
        return results;
    }
    
    /**
     * Executes an UPDATE, INSERT, or DELETE query
     * @param query SQL DML query
     * @return Number of affected rows
     */
    public static int executeUpdate(String query) {
        try {
            Statement stmt = connection.createStatement();
            int rowsAffected = stmt.executeUpdate(query);
            stmt.close();
            return rowsAffected;
        } catch (Exception e) {
            throw new RuntimeException("Failed to execute update: " + e.getMessage(), e);
        }
    }
    
    /**
     * Closes the database connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to close connection: " + e.getMessage(), e);
        }
    }
    
    /**
     * Validates that a query returns exactly one row
     * @param query SQL SELECT query
     * @return Map representing the single row
     */
    public static Map<String, Object> getSingleRow(String query) {
        List<Map<String, Object>> results = executeQuery(query);
        if (results.isEmpty()) {
            throw new RuntimeException("Query returned no rows");
        }
        if (results.size() > 1) {
            throw new RuntimeException("Query returned more than one row");
        }
        return results.get(0);
    }
    
    /**
     * Validates that a query returns a specific number of rows
     * @param query SQL SELECT query
     * @param expectedCount Expected number of rows
     * @return true if count matches, throws exception otherwise
     */
    public static boolean validateRowCount(String query, int expectedCount) {
        List<Map<String, Object>> results = executeQuery(query);
        if (results.size() != expectedCount) {
            throw new RuntimeException("Expected " + expectedCount + " rows but got " + results.size());
        }
        return true;
    }
}

