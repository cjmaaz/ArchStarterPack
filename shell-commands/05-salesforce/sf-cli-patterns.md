# Salesforce CLI Integration Patterns

Real-world patterns for Salesforce development automation.

---

## 📋 Common SF CLI Commands

```bash
sf org list                          # List all orgs
sf org display                       # Show current org info
sf data query                        # Run SOQL query
sf apex run                          # Execute Apex
sf project deploy start              # Deploy metadata
sf apex run test                     # Run Apex tests
sf apex get log                      # Get debug logs
```

---

## Pattern 1: Query and Process Results

### Basic Query
```bash
# Simple query
sf data query --query "SELECT Name FROM Account LIMIT 5" --target-org myOrg
```

### Extract Specific Fields
```bash
# Get just the names (no JSON structure)
sf data query --query "SELECT Name FROM Account" --json | \
jq -r '.result.records[].Name'
```

### Count Records
```bash
# Count Accounts
sf data query --query "SELECT COUNT() FROM Account" --json | \
jq '.result.totalSize'
```

### Filter and Format
```bash
# Get active accounts with formatted output
sf data query --query "SELECT Name, AnnualRevenue FROM Account WHERE IsActive__c = true" --json | \
jq -r '.result.records[] | "\(.Name): $\(.AnnualRevenue)"'
```

---

## Pattern 2: Deployment Automation

### Deploy with Error Capture
```bash
# Deploy and capture any errors
sf project deploy start --source-dir force-app/main/default/classes/ 2>&1 | \
tee deploy.log | grep -i "error"
```

### Deploy Only if Tests Pass
```bash
# Chain deploy with test
sf apex run test --test-level RunLocalTests && \
sf project deploy start --target-org prod
```

### Deploy with Verification
```bash
# Deploy and verify success
if sf project deploy start --source-dir force-app 2>&1 | grep -q "Succeeded"; then
    echo "✓ Deployment successful"
    sf data query --query "SELECT COUNT() FROM ApexClass"
else
    echo "✗ Deployment failed"
    exit 1
fi
```

### Deploy to Multiple Orgs
```bash
# Deploy to all sandboxes
for org in $(sf org list --json | jq -r '.result.nonScratchOrgs[] | select(.isSandbox == true) | .username'); do
    echo "Deploying to $org..."
    sf project deploy start --target-org "$org"
done
```

---

## Pattern 3: Log Analysis

### Get Latest Log
```bash
# Get most recent log
LOG_ID=$(sf apex get log --json | jq -r '.result[0].Id')
sf apex get log --log-id "$LOG_ID" > latest.log
```

### Extract Errors from Logs
```bash
# Find all errors in recent logs
sf apex get log | grep -i "error" | \
awk '{print $1, $2, $3}' | sort | uniq -c
```

### Monitor Logs Real-Time
```bash
# Watch for errors in logs (polling)
watch -n 10 'sf apex get log --json | jq -r ".result[0]" | grep -i error'
```

### Analyze SOQL Queries
```bash
# Extract all SOQL queries from log
sf apex get log | grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sort | uniq -c | sort -nr
```

---

## Pattern 4: Test Execution

### Run Specific Test Class
```bash
# Run one test class
sf apex run test --tests AccountTest --result-format human
```

### Run Tests and Check Coverage
```bash
# Run tests and extract coverage percentage
sf apex run test --test-level RunLocalTests --json | \
jq '.result.summary.testRunCoverage'
```

### Find Failed Tests
```bash
# List all failed tests
sf apex run test --test-level RunLocalTests --json | \
jq -r '.result.tests[] | select(.Outcome == "Fail") | "\(.MethodName): \(.Message)"'
```

### Run Tests for Changed Classes
```bash
# Get changed classes and run their tests
CHANGED_CLASSES=$(git diff --name-only HEAD~1 | grep "\.cls$" | sed 's/.*\///' | sed 's/\.cls$//')

for class in $CHANGED_CLASSES; do
    TEST_CLASS="${class}Test"
    echo "Running tests for $class..."
    sf apex run test --tests "$TEST_CLASS"
done
```

---

## Pattern 5: Data Operations

### Bulk Insert from CSV
```bash
# Import records from CSV
sf data import tree --plan data/plan.json --target-org myOrg
```

### Export and Transform
```bash
# Export data and transform format
sf data query --query "SELECT Id, Name, Email FROM Contact" --json | \
jq -r '.result.records[] | [.Id, .Name, .Email] | @csv' > contacts.csv
```

### Upsert with External ID
```bash
# Update or insert records
sf data upsert bulk --sobject Account --external-id ExternalId__c \
--file accounts.csv --target-org myOrg
```

### Delete Records Matching Criteria
```bash
# Query and delete
IDS=$(sf data query --query "SELECT Id FROM Account WHERE Name LIKE 'Test%'" --json | \
jq -r '.result.records[].Id')

for id in $IDS; do
    sf data delete record --sobject Account --record-id "$id"
done
```

---

## Pattern 6: Org Management

### Check Org Limits
```bash
# Get API usage
sf org display --json | jq '.result.apiVersion'

# Get storage usage
sf data query --query "SELECT SubscriptionType, Used, Available FROM StorageUsage" --use-tooling-api
```

### Compare Orgs
```bash
# Compare metadata between orgs
for org in dev staging prod; do
    echo "=== $org ==="
    sf data query --query "SELECT COUNT() FROM ApexClass" --target-org "$org"
done
```

### Refresh Sandbox
```bash
# Automate sandbox refresh
sf org create sandbox --name MySandbox --clone Dev &&
echo "Sandbox created" &&
sf org list --json | jq '.result.sandboxes[] | select(.SandboxName == "MySandbox")'
```

---

## Pattern 7: CI/CD Integration

### GitHub Actions Example
```bash
#!/bin/bash
# deploy.sh for CI/CD

set -e  # Exit on error

echo "Authenticating..."
sf org login jwt --client-id "$CLIENT_ID" \
    --jwt-key-file server.key \
    --username "$USERNAME" \
    --set-default

echo "Running tests..."
sf apex run test --test-level RunLocalTests --json | \
tee test-results.json

PASS=$(jq '.result.summary.passing' test-results.json)
TOTAL=$(jq '.result.summary.testsRan' test-results.json)

if [ "$PASS" != "$TOTAL" ]; then
    echo "Tests failed: $PASS/$TOTAL passed"
    exit 1
fi

echo "Deploying..."
sf project deploy start --wait 10

echo "✓ Deployment complete"
```

### Pre-Deployment Validation
```bash
# Validate before actual deploy
validate_deploy() {
    echo "Validating deployment..."
    
    # Check for compilation errors
    sf project deploy validate --source-dir force-app 2>&1 | tee validate.log
    
    if grep -q "error" validate.log; then
        echo "✗ Validation failed"
        return 1
    fi
    
    echo "✓ Validation passed"
    return 0
}

validate_deploy && sf project deploy start
```

---

## Pattern 8: Monitoring & Alerts

### Check for Errors in Logs
```bash
#!/bin/bash
# monitor-errors.sh

while true; do
    ERROR_COUNT=$(sf apex get log --json | \
        jq -r '.result[0].log' | \
        grep -c "ERROR" || echo 0)
    
    if [ "$ERROR_COUNT" -gt 10 ]; then
        echo "⚠️  Alert: $ERROR_COUNT errors detected!"
        # Send notification (Slack, email, etc.)
    fi
    
    sleep 60  # Check every minute
done
```

### Track Deployment Status
```bash
# Monitor async deployment
DEPLOY_ID=$(sf project deploy start --async --json | jq -r '.result.id')

while true; do
    STATUS=$(sf project deploy report --deploy-id "$DEPLOY_ID" --json | \
        jq -r '.result.status')
    
    echo "Status: $STATUS"
    
    if [ "$STATUS" == "Succeeded" ] || [ "$STATUS" == "Failed" ]; then
        break
    fi
    
    sleep 10
done
```

---

## Pattern 9: Bulk Operations

### Process Multiple Files
```bash
# Deploy multiple directories
for dir in force-app/lwc force-app/classes force-app/triggers; do
    echo "Deploying $dir..."
    sf project deploy start --source-dir "$dir" || echo "Failed: $dir"
done
```

### Parallel Processing
```bash
# Run multiple queries in parallel
sf data query --query "SELECT COUNT() FROM Account" &
sf data query --query "SELECT COUNT() FROM Contact" &
sf data query --query "SELECT COUNT() FROM Opportunity" &
wait

echo "All queries complete"
```

---

## Pattern 10: Error Recovery

### Retry Logic
```bash
# Retry command on failure
retry_command() {
    local max_attempts=3
    local attempt=1
    local exitCode=0
    
    until [ $attempt -gt $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts..."
        
        if sf project deploy start; then
            return 0
        fi
        
        echo "Failed. Waiting before retry..."
        sleep $((attempt * 10))
        ((attempt++))
    done
    
    echo "All attempts failed"
    return 1
}

retry_command
```

### Rollback on Failure
```bash
# Deploy with automatic rollback
deploy_with_rollback() {
    # Backup current state
    sf data query --query "SELECT COUNT() FROM ApexClass" > pre-deploy.txt
    
    # Attempt deploy
    if ! sf project deploy start; then
        echo "Deploy failed, rolling back..."
        # Restore previous version
        git checkout HEAD~1 force-app/
        sf project deploy start
    fi
}
```

---

## Complete Real-World Example

### Automated Deployment Pipeline
```bash
#!/bin/bash
# complete-deploy.sh

set -e

# Colors for output
RED='\033[0:31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Configuration
TARGET_ORG="production"
TEST_LEVEL="RunLocalTests"
SOURCE_DIR="force-app"

# Step 1: Authenticate
echo "Step 1: Authenticating..."
sf org login jwt --client-id "$CLIENT_ID" \
    --jwt-key-file server.key \
    --username "$USERNAME" \
    --set-default-dev-hub

# Step 2: Run Tests
echo "Step 2: Running tests..."
TEST_RESULT=$(sf apex run test --test-level "$TEST_LEVEL" --json)

PASSED=$(echo "$TEST_RESULT" | jq '.result.summary.passing')
TOTAL=$(echo "$TEST_RESULT" | jq '.result.summary.testsRan')
COVERAGE=$(echo "$TEST_RESULT" | jq '.result.summary.testRunCoverage' | cut -d'%' -f1)

if [ "$PASSED" != "$TOTAL" ] || [ "${COVERAGE%.*}" -lt 75 ]; then
    echo -e "${RED}✗ Tests failed: $PASSED/$TOTAL passed, Coverage: $COVERAGE%${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Tests passed: $PASSED/$TOTAL, Coverage: $COVERAGE%${NC}"

# Step 3: Deploy
echo "Step 3: Deploying to $TARGET_ORG..."
DEPLOY_RESULT=$(sf project deploy start --target-org "$TARGET_ORG" --json)

if echo "$DEPLOY_RESULT" | jq -e '.status == 0' > /dev/null; then
    echo -e "${GREEN}✓ Deployment successful${NC}"
    
    # Step 4: Post-deployment verification
    echo "Step 4: Verifying deployment..."
    sf data query --query "SELECT COUNT() FROM ApexClass" --target-org "$TARGET_ORG"
    
    echo -e "${GREEN}✅ Pipeline complete${NC}"
else
    echo -e "${RED}✗ Deployment failed${NC}"
    echo "$DEPLOY_RESULT" | jq '.message'
    exit 1
fi
```

---

## Best Practices

### 1. Always Use JSON Output for Parsing
```bash
# Good
sf org list --json | jq '.result'

# Bad (hard to parse)
sf org list
```

### 2. Error Handling
```bash
# Always capture both stdout and stderr
command 2>&1 | tee output.log

# Check exit codes
if ! sf project deploy start; then
    echo "Deploy failed"
    exit 1
fi
```

### 3. Use Variables for Reusability
```bash
ORG="myOrg"
QUERY="SELECT Id, Name FROM Account"

sf data query --query "$QUERY" --target-org "$ORG"
```

### 4. Log Everything
```bash
# Create timestamped logs
LOG_FILE="deploy_$(date +%Y%m%d_%H%M%S).log"
sf project deploy start 2>&1 | tee "$LOG_FILE"
```

### 5. Validate Before Deploying
```bash
# Always validate first
sf project deploy validate --source-dir force-app && \
sf project deploy start --source-dir force-app
```

---

**Next**: [Apex Log Analysis](./log-analysis.md)
