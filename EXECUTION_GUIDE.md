# Test Execution Guide

## Quick Start

### 1. Install Dependencies
```bash
mvn clean install -DskipTests
```

### 2. Run All API Tests
```bash
mvn test "-Dtest=TestRunner#testApiScenarios"
```

### 3. Run API Schema Validation Tests
```bash
mvn test "-Dtest=TestRunner#testApiSchemaValidation"
```

### 4. Run All Tests (API + Database)
```bash
mvn test "-Dtest=TestRunner#testAll"
```

## Test Execution Commands

### Run Specific Test Suite

**API Scenarios (Response Code Validation):**
```bash
mvn test "-Dtest=TestRunner#testApiScenarios"
```

**API Schema Validation:**
```bash
mvn test "-Dtest=TestRunner#testApiSchemaValidation"
```

**Database Validation:**
```bash
mvn test "-Dtest=TestRunner#testDatabaseValidation"
```
*Note: Requires PostgreSQL database connection configured in `config/db-config.js`*

**Database Schema Validation:**
```bash
mvn test "-Dtest=TestRunner#testDatabaseSchemaValidation"
```
*Note: Requires PostgreSQL database connection configured in `config/db-config.js`*

### Run All Tests
```bash
mvn test
```

### Run with TestNG XML
```bash
mvn test -Dsurefire.suiteXmlFiles=testng.xml
```

## View Test Reports

After running tests, view the HTML report:
```bash
open target/karate-reports/karate-summary.html
```

Or navigate to: `target/karate-reports/karate-summary.html` in your browser.

## Configuration

Before running tests, make sure to update:

1. **API Configuration** - `src/test/resources/config/api-config.js`
   - Update `baseUri` with your API URL
   - Update `apiToken`, `apiKey`, `username`, `password` as needed

2. **Database Configuration** - `src/test/resources/config/db-config.js`
   - Update database connection details
   - Only needed for database validation tests

## Current Test Status

✅ **API Scenarios** - All 10 scenarios passing
- GET, POST, PUT, PATCH, DELETE requests
- Response code validation (200, 201, 404)
- Response header validation
- Response time validation

⚠️ **API Schema Validation** - Some scenarios may need adjustment based on your API
- Schema validation for posts, users, comments
- Nested object validation
- Array validation

⚠️ **Database Tests** - Require database setup
- Configure PostgreSQL connection first
- Create required tables (users, posts)

## Troubleshooting

### Tests not running
- Ensure Maven dependencies are installed: `mvn clean install -DskipTests`
- Check Java version: `java -version` (should be 11+)

### API tests failing
- Verify API base URL in `config/api-config.js`
- Check if API is accessible
- Verify authentication credentials

### Database tests failing
- Ensure PostgreSQL is running
- Verify database credentials in `config/db-config.js`
- Check if required tables exist

## Next Steps

1. Update API credentials in `config/api-config.js`
2. Run API scenarios: `mvn test "-Dtest=TestRunner#testApiScenarios"`
3. Review test reports in `target/karate-reports/`
4. Customize test scenarios in feature files as needed

