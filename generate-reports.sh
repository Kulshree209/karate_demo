#!/bin/bash
# Script to generate and copy test reports

echo "Running tests and generating reports..."
mvn clean test surefire-report:report

echo "Copying test reports to reports/ directory..."
mkdir -p reports/surefire-reports

# Copy XML reports
if [ -d "target/surefire-reports" ]; then
    cp -r target/surefire-reports/* reports/surefire-reports/ 2>/dev/null || true
fi

# Copy HTML reports
if [ -d "target/site/surefire-report.html" ]; then
    mkdir -p reports/html
    cp target/site/surefire-report.html reports/html/ 2>/dev/null || true
fi

# Generate summary
echo "Generating test summary..."
cat > reports/test-summary.txt << EOF
Test Execution Summary
======================
Generated: $(date)

To view HTML reports, open: reports/surefire-reports/index.html
XML reports are available in: reports/surefire-reports/

EOF

# Count test results
if [ -f "reports/surefire-reports/TEST-TestSuite.xml" ] || [ -f "reports/surefire-reports/testng-results.xml" ]; then
    echo "Test reports generated successfully!"
    echo "Reports location: reports/surefire-reports/"
else
    echo "Warning: Some test reports may not have been generated."
fi

