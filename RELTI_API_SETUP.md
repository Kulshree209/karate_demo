# Reltio API Setup Guide

## Overview

This guide explains how to configure and run Reltio API tests. The Reltio API requires authentication via a token obtained from a separate authentication endpoint.

## Configuration

### Step 1: Update Authentication Endpoint

The authentication endpoint URL needs to be configured in `api-config.local.js`. Common Reltio authentication endpoints:

- `/reltio/api/auth/login`
- `/reltio/api/auth/token`
- `/reltio/api/oauth/token`
- `/reltio/api/v1/auth`

**Update in `api-config.local.js`:**
```javascript
reltioAuthUrl: 'https://test.reltio.com/reltio/api/auth/login', // Update with actual endpoint
```

### Step 2: Add Credentials

Update `api-config.local.js` with your actual Reltio credentials:

```javascript
reltioUserId: 'your-actual-user-id',
reltioPassword: 'your-actual-password',
reltioTenantId: 'AxLKMMJWrYpn5lO' // Your tenant ID
```

### Step 3: Verify Authentication Request Format

The authentication request format may vary. Common formats:

**Format 1: Username/Password**
```javascript
{ "username": "...", "password": "..." }
```

**Format 2: User ID/Password**
```javascript
{ "userId": "...", "password": "..." }
```

**Format 3: OAuth Style**
```javascript
{ "grant_type": "password", "username": "...", "password": "..." }
```

**Update in `reltio-entities.feature`** - Find the authentication scenario and update the request body:
```gherkin
And request { userId: reltioUserId, password: reltioPassword }
```

### Step 4: Verify Token Response Format

The token location in the response may vary. Common locations:

- `response.token`
- `response.access_token`
- `response.data.token`
- `response.authToken`

**Update in `reltio-entities.feature`** - Find this line and update based on your API:
```gherkin
And def authToken = response.token || response.access_token || response.data.token || response.authToken
```

## Feature File: `reltio-entities.feature`

### Scenarios Included

1. **Get authentication token with valid credentials**
   - Authenticates and extracts token
   - Stores token for subsequent requests

2. **Get entities with valid query parameters**
   - Gets token first
   - Calls entities endpoint with token
   - Validates response

3. **Get entities - validate response schema**
   - Validates response structure
   - Checks data types

4. **Get entities - validate response time**
   - Ensures response time < 10 seconds

5. **Get entities - missing authentication token**
   - Tests 401/403 response

6. **Get entities - invalid authentication token**
   - Tests 401/403 response

7. **Get entities - expired authentication token**
   - Tests 401/403 response

8. **Get entities - missing required filter parameter**
   - Tests 400/422 response

9. **Get entities - invalid filter parameter**
   - Tests 400/422 response

10. **Get entities - validate response headers**
    - Validates Content-Type header

11. **Get entities - different merchant ID**
    - Tests with different merchant ID

12. **Get entities - different country code**
    - Tests with different country

13. **Authentication - invalid user credentials**
    - Tests 401/403 response

14. **Authentication - missing password**
    - Tests 400/422 response

15. **Authentication - missing user ID**
    - Tests 400/422 response

## Running Tests

### Run All Reltio Tests

```bash
mvn test -Dtest=TestRunner#testReltioEntities
```

### Run from IntelliJ

1. Open `TestRunner.java`
2. Right-click on `testReltioEntities()` method
3. Select `Run 'testReltioEntities()'`

### Run Specific Scenarios

Add tags to scenarios and filter:

```bash
mvn test -Dtest=TestRunner#testReltioEntities
```

Then in the feature file, use tags:
```gherkin
@reltio @entities @smoke
Scenario: Get entities with valid query parameters
```

## Authentication Flow

The feature file implements a two-step authentication flow:

1. **Step 1: Get Token**
   ```gherkin
   Given url reltioAuthUrl
   And request { userId: reltioUserId, password: reltioPassword }
   When method POST
   Then status 200 || status 201
   And def authToken = response.token || response.access_token || response.data.token || response.authToken
   ```

2. **Step 2: Use Token**
   ```gherkin
   Given url reltioBaseUrl
   And path 'reltio', 'api', reltioTenantId, 'entities'
   And header Authorization = 'Bearer ' + authToken
   When method GET
   ```

## Query Parameters

The entities endpoint uses URL-encoded query parameters:

- **filter**: Entity filter criteria
- **select**: Fields to select
- **options**: Additional options (cleanEntity, ovOnly)

Example:
```
filter=((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))
select=attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID...
options=cleanEntity%2CovOnly
```

## Troubleshooting

### Issue 1: Authentication Fails

**Check:**
- Authentication endpoint URL is correct
- Request body format matches API requirements
- Credentials are correct
- Token extraction path is correct

**Solution:**
1. Check `reltioAuthUrl` in `api-config.local.js`
2. Verify request body format in feature file
3. Check token location in response
4. Test authentication endpoint manually first

### Issue 2: Token Not Found in Response

**Check:**
- Response structure
- Token field name

**Solution:**
1. Print response: `And print 'Auth Response:', response`
2. Identify token field name
3. Update: `And def authToken = response.yourTokenField`

### Issue 3: 401 Unauthorized on Entities Endpoint

**Check:**
- Token is being passed correctly
- Token format (Bearer prefix)
- Token is not expired

**Solution:**
1. Verify token is extracted: `And print 'Token:', authToken`
2. Check Authorization header: `And print 'Auth Header:', 'Bearer ' + authToken`
3. Ensure token is not expired

### Issue 4: 400 Bad Request

**Check:**
- Query parameters are URL-encoded correctly
- Filter syntax is correct
- Required parameters are present

**Solution:**
1. Verify parameter encoding
2. Test with simpler filter first
3. Check API documentation for filter syntax

## Customization

### Update Filter Criteria

To test with different filter criteria, update the `filter` parameter:

```gherkin
And param filter = "your-filter-criteria-here"
```

### Update Selected Fields

To select different fields, update the `select` parameter:

```gherkin
And param select = "attributes.Field1%2Cattributes.Field2"
```

### Add More Test Data

Create a Scenario Outline with Examples table:

```gherkin
Scenario Outline: Get entities with different merchant IDs
  # Get token
  Given url reltioAuthUrl
  And request { userId: reltioUserId, password: reltioPassword }
  When method POST
  Then status 200 || status 201
  And def authToken = response.token || response.access_token || response.data.token || response.authToken
  
  # Get entities
  Given url reltioBaseUrl
  And path 'reltio', 'api', reltioTenantId, 'entities'
  And header Authorization = 'Bearer ' + authToken
  And param filter = "((equals(attributes.ACQ_MERCHANT_ID%2C'<merchant_id>')))"
  When method GET
  Then status 200

  Examples:
    | merchant_id      |
    | 000000128015757  |
    | 000000128015758  |
    | 000000128015759  |
```

## Security Notes

- **Never commit `api-config.local.js`** - It contains actual credentials
- **Use environment variables** for CI/CD pipelines
- **Rotate credentials** regularly
- **Use test environment** credentials only

## Summary

1. **Configure** `api-config.local.js` with credentials and auth endpoint
2. **Update** authentication request format if needed
3. **Update** token extraction path if needed
4. **Run tests** using `mvn test -Dtest=TestRunner#testReltioEntities`
5. **Customize** scenarios as needed for your use case

The feature file is flexible and can be easily customized based on your Reltio API's specific requirements.

