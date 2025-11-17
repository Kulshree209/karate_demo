# IntelliJ IDEA Setup Guide for Karate Tests

## Issue: Unable to Execute Schema Validation Tests from TestRunner.java

### Common Causes and Solutions

#### 1. TestNG Plugin Not Installed/Enabled

**Check:**
- Go to `File` → `Settings` (or `IntelliJ IDEA` → `Preferences` on Mac)
- Navigate to `Plugins`
- Search for "TestNG" and ensure it's installed and enabled

**Install if missing:**
- Click `Marketplace` tab
- Search for "TestNG"
- Click `Install` and restart IntelliJ

#### 2. TestNG Not Recognized as Test Framework

**Solution:**
1. Right-click on `TestRunner.java`
2. Select `Run 'TestRunner'` or `Debug 'TestRunner'`
3. If you see an error, go to `Run` → `Edit Configurations`
4. Check if TestNG is selected as the test framework
5. If not, delete the configuration and create a new one:
   - Click `+` → `TestNG`
   - Select `Class` or `Method`
   - Choose `TestRunner` class
   - Select the specific test method (e.g., `testApiSchemaValidation`)

#### 3. Running Individual Test Methods

**Method 1: Using Green Arrow**
- Click the green arrow next to the test method name
- Select `Run 'testApiSchemaValidation()'` or `Debug 'testApiSchemaValidation()'`

**Method 2: Right-Click Menu**
- Right-click on the test method name
- Select `Run 'testApiSchemaValidation()'`

**Method 3: Keyboard Shortcut**
- Place cursor on the test method
- Press `Ctrl+Shift+F10` (Windows/Linux) or `Ctrl+Shift+R` (Mac)

#### 4. TestNG Configuration File

Ensure `testng.xml` is recognized:
1. Right-click on `testng.xml`
2. Select `Run 'testng.xml'` or `Debug 'testng.xml'`

#### 5. Maven Configuration

**Check Maven Settings:**
1. Go to `File` → `Settings` → `Build, Execution, Deployment` → `Build Tools` → `Maven`
2. Ensure Maven is properly configured
3. Click `Maven` → `Reload Project` to refresh dependencies

#### 6. Project Structure

**Verify Test Sources:**
1. Right-click on `src/test/java` folder
2. Select `Mark Directory as` → `Test Sources Root`
3. Right-click on `src/test/resources` folder
4. Select `Mark Directory as` → `Test Resources Root`

#### 7. Run Configuration for Specific Test

**Create Custom Run Configuration:**
1. Go to `Run` → `Edit Configurations`
2. Click `+` → `TestNG`
3. Configure:
   - **Name:** `testApiSchemaValidation`
   - **Test kind:** `Method`
   - **Class:** `com.example.karate.TestRunner`
   - **Method:** `testApiSchemaValidation`
   - **VM options:** (leave empty or add if needed)
   - **Working directory:** `$MODULE_DIR$`
4. Click `OK` and run

#### 8. Alternative: Run via Maven

If IntelliJ TestNG runner doesn't work, use Maven:

**In IntelliJ Terminal:**
```bash
# Run specific test method
mvn test -Dtest=TestRunner#testApiSchemaValidation

# Run all schema validation tests
mvn test -Dtest=TestRunner#testApiSchemaValidation,TestRunner#testDatabaseSchemaValidation

# Run all tests
mvn test
```

**Or create Maven Run Configuration:**
1. Go to `Run` → `Edit Configurations`
2. Click `+` → `Maven`
3. Configure:
   - **Name:** `Run Schema Validation Tests`
   - **Working directory:** `$MODULE_DIR$`
   - **Command line:** `test -Dtest=TestRunner#testApiSchemaValidation`
4. Click `OK` and run

#### 9. Check for Errors

**View Test Results:**
- After running, check the `Run` tool window at the bottom
- Look for any error messages
- Check if tests are being skipped or failing

**Common Error Messages:**
- "No tests found" → Check if TestNG plugin is installed
- "Class not found" → Rebuild project (`Build` → `Rebuild Project`)
- "Method not found" → Ensure method is annotated with `@Test`

#### 10. Rebuild Project

If nothing works:
1. `Build` → `Rebuild Project`
2. `File` → `Invalidate Caches / Restart` → `Invalidate and Restart`
3. Wait for indexing to complete
4. Try running the test again

## Quick Troubleshooting Checklist

- [ ] TestNG plugin installed and enabled
- [ ] `src/test/java` marked as Test Sources Root
- [ ] `src/test/resources` marked as Test Resources Root
- [ ] Maven dependencies downloaded (check `External Libraries`)
- [ ] Project rebuilt successfully
- [ ] TestNG run configuration created
- [ ] No compilation errors in TestRunner.java

## Recommended IntelliJ Settings

1. **Enable TestNG:**
   - `File` → `Settings` → `Plugins` → Enable TestNG

2. **Test Runner:**
   - `File` → `Settings` → `Build, Execution, Deployment` → `Build Tools` → `Maven` → `Runner`
   - Ensure "Delegate IDE build/run actions to Maven" is checked (optional)

3. **Code Coverage:**
   - TestNG supports code coverage
   - Right-click test → `Run with Coverage`

## Still Having Issues?

If the test runs via Maven but not via IntelliJ TestNG runner:
1. Use Maven run configuration (see Method 8 above)
2. Or run from terminal: `mvn test -Dtest=TestRunner#testApiSchemaValidation`

The tests are working correctly (verified via Maven), so this is likely an IntelliJ configuration issue.

