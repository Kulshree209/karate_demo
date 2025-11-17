# Mastercard API Setup Guide

## Overview

This guide explains how to configure and test the Mastercard Small Business Credit Analytics - Location Matches API using OAuth 1.0 with RSA-SHA1 signature method.

## API Endpoint

```
GET https://stage.api.gateway.mastercard.com/small-business/credit-analytics/locations/matches
```

## Query Parameters

- `company_name` - Company name (e.g., KIDPRENEURS)
- `street_address` - Street address (e.g., 312 WCAREFREEHWYSU)
- `state_province_region` - State/Province/Region code (e.g., AZ)
- `postal_code` - Postal/ZIP code (e.g., 85086)
- `country_code` - Country code (e.g., USA)
- `city` - City name (e.g., Phoenix)

## Authentication

The API uses **OAuth 1.0** with **RSA-SHA1** signature method.

### Required Credentials

1. **Consumer Key** - Your OAuth consumer key
2. **Private Key** - Your RSA private key in PKCS#8 format

## Configuration Steps

### Step 1: Update API Configuration

Edit `src/test/resources/config/api-config.js` and update the Mastercard credentials:

```javascript
function fn() {
  return {
    // ... other config ...
    
    // Mastercard API Gateway OAuth 1.0 Configuration
    mastercardBaseUrl: 'https://stage.api.gateway.mastercard.com',
    mastercardConsumerKey: 'your-actual-consumer-key-here',
    mastercardPrivateKey: 'your-actual-private-key-here'
  };
}
```

### Step 2: Private Key Format

The private key should be in **PKCS#8 format**. You can provide it in two ways:

#### Option A: PEM Format (Recommended)
```javascript
mastercardPrivateKey: `
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
...your private key content...
-----END PRIVATE KEY-----
`
```

#### Option B: Base64 Encoded (without headers)
```javascript
mastercardPrivateKey: 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...'
```

### Step 3: Convert Private Key to PKCS#8 (if needed)

If you have a private key in PKCS#1 format (RSA PRIVATE KEY), convert it to PKCS#8:

```bash
# Using OpenSSL
openssl pkcs8 -topk8 -inform PEM -in private_key.pem -outform PEM -nocrypt -out private_key_pkcs8.pem
```

## Feature File

The test scenarios are in:
```
src/test/resources/api/mastercard-locations-matches.feature
```

## Running Tests

### Run All Mastercard Tests

```bash
mvn test -Dtest=TestRunner#testMastercardLocationsMatches
```

### Run Specific Scenario

Use tags to run specific scenarios:

```bash
# Run via TestRunner
mvn test -Dtest=TestRunner#testMastercardLocationsMatches
```

### Run from IntelliJ

1. Open `TestRunner.java`
2. Right-click on `testMastercardLocationsMatches()` method
3. Select `Run 'testMastercardLocationsMatches()'`

## Test Scenarios

The feature file includes the following test scenarios:

1. **Get location matches with valid query parameters** - Tests successful API call
2. **Validate response schema** - Validates response structure
3. **Validate response time** - Ensures API responds within acceptable time
4. **Missing required parameter** - Tests error handling for missing parameters
5. **Invalid OAuth signature** - Tests authentication error handling
6. **Validate headers** - Validates response headers
7. **Different city parameter** - Tests with corrected city spelling

## OAuth 1.0 Implementation

The OAuth 1.0 implementation is handled by the `OAuth1Utils` Java class:

- **Location:** `src/test/java/com/example/karate/OAuth1Utils.java`
- **Signature Method:** RSA-SHA1
- **OAuth Version:** 1.0

The utility automatically:
- Generates OAuth nonce and timestamp
- Creates signature base string
- Signs the request with RSA-SHA1
- Builds the Authorization header

## Example Request

```gherkin
Scenario: Get location matches with valid query parameters
  Given path 'small-business', 'credit-analytics', 'locations', 'matches'
  And param company_name = 'KIDPRENEURS'
  And param street_address = '312 WCAREFREEHWYSU'
  And param state_province_region = 'AZ'
  And param postal_code = '85086'
  And param country_code = 'USA'
  And param city = 'Pheonix'
  # OAuth 1.0 header is automatically generated
  When method GET
  Then status 200
```

## Troubleshooting

### Error: "Failed to generate OAuth 1.0 header"

**Possible causes:**
1. Private key format is incorrect
2. Private key is not in PKCS#8 format
3. Private key contains invalid characters

**Solution:**
- Ensure private key is in PKCS#8 format
- Check for extra whitespace or line breaks
- Verify the key is properly base64 encoded

### Error: "401 Unauthorized"

**Possible causes:**
1. Consumer key is incorrect
2. Private key doesn't match the consumer key
3. Signature generation is incorrect

**Solution:**
- Verify consumer key and private key are correct
- Ensure private key matches the consumer key
- Check that the signature method is RSA-SHA1

### Error: "400 Bad Request" or "422 Unprocessable Entity"

**Possible causes:**
1. Missing required query parameters
2. Invalid parameter values
3. Parameter encoding issues

**Solution:**
- Ensure all required parameters are provided
- Verify parameter values are correct
- Check parameter encoding (URL encoding is handled automatically)

## Security Notes

⚠️ **Important Security Considerations:**

1. **Never commit credentials to version control**
   - Keep `api-config.js` with placeholder values in git
   - Use environment variables or secure credential storage for actual keys

2. **Private Key Security**
   - Store private keys securely
   - Use environment variables or secure vaults
   - Never log or print private keys

3. **Configuration Management**
   - Use different credentials for different environments
   - Consider using `.env` files (not tracked in git) for local development

## Environment Variables (Alternative)

You can also use environment variables instead of hardcoding in config files:

```javascript
// In api-config.js
mastercardConsumerKey: karate.env['MASTERCARD_CONSUMER_KEY'] || 'your-consumer-key-here',
mastercardPrivateKey: karate.env['MASTERCARD_PRIVATE_KEY'] || 'your-private-key-here'
```

Then set environment variables:
```bash
export MASTERCARD_CONSUMER_KEY="your-actual-key"
export MASTERCARD_PRIVATE_KEY="your-actual-key"
```

## Additional Resources

- [OAuth 1.0 Specification](https://tools.ietf.org/html/rfc5849)
- [Mastercard API Documentation](https://developer.mastercard.com/)
- [RSA-SHA1 Signature](https://tools.ietf.org/html/rfc3447)

