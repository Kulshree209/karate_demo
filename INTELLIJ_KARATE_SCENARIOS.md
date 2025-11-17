# Running Individual Karate Scenarios in IntelliJ IDEA

## Why You Don't See Run Options on Scenarios

IntelliJ IDEA doesn't natively recognize Karate `.feature` files as test files, so you won't see green "run" arrows (▶️) next to individual scenarios by default.

## Solutions

### Solution 1: Install Karate Plugin for IntelliJ (Recommended)

The Karate plugin adds support for running scenarios directly from feature files.

#### Installation Steps:

1. **Open IntelliJ Settings:**
   - `File` → `Settings` (Windows/Linux) or `IntelliJ IDEA` → `Preferences` (Mac)
   - Go to `Plugins`

2. **Install Karate Plugin:**
   - Click `Marketplace` tab
   - Search for "Karate"
   - Look for "Karate" by Intuit (official plugin)
   - Click `Install`
   - Restart IntelliJ

3. **After Installation:**
   - You should see green arrows (▶️) next to each `Scenario:` line
   - Right-click on any scenario → `Run 'Scenario: ...'`
   - Or click the green arrow next to the scenario name

#### Plugin Features:
- Run individual scenarios
- Run entire feature files
- Debug scenarios
- View test results
- Syntax highlighting for Gherkin

### Solution 2: Use Tags (Current Method - Works Without Plugin)

This is the method you're currently using and it works well.

#### Step 1: Add Unique Tags to Scenarios

In your feature file, add unique tags:

```gherkin
@single @getAllPosts
Scenario: GET request - Retrieve all posts with 200 OK status
  Given path 'posts'
  When method GET
  Then status 200
```

#### Step 2: Create Test Method in TestRunner.java

```java
@Test
public void testGetAllPosts() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@getAllPosts")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

#### Step 3: Run from IntelliJ

- Click green arrow next to `testGetAllPosts()` method
- Or right-click → `Run 'testGetAllPosts()'`

### Solution 3: Use Scenario Name Pattern

You can also run scenarios by name pattern:

```java
@Test
public void testSpecificScenario() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@api")
            .scenarioName("GET request - Retrieve all posts with 200 OK status")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

### Solution 4: Quick Test Method Generator

Create a helper method in TestRunner.java for quick scenario testing:

```java
@Test
public void testScenarioByTag() {
    // Change the tag to run different scenarios
    String tag = "@getAllPosts"; // Change this tag
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags(tag)
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

Then just change the `tag` variable and run.

### Solution 5: Use Maven from IntelliJ Terminal

1. Open Terminal in IntelliJ: `View` → `Tool Windows` → `Terminal`
2. Run with specific tag:
   ```bash
   mvn test -Dtest=TestRunner#testSingleScenario
   ```
3. Or create a Maven run configuration (see below)

### Solution 6: Create Maven Run Configuration for Quick Testing

1. `Run` → `Edit Configurations`
2. Click `+` → `Maven`
3. Configure:
   - **Name:** `Run Single Scenario`
   - **Working directory:** `$MODULE_DIR$`
   - **Command line:** `test -Dtest=TestRunner#testSingleScenario`
4. Click `OK`
5. Now you can quickly run from the dropdown

## Recommended Approach

### For Development (Quick Testing):
1. **Install Karate Plugin** (Solution 1) - Best experience
2. Or use **Solution 4** (Quick Test Method) - Change tag and run

### For CI/CD and Production:
- Use **Solution 2** (Tags with TestRunner methods) - More maintainable

## Adding Tags to Your Scenarios

To make scenarios easily runnable, add unique tags:

```gherkin
@api @getAllPosts
Scenario: GET request - Retrieve all posts with 200 OK status
  ...

@api @getPostById
Scenario: GET request - Retrieve specific post by ID
  ...

@api @createPost
Scenario: POST request - Create a new post
  ...
```

Then create corresponding test methods:

```java
@Test
public void testGetAllPosts() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@getAllPosts")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}

@Test
public void testGetPostById() {
    Results results = Runner.path("classpath:api/api-scenarios.feature")
            .tags("@getPostById")
            .parallel(1);
    assertEquals(results.getFailCount(), 0, results.getErrorMessages());
}
```

## Troubleshooting

### Plugin Not Showing Run Arrows

1. **Restart IntelliJ** after installing plugin
2. **Invalidate Caches:** `File` → `Invalidate Caches / Restart` → `Invalidate and Restart`
3. **Check Plugin is Enabled:** `Settings` → `Plugins` → Ensure "Karate" is checked
4. **Re-import Project:** `File` → `Invalidate Caches` → `Invalidate and Restart`

### Tags Not Working

1. Ensure tags are on the line **above** `Scenario:`
2. Tags should start with `@`
3. Multiple tags: `@tag1 @tag2`
4. Rebuild project: `Build` → `Rebuild Project`

### Test Methods Not Found

1. Ensure `src/test/java` is marked as **Test Sources Root**
2. Ensure `src/test/resources` is marked as **Test Resources Root**
3. Rebuild: `Build` → `Rebuild Project`

## Quick Reference

| Method | Pros | Cons |
|--------|------|------|
| Karate Plugin | Direct scenario execution, best UX | Requires plugin installation |
| Tags + TestRunner | No plugin needed, CI/CD friendly | Need to create test methods |
| Maven Command | Always works, flexible | Command line only |
| Scenario Name | No tags needed | Less flexible |

## Summary

**The reason you don't see run options:** IntelliJ doesn't natively support Karate feature files.

**Best solution:** Install the Karate plugin for the best experience, or use tags with TestRunner methods for a plugin-free approach.

