# grep - Global Regular Expression Print

Search for patterns in text files or streams.

---

## 📋 Quick Reference

```bash
grep "pattern" file.txt           # Basic search
grep -i "pattern" file.txt         # Case insensitive
grep -r "pattern" directory/       # Recursive search
grep -v "pattern" file.txt         # Invert match (exclude)
grep -E "regex" file.txt           # Extended regex
grep -n "pattern" file.txt         # Show line numbers
grep -c "pattern" file.txt         # Count matches
grep -A 3 "pattern" file.txt       # Show 3 lines after
grep -B 3 "pattern" file.txt       # Show 3 lines before
grep -C 3 "pattern" file.txt       # Show 3 lines context
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-i` | Case insensitive | `grep -i "error"` |
| `-v` | Invert match | `grep -v "debug"` |
| `-r` or `-R` | Recursive | `grep -r "TODO"` |
| `-n` | Line numbers | `grep -n "function"` |
| `-c` | Count matches | `grep -c "ERROR"` |
| `-l` | Files with matches | `grep -l "bug" *.txt` |
| `-L` | Files WITHOUT matches | `grep -L "test"` |
| `-w` | Whole word | `grep -w "test"` |
| `-x` | Whole line | `grep -x "exact line"` |
| `-A NUM` | After context | `grep -A 5 "error"` |
| `-B NUM` | Before context | `grep -B 5 "error"` |
| `-C NUM` | Context (both) | `grep -C 3 "error"` |
| `-E` | Extended regex | `grep -E "pat1|pat2"` |
| `-F` | Fixed strings (faster) | `grep -F "[DEBUG]"` |
| `-q` | Quiet (exit status only) | `grep -q "pattern"` |
| `--color` | Colorize matches | `grep --color "ERROR"` |

---

## Beginner Level

### Example 1: Basic Search
```bash
# Find lines containing "ERROR"
grep "ERROR" application.log

# Output:
# 2025-12-05 ERROR: Connection failed
# 2025-12-05 ERROR: Timeout occurred
```

### Example 2: Case Insensitive
```bash
# Find "error" in any case
grep -i "error" log.txt

# Matches: ERROR, Error, error, ErRoR
```

### Example 3: Count Occurrences
```bash
# Count how many times "ERROR" appears
grep -c "ERROR" application.log

# Output: 127
```

### Example 4: Search Multiple Files
```bash
# Search in all .txt files
grep "pattern" *.txt

# Output shows filename: line
# file1.txt:matching line
# file2.txt:another match
```

### Example 5: Invert Match (Exclude)
```bash
# Show all lines NOT containing "DEBUG"
grep -v "DEBUG" log.txt

# Useful for filtering out noise
```

### Example 6: Show Line Numbers
```bash
# Find errors with line numbers
grep -n "ERROR" application.log

# Output:
# 15:2025-12-05 ERROR: Connection failed
# 42:2025-12-05 ERROR: Timeout occurred
```

### Example 7: List Files with Matches
```bash
# Which files contain "TODO"?
grep -l "TODO" *.js

# Output:
# app.js
# utils.js
# config.js
```

### Example 8: Exact Word Match
```bash
# Find "test" as a complete word
grep -w "test" code.txt

# Matches: "test" but NOT "testing" or "attest"
```

---

## Intermediate Level

### Example 9: Context Lines
```bash
# Show 3 lines before and after match
grep -C 3 "ERROR" log.txt

# Useful for understanding error context
```

### Example 10: Recursive Search
```bash
# Search all files in directory tree
grep -r "FIXME" src/

# Output:
# src/components/Header.js:// FIXME: Update logo
# src/utils/api.js:// FIXME: Add error handling
```

### Example 11: Multiple Patterns (OR)
```bash
# Find ERROR or WARNING
grep -E "ERROR|WARNING" log.txt

# Alternative: grep 'ERROR\|WARNING'
```

### Example 12: Exclude Patterns
```bash
# Find errors but exclude specific types
grep "ERROR" log.txt | grep -v "DeprecationWarning"
```

### Example 13: Search with Regex
```bash
# Find lines starting with numbers
grep -E "^[0-9]+" file.txt

# Find email addresses
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" contacts.txt
```

### Example 14: Count Unique Matches
```bash
# Count unique error types
grep "ERROR" log.txt | sort | uniq -c | sort -nr

# Output:
#  45 ERROR: Connection timeout
#  23 ERROR: File not found
#  12 ERROR: Permission denied
```

### Example 15: Case Insensitive with Line Numbers
```bash
# Find "select" queries (any case) with line numbers
grep -in "select" query.sql

# Output:
# 12:SELECT * FROM Account
# 45:select name from Contact
```

### Example 16: Quiet Mode for Scripting
```bash
# Check if pattern exists (exit code 0 if found)
if grep -q "ERROR" log.txt; then
    echo "Errors found!"
fi
```

---

## Advanced Level

### Example 17: Complex Regex Patterns
```bash
# Find Apex method declarations
grep -E "public\s+(static\s+)?(void|String|Integer|Boolean)\s+\w+\s*\(" *.cls

# Find Salesforce IDs (15 or 18 characters)
grep -E "[a-zA-Z0-9]{15}([a-zA-Z0-9]{3})?" data.txt
```

### Example 18: Exclude Directories
```bash
# Search excluding node_modules and .git
grep -r "TODO" --exclude-dir={node_modules,.git,dist} .
```

### Example 19: Only Show Matching Part
```bash
# Extract IP addresses only
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log

# Output (only IPs):
# 192.168.1.1
# 10.0.0.5
# 172.16.0.10
```

### Example 20: Multiple File Types
```bash
# Search in .cls and .trigger files
grep -r --include="*.{cls,trigger}" "Database.query" force-app/
```

### Example 21: Before/After Context
```bash
# Show 5 lines after ERROR for debugging
grep -A 5 "ERROR" application.log

# Show 3 lines before for context
grep -B 3 "Exception" stacktrace.log
```

### Example 22: Highlight Matches
```bash
# Colorize matches for easier reading
grep --color=always "ERROR" log.txt | less -R
```

### Example 23: Count Per File
```bash
# Show count of matches per file
grep -c "public class" *.cls

# Output:
# Account.cls:1
# Contact.cls:1
# Utils.cls:3
```

### Example 24: Fixed String Search (Faster)
```bash
# Search for exact string (no regex)
grep -F "[DEBUG]" log.txt

# Much faster than: grep "\[DEBUG\]"
```

---

## Expert Level

### Example 25: Parallel Processing
```bash
# Process multiple logs in parallel
for log in /var/log/*.log; do
    grep "ERROR" "$log" > "${log}.errors" &
done
wait
```

### Example 26: Stream Processing
```bash
# Monitor live log file
tail -f application.log | grep --line-buffered "ERROR"

# With timestamp
tail -f app.log | grep --line-buffered "ERROR" | while read line; do
    echo "[$(date '+%H:%M:%S')] $line"
done
```

### Example 27: Complex Multi-Pattern
```bash
# Find Apex classes with specific patterns
grep -l "public class" *.cls | \
xargs grep -l "Database.Batchable" | \
xargs grep -l "execute.*BatchableContext"

# Finds batchable Apex classes
```

### Example 28: Performance Analysis
```bash
# Find slow SOQL queries in logs
grep -E "SOQL_EXECUTE_BEGIN.*FROM" debug.log | \
grep -oE "FROM [^ ]+" | \
sort | uniq -c | sort -nr | head -10

# Shows most frequently queried objects
```

### Example 29: Data Extraction Pipeline
```bash
# Extract and analyze error codes
grep -oE "ERROR_CODE_[0-9]{4}" log.txt | \
sort | uniq -c | sort -nr | \
awk '{printf "Error %s: %d occurrences\n", $2, $1}'

# Output:
# Error ERROR_CODE_1001: 45 occurrences
# Error ERROR_CODE_2003: 23 occurrences
```

### Example 30: Conditional Filtering
```bash
# Complex multi-stage filter
grep -E "(ERROR|FATAL)" application.log | \
grep -v "DeprecationWarning" | \
grep -v "Test environment" | \
awk '{print $1, $2, $3}' | \
sort | uniq -c

# Filters and counts unique errors
```

### Example 31: Cross-Reference Search
```bash
# Find Apex classes that call specific methods
find . -name "*.cls" -exec grep -l "MyUtility\.processData" {} \; | \
while read file; do
    echo "File: $file"
    grep -n "MyUtility\.processData" "$file"
done
```

### Example 32: Log Level Analysis
```bash
# Count log entries by level
grep -oE "^[0-9\-: ]+(DEBUG|INFO|WARN|ERROR|FATAL)" app.log | \
awk '{print $NF}' | sort | uniq -c | \
awk '{printf "%-8s: %5d\n", $2, $1}'

# Output:
# DEBUG   : 15234
# INFO    :  3421
# WARN    :   412
# ERROR   :    87
# FATAL   :     3
```

---

## Salesforce-Specific Examples

### Example 33: Find Governor Limit Violations
```bash
# Find SOQL limit errors
grep -i "too many soql" debug.log

# Find DML limit errors
grep -i "too many dml" debug.log

# Find CPU time limit
grep -i "cpu time limit" debug.log
```

### Example 34: Extract SOQL Queries
```bash
# Get all SOQL queries from log
grep "SOQL_EXECUTE_BEGIN" debug.log | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sed 's/Aggregations:.*//'

# Output: Clean SOQL queries
```

### Example 35: Find Apex Errors with Context
```bash
# Show errors with 10 lines of context
grep -C 10 "EXCEPTION_THROWN" debug.log | \
grep -v "^--$"  # Remove separator lines
```

### Example 36: Analyze Test Coverage
```bash
# Find classes with low coverage
grep -A 1 "Coverage for" test-result.txt | \
grep -E "[0-9]+%" | \
awk '$NF < 75 {print}'

# Shows classes below 75% coverage
```

---

## Common Patterns & Recipes

### Pattern 1: Error Monitoring
```bash
#!/bin/bash
# Monitor logs for errors
LOG_FILE="app.log"
ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")

if [ $ERROR_COUNT -gt 10 ]; then
    echo "Alert: $ERROR_COUNT errors found!"
    grep "ERROR" "$LOG_FILE" | tail -10
fi
```

### Pattern 2: Extract and Report
```bash
# Extract unique errors and count them
grep "ERROR" application.log | \
awk '{print $4}' | \
sort | uniq -c | sort -nr | \
head -20 > error_summary.txt
```

### Pattern 3: Multi-File Analysis
```bash
# Find common errors across logs
for log in *.log; do
    echo "=== $log ==="
    grep -c "ERROR" "$log"
done | sort -t: -k2 -nr
```

### Pattern 4: Real-Time Filtering
```bash
# Watch for specific patterns
tail -f deployment.log | grep -E "(ERROR|FATAL|Deploy)" --color=always
```

---

## Generic Real-World Examples

### Example 37: Apache/Nginx Log Analysis
```bash
# Find 404 errors in access log
grep " 404 " /var/log/apache2/access.log | wc -l

# Find requests from specific IP
grep "192.168.1.100" /var/log/nginx/access.log

# Count requests per HTTP method
grep -oE "GET|POST|PUT|DELETE" access.log | sort | uniq -c
```

### Example 38: System Log Monitoring
```bash
# Find authentication failures
grep "Failed password" /var/log/auth.log

# Monitor system errors in real-time
tail -f /var/log/syslog | grep -i "error\|warning"

# Find kernel messages
dmesg | grep -i "error"
```

### Example 39: Application Log Processing
```bash
# Find exceptions in Java logs
grep -A 10 "Exception" application.log | grep -v "at java\."

# Extract timestamps of errors
grep "ERROR" app.log | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"

# Find slow database queries (> 1 second)
grep "Query took" db.log | awk '$3 > 1000 {print}'
```

### Example 40: Git Operations
```bash
# Find all commits by author
git log | grep "Author: John"

# Find files changed in commits with "bugfix"
git log --oneline | grep "bugfix" | awk '{print $1}' | xargs git show --name-only

# Find merge conflicts in git diff
git diff | grep -A 5 "<<<<<<< HEAD"
```

### Example 41: Docker/Container Logs
```bash
# Find errors in container logs
docker logs mycontainer 2>&1 | grep -i "error"

# Monitor multiple containers
for container in $(docker ps --format '{{.Names}}'); do
    echo "=== $container ==="
    docker logs --tail 10 "$container" | grep -i "error"
done
```

### Example 42: CSV/TSV Data Processing
```bash
# Find rows with specific value
grep "New York" customers.csv

# Extract rows where column 3 is above threshold
awk -F',' '$3 > 1000' sales.csv

# Find duplicates in first column
cut -d',' -f1 data.csv | sort | uniq -d
```

### Example 43: Configuration Files
```bash
# Find all Python paths in configs
grep -r "python" /etc/ 2>/dev/null

# Find non-commented lines in config
grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"

# Find all environment variables
env | grep -i "path"
```

### Example 44: Network Analysis
```bash
# Find connections to specific port
netstat -an | grep ":80"

# Extract IP addresses from log
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log | sort | uniq -c

# Find failed SSH attempts
grep "Failed password" /var/log/auth.log | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
```

---

## Practice Problems

### Beginner (1-8)

1. Find all lines containing "test" in file.txt
2. Count occurrences of "ERROR" in log.txt
3. Search for "function" case-insensitively
4. List all .js files containing "console.log"
5. Find lines NOT containing "DEBUG"
6. Show line numbers for matches of "TODO"
7. Find whole word "test" (not "testing")
8. Search all .txt files in current directory

### Intermediate (9-16)

9. Find ERROR or WARNING in logs
10. Recursive search for "FIXME" in src/
11. Show 5 lines before each ERROR
12. Count unique error messages
13. Find email addresses in contacts.txt
14. Search excluding node_modules directory
15. Extract only IP addresses from log
16. Find files containing "class" but not "test"

### Advanced (17-24)

17. Find Apex method declarations
18. Extract Salesforce 15/18 char IDs
19. Monitor live log for errors with timestamps
20. Find and count error codes
21. Search in .cls and .trigger files only
22. Performance: Compare grep vs grep -F
23. Extract all SOQL queries from debug log
24. Find classes with specific annotation

### Expert (25-32)

25. Build error frequency report
26. Parse log levels and create summary
27. Find cross-references between Apex classes
28. Stream process with multiple filters
29. Parallel search in 100+ log files
30. Extract and analyze API response times
31. Build real-time dashboard from logs
32. Complex regex for custom log format

### Generic Linux (33-40)

33. Find all 404 errors in Apache/Nginx logs and count by IP
34. Monitor system logs for authentication failures
35. Extract timestamps of all errors from application log
36. Find Docker container errors across multiple containers
37. Parse CSV to find rows where column 3 > threshold
38. Find non-commented configuration lines
39. Extract and count unique IP addresses from access log
40. Search git history for commits containing "security"

---

**Solutions**: [grep Practice Solutions](../04-practice/grep-solutions.md)

**Next**: [sed - Stream Editor](./sed.md)
