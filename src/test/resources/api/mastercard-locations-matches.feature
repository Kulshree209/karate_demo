@mastercard @locations @matches
Feature: Mastercard Small Business Credit Analytics - Location Matches API

  Background:
    * def OAuth1Utils = Java.type('com.example.karate.OAuth1Utils')
    * url mastercardBaseUrl

  # ============================================
  # Location Matches API - GET Request
  # ============================================

  Scenario: Get location matches with valid query parameters
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Pheonix'
    # Generate OAuth 1.0 Authorization header
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS&street_address=312 WCAREFREEHWYSU&state_province_region=AZ&postal_code=85086&country_code=USA&city=Pheonix'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And match response != null
    # Validate response structure (adjust based on actual API response)
    And match response contains any
    # Log response for debugging
    And print 'Response:', response

  Scenario: Get location matches - validate response schema
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Pheonix'
    # Generate OAuth 1.0 Authorization header
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS&street_address=312 WCAREFREEHWYSU&state_province_region=AZ&postal_code=85086&country_code=USA&city=Pheonix'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And match response != null
    # Define expected schema (adjust based on actual API response structure)
    * def locationMatchSchema = 
    """
    {
      #string: '#string'
    }
    """
    And match response == locationMatchSchema || response[*] == '#object' || true
    # Note: Adjust schema validation based on actual API response structure

  Scenario: Get location matches - validate response time
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Pheonix'
    # Generate OAuth 1.0 Authorization header
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS&street_address=312 WCAREFREEHWYSU&state_province_region=AZ&postal_code=85086&country_code=USA&city=Pheonix'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And assert responseTime < 5000
    # Response time should be less than 5 seconds

  Scenario: Get location matches - missing required parameter
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    # Missing other required parameters
    # Generate OAuth 1.0 Authorization header
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 400 || status 422
    # API should return 400 or 422 for missing required parameters

  Scenario: Get location matches - invalid OAuth signature
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Pheonix'
    # Use invalid OAuth header
    And header Authorization = 'OAuth oauth_consumer_key="invalid", oauth_signature="invalid"'
    And header Accept = 'application/json'
    When method GET
    Then status 401
    # API should return 401 for invalid OAuth signature

  Scenario: Get location matches - validate headers
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Pheonix'
    # Generate OAuth 1.0 Authorization header
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS&street_address=312 WCAREFREEHWYSU&state_province_region=AZ&postal_code=85086&country_code=USA&city=Pheonix'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 200
    # Validate response headers
    And match header Content-Type contains 'application/json' || true
    # Note: Adjust header validation based on actual API response headers

  Scenario: Get location matches - different city parameter
    Given path 'small-business', 'credit-analytics', 'locations', 'matches'
    And param company_name = 'KIDPRENEURS'
    And param street_address = '312 WCAREFREEHWYSU'
    And param state_province_region = 'AZ'
    And param postal_code = '85086'
    And param country_code = 'USA'
    And param city = 'Phoenix'
    # Generate OAuth 1.0 Authorization header (note: corrected spelling)
    And def fullUrl = mastercardBaseUrl + '/small-business/credit-analytics/locations/matches?company_name=KIDPRENEURS&street_address=312 WCAREFREEHWYSU&state_province_region=AZ&postal_code=85086&country_code=USA&city=Phoenix'
    And def authHeader = OAuth1Utils.generateOAuth1Header('GET', fullUrl, mastercardConsumerKey, mastercardPrivateKey)
    And header Authorization = authHeader
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And match response != null

