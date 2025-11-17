# Quick Fix: Running Schema Validation Tests in IntelliJ

## The Problem
Tests run fine via Maven but not via IntelliJ TestNG runner.

## Quick Solutions (Try in Order)

### Solution 1: Install/Enable TestNG Plugin (Most Common Fix)

1. **Check if TestNG is installed:**
   - `File` → `Settings` (Windows/Linux) or `IntelliJ IDEA` → `Preferences` (Mac)
   - Go to `Plugins`
   - Search for "TestNG"
   - If not installed, click `Install` and restart IntelliJ

2. **After restart, try running:**
   - Click the green arrow (▶️) next to `testApiSchemaValidation()` method
   - Or right-click the method → `Run 'testApiSchemaValidation()'`

### Solution 2: Use Pre-configured Run Configurations

I've created run configurations for you. After restarting IntelliJ:

1. Look at the top toolbar for the run configuration dropdown
2. You should see:
   - `TestNG - testApiSchemaValidation`
   - `TestNG - testDatabaseSchemaValidation`
3. Select one and click Run (▶️)

### Solution 3: Create Run Configuration Manually

1. **Right-click on `testApiSchemaValidation()` method**
2. Select `Run 'testApiSchemaValidation()'`
3. If it doesn't work, go to `Run` → `Edit Configurations`
4. Click `+` → `TestNG`
5. Configure:
   - **Name:** `testApiSchemaValidation`
   - **Test kind:** `Method`
   - **Class:** `com.example.karate.TestRunner`
   - **Method:** `testApiSchemaValidation`
6. Click `OK` and run

### Solution 4: Mark Directories Correctly

1. **Right-click `src/test/java` folder**
   - Select `Mark Directory as` → `Test Sources Root`
2. **Right-click `src/test/resources` folder**
   - Select `Mark Directory as` → `Test Resources Root`
3. **Rebuild:** `Build` → `Rebuild Project`

### Solution 5: Use Maven Runner (Always Works)

If IntelliJ TestNG runner still doesn't work, use Maven:

1. **Open Terminal in IntelliJ** (View → Tool Windows → Terminal)
2. **Run:**
   ```bash
   mvn test -Dtest=TestRunner#testApiSchemaValidation
   ```

Or create a Maven run configuration:
1. `Run` → `Edit Configurations`
2. Click `+` → `Maven`
3. **Name:** `Run Schema Validation`
4. **Command line:** `test -Dtest=TestRunner#testApiSchemaValidation`
5. Click `OK` and run

### Solution 6: Invalidate Caches

If nothing works:

1. `File` → `Invalidate Caches / Restart`
2. Select `Invalidate and Restart`
3. Wait for IntelliJ to restart and re-index
4. Try running the test again

## Verification

After applying a solution, you should see:
- Green arrow (▶️) next to the test method
- Test runs and shows results in the Run window
- 14 scenarios pass for `testApiSchemaValidation`
- 16 scenarios pass for `testDatabaseSchemaValidation`

## Still Not Working?

The tests are confirmed working via Maven. If IntelliJ still doesn't work:
1. Use Maven run configuration (Solution 5) - it always works
2. Check IntelliJ version - ensure you're using a recent version
3. Check for IntelliJ updates: `Help` → `Check for Updates`

## Test Results Expected

When `testApiSchemaValidation` runs successfully, you should see:
```
scenarios: 14 | passed: 14 | failed: 0
```

When `testDatabaseSchemaValidation` runs successfully, you should see:
```
scenarios: 16 | passed: 16 | failed: 0
```

