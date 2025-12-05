# Input/Output Redirection

Deep dive into stdin, stdout, stderr, and advanced redirection techniques.

---

## 📋 Table of Contents
- [Standard Streams](#standard-streams)
- [Output Redirection `>`](#output-redirection-)
- [Append Redirection `>>`](#append-redirection-)
- [Input Redirection `<`](#input-redirection-)
- [Error Redirection `2>`](#error-redirection-2)
- [Combined Redirection `&>`](#combined-redirection-)
- [Here Documents `<<`](#here-documents-)
- [Here Strings `<<<`](#here-strings-)
- [File Descriptors](#file-descriptors)
- [Advanced Redirection](#advanced-redirection)

---

## Standard Streams

Every process has three default streams:

| Stream | Name | File Descriptor | Default | Purpose |
|--------|------|-----------------|---------|---------|
| stdin | Standard Input | 0 | Keyboard | Input data |
| stdout | Standard Output | 1 | Terminal | Normal output |
| stderr | Standard Error | 2 | Terminal | Error messages |

```bash
# Visualize streams
command
  ↑ stdin (0)
  ↓ stdout (1)
  ↓ stderr (2)
```

---

## Output Redirection `>`

Redirect stdout to a file (overwrites existing file).

### Beginner Level

#### Example 1: Basic Output Redirection
```bash
# Save output to file
echo "Hello World" > greeting.txt

# Creates/overwrites greeting.txt
```

#### Example 2: Command Output to File
```bash
# Save directory listing
ls -la > filelist.txt

# Captures ls output
```

#### Example 3: Overwrite Behavior
```bash
# First write
echo "Line 1" > file.txt

# Second write (overwrites!)
echo "Line 2" > file.txt

# file.txt contains only: Line 2
```

#### Example 4: Empty File Creation
```bash
# Create empty file
> newfile.txt

# Or:
: > newfile.txt

# Truncates to zero length
```

### Intermediate Level

#### Example 5: Save Command Results
```bash
# Save query results
sf data query --query "SELECT Name FROM Account" > accounts.txt

# Stores output for later analysis
```

#### Example 6: Redirect with Pipeline
```bash
# Pipeline to file
cat log.txt | grep "ERROR" > errors.txt

# Filters then saves
```

#### Example 7: Noclobber Protection
```bash
# Prevent accidental overwrite
set -o noclobber
echo "data" > file.txt    # Creates file
echo "more" > file.txt    # Error: file exists

# Override noclobber:
echo "more" >| file.txt   # Forces overwrite

# Disable noclobber:
set +o noclobber
```

---

## Append Redirection `>>`

Append stdout to file (preserves existing content).

### Beginner Level

#### Example 8: Basic Append
```bash
# Add to existing file
echo "Line 1" > file.txt
echo "Line 2" >> file.txt
echo "Line 3" >> file.txt

# file.txt contains all three lines
```

#### Example 9: Log Appending
```bash
# Build log file
date >> activity.log
echo "Task started" >> activity.log
echo "Task completed" >> activity.log

# Accumulates log entries
```

#### Example 10: Accumulate Data
```bash
# Collect results over time
for i in {1..5}; do
    echo "Iteration $i" >> results.txt
done

# All iterations in one file
```

### Intermediate Level

#### Example 11: Multi-Source Append
```bash
# Combine multiple sources
echo "Header" > report.txt
cat data1.txt >> report.txt
cat data2.txt >> report.txt
echo "Footer" >> report.txt

# Complete report
```

---

## Input Redirection `<`

Redirect stdin from a file.

### Beginner Level

#### Example 12: Basic Input Redirection
```bash
# Read from file
wc -l < file.txt

# Counts lines, reading from file
```

#### Example 13: Sort from File
```bash
# Use file as input
sort < unsorted.txt > sorted.txt

# Reads from unsorted.txt, writes to sorted.txt
```

#### Example 14: Input vs Argument
```bash
# These are different:
cat file.txt        # file.txt as argument
cat < file.txt      # file.txt as stdin

# Usually same result, different mechanism
```

### Intermediate Level

#### Example 15: Input with Loop
```bash
# Read file line by line
while read line; do
    echo "Processing: $line"
done < input.txt

# Processes each line
```

---

## Error Redirection `2>`

Redirect stderr to file.

### Beginner Level

#### Example 16: Basic Error Redirection
```bash
# Save errors only
command 2> errors.log

# stdout to terminal, stderr to file
```

#### Example 17: Discard Errors
```bash
# Suppress error messages
find / -name "*.txt" 2> /dev/null

# Hides "Permission denied" errors
```

#### Example 18: Separate Output and Errors
```bash
# Save each stream differently
command > output.txt 2> errors.txt

# Normal output and errors in separate files
```

### Intermediate Level

#### Example 19: Append Errors
```bash
# Add to error log
command 2>> errors.log

# Preserves previous errors
```

#### Example 20: Conditional Error Handling
```bash
# Check if errors occurred
command 2> error.tmp
if [ -s error.tmp ]; then
    echo "Errors occurred:"
    cat error.tmp
fi

# -s checks if file non-empty
```

---

## Combined Redirection `&>` or `2>&1`

Redirect both stdout and stderr.

### Beginner Level

#### Example 21: Combine to Same File (Modern)
```bash
# Redirect both streams
command &> output.log

# Both stdout and stderr to output.log
```

#### Example 22: Combine to Same File (Traditional)
```bash
# Classic method
command > output.log 2>&1

# Must redirect stdout first, then stderr to stdout
```

#### Example 23: Append Both Streams
```bash
# Append combined output
command >> output.log 2>&1

# Accumulates both streams
```

### Intermediate Level

#### Example 24: Order Matters
```bash
# Wrong order - stderr goes to terminal
command 2>&1 > output.txt    # WRONG

# Correct order - both to file
command > output.txt 2>&1     # CORRECT

# Redirects are processed left to right
```

#### Example 25: Discard Everything
```bash
# Send all output to /dev/null
command &> /dev/null

# Complete silence
```

#### Example 26: Split After Combining
```bash
# Combine, then filter
command 2>&1 | grep "ERROR"

# Searches both stdout and stderr
```

### Advanced Level

#### Example 27: Separate Then Combine
```bash
# Advanced stream manipulation
{
    command1 > output1.txt 2> error1.txt
    command2 > output2.txt 2> error2.txt
} 2>&1 | tee combined.log

# Complex multi-command redirection
```

---

## Here Documents `<<`

Multi-line input redirection.

### Beginner Level

#### Example 28: Basic Here Document
```bash
# Multi-line input
cat << EOF
Line 1
Line 2
Line 3
EOF

# Prints all lines
```

#### Example 29: Create File with Here Doc
```bash
# Write multi-line file
cat > config.txt << EOF
setting1=value1
setting2=value2
setting3=value3
EOF

# Creates config file
```

#### Example 30: Custom Delimiter
```bash
# Use different end marker
cat << ENDOFTEXT
Content here
More content
ENDOFTEXT

# Any word works as delimiter
```

### Intermediate Level

#### Example 31: Variable Expansion in Here Doc
```bash
# Variables are expanded
cat << EOF
User: $USER
Home: $HOME
Date: $(date)
EOF

# Shows current values
```

#### Example 32: Prevent Expansion (Quoted Delimiter)
```bash
# Literal text (no expansion)
cat << 'EOF'
User: $USER
Home: $HOME
Date: $(date)
EOF

# Quotes prevent expansion
```

#### Example 33: Strip Leading Tabs
```bash
# Remove leading tabs with <<-
cat <<- EOF
	Indented line 1
	Indented line 2
	EOF

# Tabs removed from output
```

### Advanced Level

#### Example 34: Here Doc in Scripts
```bash
# Generate script
cat > deploy.sh << 'SCRIPT'
#!/bin/bash
echo "Starting deployment..."
sf project deploy start
echo "Deployment complete"
SCRIPT
chmod +x deploy.sh

# Creates executable script
```

#### Example 35: SQL from Here Doc
```bash
# Multi-line SQL
mysql database << SQL
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users VALUES (1, 'John', 'john@example.com');
SQL

# Executes SQL commands
```

---

## Here Strings `<<<`

Single-line input redirection.

### Beginner Level

#### Example 36: Basic Here String
```bash
# Pass string as input
grep "pattern" <<< "text with pattern here"

# Searches within string
```

#### Example 37: Here String vs Echo Pipe
```bash
# These are equivalent:
echo "hello" | command
command <<< "hello"

# Here string is cleaner
```

### Intermediate Level

#### Example 38: Variable as Input
```bash
# Use variable
DATA="line1 line2 line3"
wc -w <<< "$DATA"

# Counts words in variable
```

#### Example 39: Command Substitution
```bash
# Use command output
grep "ERROR" <<< "$(cat logfile.txt)"

# Searches command output
```

---

## File Descriptors

Advanced stream manipulation using file descriptor numbers.

### Intermediate Level

#### Example 40: Open File Descriptor for Reading
```bash
# Open file on FD 3
exec 3< input.txt

# Read from FD 3
while read line <&3; do
    echo "Read: $line"
done

# Close FD 3
exec 3<&-

# Manual file descriptor management
```

#### Example 41: Open File Descriptor for Writing
```bash
# Open for writing
exec 4> output.txt

# Write to FD 4
echo "Line 1" >&4
echo "Line 2" >&4

# Close FD 4
exec 4>&-

# Creates output.txt with both lines
```

#### Example 42: Duplicate File Descriptors
```bash
# Save stdout to FD 3
exec 3>&1

# Redirect stdout to file
exec > output.txt

# Write (goes to file)
echo "To file"

# Restore stdout from FD 3
exec 1>&3

# Write (goes to terminal)
echo "To terminal"

# Close FD 3
exec 3>&-

# Stream preservation and restoration
```

### Advanced Level

#### Example 43: Swap stdout and stderr
```bash
# Swap streams
command 3>&1 1>&2 2>&3

# FD 3 = copy of stdout
# stdout = stderr  
# stderr = FD 3 (original stdout)

# stdout and stderr swapped
```

#### Example 44: Multiple Output Destinations
```bash
# Write to multiple files
exec 3> file1.txt 4> file2.txt 5> file3.txt

echo "To file1" >&3
echo "To file2" >&4
echo "To file3" >&5

exec 3>&- 4>&- 5>&-

# Parallel output streams
```

---

## Advanced Redirection

### Expert Level

#### Example 45: Process Substitution
```bash
# Use command output as file
diff <(sort file1.txt) <(sort file2.txt)

# <(...) creates temporary file
```

#### Example 46: Named Pipes (FIFO)
```bash
# Create named pipe
mkfifo mypipe

# Writer (background)
echo "data" > mypipe &

# Reader (foreground)
cat < mypipe

# Removes pipe
rm mypipe

# Inter-process communication
```

#### Example 47: Logging with tee
```bash
# Output to terminal AND file
command | tee output.log

# Append mode:
command | tee -a output.log

# See output while saving
```

#### Example 48: Multiple Logging Destinations
```bash
# Log to multiple files
command | tee file1.log | tee file2.log | tee file3.log

# Or more efficiently:
command | tee file1.log file2.log file3.log > /dev/null

# Distributes output
```

#### Example 49: Separate Streams with tee
```bash
# Log stdout and stderr separately
command > >(tee stdout.log) 2> >(tee stderr.log >&2)

# Process substitution with tee
```

#### Example 50: Exec for Script-Wide Redirection
```bash
#!/bin/bash
# Redirect all output
exec > script_output.log 2>&1

# Everything now logged
echo "This goes to log"
ls /nonexistent  # Error also logged

# Rest of script...

# Entire script's output captured
```

---

## Salesforce-Specific Examples

#### Example 51: Log Deployment Output
```bash
# Capture deployment logs
sf project deploy start > deploy_out.log 2> deploy_err.log

# Separate success and error logs
```

#### Example 52: Silent Deployment
```bash
# Suppress output, check exit code
sf project deploy start &> /dev/null
if [ $? -eq 0 ]; then
    echo "✓ Deployment successful"
else
    echo "✗ Deployment failed"
fi

# Status-based notification
```

#### Example 53: Append Test Results
```bash
# Accumulate test runs
echo "=== Test Run $(date) ===" >> test_history.log
sf apex run test --test-level RunLocalTests >> test_history.log 2>&1

# Historical test log
```

#### Example 54: Filter and Save Errors
```bash
# Extract errors from deployment
sf project deploy start 2>&1 | tee deploy.log | grep -i "error" > errors_only.txt

# Full log + error summary
```

---

## Generic Real-World Examples

#### Example 55: Backup with Logging
```bash
# Log backup process
{
    echo "Backup started: $(date)"
    tar -czf backup.tar.gz /data/
    echo "Backup completed: $(date)"
} >> backup.log 2>&1

# Complete backup log
```

#### Example 56: Cron Job Logging
```bash
# In crontab
0 2 * * * /path/to/script.sh >> /var/log/cronjob.log 2>&1

# Captures cron output
```

#### Example 57: Development vs Production Logging
```bash
# Development: verbose
if [ "$ENV" = "dev" ]; then
    exec 2>&1 | tee -a debug.log
fi

# Production: errors only
if [ "$ENV" = "prod" ]; then
    exec 2>> errors.log
fi

# Environment-specific logging
```

---

## Common Patterns & Recipes

### Pattern 1: Complete Output Capture
```bash
# Save everything with timestamp
{
    echo "Started: $(date)"
    command
    echo "Finished: $(date)"
} > output.log 2>&1
```

### Pattern 2: Conditional Logging
```bash
# Log only on error
command > /dev/null 2> error.tmp
if [ -s error.tmp ]; then
    cat error.tmp >> permanent_errors.log
fi
rm error.tmp
```

### Pattern 3: Progressive Log File
```bash
# Numbered log files
LOG_FILE="script_$(date +%Y%m%d_%H%M%S).log"
exec > "$LOG_FILE" 2>&1
# Script runs with timestamped log
```

### Pattern 4: Debug Mode
```bash
# Debug flag enables verbose logging
if [ "$DEBUG" = "true" ]; then
    exec 2>&1 | tee -a debug.log
fi
```

### Pattern 5: Stream Separation and Combination
```bash
# Save separately, display combined
command > stdout.log 2> stderr.log
cat stdout.log stderr.log > combined.log
```

---

## Practice Problems

### Beginner (1-10)

1. Redirect command output to file
2. Append output to existing file
3. Create empty file using redirection
4. Use file as command input
5. Redirect errors to file
6. Discard all output to /dev/null
7. Create file with here document
8. Use here string for input
9. Combine stdout and stderr to same file
10. Save errors, display output

### Intermediate (11-20)

11. Separate stdout and stderr to different files
12. Append both streams to log file
13. Create multi-line config with here doc
14. Prevent variable expansion in here doc
15. Open file descriptor for writing
16. Use tee to display and save output
17. Redirect within a while loop
18. Create conditional error logging
19. Use process substitution with diff
20. Swap stdout and stderr

### Advanced (21-30)

21. Create named pipe for IPC
22. Multiple file descriptors simultaneously
23. Save and restore stdout
24. Log to multiple files with tee
25. Script-wide redirection with exec
26. Separate streams with process substitution
27. Dynamic log file naming
28. Debug mode with conditional verbosity
29. Comprehensive backup logging
30. Environment-specific redirection

---

**Next**: [grep - Search & Filter](../02-commands/grep.md)
