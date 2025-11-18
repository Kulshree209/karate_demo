# Fix: Karate Plugin Asking for Sign-In

## Issue
The Karate plugin is asking for sign-in, which shouldn't happen with the official free plugin.

## Solution 1: Use Cucumber for Java Plugin (Recommended - No Sign-In Required)

The **Cucumber for Java** plugin by JetBrains works perfectly with Karate feature files and is completely free with no sign-in required.

### Installation Steps:

1. **Open IntelliJ Settings:**
   - `File` → `Settings` (Windows/Linux) or `IntelliJ IDEA` → `Preferences` (Mac)
   - Or press `Ctrl+Alt+S` (Windows/Linux) / `Cmd+,` (Mac)

2. **Go to Plugins:**
   - Click `Plugins` in the left sidebar
   - Click the `Marketplace` tab

3. **Install Cucumber for Java:**
   - Search for **"Cucumber for Java"**
   - Look for **"Cucumber for Java"** by **JetBrains** (official, free plugin)
   - Click `Install`
   - Click `Apply` and `OK`
   - **Restart IntelliJ** when prompted

4. **After Restart:**
   - Open any `.feature` file
   - You should see green arrows (▶️) next to scenarios
   - Right-click on scenario → `Run 'Scenario: ...'`

### Why Cucumber Plugin Works:
- Karate uses Gherkin syntax (same as Cucumber)
- Cucumber plugin recognizes `.feature` files
- No additional configuration needed
- Completely free, no sign-in required

---

## Solution 2: Verify You're Installing the Correct Plugin

If you still want to try the Karate plugin, make sure you're installing the correct one:

### Correct Plugin:
- **Name:** "Karate"
- **Publisher:** Intuit
- **Free:** Yes
- **Sign-in Required:** No

### How to Find It:
1. In IntelliJ Marketplace, search for "Karate"
2. Look for the one by **Intuit** (the official one)
3. It should show as **FREE** with no sign-in requirement
4. Avoid any plugins that say "Premium" or require authentication

---

## Solution 3: Install Plugin Manually (If Marketplace Doesn't Work)

If the Marketplace version requires sign-in, you can try installing manually:

1. **Download from JetBrains Plugin Repository:**
   - Go to: https://plugins.jetbrains.com/plugin/19232-karate
   - Download the `.zip` file

2. **Install from Disk:**
   - `File` → `Settings` → `Plugins`
   - Click the ⚙️ gear icon → `Install Plugin from Disk...`
   - Select the downloaded `.zip` file
   - Restart IntelliJ

---

## Solution 4: Use Cucumber for Java (Easiest - Recommended)

**This is the easiest solution and works perfectly:**

1. Install **"Cucumber for Java"** by JetBrains (free, no sign-in)
2. It will recognize all your `.feature` files
3. You can right-click and run scenarios
4. No additional configuration needed

---

## Quick Comparison

| Plugin | Publisher | Free | Sign-In | Works with Karate |
|--------|-----------|------|---------|-------------------|
| **Cucumber for Java** | JetBrains | ✅ Yes | ❌ No | ✅ Yes (Recommended) |
| Karate | Intuit | ✅ Yes | ❌ No (shouldn't) | ✅ Yes |
| Other Karate plugins | Various | ⚠️ Maybe | ⚠️ Maybe | ⚠️ Maybe |

---

## Recommended Action

**Install "Cucumber for Java" by JetBrains:**
- It's the official JetBrains plugin
- Completely free
- No sign-in required
- Works perfectly with Karate feature files
- Most reliable option

---

## After Installation

Once you install Cucumber for Java:

1. **Restart IntelliJ**
2. **Open a feature file** (e.g., `mastercard-locations-matches.feature`)
3. **You should see:**
   - Green arrows (▶️) next to `Scenario:` lines
   - Green arrow next to `Feature:` line
   - Syntax highlighting

4. **To run:**
   - Right-click on scenario → `Run 'Scenario: ...'`
   - Right-click on feature → `Run 'Feature: ...'`
   - Or click the green arrow

---

## Still Having Issues?

If Cucumber for Java doesn't work:

1. **Check IntelliJ Version:**
   - Cucumber for Java requires IntelliJ IDEA 2019.3 or later
   - `Help` → `About` to check version

2. **Update IntelliJ:**
   - `Help` → `Check for Updates`
   - Update to latest version

3. **Alternative: Continue Using TestRunner.java**
   - Your current method (using TestRunner.java with tags) works perfectly
   - No plugin needed
   - Just add tags to scenarios and create test methods

---

## Summary

**Best Solution:** Install **"Cucumber for Java"** by JetBrains
- Free, no sign-in
- Works with Karate
- Official JetBrains plugin
- Most reliable

**If that doesn't work:** Continue using your current method with TestRunner.java - it works great!

