# Using Examples Table in Karate Feature Files

## Overview

The Examples table allows you to run the same scenario with different test data sets. This is perfect for data-driven testing.

## Current Implementation

The `mastercard-locations-matches.feature` file now uses a **Scenario Outline** with an **Examples** table.

## How It Works

### Scenario Outline Structure

```gherkin
Scenario Outline: Get location matches with valid query parameters
  Given path 'small-business', 'credit-analytics', 'locations', 'matches'
  And param company_name = '<company_name>'
  And param street_address = '<street_address>'
  # ... other parameters using <placeholder> syntax
  
  Examples:
    | company_name | street_address | ... | expected_status |
    | KIDPRENEURS  | 312 WCAREFREEHWYSU | ... | 403 |
    | YourCompany  | 123 Main St | ... | 200 |
```

### Key Points

1. **Scenario Outline** - Use this instead of `Scenario` when you want to use Examples table
2. **Placeholders** - Use `<column_name>` syntax to reference table columns
3. **Examples Table** - Define your test data in a table format
4. **Multiple Rows** - Each row in the Examples table runs as a separate test execution

## Adding More Test Data

### Example 1: Add Another Aggregated Merchant

```gherkin
Examples:
  | company_name | street_address      | state_province_region | postal_code | country_code | city     | expected_status |
  | KIDPRENEURS  | 312 WCAREFREEHWYSU | AZ                    | 85086       | USA          | Pheonix  | 403             |
  | BIGCORP      | 500 Corporate Blvd | NY                    | 10001       | USA          | New York | 403             |
```

### Example 2: Add Valid Small Business (200 Response)

```gherkin
Examples:
  | company_name | street_address      | state_province_region | postal_code | country_code | city     | expected_status |
  | KIDPRENEURS  | 312 WCAREFREEHWYSU | AZ                    | 85086       | USA          | Pheonix  | 403             |
  | LocalShop    | 123 Main Street    | CA                    | 90210       | USA          | Beverly Hills | 200 |
```

### Example 3: Multiple Test Cases

```gherkin
Examples:
  | company_name | street_address      | state_province_region | postal_code | country_code | city     | expected_status |
  | KIDPRENEURS  | 312 WCAREFREEHWYSU | AZ                    | 85086       | USA          | Pheonix  | 403             |
  | LocalShop    | 123 Main Street    | CA                    | 90210       | USA          | Beverly Hills | 200 |
  | SmallBiz     | 456 Oak Avenue     | TX                    | 75001       | USA          | Dallas   | 200 |
  | ChainStore   | 789 Chain Road     | FL                    | 33101       | USA          | Miami    | 403             |
```

## Benefits

1. **Easy to Add Test Data** - Just add rows to the table
2. **Clear Test Cases** - Each row represents a test case
3. **Maintainable** - All test data in one place
4. **Reusable** - Same scenario logic for all test data

## Running Tests

The scenario will run once for each row in the Examples table:

```bash
mvn test -Dtest=TestRunner#testMastercardLocationsMatches
```

If you have 3 rows in the Examples table, the scenario will execute 3 times with different data.

## Tips

1. **Column Names** - Must match the placeholders exactly (case-sensitive)
2. **Data Types** - Numbers don't need quotes, strings can be with or without quotes
3. **Empty Values** - Use empty cells for optional parameters
4. **Comments** - Use `#` for comments in the Examples table

## Example with Comments

```gherkin
Examples:
  | company_name | street_address      | state_province_region | postal_code | country_code | city     | expected_status |
  # Aggregated merchant - will return 403
  | KIDPRENEURS  | 312 WCAREFREEHWYSU | AZ                    | 85086       | USA          | Pheonix  | 403             |
  # Valid small business - will return 200
  | LocalShop    | 123 Main Street    | CA                    | 90210       | USA          | Beverly Hills | 200 |
```

## Current Test Data

The current Examples table includes:
- **KIDPRENEURS** - Aggregated merchant (returns 403)

To test successful responses (200), add rows with valid small/medium business merchants.

