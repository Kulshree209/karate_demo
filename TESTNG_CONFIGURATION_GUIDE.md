# TestNG Configuration Guide

## Overview

TestNG configuration can be done in two ways:
1. **testng.xml file** - XML configuration file for test suites
2. **IntelliJ Run Configuration** - GUI-based configuration in IntelliJ IDEA

---

## Method 1: Create/Edit testng.xml File

### Current testng.xml Location
`/Users/kulshreepatil/Downloads/karate_project/testng.xml`

### Basic testng.xml Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Karate Test Suite" parallel="methods" thread-count="5">
    <test name="API Tests">
        <classes>
            <class name="com.example.karate.TestRunner">
                <methods>
                    <include name="testApiScenarios"/>
                    <include name="testApiSchemaValidation"/>
                </methods>
            </class>
        </classes>
    </test>
    
    <test name="Database Tests">
        <classes>
            <class name="com.example.karate.TestRunner">
                <methods>
                    <include name="testDatabaseValidation"/>
                    <include name="testDatabaseSchemaValidation"/>
                </methods>
            </class>
        </classes>
    </test>
    
    <test name="Mastercard API Tests">
        <classes>
            <class name="com.example.karate.TestRunner">
                <methods>
                    <include name="testMastercardLocationsMatches"/>
                </methods>
            </class>
        </classes>
    </test>
    
    <test name="All Tests">
        <classes>
            <class name="com.example.karate.TestRunner">
                <methods>
                    <include name="testAll"/>
                </methods>
            </class>
        </classes>
    </test>
</suite>
```

### TestNG XML Configuration Options

#### Suite Level Options

```xml
<suite name="My Test Suite" 
       parallel="methods|tests|classes|instances" 
       thread-count="5"
       verbose="1"
       time-out="10000">
```

- **name**: Suite name
- **parallel**: Parallel execution mode
  - `methods` - Run test methods in parallel
  - `tests` - Run tests in parallel
  - `classes` - Run classes in parallel
  - `instances` - Run instances in parallel
- **thread-count**: Number of threads for parallel execution
- **verbose**: Verbosity level (0-10)
- **time-out**: Default timeout in milliseconds

#### Test Level Options

```xml
<test name="API Tests" 
      parallel="methods" 
      thread-count="3"
      preserve-order="true">
```

- **name**: Test name
- **parallel**: Parallel execution for this test
- **thread-count**: Threads for this test
- **preserve-order**: Maintain execution order

#### Class Level Options

```xml
<class name="com.example.karate.TestRunner">
    <methods>
        <include name="testMethod1"/>
        <include name="testMethod2"/>
        <exclude name="testMethod3"/>
    </methods>
</class>
```

- **include**: Include specific methods
- **exclude**: Exclude specific methods

#### Method Level Options

```xml
<methods>
    <include name="testApiScenarios"/>
    <exclude name="testDatabaseValidation"/>
</methods>
```

---

## Method 2: Create TestNG Run Configuration in IntelliJ

### Step-by-Step Guide

#### Option A: Create from Test Class

1. **Open TestRunner.java**
2. **Right-click on the class name** (`TestRunner`)
3. Select **`Run 'TestRunner'`** or **`Debug 'TestRunner'`**
4. IntelliJ will automatically create a TestNG run configuration

#### Option B: Create from Test Method

1. **Open TestRunner.java**
2. **Right-click on a test method** (e.g., `testApiScenarios()`)
3. Select **`Run 'testApiScenarios()'`** or **`Debug 'testApiScenarios()'`**
4. IntelliJ will create a TestNG run configuration for that method

#### Option C: Create Manually

1. **Go to Run Menu:**
   - `Run` → `Edit Configurations...`
   - Or click the dropdown next to Run button → `Edit Configurations...`

2. **Add New Configuration:**
   - Click the `+` button (top left)
   - Select **`TestNG`**

3. **Configure TestNG:**
   - **Name**: Give it a name (e.g., "TestNG - All API Tests")
   - **Test kind**: Choose one:
     - `Class` - Run all tests in a class
     - `Method` - Run a specific method
     - `Suite` - Run from testng.xml file
     - `Group` - Run tests by group
     - `Package` - Run all tests in a package
   
4. **For Class:**
   - **Class**: `com.example.karate.TestRunner`
   - **Method**: (leave empty to run all methods, or select specific method)

5. **For Method:**
   - **Class**: `com.example.karate.TestRunner`
   - **Method**: `testApiScenarios` (select from dropdown)

6. **For Suite (testng.xml):**
   - **Suite**: Browse and select `testng.xml` file
   - Or enter path: `$MODULE_DIR$/testng.xml`

7. **Additional Options:**
   - **VM options**: (optional) Add JVM arguments
   - **Working directory**: `$MODULE_DIR$` (default)
   - **Use classpath of module**: Select your module

8. **Click OK**

### Run Configuration Examples

#### Example 1: Run Single Test Method

```
Name: TestNG - testApiScenarios
Test kind: Method
Class: com.example.karate.TestRunner
Method: testApiScenarios
```

#### Example 2: Run All Tests in Class

```
Name: TestNG - TestRunner (All Tests)
Test kind: Class
Class: com.example.karate.TestRunner
```

#### Example 3: Run from testng.xml

```
Name: TestNG - Run testng.xml
Test kind: Suite
Suite: $MODULE_DIR$/testng.xml
```

#### Example 4: Run by Group

```
Name: TestNG - API Group
Test kind: Group
Groups: api
```

---

## Method 3: Using testng.xml in Maven

Your `pom.xml` is already configured to use `testng.xml`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0</version>
    <configuration>
        <suiteXmlFiles>
            <suiteXmlFile>testng.xml</suiteXmlFile>
        </suiteXmlFiles>
    </configuration>
</plugin>
```

### Run with Maven:

```bash
# Run all tests from testng.xml
mvn test

# Run specific test method
mvn test -Dtest=TestRunner#testApiScenarios

# Run with specific testng.xml
mvn test -Dsurefire.suiteXmlFiles=testng.xml
```

---

## Advanced TestNG Configuration

### Groups

Add groups to your test methods:

```java
@Test(groups = {"api", "smoke"})
public void testApiScenarios() {
    // ...
}

@Test(groups = {"database", "integration"})
public void testDatabaseValidation() {
    // ...
}
```

Then in testng.xml:

```xml
<test name="Smoke Tests">
    <groups>
        <run>
            <include name="smoke"/>
        </run>
    </groups>
    <classes>
        <class name="com.example.karate.TestRunner"/>
    </classes>
</test>
```

### Parameters

Pass parameters from testng.xml:

```xml
<test name="Parameterized Tests">
    <parameter name="baseUrl" value="https://api.example.com"/>
    <parameter name="timeout" value="5000"/>
    <classes>
        <class name="com.example.karate.TestRunner"/>
    </classes>
</test>
```

Use in test:

```java
@Test
@Parameters({"baseUrl", "timeout"})
public void testWithParameters(String baseUrl, int timeout) {
    // Use parameters
}
```

### Listeners

Add listeners in testng.xml:

```xml
<suite name="My Suite" listeners="com.example.MyListener">
    <!-- tests -->
</suite>
```

Or in Java:

```java
@Listeners(MyListener.class)
public class TestRunner {
    // ...
}
```

---

## Common TestNG Configuration Scenarios

### Scenario 1: Run Only API Tests

**testng.xml:**
```xml
<suite name="API Test Suite">
    <test name="API Tests">
        <classes>
            <class name="com.example.karate.TestRunner">
                <methods>
                    <include name="testApiScenarios"/>
                    <include name="testApiSchemaValidation"/>
                </methods>
            </class>
        </classes>
    </test>
</suite>
```

### Scenario 2: Run Tests in Parallel

**testng.xml:**
```xml
<suite name="Parallel Tests" parallel="methods" thread-count="5">
    <test name="All Tests">
        <classes>
            <class name="com.example.karate.TestRunner"/>
        </classes>
    </test>
</suite>
```

### Scenario 3: Run Tests Sequentially

**testng.xml:**
```xml
<suite name="Sequential Tests" parallel="false">
    <test name="All Tests" preserve-order="true">
        <classes>
            <class name="com.example.karate.TestRunner"/>
        </classes>
    </test>
</suite>
```

### Scenario 4: Run by Tags/Groups

**testng.xml:**
```xml
<suite name="Group Tests">
    <test name="API Group">
        <groups>
            <run>
                <include name="api"/>
            </run>
        </groups>
        <classes>
            <class name="com.example.karate.TestRunner"/>
        </classes>
    </test>
</suite>
```

---

## Running TestNG Configurations

### From IntelliJ:

1. **Select Configuration:**
   - Click the dropdown next to Run button
   - Select your TestNG configuration

2. **Run:**
   - Click Run button (▶️)
   - Or press `Shift+F10`

3. **Debug:**
   - Click Debug button (🐛)
   - Or press `Shift+F9`

### From Command Line:

```bash
# Run testng.xml
mvn test

# Run specific test method
mvn test -Dtest=TestRunner#testApiScenarios

# Run with custom testng.xml
mvn test -Dsurefire.suiteXmlFiles=custom-testng.xml
```

### From testng.xml directly:

```bash
# If TestNG is in classpath
java -cp "target/test-classes:target/classes:$HOME/.m2/repository/..." org.testng.TestNG testng.xml
```

---

## Troubleshooting

### Issue 1: testng.xml Not Found

**Solution:**
- Ensure `testng.xml` is in project root
- Check path in `pom.xml` matches file location
- Use absolute path: `$MODULE_DIR$/testng.xml`

### Issue 2: Tests Not Running

**Solution:**
- Check TestNG plugin is installed in IntelliJ
- Verify test methods have `@Test` annotation
- Check class/method names match exactly

### Issue 3: Configuration Not Saving

**Solution:**
- Click `Apply` before `OK` in Edit Configurations
- Check `.idea/runConfigurations/` folder exists
- Restart IntelliJ

---

## Quick Reference

| Configuration Type | Use Case | Location |
|-------------------|----------|----------|
| testng.xml | CI/CD, Maven builds | Project root |
| IntelliJ Run Config | Development, debugging | `.idea/runConfigurations/` |
| Maven command | Quick runs, scripts | Command line |

---

## Summary

1. **testng.xml** - Best for CI/CD and Maven builds
2. **IntelliJ Run Configuration** - Best for development and debugging
3. **Maven commands** - Best for quick test runs

Your project already has a `testng.xml` file configured. You can:
- Edit it to customize test execution
- Create IntelliJ run configurations for easier development
- Use Maven commands for quick runs

