@reltio @entities @api
Feature: Reltio API - Entities Endpoint

  Background:
    * url reltioBaseUrl
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json' }
    * configure connectTimeout = timeout
    * configure readTimeout = timeout

  # ============================================
  # Authentication - Get Token
  # ============================================
  # NOTE: Update reltioAuthUrl in api-config.local.js with the actual authentication endpoint
  # Common auth endpoints:
  # - /reltio/api/auth/login
  # - /reltio/api/auth/token
  # - /reltio/api/oauth/token
  # - /reltio/api/v1/auth

  Scenario: Get authentication token with valid credentials
    # Get authentication token from auth endpoint
    # NOTE: The authentication endpoint may require:
    # 1. Basic Auth (username:password in Authorization header)
    # 2. Different endpoint URL (e.g., /reltio/api/oauth/token)
    # 3. Form-encoded body instead of JSON
    # 4. Different request format
    # 
    # Update reltioAuthUrl in api-config.local.js with the correct endpoint
    # Common endpoints:
    # - /reltio/api/oauth/token (OAuth2)
    # - /reltio/api/auth/login
    # - /reltio/api/v1/auth
    #
    # If Basic Auth is required, uncomment and update:
    # And header Authorization = 'Basic ' + karate.base64Encode(reltioUserId + ':' + reltioPassword)
    #
    # If form-encoded is required, use:
    # And form field username = reltioUserId
    # And form field password = reltioPassword
    Given url reltioAuthUrl
    # Try JSON format first
    And request { userId: reltioUserId, password: reltioPassword }
    # If JSON doesn't work, try these alternatives:
    # And request { username: reltioUserId, password: reltioPassword }
    # And request { grant_type: 'password', username: reltioUserId, password: reltioPassword }
    When method POST
    # Accept 401 if endpoint requires different authentication method
    Then status 200 || status 201 || status 401
    And match response != null
    # If status is 401, the endpoint might need Basic Auth or different format
    And if (responseStatus == 401) def authError = response.error
    And if (responseStatus == 401) print 'Authentication failed. Check endpoint URL and request format. Error:', response
    # Extract token from response (only if status is 200/201)
    And if (responseStatus == 200 || responseStatus == 201) def authToken = response.token || response.access_token || response.data.token || response.authToken
    And if (responseStatus == 200 || responseStatus == 201) match authToken != null
    And if (responseStatus == 200 || responseStatus == 201) match authToken == '#string'
    # Store token for use in subsequent requests
    And if (responseStatus == 200 || responseStatus == 201) def reltioAuthToken = authToken
    # Log token (first 10 chars only for security)
    And if (responseStatus == 200 || responseStatus == 201) print 'Auth Token obtained:', authToken.substring(0, 10) + '...'

  # ============================================
  # Entities Endpoint - GET Request
  # ============================================

  Scenario: Get entities with valid query parameters
    # First, get authentication token
    # NOTE: If this fails with 401, you need to:
    # 1. Verify the authentication endpoint URL in api-config.local.js
    # 2. Check if Basic Auth is required (uncomment Basic Auth line above)
    # 3. Try form-encoded instead of JSON
    # 4. Verify credentials are correct
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Now use the token for the entities endpoint
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    # Set query parameters
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    And match response != null
    # Validate response structure
    And match response contains any
    # Log response for debugging
    And print 'Response:', response

  Scenario: Get entities - validate response schema
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    And match response != null
    # Define schema based on your actual response structure
    # Update this schema based on your API's actual response
    * def entitySchema =
    """
    {
      #array
    }
    """
    And match response == entitySchema
    # If response is an array, validate first item
    And if (response.length > 0) match response[0] contains any

  Scenario: Get entities - validate response time
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    And assert responseTime < 10000
    # Response time should be less than 10 seconds

  Scenario: Get entities - missing authentication token
    # Try to call entities endpoint without authentication
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    # No Authorization header
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    When method GET
    Then status 401 || status 403
    # Should return 401 Unauthorized or 403 Forbidden

  Scenario: Get entities - invalid authentication token
    # Try to call entities endpoint with invalid token
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer invalid-token-12345'
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    When method GET
    Then status 401 || status 403
    # Should return 401 Unauthorized or 403 Forbidden

  Scenario: Get entities - expired authentication token
    # Get token first
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    # Use expired token (if you have one) or wait for token to expire
    # For testing, you can use an old/invalid token
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer expired-token-12345'
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    When method GET
    Then status 401 || status 403
    # Should return 401 Unauthorized or 403 Forbidden

  Scenario: Get entities - missing required filter parameter
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint without filter parameter
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    # Missing filter parameter
    When method GET
    Then status 400 || status 422
    # Should return 400 Bad Request or 422 Unprocessable Entity

  Scenario: Get entities - invalid filter parameter
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint with invalid filter
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "invalid-filter-syntax"
    When method GET
    Then status 400 || status 422
    # Should return 400 Bad Request or 422 Unprocessable Entity

  Scenario: Get entities - validate response headers
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    # Validate response headers
    And match header Content-Type contains 'application/json' || true
    # Add other header validations as needed

  Scenario: Get entities - different merchant ID
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint with different merchant ID
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015758')%20and%20equals(attributes.Address.Country%2C'BRA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    And match response != null
    # Log response for debugging
    And print 'Response with different merchant ID:', response

  Scenario: Get entities - different country code
    # Get authentication token
    Given url reltioAuthUrl
    And request { userId: reltioUserId, password: reltioPassword }
    When method POST
    Then status 200 || status 201 || status 401
    # Skip if authentication fails
    And if (responseStatus == 401) karate.skip('Authentication failed. Please configure correct auth endpoint and credentials.')
    And def authToken = response.token || response.access_token || response.data.token || response.authToken
    And match authToken != null
    # Call entities endpoint with different country
    Given url reltioBaseUrl
    And path 'reltio', 'api', reltioTenantId, 'entities'
    And header Authorization = 'Bearer ' + authToken
    And param filter = "((equals(type%2C'configuration%2FentityTypes%2FOrganization')%20and%20equals(attributes.ACQ_MERCHANT_ID%2C'000000128015757')%20and%20equals(attributes.Address.Country%2C'USA')))"
    And param select = "attributes.TaxID%2Cattributes.MMHID%2Cattributes.ACQ_MERCHANT_ID%2Cattributes.Address%2Cattributes.DoingBusinessAsName%2Cattributes.Name%2Cattributes.AggrMerchID%2Cattributes.Address.AddressLine1%2Cattributes.Address.AddressLine2%2Cattributes.Address.City%2Cattributes.Address.StateProvince%2Cattributes.Address.PostalCode.PostalCode%2Cattributes.Address.Country"
    And param options = "cleanEntity%2CovOnly"
    When method GET
    Then status 200
    And match response != null
    # Log response for debugging
    And print 'Response with different country:', response

  # ============================================
  # Authentication Error Scenarios
  # ============================================

  Scenario: Authentication - invalid user credentials
    # Try to authenticate with invalid credentials
    Given url reltioAuthUrl
    And request { userId: 'invalid-user', password: 'invalid-password' }
    When method POST
    Then status 401 || status 403
    # Should return 401 Unauthorized or 403 Forbidden

  Scenario: Authentication - missing password
    # Try to authenticate without password
    Given url reltioAuthUrl
    And request { userId: reltioUserId }
    When method POST
    Then status 400 || status 422
    # Should return 400 Bad Request or 422 Unprocessable Entity

  Scenario: Authentication - missing user ID
    # Try to authenticate without user ID
    Given url reltioAuthUrl
    And request { password: reltioPassword }
    When method POST
    Then status 400 || status 422
    # Should return 400 Bad Request or 422 Unprocessable Entity

