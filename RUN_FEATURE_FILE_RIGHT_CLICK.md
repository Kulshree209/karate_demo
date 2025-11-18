# Running Karate Feature Files with Right-Click in IntelliJ

## Quick Setup Guide

To enable right-click execution on `.feature` files in IntelliJ, you need to install the **Karate Plugin** or **Cucumber for Java Plugin**.

---

## Method 1: Install Karate Plugin (Recommended for Karate)

### Step 1: Install the Plugin

1. **Open IntelliJ Settings:**
   - `File` → `Settings` (Windows/Linux) 
   - OR `IntelliJ IDEA` → `Preferences` (Mac)
   - OR Press `Ctrl+Alt+S` (Windows/Linux) / `Cmd+,` (Mac)

2. **Go to Plugins:**
   - Click on `Plugins` in the left sidebar

3. **Install Karate Plugin:**
   - Click the `Marketplace` tab
   - Search for **"Karate"**
   - Look for **"Karate"** by Intuit (official plugin)
   - Click `Install`
   - Wait for installation to complete
   - Click `Apply` and `OK`
   - **Restart IntelliJ** when prompted

### Step 2: Verify Installation

After restarting IntelliJ:

1. **Open any `.feature` file** (e.g., `mastercard-locations-matches.feature`)
2. You should see:
   - **Green arrows (▶️)** next to each `Scenario:` line
   - **Green arrow** next to `Feature:` line (to run entire feature)
   - Syntax highlighting for Gherkin keywords

### Step 3: Run Tests

**To run a single scenario:**
- Click the green arrow (▶️) next to the `Scenario:` line
- OR right-click on the scenario → `Run 'Scenario: ...'`
- OR right-click on the scenario → `Debug 'Scenario: ...'`

**To run entire feature file:**
- Click the green arrow (▶️) next to the `Feature:` line
- OR right-click on the feature name → `Run 'Feature: ...'`

**To run multiple scenarios:**
- Select multiple scenarios (hold `Ctrl`/`Cmd` and click)
- Right-click → `Run 'Scenarios'`

---

## Method 2: Install Cucumber for Java Plugin (Alternative)

If the Karate plugin doesn't work, try the Cucumber plugin:

### Step 1: Install Cucumber Plugin

1. **Open IntelliJ Settings:**
   - `File` → `Settings` (Windows/Linux) 
   - OR `IntelliJ IDEA` → `Preferences` (Mac)

2. **Go to Plugins:**
   - Click on `Plugins` in the left sidebar

3. **Install Cucumber Plugin:**
   - Click the `Marketplace` tab
   - Search for **"Cucumber for Java"**
   - Look for **"Cucumber for Java"** by JetBrains
   - Click `Install`
   - Wait for installation
   - Click `Apply` and `OK`
   - **Restart IntelliJ**

### Step 2: Configure Cucumber Plugin

After restart:

1. **Go to Settings:**
   - `File` → `Settings` → `Tools` → `Cucumber`

2. **Set Glue Code:**
   - Glue code location: `com.example.karate` (or your package)
   - This tells Cucumber where to find step definitions

3. **Set Feature Files Location:**
   - Feature files location: `src/test/resources`

### Step 3: Run Tests

- Right-click on any `.feature` file → `Run 'Feature: ...'`
- Right-click on any scenario → `Run 'Scenario: ...'`

---

## Method 3: Add Cucumber Dependency (If Needed)

If plugins don't work, you might need to add Cucumber dependency to `pom.xml`:

```xml
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-java</artifactId>
    <version>7.14.0</version>
    <scope>test</scope>
</dependency>
```

**Note:** Karate doesn't require Cucumber dependency, but the IntelliJ plugin might need it for recognition.

---

## Troubleshooting

### Issue 1: No Green Arrows After Installing Plugin

**Solution:**
1. **Invalidate Caches:**
   - `File` → `Invalidate Caches / Restart`
   - Select `Invalidate and Restart`
   - Wait for IntelliJ to restart and re-index

2. **Check Plugin is Enabled:**
   - `File` → `Settings` → `Plugins`
   - Ensure "Karate" or "Cucumber for Java" is checked/enabled

3. **Re-import Project:**
   - `File` → `Invalidate Caches / Restart` → `Invalidate and Restart`

### Issue 2: "No tests found" When Running

**Solution:**
1. **Check File Association:**
   - Right-click on `.feature` file → `Open With` → `Text` or `Gherkin`
   - Go to `File` → `Settings` → `Editor` → `File Types`
   - Find "Gherkin" or "Cucumber" file type
   - Ensure `.feature` extension is associated

2. **Mark Test Resources:**
   - Right-click `src/test/resources` folder
   - Select `Mark Directory as` → `Test Resources Root`

3. **Rebuild Project:**
   - `Build` → `Rebuild Project`

### Issue 3: Tests Run But Fail

**Solution:**
1. **Check Configuration:**
   - Ensure `karate-config.js` is in `src/test/resources`
   - Ensure `api-config.local.js` exists with credentials

2. **Check Run Configuration:**
   - `Run` → `Edit Configurations`
   - Find the feature file run configuration
   - Check "Working directory" is set to project root
   - Check "Use classpath of module" is selected

### Issue 4: Plugin Not Found in Marketplace

**Solution:**
1. **Check IntelliJ Version:**
   - Karate plugin requires IntelliJ IDEA 2020.1 or later
   - Cucumber plugin requires IntelliJ IDEA 2019.3 or later

2. **Update IntelliJ:**
   - `Help` → `Check for Updates`
   - Update to latest version

3. **Install Manually:**
   - Download plugin from JetBrains Plugin Repository
   - `File` → `Settings` → `Plugins` → `⚙️` → `Install Plugin from Disk`

---

## Recommended Setup

### For Best Experience:

1. **Install Karate Plugin** (Method 1) - Best for Karate projects
2. **Mark Directories:**
   - `src/test/java` → `Test Sources Root`
   - `src/test/resources` → `Test Resources Root`
3. **Invalidate Caches** after installation
4. **Rebuild Project**

### After Setup:

- ✅ Right-click on feature file → Run entire feature
- ✅ Right-click on scenario → Run single scenario
- ✅ Green arrows next to scenarios
- ✅ Debug support for scenarios
- ✅ Syntax highlighting for Gherkin

---

## Quick Reference

| Action | Method |
|--------|--------|
| Run entire feature | Right-click feature name → `Run 'Feature: ...'` |
| Run single scenario | Right-click scenario → `Run 'Scenario: ...'` |
| Debug scenario | Right-click scenario → `Debug 'Scenario: ...'` |
| Run multiple scenarios | Select scenarios → Right-click → `Run 'Scenarios'` |

---

## Alternative: Use TestRunner.java (Current Method)

If plugins don't work, you can continue using the current method:

1. **Add tags to scenarios:**
   ```gherkin
   @mastercard @test1
   Scenario: Get location matches
   ```

2. **Create test method in TestRunner.java:**
   ```java
   @Test
   public void testMastercardScenario1() {
       Results results = Runner.path("classpath:api/mastercard-locations-matches.feature")
               .tags("@test1")
               .parallel(1);
       assertEquals(results.getFailCount(), 0, results.getErrorMessages());
   }
   ```

3. **Run from TestRunner.java:**
   - Click green arrow next to test method
   - OR right-click method → `Run 'testMastercardScenario1()'`

---

## Summary

**To enable right-click on feature files:**
1. Install **Karate Plugin** (recommended) or **Cucumber for Java Plugin**
2. Restart IntelliJ
3. Invalidate caches if needed
4. Right-click on feature file or scenario → Run!

**If plugins don't work:**
- Continue using TestRunner.java with tags (current method)
- Or use Maven commands from terminal

