@api @schema
Feature: API Schema Validation

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': authHeader }
    * def postSchema = 
    """
    {
      "id": "#number",
      "userId": "#number",
      "title": "#string",
      "body": "#string"
    }
    """
    * def userSchema = 
    """
    {
      "id": "#number",
      "name": "#string",
      "username": "#string",
      "email": "#string",
      "address": {
        "street": "#string",
        "suite": "#string",
        "city": "#string",
        "zipcode": "#string",
        "geo": {
          "lat": "#string",
          "lng": "#string"
        }
      },
      "phone": "#string",
      "website": "#string",
      "company": {
        "name": "#string",
        "catchPhrase": "#string",
        "bs": "#string"
      }
    }
    """
    * def commentSchema = 
    """
    {
      "postId": "#number",
      "id": "#number",
      "name": "#string",
      "email": "#string",
      "body": "#string"
    }
    """

  Scenario: Validate GET /posts/{id} response schema
    Given path 'posts', 1
    When method GET
    Then status 200
    And match response == postSchema
    And match response.id == 1
    And match response.userId == '#number'
    And match response.title == '#string?'
    And match response.body == '#string?'

  Scenario: Validate GET /posts response array schema
    Given path 'posts'
    When method GET
    Then status 200
    And match each response == postSchema
    # Validate array elements individually
    And assert response.length > 0
    And def firstPost = response[0]
    And match firstPost.id == '#number'
    And match firstPost.userId == '#number'
    And match firstPost.title == '#string'
    And match firstPost.body == '#string'

  Scenario: Validate POST /posts response schema
    Given path 'posts'
    And request { userId: 1, title: 'Schema Test Post', body: 'Testing schema validation' }
    When method POST
    Then status 201
    And match response == postSchema
    And match response.id == '#number'
    And match response.userId == 1
    And match response.title == 'Schema Test Post'
    And match response.body == 'Testing schema validation'

  Scenario: Validate PUT /posts/{id} response schema
    Given path 'posts', 1
    And request { id: 1, userId: 1, title: 'Updated Schema Test', body: 'Updated body' }
    When method PUT
    Then status 200
    And match response == postSchema
    And match response.id == 1
    And match response.userId == 1

  Scenario: Validate GET /users/{id} response schema
    Given path 'users', 1
    When method GET
    Then status 200
    And match response == userSchema
    And match response.id == 1
    And match response.name == '#string'
    And match response.email == '#string'
    And match response.address.street == '#string'
    And match response.address.geo.lat == '#string'

  Scenario: Validate GET /users response array schema
    Given path 'users'
    When method GET
    Then status 200
    And match each response == userSchema
    # Validate array elements
    And assert response.length > 0
    And def firstUser = response[0]
    And match firstUser.id == '#number'
    And match firstUser.email contains '@'

  Scenario: Validate GET /posts/{id}/comments response schema
    Given path 'posts', 1, 'comments'
    When method GET
    Then status 200
    And match each response == commentSchema
    # Validate array elements
    And assert response.length > 0
    And def firstComment = response[0]
    And match firstComment.postId == 1
    And match firstComment.email contains '@'

  Scenario: Validate nested object schema structure
    Given path 'users', 1
    When method GET
    Then status 200
    And match response.address == 
    """
    {
      "street": "#string",
      "suite": "#string",
      "city": "#string",
      "zipcode": "#string",
      "geo": {
        "lat": "#string",
        "lng": "#string"
      }
    }
    """
    And match response.company == 
    """
    {
      "name": "#string",
      "catchPhrase": "#string",
      "bs": "#string"
    }
    """

  Scenario: Validate array of objects schema
    Given path 'posts'
    When method GET
    Then status 200
    And def schemaArray = '#[] postSchema'
    And match response == schemaArray
    And assert response.length > 0

  Scenario: Validate optional fields in schema
    Given path 'posts', 1
    When method GET
    Then status 200
    And match response contains { id: '#number', userId: '#number' }
    And match response.title == '#string?'
    And match response.body == '#string?'

  Scenario: Validate data types in schema
    Given path 'posts', 1
    When method GET
    Then status 200
    And match response.id == '#number'
    And match response.userId == '#number'
    And match response.title == '#string'
    And match response.body == '#string'

  Scenario: Validate schema with regex pattern
    Given path 'users', 1
    When method GET
    Then status 200
    And match response.email == '#regex [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'
    And match response.phone == '#string'

  Scenario: Validate schema with null values handling
    Given path 'posts', 1
    When method GET
    Then status 200
    And match response == 
    """
    {
      "id": "#number",
      "userId": "#number",
      "title": "#string?",
      "body": "#string?"
    }
    """

  Scenario: Validate schema with array of primitives
    Given path 'users', 1
    When method GET
    Then status 200
    # If API returns array fields, validate them
    And match response.id == '#number'
    And match response.name == '#string'

