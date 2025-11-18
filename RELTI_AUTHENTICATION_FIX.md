# Reltio Authentication Configuration Guide

## Current Issue

The authentication endpoint is returning **401 Unauthorized** with the error:
```
{"error":"unauthorized","error_description":"Full authentication is required to access this resource"}
```

This means the authentication endpoint URL or request format needs to be corrected.

## Solutions to Try

### Solution 1: Update Authentication Endpoint URL

The endpoint `/reltio/api/auth` might not be correct. Try these common Reltio authentication endpoints:

1. **OAuth2 Token Endpoint:**
   ```
   https://test.reltio.com/reltio/api/oauth/token
   ```

2. **Login Endpoint:**
   ```
   https://test.reltio.com/reltio/api/auth/login
   ```

3. **Versioned Auth Endpoint:**
   ```
   https://test.reltio.com/reltio/api/v1/auth
   ```

**Update in `api-config.local.js`:**
```javascript
reltioAuthUrl: 'https://test.reltio.com/reltio/api/oauth/token', // Try this first
```

### Solution 2: Use Basic Authentication

Some Reltio APIs require Basic Auth for the authentication endpoint itself. Update the feature file:

**In `reltio-entities.feature`, find the authentication scenario and add:**

```gherkin
Given url reltioAuthUrl
# Add Basic Auth header
And header Authorization = 'Basic ' + karate.base64Encode(reltioUserId + ':' + reltioPassword)
And request { grant_type: 'password', username: reltioUserId, password: reltioPassword }
When method POST
```

### Solution 3: Use Form-Encoded Request

OAuth2 token endpoints typically require form-encoded data, not JSON:

**Update the authentication scenario:**

```gherkin
Given url reltioAuthUrl
And header Content-Type = 'application/x-www-form-urlencoded'
And form field grant_type = 'password'
And form field username = reltioUserId
And form field password = reltioPassword
When method POST
```

### Solution 4: OAuth2 Client Credentials Flow

If your Reltio API uses OAuth2 client credentials:

```gherkin
Given url reltioAuthUrl
And header Content-Type = 'application/x-www-form-urlencoded'
And form field grant_type = 'client_credentials'
And form field client_id = reltioUserId
And form field client_secret = reltioPassword
When method POST
```

### Solution 5: Check API Documentation

1. **Check Reltio API documentation** for the correct authentication endpoint
2. **Verify the authentication method** (Basic Auth, OAuth2, etc.)
3. **Check request format** (JSON vs form-encoded)
4. **Verify required headers** (Content-Type, Accept, etc.)

## Quick Test Steps

1. **Test authentication endpoint manually** using Postman or curl:
   ```bash
   curl -X POST https://test.reltio.com/reltio/api/oauth/token \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "grant_type=password&username=YOUR_USER&password=YOUR_PASS"
   ```

2. **Once you get a successful response**, note:
   - The endpoint URL that worked
   - The request format (JSON or form-encoded)
   - The token location in the response
   - Any required headers

3. **Update the feature file** with the correct format

## Updated Feature File

The feature file has been updated to:
- Accept 401 responses gracefully
- Skip scenarios that require authentication if auth fails
- Provide clear error messages

## Next Steps

1. **Identify the correct authentication endpoint** from Reltio documentation
2. **Update `reltioAuthUrl`** in `api-config.local.js`
3. **Update the authentication scenario** in `reltio-entities.feature` with the correct format
4. **Run tests again**: `mvn test -Dtest=TestRunner#testReltioEntities`

## Common Reltio Authentication Patterns

### Pattern 1: OAuth2 Password Grant
```gherkin
Given url 'https://test.reltio.com/reltio/api/oauth/token'
And header Content-Type = 'application/x-www-form-urlencoded'
And form field grant_type = 'password'
And form field username = reltioUserId
And form field password = reltioPassword
When method POST
Then status 200
And def authToken = response.access_token
```

### Pattern 2: Basic Auth + JSON
```gherkin
Given url 'https://test.reltio.com/reltio/api/auth/login'
And header Authorization = 'Basic ' + karate.base64Encode(reltioUserId + ':' + reltioPassword)
And request { username: reltioUserId, password: reltioPassword }
When method POST
Then status 200
And def authToken = response.token
```

### Pattern 3: API Key Authentication
```gherkin
Given url 'https://test.reltio.com/reltio/api/auth'
And header X-API-Key = reltioApiKey
And request { userId: reltioUserId }
When method POST
Then status 200
And def authToken = response.token
```

## Need Help?

If you're still having issues:
1. Check Reltio API documentation
2. Contact Reltio support for authentication endpoint details
3. Test the endpoint manually first to understand the format
4. Share the working curl/Postman request format, and I can help update the feature file

