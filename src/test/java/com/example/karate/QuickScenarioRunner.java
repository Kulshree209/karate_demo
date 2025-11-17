package com.example.karate;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.testng.annotations.Test;
import static org.testng.Assert.assertEquals;

/**
 * Quick Scenario Runner - Easy way to run individual scenarios
 * 
 * Usage:
 * 1. Change the tag variable to match your scenario tag
 * 2. Change the feature file path if needed
 * 3. Run the test method
 */
public class QuickScenarioRunner {
    
    /**
     * Quick test runner - Change the tag to run different scenarios
     * 
     * Steps:
     * 1. Add a unique tag to your scenario in the feature file (e.g., @myScenario)
     * 2. Change the 'tag' variable below to match your tag
     * 3. Run this test method
     */
    @Test
    public void runScenarioByTag() {
        // ============================================
        // CHANGE THESE VALUES TO RUN DIFFERENT SCENARIOS
        // ============================================
        String featureFile = "classpath:api/api-scenarios.feature";
        String tag = "@getAllPosts";  // Change this to your scenario tag
        
        // ============================================
        // Run the scenario
        // ============================================
        Results results = Runner.path(featureFile)
                .tags(tag)
                .parallel(1);
        
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    /**
     * Run scenario by name pattern
     * 
     * Change scenarioNamePattern to match part of your scenario name
     */
    @Test
    public void runScenarioByName() {
        // ============================================
        // CHANGE THESE VALUES
        // ============================================
        String featureFile = "classpath:api/api-scenarios.feature";
        String scenarioNamePattern = "GET request - Retrieve all posts";  // Part of scenario name
        
        // ============================================
        // Run the scenario
        // ============================================
        Results results = Runner.path(featureFile)
                .tags("@api")
                .scenarioName(scenarioNamePattern)
                .parallel(1);
        
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    /**
     * Run Mastercard API scenario
     */
    @Test
    public void runMastercardScenario() {
        String featureFile = "classpath:api/mastercard-locations-matches.feature";
        String tag = "@mastercard";  // Change to specific tag if needed
        
        Results results = Runner.path(featureFile)
                .tags(tag)
                .parallel(1);
        
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
}

