# tail/head - File Viewing Commands

View the beginning or end of files efficiently.

---

## 📋 Quick Reference

### head - View Beginning

```bash
head file.txt                      # First 10 lines
head -n 20 file.txt               # First 20 lines
head -n -5 file.txt               # All except last 5 lines
head -c 100 file.txt              # First 100 bytes
head -n 1 *.txt                   # First line of each file
```

### tail - View End

```bash
tail file.txt                      # Last 10 lines
tail -n 20 file.txt               # Last 20 lines
tail -n +5 file.txt               # From line 5 to end
tail -c 100 file.txt              # Last 100 bytes
tail -f file.txt                  # Follow file (live updates)
tail -F file.txt                  # Follow by name (survives rotation)
```

---

## Common Options

| Option | Command | Purpose | Example |
|--------|---------|---------|---------|
| `-n NUM` | both | Show NUM lines | `head -n 5` |
| `-c NUM` | both | Show NUM bytes | `tail -c 100` |
| `-f` | tail | Follow file | `tail -f log.txt` |
| `-F` | tail | Follow by name | `tail -F app.log` |
| `-q` | both | Quiet (no headers) | `head -q *.txt` |
| `-v` | both | Verbose (show headers) | `tail -v *.log` |
| `--pid=PID` | tail | Follow until PID dies | `tail -f --pid=1234` |
| `-s NUM` | tail | Sleep interval for -f | `tail -f -s 2` |

---

## Beginner Level

### Example 1: View First 10 Lines (head)
```bash
# Default head behavior
head application.log

# Shows first 10 lines
```

### Example 2: View Last 10 Lines (tail)
```bash
# Default tail behavior
tail application.log

# Shows last 10 lines
```

### Example 3: Specify Line Count (head)
```bash
# First 20 lines
head -n 20 file.txt

# Short form:
head -20 file.txt
```

### Example 4: Specify Line Count (tail)
```bash
# Last 50 lines
tail -n 50 file.txt

# Short form:
tail -50 file.txt
```

### Example 5: Preview Multiple Files (head)
```bash
# First 5 lines of each file
head -n 5 *.txt

# Output shows filename headers:
# ==> file1.txt <==
# ...content...
# ==> file2.txt <==
```

### Example 6: View End of Multiple Files (tail)
```bash
# Last 5 lines of each log
tail -n 5 *.log

# Shows filename headers
```

### Example 7: Suppress Headers (head)
```bash
# View multiple files without headers
head -q -n 3 file1.txt file2.txt

# Outputs continuous content
```

### Example 8: Follow File in Real-Time (tail)
```bash
# Watch log file live
tail -f application.log

# Updates as new lines added
# Press Ctrl+C to stop
```

---

## Intermediate Level

### Example 9: Start from Specific Line (tail)
```bash
# Show from line 100 to end
tail -n +100 file.txt

# + means "starting from"
```

### Example 10: All But Last N Lines (head)
```bash
# Show all except last 5 lines
head -n -5 file.txt

# - means "exclude"
```

### Example 11: Byte Count Instead of Lines (head)
```bash
# First 1KB of file
head -c 1024 file.bin

# Useful for binary files
```

### Example 12: Last N Bytes (tail)
```bash
# Last 500 bytes
tail -c 500 file.txt

# Gets end of file by bytes
```

### Example 13: Follow with Line Limit (tail)
```bash
# Show last 20, then follow
tail -n 20 -f application.log

# Start with context, then live updates
```

### Example 14: Follow Multiple Files (tail)
```bash
# Monitor multiple logs simultaneously
tail -f /var/log/syslog /var/log/auth.log

# Shows updates from both files
```

### Example 15: Pipe with head
```bash
# Get top 5 largest files
ls -lS | head -n 6

# head -n 6 because first line is header
```

### Example 16: Pipe with tail
```bash
# Get last 5 files (oldest if sorted by time)
ls -lt | tail -n 5

# Excludes the total line
```

---

## Advanced Level

### Example 17: Middle Section of File
```bash
# Lines 100-110
head -n 110 file.txt | tail -n 10

# First take 110 lines, then last 10 of those
```

### Example 18: Follow by Name (tail -F)
```bash
# Follow file even if rotated
tail -F /var/log/application.log

# Handles log rotation
# Reopens file if renamed/deleted
```

### Example 19: Follow Until Process Ends (tail)
```bash
# Follow until PID 1234 terminates
tail -f --pid=1234 output.log

# Auto-stops when process dies
```

### Example 20: Custom Sleep Interval (tail)
```bash
# Check file every 5 seconds
tail -f -s 5 slow_update.log

# Default is 1 second
# Useful for slowly updating files
```

### Example 21: Combine with grep
```bash
# Monitor only ERROR lines
tail -f application.log | grep "ERROR"

# Real-time error monitoring
```

### Example 22: Extract Specific Line
```bash
# Get line 42
head -n 42 file.txt | tail -n 1

# Alternative: sed -n '42p' file.txt
```

### Example 23: Skip Header and Footer
```bash
# Remove first 5 and last 3 lines
head -n -3 file.txt | tail -n +6

# Useful for data files with metadata
```

### Example 24: Rotate Log Viewing
```bash
# View current and previous log
tail -n 100 app.log app.log.1

# Shows recent history across rotations
```

---

## Expert Level

### Example 25: Multi-File Follow with Filtering
```bash
# Follow multiple logs, filter errors
tail -f /var/log/*.log 2>/dev/null | grep -E "ERROR|FATAL" --color=always

# Monitors all logs for errors
```

### Example 26: Conditional Follow
```bash
# Follow file if it exists, create if not
touch -a logfile.txt && tail -f logfile.txt

# Ensures file exists before following
```

### Example 27: Performance Monitoring Loop
```bash
# Show last 5 lines every 2 seconds
while true; do clear; tail -n 5 metrics.log; sleep 2; done

# Creates live dashboard effect
```

### Example 28: Extract Time-Bounded Data
```bash
# Get logs from specific time period
grep "2025-12-05" application.log | head -n 1000 | tail -n 100

# First 100 entries after finding date
```

### Example 29: Parallel File Monitoring
```bash
# Monitor with timestamps
tail -f app.log | while read line; do echo "$(date '+%H:%M:%S') $line"; done

# Adds timestamp to each new line
```

### Example 30: Sampling Large Files
```bash
# Get representative samples
{
    head -n 100 largefile.txt
    tail -n +$(($(wc -l < largefile.txt) / 2)) largefile.txt | head -n 100
    tail -n 100 largefile.txt
} > sample.txt

# Beginning, middle, and end samples
```

### Example 31: Follow with Buffer
```bash
# Buffer output and process in batches
tail -f application.log | stdbuf -oL grep "ERROR" | xargs -n 10 process_errors.sh

# Processes errors in batches of 10
```

### Example 32: Dynamic Line Count
```bash
# Show 10% of file from end
LINES=$(wc -l < file.txt)
tail -n $((LINES / 10)) file.txt

# Adapts to file size
```

---

## Salesforce-Specific Examples

### Example 33: Monitor Apex Log Tail
```bash
# Watch latest Apex execution
sf apex get log --json | jq -r '.result[0].Id' | xargs -I {} sf apex get log --log-id {} | tail -f

# Monitors most recent log
```

### Example 34: Deployment Progress
```bash
# Watch deployment output
sf project deploy start --source-dir force-app 2>&1 | tee deploy.log &
tail -f deploy.log | grep -E "Deployed|Error"

# Shows deployment progress
```

### Example 35: Test Execution Monitoring
```bash
# Follow test execution
sf apex run test --test-level RunLocalTests --result-format human | tail -n 50

# Shows test results summary
```

### Example 36: Extract Recent Errors from Debug Log
```bash
# Get last 100 ERROR lines
sf apex get log | grep "ERROR" | tail -n 100

# Recent errors only
```

### Example 37: Analyze Log Sections
```bash
# Extract CODE_UNIT executions
sf apex get log | grep "CODE_UNIT" | head -n 20

# Shows first 20 unit starts/ends
```

### Example 38: Monitor Batch Job Progress
```bash
# Track batch apex execution
sf apex list log --json | jq -r '.[0].Id' | xargs -I {} sh -c 'watch -n 5 "sf apex get log --log-id {} | tail -n 30"'

# Refreshes batch progress
```

---

## Generic Real-World Examples

### Example 39: Web Server Log Monitoring
```bash
# Monitor access log for 404 errors
tail -f /var/log/apache2/access.log | grep " 404 "

# Real-time 404 monitoring
```

### Example 40: System Log Analysis
```bash
# Check recent system errors
tail -n 500 /var/log/syslog | grep -i error

# Last 500 lines with errors
```

### Example 41: Docker Container Logs
```bash
# Follow container logs (last 100 lines)
docker logs -f --tail 100 container_name

# Similar to tail -f
```

### Example 42: Database Query Logs
```bash
# Monitor slow queries
tail -f /var/log/mysql/slow.log | grep -A 5 "Query_time"

# Shows slow queries with context
```

### Example 43: Application Startup Logs
```bash
# View startup sequence
head -n 200 application.log | grep "Starting"

# Shows initialization
```

### Example 44: Deployment Rollback Info
```bash
# Get pre-deployment state
tail -n 1000 production.log | head -n 100

# Shows state before deployment
```

---

## Common Patterns & Recipes

### Pattern 1: Live Error Dashboard
```bash
#!/bin/bash
# Monitor errors from multiple sources
tail -f /var/log/*.log 2>/dev/null | grep --color=always -E "ERROR|FATAL|CRITICAL"
```

### Pattern 2: Log Sampling for Analysis
```bash
# Get representative sample of large log
{
    echo "=== BEGINNING ==="
    head -n 100 huge.log
    echo "=== MIDDLE ==="
    TOTAL=$(wc -l < huge.log)
    tail -n +$((TOTAL/2)) huge.log | head -n 100
    echo "=== END ==="
    tail -n 100 huge.log
} > sample.log
```

### Pattern 3: Rotating Log Viewer
```bash
# View across log rotations
for log in app.log{,.{1..5}}; do
    [ -f "$log" ] && {
        echo "=== $log ==="
        tail -n 20 "$log"
    }
done
```

### Pattern 4: Conditional File Following
```bash
# Follow file when it appears
while [ ! -f "output.log" ]; do sleep 1; done
echo "File appeared, following..."
tail -f output.log
```

### Pattern 5: Extract Specific Time Window
```bash
# Get logs between two timestamps
sed -n '/2025-12-05 10:00/,/2025-12-05 11:00/p' app.log | \
tail -n +1 | \
head -n 1000 > time_window.log
```

---

## Practice Problems

### Beginner (1-8)

1. Show first 15 lines of a file
2. Show last 25 lines of a file
3. View first 5 lines of all .txt files
4. Follow a log file in real-time
5. Show last line only
6. Show first line of multiple files without headers
7. View last 3 lines of each .log file
8. Show first 100 bytes of a file

### Intermediate (9-16)

9. Show lines 50-60 of a file
10. Show all but first 10 lines
11. Show all but last 10 lines
12. Follow file starting from last 50 lines
13. Get line 100 exactly
14. Monitor multiple files simultaneously
15. Show last 1KB of binary file
16. View from line 200 to end of file

### Advanced (17-24)

17. Follow file even during log rotation
18. Extract middle 100 lines of 1000-line file
19. Monitor log and show only ERROR lines
20. Follow until specific process terminates
21. Create sampling of large log file
22. Monitor with custom timestamps
23. Show lines between two patterns
24. Follow with 5-second update interval

### Expert (25-32)

25. Multi-file monitoring with colored output
26. Dynamic percentage-based tail
27. Buffered batch processing from tail
28. Conditional follow with file creation
29. Performance metrics dashboard with head/tail
30. Time-bounded log extraction
31. Parallel monitoring with timestamps
32. Smart log rotation viewer

---

**Solutions**: [tail/head Practice Solutions](../04-practice/tail-head-solutions.md)

**Next**: [cat - Concatenate](./cat.md)
