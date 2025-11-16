# Karate API Testing Project

This project is set up for API testing using Karate framework with PostgreSQL database validation capabilities. It uses **TestNG** as the test runner and includes comprehensive schema validation for both API responses and database structures.

## Project Structure

```
karate_project/
├── pom.xml                                    # Maven configuration
├── testng.xml                                 # TestNG configuration
├── src/
│   └── test/
│       ├── java/
│       │   └── com/example/karate/
│       │       ├── TestRunner.java           # TestNG test runner
│       │       └── DatabaseUtils.java        # Database utility class for PostgreSQL
│       └── resources/
│           ├── karate-config.js              # Karate configuration (loads from config files)
│           ├── config/
│           │   ├── api-config.feature        # API credentials and configuration
│           │   └── db-config.feature         # Database credentials and configuration
│           ├── api/
│           │   ├── api-scenarios.feature     # API test scenarios with response codes
│           │   └── api-schema-validation.feature # API schema validation scenarios
│           ├── database/
│           │   ├── database-validation.feature # Database data validation scenarios
│           │   └── database-schema-validation.feature # Database schema validation scenarios
│           ├── common/
│           │   └── common-utils.js           # Common utility functions
│           └── logback-test.xml              # Logging configuration
└── README.md
```

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- PostgreSQL database (for database validation tests)
- TestNG (included in dependencies)

## Setup Instructions

### 1. Install Dependencies

```bash
mvn clean install
```

### 2. Configure API Credentials

Edit `src/test/resources/config/api-config.js` and update with your API details:

```javascript
function fn() {
  return {
    baseUri: 'https://your-api-url.com',
    apiToken: 'your-api-token-here',
    apiKey: 'your-api-key-here',
    username: 'your-username',
    password: 'your-password',
    timeout: 30000
  };
}
```

### 3. Configure Database Connection

Edit `src/test/resources/config/db-config.js` and update with your database details:

```javascript
function fn() {
  return {
    dbUrl: 'jdbc:postgresql://localhost:5432/your_database',
    dbUsername: 'your_username',
    dbPassword: 'your_password',
    dbHost: 'localhost',
    dbPort: '5432',
    dbName: 'your_database'
  };
}
```

**Note:** The configuration files (`api-config.js` and `db-config.js`) are loaded automatically by `karate-config.js`. All credentials and connection details should be updated in these JavaScript config files. The corresponding `.feature` files are optional and can be used in test scenarios if needed.

### 4. Set Up Database Schema (Example)

You may need to create tables in your PostgreSQL database. Example schema:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    status VARCHAR(50),
    role VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Running Tests

### Run All Tests

```bash
mvn test
```

### Run Using TestNG XML

```bash
mvn test -Dsurefire.suiteXmlFiles=testng.xml
```

### Run Specific Test Suite

```bash
# Run only API scenarios
mvn test -Dtest=TestRunner#testApiScenarios

# Run only API schema validation
mvn test -Dtest=TestRunner#testApiSchemaValidation

# Run only database validation
mvn test -Dtest=TestRunner#testDatabaseValidation

# Run only database schema validation
mvn test -Dtest=TestRunner#testDatabaseSchemaValidation
```

### Run with Specific Environment

```bash
# Run with dev environment (default)
mvn test -Dkarate.env=dev

# Run with staging environment
mvn test -Dkarate.env=staging

# Run with production environment
mvn test -Dkarate.env=prod
```

### Run Specific Feature File

```bash
mvn test -Dtest=TestRunner#testApiScenarios
```

## Test Scenarios

### 1. API Scenarios (`api-scenarios.feature`)

The API scenarios include:
- GET requests with 200 OK validation
- POST requests with 201 Created validation
- PUT/PATCH requests with 200 OK validation
- DELETE requests with 200 OK validation
- Error scenarios (404 Not Found)
- Response header validation
- Response time validation
- Response data structure validation

**Tags:** `@api`, `@scenarios`

### 2. API Schema Validation (`api-schema-validation.feature`)

The API schema validation scenarios include:
- Complete response schema validation
- Nested object schema validation
- Array of objects schema validation
- Data type validation (number, string, boolean)
- Optional fields validation
- Regex pattern validation for fields (e.g., email)
- Null value handling
- Schema validation for different endpoints

**Tags:** `@api`, `@schema`

### 3. Database Validation (`database-validation.feature`)

The database validation scenarios include:
- Validating record existence
- Validating record counts
- Validating data integrity
- Comparing API response with database records
- Validating field values
- Data integrity constraint validation
- Multiple record validation

**Tags:** `@database`, `@validation`

### 4. Database Schema Validation (`database-schema-validation.feature`)

The database schema validation scenarios include:
- Table existence validation
- Column structure validation
- Data type validation for columns
- Primary key constraint validation
- Foreign key constraint validation
- NOT NULL constraint validation
- Unique constraint validation
- Index validation
- Default value validation
- Check constraint validation
- Sequence validation (for auto-increment)
- Multi-table schema validation

**Tags:** `@database`, `@schema`

## Writing Custom Tests

### API Test Example

```gherkin
Scenario: Custom API test
  Given url baseUrl
  And path 'your-endpoint'
  And header Authorization = authHeader
  When method GET
  Then status 200
  And match response.yourField == 'expectedValue'
```

### API Schema Validation Example

```gherkin
Scenario: Validate response schema
  Given url baseUrl
  And path 'your-endpoint'
  When method GET
  Then status 200
  And match response == 
  """
  {
    "id": "#number",
    "name": "#string",
    "email": "#regex [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
  }
  """
```

### Database Test Example

```gherkin
Scenario: Custom database validation
  Given def query = "SELECT * FROM your_table WHERE id = 1"
  When def result = DatabaseUtils.getSingleRow(query)
  Then match result.id == 1
  And match result.yourField == 'expectedValue'
```

### Database Schema Validation Example

```gherkin
Scenario: Validate table schema
  Given def query = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'your_table'"
  When def schema = DatabaseUtils.executeQuery(query)
  Then match schema != null
  And def columnNames = $schema[*].column_name
  And match columnNames contains 'id'
  And match columnNames contains 'name'
```

## Configuration Files

### API Configuration (`config/api-config.js`)

This JavaScript file contains all API-related configuration:
- `baseUri` - Base URL of the API
- `apiToken` - API authentication token
- `apiKey` - API key (if required)
- `username` - Username for authentication
- `password` - Password for authentication
- `timeout` - Request timeout in milliseconds

The `authHeader` is automatically generated as `'Bearer ' + apiToken` in `karate-config.js`.

### Database Configuration (`config/db-config.js`)

This JavaScript file contains all database-related configuration:
- `dbUrl` - Complete JDBC connection URL
- `dbUsername` - Database username
- `dbPassword` - Database password
- `dbHost` - Database host
- `dbPort` - Database port
- `dbName` - Database name

**Important:** Always update credentials in these JavaScript config files (`api-config.js` and `db-config.js`), not in `karate-config.js`. The corresponding `.feature` files are optional and can be used in test scenarios if you need to load config within a feature file.

## Database Utility Methods

The `DatabaseUtils` class provides the following methods:

- `getConnection(url, username, password)` - Establish database connection
- `executeQuery(query)` - Execute SELECT query and return results as List of Maps
- `executeUpdate(query)` - Execute INSERT/UPDATE/DELETE query
- `getSingleRow(query)` - Get single row from query result
- `validateRowCount(query, expectedCount)` - Validate row count
- `closeConnection()` - Close database connection

## TestNG Configuration

The project uses TestNG for test execution. The `testng.xml` file defines test suites:

- **API Tests** - Runs API scenarios and schema validation
- **Database Tests** - Runs database validation and schema validation
- **All Tests** - Runs all test scenarios

You can customize the TestNG configuration in `testng.xml` to:
- Change parallel execution settings
- Modify thread count
- Add or remove test groups
- Configure test listeners

## Reports

After running tests, Karate generates HTML reports in the `target/karate-reports` directory.

View reports:
```bash
open target/karate-reports/karate-summary.html
```

TestNG also generates its own reports in `target/surefire-reports`.

## Environment Configuration

You can configure different environments in `karate-config.js`. The configuration automatically loads from the config files:

- `dev` - Development environment (default)
- `staging` - Staging environment
- `prod` - Production environment

Environment-specific overrides can be added in `karate-config.js` while base configuration remains in the config feature files.

## Troubleshooting

### Database Connection Issues

1. Ensure PostgreSQL is running
2. Verify connection credentials in `config/db-config.feature`
3. Check if the database exists
4. Verify network connectivity
5. Ensure PostgreSQL JDBC driver is in classpath

### API Connection Issues

1. Verify the API base URL is correct in `config/api-config.feature`
2. Check if the API is accessible
3. Verify authentication token/key is valid
4. Check firewall/network settings
5. Verify timeout settings

### TestNG Issues

1. Ensure TestNG dependency is correctly added in `pom.xml`
2. Verify `testng.xml` is in the project root
3. Check surefire plugin configuration in `pom.xml`

### Schema Validation Failures

1. Verify the expected schema matches the actual API response
2. Check data types match (number vs string)
3. Verify optional fields are marked with `?` in schema
4. For database schema, ensure you have proper permissions to query `information_schema`

## Additional Resources

- [Karate Documentation](https://github.com/karatelabs/karate)
- [Karate DSL Syntax](https://github.com/karatelabs/karate#core-keywords)
- [TestNG Documentation](https://testng.org/doc/documentation-main.html)
- [PostgreSQL JDBC Driver](https://jdbc.postgresql.org/)
- [Karate Schema Validation](https://github.com/karatelabs/karate#schema-validation)

## License

This project is for testing purposes.
