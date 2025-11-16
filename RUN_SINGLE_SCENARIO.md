# How to Run a Single Scenario from Feature File

There are several ways to run a single scenario in Karate. Here are the most common methods:

## Method 1: Using Tags (Recommended)

### Step 1: Add a unique tag to your scenario

In your feature file, add a unique tag above the scenario:

```gherkin
@single @getAllPosts
Scenario: GET request - Retrieve all posts with 200 OK status
  Given path 'posts'
  When method GET
  Then status 200
```

### Step 2: Run using the tag

**Option A: Add a test method in TestRunner.java**

```java
@Test
public void testSingleScenario() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@getAllPosts")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

Then run:
```bash
mvn test "-Dtest=TestRunner#testSingleScenario"
```

**Option B: Run from command line using Maven**

```bash
mvn test "-Dkarate.options=--tags @getAllPosts"
```

**Option C: Run using Karate CLI**

```bash
mvn test "-Dkarate.options=classpath:api/api-scenarios.feature --tags @getAllPosts"
```

## Method 2: Using Scenario Name Pattern

### In TestRunner.java:

```java
@Test
public void testScenarioByName() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@api")
            .scenarioName("GET request - Retrieve specific post by ID")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

Run:
```bash
mvn test "-Dtest=TestRunner#testScenarioByName"
```

## Method 3: Using Command Line with Scenario Name

```bash
mvn test "-Dkarate.options=classpath:api/api-scenarios.feature --name 'GET request - Retrieve all posts'"
```

## Method 4: Using Multiple Tags (AND condition)

To run scenarios that match multiple tags:

```java
@Test
public void testMultipleTags() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@api", "@single")  // Must have both tags
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

## Method 5: Excluding Tags (NOT condition)

To run all scenarios except those with a specific tag:

```java
@Test
public void testExcludeTag() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@api", "~@ignore")  // @api AND NOT @ignore
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

## Quick Examples

### Example 1: Run scenario with tag @getAllPosts
```bash
mvn test "-Dtest=TestRunner#testSingleScenario"
```

### Example 2: Run by scenario name
```bash
mvn test "-Dtest=TestRunner#testScenarioByName"
```

### Example 3: Run directly with Karate options
```bash
mvn test "-Dkarate.options=--tags @getAllPosts classpath:api/api-scenarios.feature"
```

## Best Practices

1. **Use descriptive tags**: Use meaningful tag names like `@getAllPosts`, `@createUser`, etc.
2. **Tag naming convention**: Consider using prefixes like `@smoke`, `@regression`, `@api`, etc.
3. **Combine tags**: Use multiple tags for better filtering (e.g., `@api @smoke`)
4. **Document tags**: Keep a list of available tags in your README

## Tag Examples in Feature Files

```gherkin
@api @smoke @getAllPosts
Scenario: GET request - Retrieve all posts with 200 OK status
  ...

@api @regression @createPost
Scenario: POST request - Create a new post with 201 Created status
  ...

@api @negative @notFound
Scenario: GET request - Non-existent resource returns 404 Not Found
  ...
```

Then you can run:
- All smoke tests: `--tags @smoke`
- All regression tests: `--tags @regression`
- Specific scenario: `--tags @getAllPosts`
- Smoke + API: `--tags @smoke @api`

## Troubleshooting

**Scenario not found?**
- Check tag spelling (case-sensitive)
- Ensure tag is above the `Scenario:` line
- Verify the feature file path is correct

**Multiple scenarios running?**
- Use more specific tags
- Combine tags for AND condition
- Use scenario name pattern for exact match

