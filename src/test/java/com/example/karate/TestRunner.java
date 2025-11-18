package com.example.karate;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.testng.annotations.Test;
import static org.testng.Assert.assertEquals;

public class TestRunner {
    
    @Test
    public void testApiScenarios() {
        Results results = Runner.path("classpath:api/api-scenarios.feature")
                .tags("@api")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testApiSchemaValidation() {
        Results results = Runner.path("classpath:api/api-schema-validation.feature")
                .tags("@api", "@schema")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testDatabaseValidation() {
        Results results = Runner.path("classpath:database/database-validation.feature")
                .tags("@database")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testDatabaseSchemaValidation() {
        Results results = Runner.path("classpath:database/database-schema-validation.feature")
                .tags("@database", "@schema")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testAll() {
        Results results = Runner.path("classpath:api", "classpath:database")
                .tags("~@ignore")
                .parallel(5);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    // Example: Run a single scenario by tag
    @Test
    public void testSingleScenario() {
        Results results = Runner.path("classpath:api/api-scenarios.feature")
                .tags("@getAllPosts")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    // Example: Run scenarios matching a specific tag combination
    @Test
    public void testScenarioByMultipleTags() {
        Results results = Runner.path("classpath:api/api-scenarios.feature")
                .tags("@api", "@single")  // Must match both tags
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testMastercardLocationsMatches() {
        Results results = Runner.path("classpath:api/mastercard-locations-matches.feature")
                .tags("@mastercard", "@locations", "@matches")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
    
    @Test
    public void testReltioEntities() {
        Results results = Runner.path("classpath:api/reltio-entities.feature")
                .tags("@reltio", "@entities")
                .parallel(1);
        assertEquals(results.getFailCount(), 0, results.getErrorMessages());
    }
}
