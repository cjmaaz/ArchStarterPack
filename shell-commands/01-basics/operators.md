# Shell Operators & Symbols

Understanding shell operators is fundamental to command line mastery.

---

## 📋 Table of Contents
- [Pipe Operator `|`](#pipe-operator-)
- [Redirection `>` `>>` `<`](#redirection----)
- [Error Redirection `2>&1`](#error-redirection-21)
- [AND Operator `&&`](#and-operator-)
- [OR Operator `||`](#or-operator-)
- [Semicolon `;`](#semicolon-)
- [Background `&`](#background-)
- [Subshell `()`](#subshell-)
- [Command Substitution `$()`](#command-substitution-)

---

## Pipe Operator `|`

**Purpose**: Send output of one command as input to another

### Syntax
```bash
command1 | command2
```

### How It Works
```
command1 → stdout → | → stdin → command2
```

### Examples

**Beginner:**
```bash
# Count lines in output
ls | wc -l

# Show first 5 files
ls | head -5

# Sort files alphabetically
ls | sort
```

**Intermediate:**
```bash
# Find and count specific pattern
grep "ERROR" log.txt | wc -l

# Extract and sort unique values
cat data.txt | sort | uniq

# Chain multiple filters
ps aux | grep java | grep -v grep
```

**Advanced:**
```bash
# Multi-stage pipeline
cat access.log | grep "404" | awk '{print $1}' | sort | uniq -c | sort -nr

# Process Salesforce query results
sf data query --query "SELECT Name FROM Account" | grep "Name" | sed 's/.*: //'
```

**Expert:**
```bash
# Complex data transformation
cat report.csv | awk -F',' '{sum+=$3} END {print sum/NR}' | xargs printf "Average: %.2f\n"

# Parallel processing with named pipes
mkfifo pipe1 pipe2
grep "ERROR" log1.txt > pipe1 &
grep "ERROR" log2.txt > pipe2 &
cat pipe1 pipe2 | sort
```

---

## Redirection `>` `>>` `<`

**Purpose**: Control input/output streams

### Operators

| Operator | Purpose | Overwrites? |
|----------|---------|-------------|
| `>` | Redirect stdout to file | Yes |
| `>>` | Append stdout to file | No |
| `<` | Read from file as stdin | N/A |
| `2>` | Redirect stderr to file | Yes |
| `2>>` | Append stderr to file | No |

### Examples

**Beginner:**
```bash
# Save output to file
echo "Hello" > greeting.txt

# Append to file
echo "World" >> greeting.txt

# Read from file
wc -l < data.txt
```

**Intermediate:**
```bash
# Save command output
ls -la > file_list.txt

# Append to existing log
date >> activity.log
echo "Task completed" >> activity.log

# Redirect errors
command_that_fails 2> errors.log
```

**Advanced:**
```bash
# Separate output and errors
sf apex run --file script.apex > success.log 2> errors.log

# Discard errors (send to null device)
command 2> /dev/null

# Here document (multi-line input)
cat > config.txt <<EOF
Setting1=Value1
Setting2=Value2
EOF
```

**Expert:**
```bash
# Swap stdout and stderr
command 3>&1 1>&2 2>&3

# Tee to file and continue pipeline
command | tee intermediate.log | next_command

# Conditional redirection
if [ -f output.txt ]; then
    command >> output.txt
else
    command > output.txt
fi
```

---

## Error Redirection `2>&1`

**Purpose**: Redirect stderr (2) to wherever stdout (1) is going

### Why It's Useful
- Capture both output and errors together
- Essential for logging and debugging
- Required for proper error handling

### Examples

**Beginner:**
```bash
# Combine output and errors
command > all_output.txt 2>&1

# Same result, newer syntax
command &> all_output.txt
```

**Intermediate:**
```bash
# Pipe both streams to grep
command 2>&1 | grep "ERROR"

# Save everything to log
sf apex run --file test.apex 2>&1 | tee test.log
```

**Advanced:**
```bash
# Separate then combine
(command1 > out.txt) 2>&1 | tee err.log

# Conditional error handling
command 2>&1 | grep -q "ERROR" && echo "Failed" || echo "Success"
```

**Expert:**
```bash
# Custom error handling function
handle_errors() {
    command 2>&1 | while IFS= read -r line; do
        if [[ $line == *ERROR* ]]; then
            echo "[$(date)] ERROR: $line" >> critical.log
        else
            echo "$line"
        fi
    done
}

# Complex logging
exec 1> >(tee -a stdout.log)
exec 2> >(tee -a stderr.log >&2)
```

---

## AND Operator `&&`

**Purpose**: Execute second command ONLY if first succeeds

### Syntax
```bash
command1 && command2
```

### Examples

**Beginner:**
```bash
# Chain dependent commands
mkdir new_folder && cd new_folder

# Conditional execution
test -f file.txt && cat file.txt
```

**Intermediate:**
```bash
# Multi-step process
npm install && npm run build && npm test

# Salesforce deployment
sf project deploy start && sf apex run test
```

**Advanced:**
```bash
# Complex conditional chain
[ -d "backup" ] && rm -rf backup && mkdir backup || mkdir backup

# Error handling pattern
deploy_command && echo "✓ Success" || (echo "✗ Failed" && exit 1)
```

**Expert:**
```bash
# Nested conditionals
check_prerequisites() {
    [ -f ".env" ] && \
    [ -d "src" ] && \
    command -v sf >/dev/null 2>&1 && \
    echo "Ready" || echo "Missing requirements"
}

# Transaction-like behavior
begin_transaction() {
    backup_data && \
    apply_changes && \
    verify_changes && \
    commit_transaction || rollback_transaction
}
```

---

## OR Operator `||`

**Purpose**: Execute second command ONLY if first fails

### Syntax
```bash
command1 || command2
```

### Examples

**Beginner:**
```bash
# Provide fallback
mkdir dir || echo "Directory already exists"

# Default value
USER=${USER:-"default_user"}
```

**Intermediate:**
```bash
# Try primary, fallback to secondary
ping google.com -c 1 || echo "No internet connection"

# Error handling
sf data query --query "SELECT Id FROM Account" || echo "Query failed"
```

**Advanced:**
```bash
# Multiple fallbacks
command1 || command2 || command3 || exit 1

# Retry logic
attempt=0
until command || [ $attempt -eq 3 ]; do
    echo "Attempt $((++attempt))"
    sleep 2
done
```

**Expert:**
```bash
# Complex error recovery
deploy_with_retry() {
    local max_attempts=3
    local attempt=1
    
    until sf project deploy start --target-org $1 || [ $attempt -eq $max_attempts ]; do
        echo "Deploy failed, attempt $attempt of $max_attempts"
        echo "Waiting 30 seconds..."
        sleep 30
        ((attempt++))
    done || {
        echo "All deploy attempts failed"
        notify_team "Deployment failed after $max_attempts attempts"
        return 1
    }
}
```

---

## Semicolon `;`

**Purpose**: Execute commands sequentially (regardless of success/failure)

### Examples

**Beginner:**
```bash
# Multiple commands on one line
cd /tmp; ls; pwd
```

**Intermediate:**
```bash
# Independent operations
echo "Starting"; run_job; echo "Finished"
```

**Advanced:**
```bash
# For loops on one line
for i in {1..5}; do echo "Count: $i"; done
```

---

## Background `&`

**Purpose**: Run command in background

### Examples

**Beginner:**
```bash
# Run long process in background
long_running_command &

# Multiple background jobs
job1 & job2 & job3 &
```

**Intermediate:**
```bash
# Background with output redirect
long_process > output.log 2>&1 &

# Get job PID
long_process & echo $!
```

**Advanced:**
```bash
# Parallel processing
for file in *.txt; do
    process_file "$file" &
done
wait  # Wait for all background jobs
```

---

## Command Substitution `$()`

**Purpose**: Use command output as a value

### Examples

**Beginner:**
```bash
# Store command output
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"
```

**Intermediate:**
```bash
# Use in other commands
FILES=$(ls *.txt | wc -l)
echo "Found $FILES text files"

# Nested substitution
APEX_COUNT=$(grep -c "public class" $(find . -name "*.cls"))
```

**Advanced:**
```bash
# Dynamic file names
BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf $BACKUP_FILE important_data/

# Process lists
for org in $(sf org list --json | jq -r '.result[].username'); do
    echo "Processing $org"
done
```

---

## Practice Problems

### Beginner (1-5)

1. List all `.txt` files and count them
2. Save the output of `ls -la` to a file
3. Append current date to a log file
4. Create a directory and immediately cd into it (use `&&`)
5. Try to remove a file, show message if it doesn't exist (use `||`)

### Intermediate (6-10)

6. Find all "ERROR" lines in a log and save to errors.txt
7. Run two commands only if a file exists
8. Count unique IP addresses in an access log
9. Redirect both output and errors to the same file
10. Run 3 commands in sequence, regardless of failures

### Advanced (11-15)

11. Extract the 3rd column from a CSV and sort it
12. Find files modified today and archive them
13. Run a command, retry 3 times if it fails
14. Process 5 files in parallel using background jobs
15. Create a dynamic filename with timestamp

### Expert (16-20)

16. Build a deployment pipeline with proper error handling
17. Implement logging that separates errors and standard output
18. Create a retry mechanism with exponential backoff
19. Parse JSON output, filter, and format results
20. Build a monitoring script that checks every 5 seconds

---

**Solutions in**: [Practice Beginner Solutions](../04-practice/beginner-solutions.md)

---

**Next**: [Input/Output Redirection](./redirection.md)
