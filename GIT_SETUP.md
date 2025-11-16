# Git Setup and Push Guide

## Initial Setup (if not already done)

1. **Add remote repository** (if you have a remote repo):
   ```bash
   git remote add origin <your-repo-url>
   ```

2. **Or create a new repository on GitHub/GitLab** and then:
   ```bash
   git remote add origin https://github.com/yourusername/karate-project.git
   ```

## Committing and Pushing Code with Test Reports

### Step 1: Generate Test Reports
```bash
./generate-reports.sh
```

### Step 2: Stage All Files
```bash
git add .
```

### Step 3: Commit Changes
```bash
git commit -m "Initial commit: Karate test framework with test reports

- Added API test scenarios (41 scenarios)
- Added API schema validation (14 scenarios)
- Added database validation (12 scenarios)
- Added database schema validation (16 scenarios)
- Configured TestNG test runner
- Added test report generation
- Total: 83 test scenarios, all passing"
```

### Step 4: Push to Remote
```bash
# If this is the first push
git push -u origin main

# For subsequent pushes
git push
```

## Quick Push Script

You can also use this one-liner to generate reports, commit, and push:

```bash
./generate-reports.sh && git add . && git commit -m "Update test reports" && git push
```

## Branch Management

To work on a feature branch:
```bash
git checkout -b feature/your-feature-name
# Make changes
./generate-reports.sh
git add .
git commit -m "Your commit message"
git push -u origin feature/your-feature-name
```

## Viewing Test Reports

After pushing, test reports will be available in the `reports/` directory in your repository.
Team members can view them directly from the repository or clone and open locally.

