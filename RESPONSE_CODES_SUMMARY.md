# HTTP Response Code Scenarios Summary

This document lists all HTTP response code scenarios covered in `api-scenarios.feature`.

## Success Response Codes (2xx)

### 200 OK
- ✅ GET request - Retrieve all posts
- ✅ GET request - Retrieve specific post by ID
- ✅ PUT request - Update existing post
- ✅ PATCH request - Partially update post
- ✅ DELETE request - Delete post
- ✅ GET request - Validate response headers
- ✅ GET request - Validate response time
- ✅ GET request - Validate response array size
- ✅ GET request - With query parameters
- ✅ GET request - With multiple query parameters
- ✅ HEAD request - Without body
- ✅ OPTIONS request - With allowed methods

### 201 Created
- ✅ POST request - Create a new post
- ✅ POST request - Validate response structure
- ✅ POST request - Validate Location header

### 204 No Content
- ✅ OPTIONS request (may return 204)

### 304 Not Modified
- ✅ GET request - With If-None-Match header
- ✅ GET request - With If-Modified-Since header

## Client Error Response Codes (4xx)

### 400 Bad Request
- ✅ POST request - Invalid request body
- ✅ POST request - Missing required fields
- ✅ POST request - Invalid data type
- ✅ PUT request - Invalid request body

### 401 Unauthorized
- ✅ GET request - Missing authorization header
- ✅ GET request - Invalid token
- ✅ POST request - Expired token

### 403 Forbidden
- ✅ DELETE request - Insufficient permissions
- ✅ PUT request - Access denied

### 404 Not Found
- ✅ GET request - Non-existent resource
- ✅ PUT request - Update non-existent resource
- ✅ PATCH request - Update non-existent resource
- ✅ DELETE request - Delete non-existent resource
- ✅ GET request - Invalid endpoint

### 405 Method Not Allowed
- ✅ PATCH request - Method not allowed on resource
- ✅ TRACE request - Method not allowed

### 409 Conflict
- ✅ POST request - Duplicate resource
- ✅ PUT request - Resource conflict

### 422 Unprocessable Entity
- ✅ POST request - Validation error (empty title)
- ✅ POST request - Invalid email format
- ✅ POST request - Out of range value

### 429 Too Many Requests
- ✅ GET request - Rate limit exceeded

## Server Error Response Codes (5xx)

### 500 Internal Server Error
- ✅ GET request - Server error
- ✅ POST request - Server processing error

### 503 Service Unavailable
- ✅ GET request - Service unavailable

## Total Scenarios

- **Total Scenarios**: 40+
- **Success Codes (2xx)**: 15 scenarios
- **Client Errors (4xx)**: 20+ scenarios
- **Server Errors (5xx)**: 3 scenarios

## Notes

1. **Conditional Status Codes**: Some scenarios use `status 200 || status 404` syntax to handle APIs that may return different codes based on implementation.

2. **API-Specific Adjustments**: Some scenarios include notes indicating they may need adjustment based on your specific API behavior:
   - 409 Conflict scenarios may return 201 if API allows duplicates
   - 422 scenarios may return 400 in some APIs
   - 500/503 scenarios are hard to test in normal operation

3. **Authentication Scenarios**: 401/403 scenarios assume your API requires authentication. If your API doesn't require auth, these may need to be adjusted or skipped.

4. **Rate Limiting**: 429 scenarios may require making multiple rapid requests to trigger, or may need to be tested in a specific environment.

## Running Specific Response Code Tests

You can add tags to scenarios to run specific response code tests:

```gherkin
@400 @badRequest
Scenario: POST request - Invalid request body returns 400 Bad Request
  ...
```

Then run:
```bash
mvn test "-Dkarate.options=--tags @400 classpath:api/api-scenarios.feature"
```

## Customization

To customize these scenarios for your API:

1. Update the request payloads to match your API's expected format
2. Adjust expected status codes based on your API's behavior
3. Add or remove scenarios based on your API's supported features
4. Update authentication headers based on your API's auth mechanism
5. Modify validation assertions to match your API's response structure

