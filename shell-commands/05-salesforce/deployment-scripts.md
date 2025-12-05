# Salesforce Deployment Scripts - Automation Patterns

Production-ready deployment automation for Salesforce projects.

---

## 📋 Overview

This guide provides complete deployment automation patterns for Salesforce, including validation, testing, rollback, and multi-org deployment strategies.

---

## Basic Deployment Scripts

### Script 1: Simple Deployment
```bash
#!/bin/bash
# basic-deploy.sh - Deploy to target org

ORG="${1:-dev}"

echo "Deploying to $ORG..."

sf project deploy start --target-org "$ORG"

if [ $? -eq 0 ]; then
    echo "✓ Deployment successful"
else
    echo "✗ Deployment failed"
    exit 1
fi
```

### Script 2: Deployment with Tests
```bash
#!/bin/bash
# deploy-with-tests.sh

ORG="${1:-dev}"

echo "=== Deploying to $ORG with test execution ==="

# Run tests first
echo "Running tests..."
sf apex run test --target-org "$ORG" --test-level RunLocalTests

if [ $? -ne 0 ]; then
    echo "✗ Tests failed, aborting deployment"
    exit 1
fi

# Deploy
echo "Tests passed, deploying..."
sf project deploy start --target-org "$ORG"

if [ $? -eq 0 ]; then
    echo "✓ Deployment completed successfully"
else
    echo "✗ Deployment failed"
    exit 1
fi
```

### Script 3: Deployment with Backup
```bash
#!/bin/bash
# deploy-with-backup.sh

ORG="${1:-production}"
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"

echo "=== Safe Deployment to $ORG ==="

# Create backup
echo "Creating backup..."
mkdir -p "$BACKUP_DIR"
sf project retrieve start --target-org "$ORG" --output-dir "$BACKUP_DIR"

if [ $? -ne 0 ]; then
    echo "✗ Backup failed, aborting"
    exit 1
fi

echo "✓ Backup saved to $BACKUP_DIR"

# Deploy
echo "Deploying changes..."
sf project deploy start --target-org "$ORG"

if [ $? -eq 0 ]; then
    echo "✓ Deployment successful"
    echo "Backup location: $BACKUP_DIR"
else
    echo "✗ Deployment failed"
    echo "Backup available at: $BACKUP_DIR"
    exit 1
fi
```

---

## Validation Scripts

### Script 4: Pre-Deployment Validation
```bash
#!/bin/bash
# validate-deployment.sh

ORG="${1:-production}"

echo "=== Pre-Deployment Validation ==="

# 1. Check connection
echo "Checking org connection..."
sf org display --target-org "$ORG" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Cannot connect to $ORG"
    exit 1
fi
echo "✓ Org connection verified"

# 2. Validate metadata
echo "Validating metadata..."
sf project deploy validate --target-org "$ORG"

if [ $? -ne 0 ]; then
    echo "✗ Validation failed"
    exit 1
fi
echo "✓ Metadata validation passed"

# 3. Check test coverage
echo "Checking test coverage..."
COVERAGE=$(sf apex run test --target-org "$ORG" --code-coverage --json | jq '.result.summary.testRunCoverage' | tr -d '%"')

if [ "$COVERAGE" -lt 75 ]; then
    echo "✗ Coverage too low: ${COVERAGE}%"
    exit 1
fi
echo "✓ Test coverage: ${COVERAGE}%"

# 4. Run static analysis
echo "Running static analysis..."
if command -v pmd &> /dev/null; then
    pmd check -d force-app/main/default/classes -R config/pmd-ruleset.xml -f text > pmd-report.txt
    
    if [ -s pmd-report.txt ]; then
        echo "⚠️ PMD violations found:"
        cat pmd-report.txt
    fi
fi

echo "✓ All validations passed"
```

### Script 5: Org Compatibility Check
```bash
#!/bin/bash
# check-compatibility.sh

SOURCE_ORG="${1:-dev}"
TARGET_ORG="${2:-production}"

echo "=== Checking Compatibility: $SOURCE_ORG → $TARGET_ORG ==="

# Get API versions
SOURCE_VERSION=$(sf org display --target-org "$SOURCE_ORG" --json | jq -r '.result.apiVersion')
TARGET_VERSION=$(sf org display --target-org "$TARGET_ORG" --json | jq -r '.result.apiVersion')

echo "Source API: v$SOURCE_VERSION"
echo "Target API: v$TARGET_VERSION"

if [ "$SOURCE_VERSION" -gt "$TARGET_VERSION" ]; then
    echo "⚠️ Warning: Source org has newer API version"
fi

# Check for required features
echo
echo "Checking features..."

REQUIRED_FEATURES=("MultiCurrency" "PersonAccounts")

for feature in "${REQUIRED_FEATURES[@]}"; do
    ENABLED=$(sf org display --target-org "$TARGET_ORG" --json | jq -r ".result.settings.${feature}")
    
    if [ "$ENABLED" = "false" ] || [ "$ENABLED" = "null" ]; then
        echo "✗ $feature not enabled in $TARGET_ORG"
        exit 1
    fi
    echo "✓ $feature enabled"
done

echo
echo "✓ Compatibility check passed"
```

---

## Advanced Deployment Scripts

### Script 6: Multi-Org Deployment Pipeline
```bash
#!/bin/bash
# multi-org-deploy.sh

set -e  # Exit on any error

ORGS=("dev" "qa" "uat" "production")
REQUIRE_MANUAL_APPROVAL=true

deploy_to_org() {
    local org=$1
    
    echo "========================================"
    echo "  Deploying to: $org"
    echo "========================================"
    
    # Run tests
    echo "Running tests..."
    sf apex run test --target-org "$org" --test-level RunLocalTests
    
    # Deploy
    echo "Deploying..."
    sf project deploy start --target-org "$org"
    
    # Smoke test
    echo "Running smoke tests..."
    smoke_test "$org"
    
    echo "✓ $org deployment successful"
}

smoke_test() {
    local org=$1
    
    # Query to verify deployment
    sf data query --query "SELECT COUNT() FROM ApexClass" --target-org "$org" > /dev/null
    
    # Additional health checks
    # Add your smoke tests here
    
    return 0
}

# Main deployment flow
for org in "${ORGS[@]}"; do
    echo
    echo "=== Next: $org ==="
    
    # Manual approval for production
    if [ "$org" = "production" ] && [ "$REQUIRE_MANUAL_APPROVAL" = true ]; then
        read -p "Deploy to PRODUCTION? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            echo "Deployment cancelled"
            exit 1
        fi
    fi
    
    # Deploy
    if deploy_to_org "$org"; then
        echo "✓ $org completed"
        
        # Notify
        send_notification "✓ $org deployment successful"
    else
        echo "✗ $org failed"
        send_notification "✗ $org deployment failed"
        
        # Stop pipeline
        exit 1
    fi
    
    # Delay between orgs
    if [ "$org" != "${ORGS[-1]}" ]; then
        echo "Waiting 30 seconds before next org..."
        sleep 30
    fi
done

echo
echo "========================================"
echo "  ✓ All orgs deployed successfully"
echo "========================================"

send_notification "✓ Complete pipeline successful"
```

### Script 7: Incremental Deployment
```bash
#!/bin/bash
# incremental-deploy.sh - Deploy only changed files

ORG="${1:-dev}"
LAST_DEPLOY_FILE=".last_deploy_commit"

echo "=== Incremental Deployment to $ORG ==="

# Get last deployed commit
if [ -f "$LAST_DEPLOY_FILE" ]; then
    LAST_COMMIT=$(cat "$LAST_DEPLOY_FILE")
    echo "Last deployment: $LAST_COMMIT"
else
    echo "No previous deployment found, deploying all"
    LAST_COMMIT=""
fi

# Get changed files
if [ -n "$LAST_COMMIT" ]; then
    CHANGED_FILES=$(git diff --name-only $LAST_COMMIT HEAD -- force-app/)
    
    if [ -z "$CHANGED_FILES" ]; then
        echo "No changes to deploy"
        exit 0
    fi
    
    echo "Changed files:"
    echo "$CHANGED_FILES"
    
    # Create temp manifest
    MANIFEST="/tmp/incremental_package.xml"
    generate_manifest "$CHANGED_FILES" > "$MANIFEST"
    
    # Deploy only changed files
    sf project deploy start --manifest "$MANIFEST" --target-org "$ORG"
else
    # Full deployment
    sf project deploy start --target-org "$ORG"
fi

if [ $? -eq 0 ]; then
    # Save current commit
    git rev-parse HEAD > "$LAST_DEPLOY_FILE"
    echo "✓ Incremental deployment successful"
else
    echo "✗ Deployment failed"
    exit 1
fi
```

### Script 8: Deployment with Rollback
```bash
#!/bin/bash
# deploy-with-rollback.sh

ORG="${1:-production}"
BACKUP_DIR="/tmp/backup_$(date +%Y%m%d_%H%M%S)"

echo "=== Deployment with Automatic Rollback ==="

# Function to rollback
rollback() {
    echo
    echo "!!! Rolling back deployment !!!"
    
    if [ -d "$BACKUP_DIR" ]; then
        sf project deploy start --source-dir "$BACKUP_DIR" --target-org "$ORG"
        
        if [ $? -eq 0 ]; then
            echo "✓ Rollback successful"
        else
            echo "✗ Rollback failed - manual intervention required!"
            send_critical_alert "ROLLBACK FAILED on $ORG"
        fi
    else
        echo "✗ No backup found - cannot rollback!"
        send_critical_alert "NO BACKUP for $ORG rollback"
    fi
}

# Trap errors
trap 'rollback' ERR

# Backup current state
echo "Creating backup..."
mkdir -p "$BACKUP_DIR"
sf project retrieve start --target-org "$ORG" --output-dir "$BACKUP_DIR"
echo "✓ Backup created"

# Deploy
echo "Deploying..."
sf project deploy start --target-org "$ORG"
echo "✓ Deployment successful"

# Validate deployment
echo "Validating deployment..."
validate_deployment "$ORG"
echo "✓ Validation passed"

# Cleanup backup if successful
echo "Cleaning up backup..."
rm -rf "$BACKUP_DIR"

echo "✓ Deployment completed successfully"
```

---

## Test Automation Scripts

### Script 9: Comprehensive Test Runner
```bash
#!/bin/bash
# run-all-tests.sh

ORG="${1:-dev}"
OUTPUT_DIR="test-results"

mkdir -p "$OUTPUT_DIR"

echo "=== Running Comprehensive Test Suite ==="

# Run Apex tests
echo "Running Apex tests..."
sf apex run test \
    --target-org "$ORG" \
    --test-level RunLocalTests \
    --code-coverage \
    --result-format human \
    --output-dir "$OUTPUT_DIR" \
    --wait 60

TEST_RESULT=$?

# Generate reports
echo
echo "=== Test Summary ==="

# Parse results
PASSED=$(grep -c "Pass" "$OUTPUT_DIR/test-result.txt" || echo "0")
FAILED=$(grep -c "Fail" "$OUTPUT_DIR/test-result.txt" || echo "0")
COVERAGE=$(grep "coverage" "$OUTPUT_DIR/test-result.txt" | awk '{print $NF}')

echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Coverage: $COVERAGE"

# Check coverage threshold
COVERAGE_NUM=$(echo "$COVERAGE" | tr -d '%')
if [ "$COVERAGE_NUM" -lt 75 ]; then
    echo "✗ Coverage below threshold (75%)"
    exit 1
fi

# Check for failures
if [ $TEST_RESULT -ne 0 ] || [ "$FAILED" != "0" ]; then
    echo "✗ Tests failed"
    
    # Show failures
    echo
    echo "=== Failed Tests ==="
    grep -A 2 "Fail" "$OUTPUT_DIR/test-result.txt"
    
    exit 1
fi

echo "✓ All tests passed"
```

### Script 10: Test Specific Classes
```bash
#!/bin/bash
# test-changed-classes.sh - Test only changed Apex classes

ORG="${1:-dev}"

echo "=== Testing Changed Classes ==="

# Get changed Apex classes since last commit
CHANGED_CLASSES=$(git diff --name-only HEAD~1 HEAD -- force-app/ | \
    grep "\.cls$" | \
    xargs -I {} basename {} .cls)

if [ -z "$CHANGED_CLASSES" ]; then
    echo "No Apex classes changed"
    exit 0
fi

echo "Changed classes:"
echo "$CHANGED_CLASSES"

# Find corresponding test classes
TEST_CLASSES=""
for class in $CHANGED_CLASSES; do
    # Try common test class naming patterns
    for pattern in "${class}Test" "${class}_Test" "Test${class}"; do
        if [ -f "force-app/main/default/classes/${pattern}.cls" ]; then
            TEST_CLASSES="$TEST_CLASSES $pattern"
            break
        fi
    done
done

if [ -z "$TEST_CLASSES" ]; then
    echo "⚠️ No test classes found for changed classes"
    exit 0
fi

echo "Running test classes: $TEST_CLASSES"

# Run tests
sf apex run test \
    --target-org "$ORG" \
    --class-names "$TEST_CLASSES" \
    --result-format human

if [ $? -eq 0 ]; then
    echo "✓ All tests passed"
else
    echo "✗ Tests failed"
    exit 1
fi
```

---

## CI/CD Integration Scripts

### Script 11: GitHub Actions Compatible
```bash
#!/bin/bash
# ci-cd-deploy.sh - For CI/CD pipelines

set -e  # Exit on error
set -o pipefail  # Pipeline failures propagate

# Environment variables (set by CI/CD)
TARGET_ORG="${TARGET_ORG:-dev}"
SF_USERNAME="${SF_USERNAME}"
SF_PASSWORD="${SF_PASSWORD}"
SF_SECURITY_TOKEN="${SF_SECURITY_TOKEN}"

echo "=== CI/CD Deployment ==="
echo "Target Org: $TARGET_ORG"

# Authenticate
echo "Authenticating..."
echo "$SF_PASSWORD$SF_SECURITY_TOKEN" | \
sf org login password \
    --username "$SF_USERNAME" \
    --set-default-org \
    --no-prompt

# Run validation
echo "Running validation..."
sf project deploy validate --target-org "$TARGET_ORG"

# Run tests
echo "Running tests..."
sf apex run test \
    --target-org "$TARGET_ORG" \
    --test-level RunLocalTests \
    --code-coverage \
    --wait 30

# Deploy
echo "Deploying..."
sf project deploy start --target-org "$TARGET_ORG"

echo "✓ CI/CD deployment successful"
```

### Script 12: GitLab CI Compatible
```bash
#!/bin/bash
# gitlab-ci-deploy.sh

set -e

STAGE="${CI_COMMIT_BRANCH}"

case "$STAGE" in
    "develop")
        TARGET_ORG="dev"
        ;;
    "staging")
        TARGET_ORG="uat"
        ;;
    "main"|"master")
        TARGET_ORG="production"
        ;;
    *)
        echo "Unknown branch: $STAGE"
        exit 1
        ;;
esac

echo "=== GitLab CI Deployment ==="
echo "Branch: $STAGE"
echo "Target: $TARGET_ORG"
echo "Commit: $CI_COMMIT_SHA"

# Authenticate using JWT
sf org login jwt \
    --client-id "$SF_CLIENT_ID" \
    --jwt-key-file "$SF_JWT_KEY_FILE" \
    --username "$SF_USERNAME" \
    --set-default-org

# Deploy
sf project deploy start --target-org "$TARGET_ORG"

# Tag successful deployment
if [ $? -eq 0 ]; then
    git tag "deployed-$TARGET_ORG-$(date +%Y%m%d-%H%M%S)"
    echo "✓ Deployment successful"
fi
```

---

## Monitoring & Notification Scripts

### Script 13: Deployment with Slack Notifications
```bash
#!/bin/bash
# deploy-with-notifications.sh

ORG="${1:-production}"
SLACK_WEBHOOK="${SLACK_WEBHOOK_URL}"

send_slack() {
    local message="$1"
    local color="${2:-good}"  # good, warning, danger
    
    curl -X POST "$SLACK_WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d "{
            \"attachments\": [{
                \"color\": \"$color\",
                \"text\": \"$message\",
                \"footer\": \"SF Deployment Bot\",
                \"ts\": $(date +%s)
            }]
        }"
}

# Start notification
send_slack "🚀 Starting deployment to *$ORG*..." "warning"

# Deploy
if sf project deploy start --target-org "$ORG" 2>&1 | tee deploy.log; then
    # Success
    SUMMARY=$(tail -20 deploy.log | grep -E "Deployed|Components")
    send_slack "✅ Deployment to *$ORG* successful\n\n$SUMMARY" "good"
else
    # Failure
    ERRORS=$(grep -i "error" deploy.log | head -5)
    send_slack "❌ Deployment to *$ORG* failed\n\n$ERRORS" "danger"
    exit 1
fi
```

### Script 14: Deployment Metrics
```bash
#!/bin/bash
# deployment-metrics.sh - Track deployment stats

ORG="${1:-production}"
METRICS_FILE="deployment_metrics.csv"

# Initialize metrics file
if [ ! -f "$METRICS_FILE" ]; then
    echo "timestamp,org,duration,components,tests,coverage,status" > "$METRICS_FILE"
fi

START_TIME=$(date +%s)

# Deploy and capture output
sf project deploy start --target-org "$ORG" --json > deploy_result.json

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# Extract metrics
STATUS=$(jq -r '.status' deploy_result.json)
COMPONENTS=$(jq -r '.result.numberComponentsDeployed' deploy_result.json)
TESTS=$(jq -r '.result.numberTestsRun // 0' deploy_result.json)
COVERAGE=$(jq -r '.result.details.runTestResult.codeCoverage // "0"' deploy_result.json)

# Log metrics
echo "$(date -Iseconds),$ORG,$DURATION,$COMPONENTS,$TESTS,$COVERAGE,$STATUS" >> "$METRICS_FILE"

# Generate report
echo "=== Deployment Metrics ==="
echo "Duration: ${DURATION}s"
echo "Components: $COMPONENTS"
echo "Tests: $TESTS"
echo "Coverage: $COVERAGE"
echo "Status: $STATUS"

# Cleanup
rm deploy_result.json

[ "$STATUS" = "0" ]
```

---

## Utility Functions

### Common Functions Library
```bash
# lib/deploy-functions.sh

# Send email notification
send_email() {
    local subject="$1"
    local body="$2"
    
    echo "$body" | mail -s "$subject" "${NOTIFICATION_EMAIL}"
}

# Send Slack message
send_slack() {
    local message="$1"
    
    curl -X POST "$SLACK_WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d "{\"text\": \"$message\"}"
}

# Validate org connection
validate_org_connection() {
    local org="$1"
    
    sf org display --target-org "$org" > /dev/null 2>&1
    return $?
}

# Generate package.xml from file list
generate_manifest() {
    local files="$1"
    
    # TODO: Implement manifest generation
    echo "Not yet implemented"
}

# Check test coverage
check_coverage() {
    local org="$1"
    local threshold="${2:-75}"
    
    COVERAGE=$(sf apex run test --target-org "$org" --code-coverage --json | \
        jq -r '.result.summary.testRunCoverage' | tr -d '%')
    
    [ "$COVERAGE" -ge "$threshold" ]
}
```

---

## Best Practices

1. **Always validate before deploying to production**
2. **Create backups before major deployments**
3. **Use incremental deployments when possible**
4. **Implement automated rollback mechanisms**
5. **Track deployment metrics**
6. **Send notifications for critical deployments**
7. **Test changed components specifically**
8. **Use CI/CD for consistent deployments**

---

**Next**: [Practice Exercises](../04-practice/advanced.md)
