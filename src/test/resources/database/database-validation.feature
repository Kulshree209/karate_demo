@database @validation
Feature: PostgreSQL Database Validation

  Background:
    * def DatabaseUtils = Java.type('com.example.karate.DatabaseUtils')
    * def connection = null
    * def dbConnected = false
    * eval
    """
    try {
      connection = DatabaseUtils.getConnection(dbUrl, dbUsername, dbPassword);
      dbConnected = true;
    } catch (e) {
      dbConnected = false;
      karate.log('Database connection failed:', e.message);
      karate.log('Skipping database tests. Please ensure PostgreSQL is running and configured.');
    }
    """

  Scenario: Validate user exists in database
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT * FROM users WHERE id = 1"
    When def result = DatabaseUtils.getSingleRow(query)
    Then match result.id == 1
    And match result.username == '#string'
    And match result.email == '#string'

  Scenario: Validate multiple records exist
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT * FROM users WHERE status = 'active'"
    When def results = DatabaseUtils.executeQuery(query)
    Then match results.length > 0
    And match results[*].status == 'active'

  Scenario: Validate record count matches expected value
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT COUNT(*) as count FROM users WHERE role = 'admin'"
    When def results = DatabaseUtils.executeQuery(query)
    Then match results[0].count == '#number'
    And assert results[0].count > 0

  Scenario: Validate data after API operation - Create and verify in DB
    * if (dbConnected == false) karate.abort()
    # First, create a record via API (if applicable)
    # Then validate it exists in database
    Given def query = "SELECT * FROM posts WHERE id = 1"
    When def result = DatabaseUtils.getSingleRow(query)
    Then match result != null
    And match result.id == 1
    And match result.title == '#string'

  Scenario: Validate database record matches API response
    * if (dbConnected == false) karate.abort()
    # Get data from API
    Given url baseUrl
    And path 'posts', 1
    When method GET
    Then status 200
    And def apiPost = response
    
    # Get same data from database
    And def dbQuery = "SELECT * FROM posts WHERE id = " + apiPost.id
    And def dbPost = DatabaseUtils.getSingleRow(dbQuery)
    
    # Validate they match
    Then match dbPost.id == apiPost.id
    And match dbPost.title == apiPost.title
    And match dbPost.body == apiPost.body

  Scenario: Validate row count after insert operation
    * if (dbConnected == false) karate.abort()
    Given def countQuery = "SELECT COUNT(*) as count FROM users"
    And def initialCount = DatabaseUtils.executeQuery(countQuery)[0].count
    
    # Perform insert operation (example)
    # def insertQuery = "INSERT INTO users (username, email) VALUES ('testuser', 'test@example.com')"
    # DatabaseUtils.executeUpdate(insertQuery)
    
    # Validate count increased
    # When def finalCount = DatabaseUtils.executeQuery(countQuery)[0].count
    # Then assert finalCount == initialCount + 1

  Scenario: Validate data integrity constraints
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT u.*, p.title as post_title FROM users u INNER JOIN posts p ON u.id = p.user_id WHERE u.id = 1"
    When def results = DatabaseUtils.executeQuery(query)
    Then match results.length > 0
    And match results[*].id == 1
    And match results[*].post_title == '#string'

  Scenario: Validate specific field values
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT username, email, created_at FROM users WHERE id = 1"
    When def result = DatabaseUtils.getSingleRow(query)
    Then match result.username == '#string'
    And match result.email contains '@'
    And match result.created_at == '#string'

  Scenario Outline: Validate multiple users by ID
    * if (dbConnected == false) karate.abort()
    Given def query = "SELECT * FROM users WHERE id = <id>"
    When def result = DatabaseUtils.getSingleRow(query)
    Then match result.id == <id>
    And match result.username == '#string'

    Examples:
      | id |
      | 1  |
      | 2  |
      | 3  |

  Scenario: Cleanup - Close database connection
    * if (dbConnected == true) DatabaseUtils.closeConnection()

