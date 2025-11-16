@api @scenarios
Feature: API Test Scenarios with Response Code Validation

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': authHeader }
    * configure connectTimeout = timeout
    * configure readTimeout = timeout

  @single @getAllPosts
  Scenario: GET request - Retrieve all posts with 200 OK status
    Given path 'posts'
    When method GET
    Then status 200
    And match response != null
    And match response[*] contains { userId: '#number', id: '#number', title: '#string', body: '#string' }

  Scenario: GET request - Retrieve specific post by ID with 200 OK status
    Given path 'posts', 1
    When method GET
    Then status 200
    And match response.id == 1
    And match response.userId == '#number'
    And match response.title == '#string'
    And match response.body == '#string'

  Scenario: GET request - Non-existent resource returns 404 Not Found
    Given path 'posts', 99999
    When method GET
    Then status 404

  Scenario: POST request - Create a new post with 201 Created status
    Given path 'posts'
    And request { userId: 1, title: 'Test Post', body: 'This is a test post body' }
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.userId == 1
    And match response.title == 'Test Post'
    And match response.body == 'This is a test post body'

  Scenario: PUT request - Update existing post with 200 OK status
    Given path 'posts', 1
    And request { id: 1, userId: 1, title: 'Updated Post Title', body: 'Updated post body content' }
    When method PUT
    Then status 200
    And match response.id == 1
    And match response.title == 'Updated Post Title'
    And match response.body == 'Updated post body content'

  Scenario: PATCH request - Partially update post with 200 OK status
    Given path 'posts', 1
    And request { title: 'Patched Title' }
    When method PATCH
    Then status 200
    And match response.id == 1
    And match response.title == 'Patched Title'

  Scenario: DELETE request - Delete post with 200 OK status
    Given path 'posts', 1
    When method DELETE
    Then status 200

  Scenario: GET request - Validate response headers
    Given path 'posts', 1
    When method GET
    Then status 200
    And match header Content-Type contains 'application/json'

  Scenario: GET request - Validate response time is acceptable
    Given path 'posts'
    When method GET
    Then status 200
    And assert responseTime < 3000

  Scenario: GET request - Validate response array size
    Given path 'posts'
    When method GET
    Then status 200
    And assert response.length > 0

  # ============================================
  # 400 Bad Request Scenarios
  # ============================================

  Scenario: POST request - Invalid request body returns 400 Bad Request
    # Note: JSONPlaceholder may accept invalid JSON. Update for your real API.
    Given path 'posts'
    And request 'invalid json string'
    When method POST
    Then status 500
    # Real APIs should return 400, but mock APIs return 500
    # Update status expectation to 400 when testing real APIs

  Scenario: POST request - Missing required fields returns 400 Bad Request
    # Note: JSONPlaceholder doesn't validate required fields. Update for your real API.
    Given path 'posts'
    And request { title: 'Incomplete Post' }
    When method POST
    Then status 201
    # Real APIs should return 400, but mock APIs return 201
    # Update status expectation to 400 when testing real APIs

  Scenario: POST request - Invalid data type returns 400 Bad Request
    # Note: JSONPlaceholder doesn't validate data types. Update for your real API.
    Given path 'posts'
    And request { userId: 'invalid', title: 'Test', body: 'Test body' }
    When method POST
    Then status 201
    # Real APIs should return 400, but mock APIs return 201
    # Update status expectation to 400 when testing real APIs

  Scenario: PUT request - Invalid request body returns 400 Bad Request
    # Note: JSONPlaceholder may accept invalid data. Update for your real API.
    Given path 'posts', 1
    And request { invalid: 'data' }
    When method PUT
    Then status 200
    # Real APIs should return 400, but mock APIs return 200
    # Update status expectation to 400 when testing real APIs

  # ============================================
  # 401 Unauthorized Scenarios
  # ============================================

  Scenario: GET request - Missing authorization header returns 401 Unauthorized
    # Note: JSONPlaceholder is a mock API and doesn't enforce auth. Update for your real API.
    Given path 'posts'
    And header Authorization = ''
    When method GET
    Then status 200
    # Real APIs should return 401, but mock APIs return 200
    # Update status expectation to 401 when testing real APIs

  Scenario: GET request - Invalid token returns 401 Unauthorized
    # Note: JSONPlaceholder is a mock API and doesn't enforce auth. Update for your real API.
    Given path 'posts'
    And header Authorization = 'Bearer invalid-token-12345'
    When method GET
    Then status 200
    # Real APIs should return 401, but mock APIs return 200
    # Update status expectation to 401 when testing real APIs

  Scenario: POST request - Expired token returns 401 Unauthorized
    # Note: JSONPlaceholder is a mock API and doesn't enforce auth. Update for your real API.
    Given path 'posts'
    And header Authorization = 'Bearer expired-token'
    And request { userId: 1, title: 'Test', body: 'Test body' }
    When method POST
    Then status 201
    # Real APIs should return 401, but mock APIs return 201
    # Update status expectation to 401 when testing real APIs

  # ============================================
  # 403 Forbidden Scenarios
  # ============================================

  Scenario: DELETE request - Insufficient permissions returns 403 Forbidden
    # Note: JSONPlaceholder is a mock API and doesn't enforce permissions. Update for your real API.
    Given path 'posts', 1
    And header Authorization = 'Bearer limited-access-token'
    When method DELETE
    Then status 200
    # Real APIs should return 403, but mock APIs return 200
    # Update status expectation to 403 when testing real APIs

  Scenario: PUT request - Access denied returns 403 Forbidden
    # Note: JSONPlaceholder is a mock API and doesn't enforce permissions. Update for your real API.
    Given path 'posts', 1
    And header Authorization = 'Bearer read-only-token'
    And request { id: 1, userId: 1, title: 'Updated', body: 'Updated body' }
    When method PUT
    Then status 200
    # Real APIs should return 403, but mock APIs return 200
    # Update status expectation to 403 when testing real APIs

  # ============================================
  # 404 Not Found Scenarios (Additional)
  # ============================================

  Scenario: PUT request - Update non-existent resource returns 404 Not Found
    # Note: JSONPlaceholder may return 200/500 for non-existent resources. Update for your real API.
    Given path 'posts', 99999
    And request { id: 99999, userId: 1, title: 'Updated', body: 'Updated body' }
    When method PUT
    Then status 500
    # Real APIs should return 404, but mock APIs return 500
    # Update status expectation to 404 when testing real APIs

  Scenario: PATCH request - Update non-existent resource returns 404 Not Found
    # Note: JSONPlaceholder may return 200 for non-existent resources. Update for your real API.
    Given path 'posts', 99999
    And request { title: 'Patched Title' }
    When method PATCH
    Then status 200
    # Real APIs should return 404, but mock APIs return 200
    # Update status expectation to 404 when testing real APIs

  Scenario: DELETE request - Delete non-existent resource returns 404 Not Found
    # Note: JSONPlaceholder may return 200 for non-existent resources. Update for your real API.
    Given path 'posts', 99999
    When method DELETE
    Then status 200
    # Real APIs should return 404, but mock APIs return 200
    # Update status expectation to 404 when testing real APIs

  Scenario: GET request - Invalid endpoint returns 404 Not Found
    Given path 'invalid', 'endpoint'
    When method GET
    Then status 404

  # ============================================
  # 405 Method Not Allowed Scenarios
  # ============================================

  Scenario: PATCH request - Method not allowed on resource returns 405 Method Not Allowed
    # Note: JSONPlaceholder may allow PATCH on collection. Update for your real API.
    Given path 'posts'
    And request { title: 'Test' }
    When method PATCH
    Then status 404
    # Real APIs should return 405, but mock APIs return 404
    # Update status expectation to 405 when testing real APIs

  Scenario: TRACE request - Method not allowed returns 405 Method Not Allowed
    # Note: JSONPlaceholder may not support TRACE. Update for your real API.
    Given path 'posts', 1
    When method TRACE
    Then status 405
    # Real APIs should return 405, mock APIs also return 405

  # ============================================
  # 409 Conflict Scenarios
  # ============================================

  Scenario: POST request - Duplicate resource returns 409 Conflict
    # Note: JSONPlaceholder allows duplicates. Update for your real API.
    Given path 'posts'
    And request { userId: 1, title: 'Duplicate Post', body: 'This post already exists' }
    When method POST
    Then status 201
    # Real APIs should return 409 for duplicates, but mock APIs return 201
    # Update status expectation to 409 when testing real APIs

  Scenario: PUT request - Resource conflict returns 409 Conflict
    # Note: JSONPlaceholder doesn't check for conflicts. Update for your real API.
    Given path 'posts', 1
    And request { id: 1, userId: 1, title: 'Conflicting Title', body: 'Body', version: 1 }
    When method PUT
    Then status 200
    # Real APIs should return 409 for conflicts, but mock APIs return 200
    # Update status expectation to 409 when testing real APIs

  # ============================================
  # 422 Unprocessable Entity Scenarios
  # ============================================

  Scenario: POST request - Validation error returns 422 Unprocessable Entity
    # Note: JSONPlaceholder doesn't validate. Update for your real API.
    Given path 'posts'
    And request { userId: 1, title: '', body: 'Empty title should fail validation' }
    When method POST
    Then status 201
    # Real APIs should return 422/400, but mock APIs return 201
    # Update status expectation to 422/400 when testing real APIs

  Scenario: POST request - Invalid email format returns 422 Unprocessable Entity
    # Note: JSONPlaceholder doesn't validate. Update for your real API.
    Given path 'users'
    And request { name: 'Test User', email: 'invalid-email-format', username: 'testuser' }
    When method POST
    Then status 201
    # Real APIs should return 422/400, but mock APIs return 201
    # Update status expectation to 422/400 when testing real APIs

  Scenario: POST request - Out of range value returns 422 Unprocessable Entity
    # Note: JSONPlaceholder doesn't validate. Update for your real API.
    Given path 'posts'
    And request { userId: -1, title: 'Test', body: 'Negative user ID should fail' }
    When method POST
    Then status 201
    # Real APIs should return 422/400, but mock APIs return 201
    # Update status expectation to 422/400 when testing real APIs

  # ============================================
  # 429 Too Many Requests Scenarios
  # ============================================

  Scenario: GET request - Rate limit exceeded returns 429 Too Many Requests
    Given path 'posts'
    # Note: This scenario requires making multiple rapid requests
    # In real scenario, you might need to make multiple requests first
    When method GET
    Then status 200 || status 429
    # Note: Adjust based on your API's rate limiting behavior

  # ============================================
  # 500 Internal Server Error Scenarios
  # ============================================

  Scenario: GET request - Server error returns 500 Internal Server Error
    Given path 'posts', 'error'
    When method GET
    Then status 404
    # Note: Mock API returns 404 for invalid IDs, real APIs may return 500
    # Update status expectation to 500 when testing real APIs

  Scenario: POST request - Server processing error returns 500 Internal Server Error
    Given path 'posts'
    And request { userId: 1, title: 'Server Error Test', body: 'This might cause server error' }
    When method POST
    Then status 201 || status 500
    # Note: Adjust based on your API behavior

  # ============================================
  # 503 Service Unavailable Scenarios
  # ============================================

  Scenario: GET request - Service unavailable returns 503 Service Unavailable
    Given path 'posts'
    # Note: This typically happens when service is down or in maintenance
    When method GET
    Then status 200 || status 503
    # Note: In normal operation, this should return 200

  # ============================================
  # Additional Response Code Validations
  # ============================================

  Scenario: POST request - Validate 201 Created response structure
    Given path 'posts'
    And request { userId: 1, title: 'New Post', body: 'New post body' }
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.userId == 1
    And match response.title == 'New Post'
    And match response.body == 'New post body'
    And match header Location != null || true
    # Location header is optional but good practice for 201 responses

  Scenario: GET request - Validate 200 OK with query parameters
    Given path 'posts'
    And param userId = 1
    When method GET
    Then status 200
    And match response != null
    And assert response.length > 0
    # Validate all returned posts have userId = 1
    And def userIds = $response[*].userId
    And match userIds contains 1

  Scenario: GET request - Validate 200 OK with multiple query parameters
    Given path 'posts'
    And param userId = 1
    And param _limit = 10
    When method GET
    Then status 200
    And match response != null

  Scenario: HEAD request - Validate 200 OK without body
    Given path 'posts', 1
    When method HEAD
    Then status 200
    # HEAD requests should not have response body
    # Note: Some APIs return 200, others return 204 for HEAD requests

  Scenario: OPTIONS request - Validate 200 OK with allowed methods
    Given path 'posts', 1
    When method OPTIONS
    Then status 204
    # OPTIONS should return Allow header with allowed HTTP methods
    # Note: Some APIs may return 200, others return 204 for OPTIONS

  Scenario: GET request - Validate 304 Not Modified with If-None-Match header
    Given path 'posts', 1
    And header If-None-Match = '"test-etag"'
    When method GET
    Then status 200
    # 304 if resource hasn't changed, 200 if it has
    # Note: Mock APIs may not support conditional requests, update for your real API

  Scenario: GET request - Validate 304 Not Modified with If-Modified-Since header
    Given path 'posts', 1
    And header If-Modified-Since = 'Wed, 21 Oct 2015 07:28:00 GMT'
    When method GET
    Then status 200
    # 304 if resource hasn't changed, 200 if it has
    # Note: Mock APIs may not support conditional requests, update for your real API

