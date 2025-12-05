# Advanced Level Practice - 20 Exercises

Master complex shell command patterns and workflows.

---

## Exercise 1: Multi-Stage Log Processing
**Task**: From an Apache access log, extract the top 10 most accessed URLs along with their request counts, excluding static assets (.css, .js, .png, .jpg).

**Sample Input** (access.log):
```
192.168.1.1 - - [05/Dec/2025:10:15:30] "GET /index.html HTTP/1.1" 200
192.168.1.2 - - [05/Dec/2025:10:16:45] "GET /api/users HTTP/1.1" 200
192.168.1.1 - - [05/Dec/2025:10:17:22] "GET /styles.css HTTP/1.1" 200
192.168.1.3 - - [05/Dec/2025:10:18:10] "GET /api/users HTTP/1.1" 200
```

<details>
<summary>Solution</summary>

```bash
awk '{print $7}' access.log | \
grep -v '\.\(css\|js\|png\|jpg\|gif\)$' | \
sort | \
uniq -c | \
sort -nr | \
head -10
```

**Explanation**:
- `awk '{print $7}'` extracts URL column
- `grep -v` excludes static assets
- `sort | uniq -c` counts occurrences
- `sort -nr` sorts by count descending
- `head -10` gets top 10

</details>

---

## Exercise 2: Process Substitution for Comparison
**Task**: Find common lines between two files without creating temporary files, where both files need to be sorted first.

<details>
<summary>Solution</summary>

```bash
comm -12 <(sort file1.txt) <(sort file2.txt)
```

**Alternative with diff**:
```bash
diff <(sort file1.txt) <(sort file2.txt) | grep "^< " | sed 's/^< //'
```

**Explanation**:
- `<(...)` creates virtual file from command output
- `comm -12` shows only common lines
- No temporary files needed

</details>

---

## Exercise 3: Parallel File Processing
**Task**: Process all .txt files in a directory in parallel (max 4 concurrent), converting each to uppercase and saving with .upper extension.

<details>
<summary>Solution</summary>

```bash
find . -name "*.txt" -print0 | \
xargs -0 -P 4 -I {} sh -c 'tr "[:lower:]" "[:upper:]" < "{}" > "{}.upper"'
```

**Alternative with loop**:
```bash
for file in *.txt; do
    while [ $(jobs -r | wc -l) -ge 4 ]; do
        wait -n 2>/dev/null || true
    done
    tr "[:lower:]" "[:upper:]" < "$file" > "${file}.upper" &
done
wait
```

**Explanation**:
- `xargs -P 4` runs 4 processes in parallel
- Loop version manually controls concurrency
- `wait -n` waits for any job to complete

</details>

---

## Exercise 4: Complex SOQL Log Analysis
**Task**: From a Salesforce debug log, extract all SOQL queries, identify queries executed more than 5 times (potential N+1), and show the query pattern with count.

<details>
<summary>Solution</summary>

```bash
grep "SOQL_EXECUTE_BEGIN" debug.log | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sed 's/ WHERE.*//' | \
sed 's/[0-9]\+/?/g' | \
sort | \
uniq -c | \
sort -nr | \
awk '$1 > 5 {print "N+1 Pattern (executed "$1" times):", substr($0, index($0,$2))}'
```

**Explanation**:
- Extract queries with `grep`
- Remove WHERE clauses for pattern matching
- Replace numbers with ? for generalization
- Count patterns and filter >5 executions

</details>

---

## Exercise 5: Dynamic Backup with Rotation
**Task**: Create a backup script that keeps only the last 5 backups, automatically deleting older ones.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
BACKUP_DIR="backups"
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_DIR/$BACKUP_NAME" /data/

# Keep only last 5 backups
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Backup created: $BACKUP_NAME"
echo "Total backups: $(ls "$BACKUP_DIR"/backup_*.tar.gz | wc -l)"
```

**Explanation**:
- `ls -t` sorts by time (newest first)
- `tail -n +6` skips first 5, shows rest
- `xargs -r rm` removes old backups

</details>

---

## Exercise 6: Real-Time Log Monitoring with Alert
**Task**: Monitor a log file in real-time. If more than 10 errors occur within 60 seconds, send an alert.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
ERROR_COUNT=0
WINDOW_START=$(date +%s)

tail -f application.log | grep --line-buffered "ERROR" | while read line; do
    CURRENT_TIME=$(date +%s)
    
    # Reset counter if window expired
    if [ $((CURRENT_TIME - WINDOW_START)) -gt 60 ]; then
        ERROR_COUNT=0
        WINDOW_START=$CURRENT_TIME
    fi
    
    ERROR_COUNT=$((ERROR_COUNT + 1))
    
    # Check threshold
    if [ $ERROR_COUNT -gt 10 ]; then
        echo "ALERT: $ERROR_COUNT errors in last 60 seconds!"
        # send_alert_notification
        ERROR_COUNT=0
        WINDOW_START=$CURRENT_TIME
    fi
done
```

**Explanation**:
- Time-window based counting
- Resets counter every 60 seconds
- Triggers alert when threshold exceeded

</details>

---

## Exercise 7: CSV Data Transformation
**Task**: Convert a CSV file from format "LastName,FirstName,Age,City" to "City|FirstName LastName|Age" sorted by city.

**Input**:
```
Doe,John,30,NYC
Smith,Jane,25,Boston
Brown,Bob,35,NYC
```

<details>
<summary>Solution</summary>

```bash
tail -n +2 input.csv | \
awk -F',' '{print $4"|"$2" "$1"|"$3}' | \
sort -t'|' -k1,1
```

**With header**:
```bash
{
    echo "City|Name|Age"
    tail -n +2 input.csv | awk -F',' '{print $4"|"$2" "$1"|"$3}' | sort -t'|' -k1,1
} > output.csv
```

**Explanation**:
- `tail -n +2` skips header
- `awk` reformats fields
- `sort -t'|'` sorts by city

</details>

---

## Exercise 8: Find and Archive Large Files
**Task**: Find all files larger than 100MB modified in the last 30 days, create a dated archive, and generate a manifest.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
ARCHIVE_NAME="large_files_$(date +%Y%m%d).tar.gz"
MANIFEST="manifest_$(date +%Y%m%d).txt"

# Find files and create manifest
find /data -type f -size +100M -mtime -30 -ls > "$MANIFEST"

# Create archive
find /data -type f -size +100M -mtime -30 -print0 | \
tar -czf "$ARCHIVE_NAME" --null -T -

# Summary
echo "Archive: $ARCHIVE_NAME"
echo "Files: $(tar -tzf "$ARCHIVE_NAME" | wc -l)"
echo "Size: $(du -h "$ARCHIVE_NAME" | cut -f1)"
```

**Explanation**:
- `find -ls` creates detailed manifest
- `-print0` with `--null` handles spaces
- `-T -` reads file list from stdin

</details>

---

## Exercise 9: Deployment Error Aggregation
**Task**: Analyze multiple Salesforce deployment logs and create a summary showing unique errors and their frequency across all deployments.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
{
    echo "=== Deployment Error Analysis ==="
    echo "Files analyzed: $(ls deploy_*.log | wc -l)"
    echo
    
    # Extract and count errors
    grep -h "ERROR" deploy_*.log | \
    sed 's/.*ERROR: //' | \
    sed 's/at line [0-9]*/at line XXX/' | \
    sort | \
    uniq -c | \
    sort -nr | \
    awk '{printf "%3d occurrences: %s\n", $1, substr($0, index($0,$2))}'
    
    echo
    echo "=== By Deployment ==="
    for log in deploy_*.log; do
        errors=$(grep -c "ERROR" "$log")
        echo "$log: $errors errors"
    done | sort -t: -k2 -nr
    
} | tee error_analysis.txt
```

**Explanation**:
- `-h` suppresses filenames in grep
- Normalizes error messages
- Aggregates across all logs
- Creates per-file summary

</details>

---

## Exercise 10: Stream Processing Pipeline
**Task**: Create a pipeline that reads from a named pipe, processes data (uppercase conversion), filters lines containing "IMPORTANT", and writes to another pipe while also logging to a file.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# Create pipes
mkfifo input_pipe output_pipe

# Start processor in background
{
    while read line; do
        # Convert to uppercase
        echo "$line" | tr '[:lower:]' '[:upper:]'
    done < input_pipe | \
    # Filter important
    grep "IMPORTANT" | \
    # Output and log
    tee -a processed.log > output_pipe
} &

PROCESSOR_PID=$!

# Consumer
{
    while read line; do
        echo "Received: $line"
    done < output_pipe
} &

CONSUMER_PID=$!

# Producer (example)
echo "important message" > input_pipe
echo "not important" > input_pipe
echo "another important item" > input_pipe

# Cleanup
sleep 2
kill $PROCESSOR_PID $CONSUMER_PID 2>/dev/null
rm input_pipe output_pipe
```

**Explanation**:
- Named pipes for IPC
- Parallel producer-processor-consumer
- `tee` for simultaneous logging and output

</details>

---

## Exercise 11: Git Repository Analysis
**Task**: Analyze a Git repository to find the 10 files that have been modified most frequently, along with the number of commits for each.

<details>
<summary>Solution</summary>

```bash
git log --name-only --pretty=format: | \
grep -v '^$' | \
sort | \
uniq -c | \
sort -nr | \
head -10 | \
awk '{printf "%4d commits: %s\n", $1, $2}'
```

**With file type filtering**:
```bash
git log --name-only --pretty=format: -- '*.js' '*.ts' | \
grep -v '^$' | \
sort | \
uniq -c | \
sort -nr | \
head -10
```

**Explanation**:
- `--name-only` shows only filenames
- `--pretty=format:` suppresses commit info
- Aggregates and ranks by frequency

</details>

---

## Exercise 12: Complex File Descriptor Management
**Task**: Create a script that logs different message types to different files using file descriptors, then combines them into a final report.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# Open file descriptors
exec 3> debug.log
exec 4> info.log
exec 5> error.log

# Logging functions
debug() { echo "[DEBUG] $(date '+%H:%M:%S') $*" >&3; }
info() { echo "[INFO] $(date '+%H:%M:%S') $*" >&4; }
error() { echo "[ERROR] $(date '+%H:%M:%S') $*" >&5; }

# Use them
debug "Starting process"
info "Processing file 1"
error "File not found: missing.txt"
info "Processing file 2"
debug "Process complete"

# Close descriptors
exec 3>&- 4>&- 5>&-

# Generate report
{
    echo "=== ERRORS ==="
    cat error.log
    echo
    echo "=== INFO ==="
    cat info.log
    echo
    echo "=== DEBUG ==="
    cat debug.log
} > combined_report.txt

echo "Report generated: combined_report.txt"
```

**Explanation**:
- FD 3,4,5 for different log levels
- Separate logging functions
- Combined final report

</details>

---

## Exercise 13: Performance Benchmarking
**Task**: Create a script that benchmarks different approaches to counting lines in large files and reports the fastest method.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
FILE="largefile.txt"

# Create test file if needed
if [ ! -f "$FILE" ]; then
    seq 1 1000000 > "$FILE"
fi

echo "=== Performance Benchmark ==="
echo "File: $FILE ($(du -h $FILE | cut -f1))"
echo

# Method 1: wc -l
START=$(date +%s.%N)
wc -l < "$FILE" > /dev/null
END=$(date +%s.%N)
TIME1=$(echo "$END - $START" | bc)
echo "wc -l: ${TIME1}s"

# Method 2: grep -c
START=$(date +%s.%N)
grep -c '' "$FILE" > /dev/null
END=$(date +%s.%N)
TIME2=$(echo "$END - $START" | bc)
echo "grep -c: ${TIME2}s"

# Method 3: awk
START=$(date +%s.%N)
awk 'END {print NR}' "$FILE" > /dev/null
END=$(date +%s.%N)
TIME3=$(echo "$END - $START" | bc)
echo "awk: ${TIME3}s"

# Find fastest
echo
echo "Fastest method:"
printf "wc -l\t%s\ngrep\t%s\nawk\t%s\n" "$TIME1" "$TIME2" "$TIME3" | \
sort -k2 -n | head -1 | awk '{print $1}'
```

**Explanation**:
- `date +%s.%N` for precise timing
- Tests multiple methods
- Reports fastest approach

</details>

---

## Exercise 14: Apex Code Coverage Analysis
**Task**: Parse Apex test results JSON and generate a formatted report showing classes below 75% coverage, sorted by coverage percentage.

<details>
<summary>Solution</summary>

```bash
sf apex run test --code-coverage --json > test_results.json

jq -r '
.result.coverage.coverage[] | 
select(.coveredPercent < 75) | 
[.coveredPercent, .name, .numLocations, .numLocationsNotCovered] | 
@tsv
' test_results.json | \
sort -n | \
awk -F'\t' '
BEGIN {
    printf "%-8s %-40s %10s %10s\n", "Coverage", "Class Name", "Total", "Uncovered"
    printf "%-8s %-40s %10s %10s\n", "--------", "----------", "-----", "---------"
}
{
    printf "%-7s%% %-40s %10d %10d\n", $1, $2, $3, $4
}
'
```

**Explanation**:
- `jq` filters and extracts data
- `@tsv` creates tab-separated output
- `awk` formats as table

</details>

---

## Exercise 15: Automated Rollback System
**Task**: Create a deployment script that automatically rolls back if post-deployment health checks fail.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
ORG="${1:-production}"
BACKUP_DIR="/tmp/backup_$(date +%Y%m%d_%H%M%S)"

# Backup function
backup() {
    echo "Creating backup..."
    mkdir -p "$BACKUP_DIR"
    sf project retrieve start --target-org "$ORG" --output-dir "$BACKUP_DIR"
}

# Rollback function
rollback() {
    echo "!!! ROLLING BACK !!!"
    sf project deploy start --source-dir "$BACKUP_DIR" --target-org "$ORG"
    rm -rf "$BACKUP_DIR"
    exit 1
}

# Health check function
health_check() {
    echo "Running health checks..."
    
    # Check 1: Verify deployment
    if ! sf org display --target-org "$ORG" > /dev/null 2>&1; then
        echo "✗ Org not accessible"
        return 1
    fi
    
    # Check 2: Verify critical classes exist
    CLASS_COUNT=$(sf data query --query "SELECT COUNT() FROM ApexClass" --target-org "$ORG" --json | jq '.result.totalSize')
    if [ "$CLASS_COUNT" -lt 10 ]; then
        echo "✗ Critical classes missing"
        return 1
    fi
    
    # Check 3: Run smoke tests
    if ! sf apex run --file smoke_test.apex --target-org "$ORG" > /dev/null 2>&1; then
        echo "✗ Smoke tests failed"
        return 1
    fi
    
    echo "✓ All health checks passed"
    return 0
}

# Main deployment
trap rollback ERR

backup
echo "Deploying..."
sf project deploy start --target-org "$ORG"

# Verify deployment
if ! health_check; then
    rollback
fi

# Success - cleanup backup
rm -rf "$BACKUP_DIR"
echo "✓ Deployment successful"
```

**Explanation**:
- `trap` catches errors
- Comprehensive health checks
- Automatic rollback on failure
- Cleanup on success

</details>

---

## Exercise 16: Multi-Source Data Aggregation
**Task**: Aggregate data from 3 different CSV files, calculate sum by category, and generate a combined report with percentages.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# Combine all CSVs (skip headers except first)
{
    head -1 file1.csv
    tail -n +2 file1.csv
    tail -n +2 file2.csv
    tail -n +2 file3.csv
} > combined.csv

# Aggregate by category
awk -F',' '
NR > 1 {
    category[$1] += $2
    total += $2
}
END {
    for (cat in category) {
        percent = (category[cat] / total) * 100
        printf "%s,%d,%.2f%%\n", cat, category[cat], percent
    }
}
' combined.csv | \
sort -t',' -k2 -nr | \
{
    echo "Category,Amount,Percentage"
    cat
} > aggregated_report.csv

# Display
column -t -s',' < aggregated_report.csv
```

**Explanation**:
- Combines multiple CSVs
- Calculates totals and percentages
- Sorts by amount
- Formats as table

</details>

---

## Exercise 17: Network Log Analysis
**Task**: From network connection logs, identify IPs that attempted connections to suspicious ports (other than 80, 443, 22) more than 5 times.

<details>
<summary>Solution</summary>

```bash
awk '
$3 !~ /:(80|443|22)$/ {
    key = $1 ":" $3
    count[key]++
    ip_port[$1] = $1
}
END {
    for (item in count) {
        if (count[item] > 5) {
            split(item, parts, ":")
            printf "%s attempted port %s %d times\n", parts[1], parts[3], count[item]
        }
    }
}
' connections.log | \
sort -k5 -nr
```

**Explanation**:
- Filters non-standard ports
- Counts attempts per IP-port combination
- Reports suspicious activity

</details>

---

## Exercise 18: Incremental Backup System
**Task**: Create a backup system that only backs up files changed since last backup, maintaining a backup log.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
BACKUP_DIR="incremental_backups"
LOG_FILE="$BACKUP_DIR/backup.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

# Get last backup time
if [ -f "$LOG_FILE" ]; then
    LAST_BACKUP=$(tail -1 "$LOG_FILE" | cut -d'|' -f1)
    echo "Last backup: $LAST_BACKUP"
    
    # Find files changed since last backup
    find /data -type f -newer "$LOG_FILE" -print0 | \
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" --null -T -
else
    echo "First backup - backing up all files"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" /data
fi

# Log backup
FILE_COUNT=$(tar -tzf "$BACKUP_DIR/$BACKUP_NAME" | wc -l)
SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
echo "$TIMESTAMP|$BACKUP_NAME|$FILE_COUNT files|$SIZE" >> "$LOG_FILE"

echo "Incremental backup complete: $BACKUP_NAME"
```

**Explanation**:
- Uses `-newer` to find changed files
- Maintains backup log
- Incremental approach saves space

</details>

---

## Exercise 19: Complex Text Transformation
**Task**: Transform a multi-line configuration file where each section should be converted to a single JSON object.

**Input**:
```
[server1]
host=192.168.1.1
port=8080
status=active

[server2]
host=192.168.1.2
port=8081
status=inactive
```

<details>
<summary>Solution</summary>

```bash
awk '
BEGIN {
    print "["
    first = 1
}
/^\[.*\]$/ {
    if (!first) print "  },"
    first = 0
    name = substr($0, 2, length($0)-2)
    printf "  {\n    \"name\": \"%s\",\n", name
    next
}
/=/ {
    split($0, parts, "=")
    key = parts[1]
    value = parts[2]
    printf "    \"%s\": \"%s\",\n", key, value
}
END {
    print "  }"
    print "]"
}
' config.ini | sed 's/,$//' > config.json
```

**Explanation**:
- Parses INI-style sections
- Generates JSON structure
- Handles comma placement

</details>

---

## Exercise 20: Production Monitoring Dashboard
**Task**: Create a real-time monitoring dashboard that displays CPU, memory, disk, and network stats, refreshing every 5 seconds.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash

while true; do
    clear
    echo "========================================"
    echo "  SYSTEM MONITORING DASHBOARD"
    echo "  $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================"
    echo
    
    # CPU Usage
    echo "=== CPU ==="
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    printf "Usage: %.1f%%\n" "$CPU"
    echo
    
    # Memory
    echo "=== MEMORY ==="
    free -h | awk 'NR==2 {printf "Used: %s / %s (%.1f%%)\n", $3, $2, ($3/$2)*100}'
    echo
    
    # Disk
    echo "=== DISK ==="
    df -h / | awk 'NR==2 {printf "Used: %s / %s (%s)\n", $3, $2, $5}'
    echo
    
    # Top Processes
    echo "=== TOP 5 PROCESSES (by CPU) ==="
    ps aux | sort -k3 -nr | head -6 | tail -5 | \
    awk '{printf "%-10s %5s%% %5s%% %s\n", $1, $3, $4, $11}'
    echo
    
    # Network
    echo "=== NETWORK ==="
    if command -v netstat > /dev/null; then
        CONNECTIONS=$(netstat -an | grep ESTABLISHED | wc -l)
        echo "Active connections: $CONNECTIONS"
    fi
    
    echo "========================================"
    echo "Press Ctrl+C to exit"
    
    sleep 5
done
```

**Explanation**:
- Continuous loop with clear
- Aggregates multiple metrics
- Formatted output
- Auto-refresh every 5 seconds

</details>

---

**Next**: [Expert Level Practice](./expert.md)
