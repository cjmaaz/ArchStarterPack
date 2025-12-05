# Command Chaining - Sequential Execution

Control command execution flow with conditional and unconditional operators.

---

## 📋 Chaining Operators

| Operator | Name | Behavior | Example |
|----------|------|----------|---------|
| `;` | Semicolon | Run commands sequentially (regardless of success) | `cmd1; cmd2` |
| `&&` | AND | Run cmd2 only if cmd1 succeeds (exit code 0) | `cmd1 && cmd2` |
| `\|\|` | OR | Run cmd2 only if cmd1 fails (exit code ≠ 0) | `cmd1 \|\| cmd2` |
| `&` | Background | Run cmd in background | `cmd &` |
| `()` | Subshell | Run commands in subshell | `(cmd1; cmd2)` |

---

## Semicolon `;` - Unconditional Execution

Run commands one after another, regardless of success or failure.

### Beginner Examples

#### Example 1: Simple Sequence
```bash
# Run three commands
cd /tmp; ls; pwd

# Executes all three
# Even if cd fails, ls and pwd still run
```

#### Example 2: Multiple Operations
```bash
# Setup sequence
mkdir project; cd project; touch README.md

# All commands execute
```

#### Example 3: Cleanup Sequence
```bash
# Clean temporary files
rm file1.txt; rm file2.txt; rm file3.txt

# Attempts all deletions
# Continues even if file doesn't exist
```

### Intermediate Examples

#### Example 4: One-Line Loop
```bash
# Compact loop
for i in {1..5}; do echo "Count: $i"; done

# Semicolon separates loop parts
```

#### Example 5: Multi-Step Process
```bash
# Build and test
make clean; make build; make test

# Runs all steps
# Dangerous: continues even if build fails
```

---

## AND Operator `&&` - Conditional Success

Execute next command ONLY if previous command succeeds (returns exit code 0).

### Beginner Examples

#### Example 6: Safe Directory Change
```bash
# Only list if cd succeeds
cd /var/log && ls

# If directory doesn't exist, ls won't run
```

#### Example 7: Create and Enter Directory
```bash
# Standard pattern
mkdir myproject && cd myproject

# Won't try to cd if mkdir fails
```

#### Example 8: Conditional Execution
```bash
# Test existence before action
test -f config.txt && cat config.txt

# Displays file only if it exists
```

### Intermediate Examples

#### Example 9: Multi-Step with Success Checks
```bash
# Safe build process
./configure && make && make install

# Stops at first failure
```

#### Example 10: Backup Before Modification
```bash
# Safe file modification
cp config.txt config.txt.bak && sed -i 's/old/new/g' config.txt

# Only modifies if backup succeeds
```

#### Example 11: Deployment Pipeline
```bash
# Safe deployment
npm test && npm run build && npm run deploy

# Stops if tests fail or build fails
```

#### Example 12: Validation Chain
```bash
# Multi-step validation
validate_input.sh && process_data.sh && save_results.sh

# Each step must succeed
```

### Advanced Examples

#### Example 13: Complex Conditional
```bash
# With status message
command && echo "✓ Success" || echo "✗ Failed"

# Shows status based on result
```

#### Example 14: Long Chain
```bash
# Multi-stage pipeline
download_data.sh && \
extract_archive.sh && \
transform_data.sh && \
load_database.sh && \
notify_completion.sh

# Stops at any failure point
```

---

## OR Operator `||` - Conditional Failure

Execute next command ONLY if previous command fails (returns exit code ≠ 0).

### Beginner Examples

#### Example 15: Provide Fallback
```bash
# Try command, show message if fails
ping google.com -c 1 || echo "No internet connection"

# Message only if ping fails
```

#### Example 16: Default Value
```bash
# Use default if variable unset
echo ${NAME:-"Guest"}

# Or with command:
get_username || echo "default_user"
```

#### Example 17: Create if Missing
```bash
# Ensure directory exists
test -d logs || mkdir logs

# Creates only if doesn't exist
```

### Intermediate Examples

#### Example 18: Retry Logic
```bash
# Try main, fallback to backup
primary_server.sh || backup_server.sh

# Uses backup only if primary fails
```

#### Example 19: Error Notification
```bash
# Alert on failure
deploy.sh || send_alert.sh "Deployment failed!"

# Sends alert only on failure
```

#### Example 20: Alternative Commands
```bash
# Try preferred, fall back to alternative
command1 || command2 || command3 || echo "All failed"

# Tries each in sequence until one succeeds
```

### Advanced Examples

#### Example 21: Exit on Failure
```bash
# Stop script on error
critical_command || exit 1

# Exits script if command fails
```

#### Example 22: Conditional Recovery
```bash
# Try to recover from failure
risky_operation || {
    echo "Operation failed, attempting recovery"
    cleanup.sh
    restore_backup.sh
}

# Block executes only on failure
```

---

## Combining `&&` and `||`

### Intermediate Examples

#### Example 23: Status Message
```bash
# Success or failure message
command && echo "Success" || echo "Failure"

# Ternary-like behavior
```

#### Example 24: Try, Fallback, Report
```bash
# Complex flow
primary_action && echo "✓ Primary succeeded" || {
    backup_action && echo "⚠ Used backup" || echo "✗ Both failed"
}

# Nested conditional logic
```

#### Example 25: Deployment with Rollback
```bash
# Safe deployment pattern
deploy_new_version && \
    test_deployment && \
    echo "✓ Deployed successfully" || \
    { rollback_deployment; echo "✗ Rolled back"; exit 1; }

# Automatic rollback on failure
```

### Advanced Examples

#### Example 26: Multi-Condition Logic
```bash
# Complex decision tree
check_requirements && \
    start_service && \
    verify_service || \
    { 
        echo "Service failed to start"
        check_logs
        notify_admin
        exit 1
    }
```

#### Example 27: Retry with Exponential Backoff
```bash
# Retry pattern
attempt=0
max_attempts=3
until command || [ $attempt -eq $max_attempts ]; do
    attempt=$((attempt + 1))
    echo "Attempt $attempt failed"
    sleep $((2 ** attempt))
done || {
    echo "All $max_attempts attempts failed"
    exit 1
}
```

---

## Background Execution `&`

Run command in background, continue with next command immediately.

### Beginner Examples

#### Example 28: Simple Background Job
```bash
# Long process in background
long_running_task.sh &

# Shell prompt returns immediately
```

#### Example 29: Multiple Background Jobs
```bash
# Start multiple processes
job1.sh &
job2.sh &
job3.sh &

# All run simultaneously
```

#### Example 30: Background with Output Redirect
```bash
# Background without terminal spam
long_process > output.log 2>&1 &

# Runs quietly in background
```

### Intermediate Examples

#### Example 31: Wait for Background Jobs
```bash
# Start jobs and wait for completion
job1.sh &
job2.sh &
job3.sh &
wait

echo "All jobs completed"
```

#### Example 32: Parallel Processing
```bash
# Process files in parallel
for file in *.txt; do
    process_file.sh "$file" &
done
wait

echo "All files processed"
```

#### Example 33: Track Background Job
```bash
# Save and monitor PID
long_process.sh &
PID=$!
echo "Process started with PID: $PID"

# Later: check if still running
if ps -p $PID > /dev/null; then
    echo "Still running"
fi
```

### Advanced Examples

#### Example 34: Controlled Parallelism
```bash
# Limit concurrent jobs
MAX_JOBS=4
for file in *.dat; do
    # Wait if too many jobs
    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        sleep 1
    done
    
    process_file.sh "$file" &
done
wait
```

#### Example 35: Background with Monitoring
```bash
# Start with health check
service.sh > service.log 2>&1 &
SERVICE_PID=$!

# Monitor service
while kill -0 $SERVICE_PID 2>/dev/null; do
    echo "Service running..."
    sleep 5
done

echo "Service stopped"
```

---

## Subshell Execution `()`

Run commands in a subshell (separate environment).

### Intermediate Examples

#### Example 36: Isolated Environment
```bash
# Changes don't affect parent shell
(cd /tmp; ls; pwd)
pwd  # Still in original directory

# cd inside () doesn't change parent
```

#### Example 37: Grouped Commands
```bash
# Group output
(
    echo "=== Report Start ==="
    date
    uptime
    echo "=== Report End ==="
) > report.txt

# All output to one file
```

#### Example 38: Parallel Subshells
```bash
# Independent execution
(command1; command2) &
(command3; command4) &
wait

# Two groups run in parallel
```

### Advanced Examples

#### Example 39: Environment Isolation
```bash
# Test different environments
(
    export PATH=/custom/path:$PATH
    test_with_custom_path.sh
)

# PATH unchanged in parent
```

#### Example 40: Transaction-Like Pattern
```bash
# All or nothing execution
(
    set -e  # Exit on any error
    step1.sh
    step2.sh
    step3.sh
) || {
    echo "Transaction failed, rolling back"
    rollback.sh
}
```

---

## Salesforce-Specific Chaining

### Example 41: Safe Deployment
```bash
# Deploy only if tests pass
sf apex run test --test-level RunLocalTests && \
sf project deploy start --target-org production

# Won't deploy if tests fail
```

### Example 42: Backup Before Deploy
```bash
# Retrieve current state before deploy
sf project retrieve start && \
sf project deploy start || \
echo "Deployment failed, existing backup available"

# Safe deployment with backup
```

### Example 43: Multi-Org Deployment
```bash
# Deploy to multiple orgs in parallel
sf project deploy start --target-org dev &
sf project deploy start --target-org qa &
sf project deploy start --target-org staging &
wait

echo "All deployments completed"
```

### Example 44: Conditional Metadata Retrieval
```bash
# Retrieve only if changes detected
git diff --quiet force-app || {
    echo "Changes detected, retrieving from org"
    sf project retrieve start
}

# Retrieves only when needed
```

### Example 45: Test and Report
```bash
# Run tests and generate report
sf apex run test --test-level RunLocalTests > test_results.txt && \
    echo "✓ All tests passed" || \
    { echo "✗ Tests failed"; cat test_results.txt | grep "FAIL"; }

# Reports failures immediately
```

---

## Generic Real-World Examples

### Example 46: Backup and Compress
```bash
# Create backup only if directory exists
test -d /data && \
    tar -czf backup_$(date +%Y%m%d).tar.gz /data && \
    echo "Backup created" || \
    echo "Backup failed"

# Safe backup operation
```

### Example 47: Build Pipeline
```bash
# Complete build process
npm install && \
    npm run lint && \
    npm run test && \
    npm run build && \
    echo "✓ Build successful" || \
    { echo "✗ Build failed"; exit 1; }

# Stops at first failure
```

### Example 48: Service Management
```bash
# Restart service if not running
pgrep myservice > /dev/null || {
    echo "Service not running, starting..."
    systemctl start myservice
}

# Auto-start if stopped
```

### Example 49: Git Operations
```bash
# Safe git workflow
git pull && \
    npm install && \
    npm test && \
    git push || \
    { echo "Pipeline failed, fix before pushing"; exit 1; }

# Won't push if any step fails
```

### Example 50: Database Operations
```bash
# Backup before migration
pg_dump database > backup.sql && \
    psql database < migration.sql && \
    echo "✓ Migration successful" || \
    { psql database < backup.sql; echo "✗ Rolled back"; }

# Automatic rollback on failure
```

---

## Best Practices

### 1. Use `&&` for Dependencies
```bash
# Good: Stops if prerequisite fails
mkdir dir && cd dir && create_files.sh

# Bad: Continues even if mkdir fails
mkdir dir; cd dir; create_files.sh
```

### 2. Use `||` for Fallbacks
```bash
# Good: Provides alternative
command || fallback_command

# Good: Exits on critical failure
critical_command || exit 1
```

### 3. Group Commands for Clarity
```bash
# Good: Clear grouping
{
    echo "Starting process"
    process_data.sh
    echo "Process complete"
} || {
    echo "Process failed"
    cleanup.sh
}
```

### 4. Use Subshells for Isolation
```bash
# Good: Doesn't affect parent
(cd /tmp && process_files.sh)

# Bad: Changes parent directory
cd /tmp && process_files.sh
```

### 5. Background Jobs with Wait
```bash
# Good: Waits for completion
job1.sh & job2.sh & job3.sh &
wait

# Bad: Script exits immediately
job1.sh & job2.sh & job3.sh &
```

---

## Common Patterns & Recipes

### Pattern 1: Safe Script Template
```bash
#!/bin/bash
set -e  # Exit on error

# Your commands here
step1 && \
step2 && \
step3 && \
echo "All steps completed"
```

### Pattern 2: Retry Mechanism
```bash
# Try up to 3 times
for i in {1..3}; do
    command && break || {
        echo "Attempt $i failed"
        [ $i -lt 3 ] && sleep 5
    }
done
```

### Pattern 3: Parallel with Limit
```bash
# Process with max concurrent jobs
for item in items/*; do
    while [ $(jobs -r | wc -l) -ge 4 ]; do
        wait -n  # Wait for any job
    done
    process "$item" &
done
wait
```

### Pattern 4: Deployment with Validation
```bash
# Deploy with checks
validate && \
    backup && \
    deploy && \
    verify || \
    { rollback; exit 1; }
```

### Pattern 5: Conditional Logging
```bash
# Log only on success/failure
command && \
    echo "[$(date)] Success" >> success.log || \
    echo "[$(date)] Failure" >> error.log
```

---

## Practice Exercises

### Beginner (1-10)
1. Create directory and cd into it
2. Run three commands sequentially
3. Try command, show message if it fails
4. Delete file only if it exists
5. Create directory if missing
6. Run command in background
7. Chain two dependent commands
8. Provide fallback command
9. Execute commands regardless of failure
10. Run command and capture exit status

### Intermediate (11-20)
11. Build process that stops on first error
12. Backup before modifying file
13. Parallel file processing with wait
14. Retry command up to 3 times
15. Deploy with automatic rollback
16. Service health check and restart
17. Multiple background jobs with limit
18. Status message based on success/failure
19. Conditional environment variable
20. Group commands in subshell

### Advanced (21-30)
21. Complex deployment pipeline
22. Exponential backoff retry
23. Parallel processing with concurrency limit
24. Transaction-like execution with rollback
25. Multi-stage build with cleanup
26. Service monitoring loop
27. Conditional multi-org deployment
28. Automatic backup and restore
29. Build, test, deploy pipeline
30. Health check with auto-recovery

---

**Next**: [Advanced Patterns](./advanced-patterns.md)
