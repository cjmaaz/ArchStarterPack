# wc - Word, Line, and Byte Count

Count lines, words, characters, and bytes in files.

---

## 📋 Quick Reference

```bash
wc file.txt                        # Lines, words, bytes
wc -l file.txt                     # Count lines only
wc -w file.txt                     # Count words only
wc -c file.txt                     # Count bytes only
wc -m file.txt                     # Count characters only
wc -L file.txt                     # Longest line length
ls | wc -l                         # Count files in directory
grep "pattern" file.txt | wc -l    # Count matching lines
cat *.txt | wc -w                  # Total words in all files
wc -l *.txt                        # Line count per file + total
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-l` | Count lines | `wc -l file.txt` |
| `-w` | Count words | `wc -w file.txt` |
| `-c` | Count bytes | `wc -c file.txt` |
| `-m` | Count characters | `wc -m file.txt` |
| `-L` | Longest line length | `wc -L file.txt` |

### Default Output Format

```bash
wc file.txt
# Output:  lines  words  bytes filename
#          10     45     256   file.txt
```

---

## Beginner Level

### Example 1: Count Everything (Default)
```bash
# Show lines, words, and bytes
wc file.txt

# Output:
#   10   45   256 file.txt
# Lines Words Bytes
```

### Example 2: Count Lines Only
```bash
# Most common usage
wc -l file.txt

# Output:
#   10 file.txt
```

### Example 3: Count Words Only
```bash
# Total words
wc -w file.txt

# Output:
#   45 file.txt
```

### Example 4: Count Bytes
```bash
# File size in bytes
wc -c file.txt

# Output:
#   256 file.txt
```

### Example 5: Count Characters
```bash
# Character count (different from bytes for UTF-8)
wc -m file.txt

# Output:
#   250 file.txt
```

### Example 6: Count Files in Directory
```bash
# Number of files
ls | wc -l

# Counts output lines from ls
```

### Example 7: Count Matches
```bash
# Count occurrences of "ERROR"
grep "ERROR" log.txt | wc -l

# Number of error lines
```

### Example 8: Longest Line Length
```bash
# Find longest line
wc -L file.txt

# Output:
#   42 file.txt
# (longest line has 42 characters)
```

---

## Intermediate Level

### Example 9: Count Lines in Multiple Files
```bash
# Per-file count + total
wc -l file1.txt file2.txt file3.txt

# Output:
#   10 file1.txt
#   15 file2.txt
#   20 file3.txt
#   45 total
```

### Example 10: Count Lines Without Filename
```bash
# Suppress filename in output
wc -l < file.txt

# Output:
#   10
# (no filename shown)
```

### Example 11: Total Words Across Files
```bash
# Combined word count
cat *.txt | wc -w

# Total words in all .txt files
```

### Example 12: Compare File Sizes
```bash
# Show bytes for each file
wc -c *.log

# Lists size of each log file
```

### Example 13: Count Unique Lines
```bash
# Number of unique lines
sort file.txt | uniq | wc -l

# Distinct line count
```

### Example 14: Count Non-Empty Lines
```bash
# Lines with content
grep -v "^$" file.txt | wc -l

# Excludes blank lines
```

### Example 15: Count Lines Matching Pattern
```bash
# Lines containing "TODO"
grep -c "TODO" *.js

# Per-file TODO count
# Same as: grep "TODO" *.js | wc -l
```

### Example 16: Estimate File Complexity
```bash
# Calculate average line length
BYTES=$(wc -c < file.txt)
LINES=$(wc -l < file.txt)
echo "scale=2; $BYTES / $LINES" | bc

# Average characters per line
```

---

## Advanced Level

### Example 17: Count Files Recursively
```bash
# All files in directory tree
find . -type f | wc -l

# Total file count
```

### Example 18: Count by File Type
```bash
# Count for each extension
for ext in txt log csv; do
    count=$(find . -name "*.$ext" | wc -l)
    echo "$ext files: $count"
done

# File type distribution
```

### Example 19: Percentage Calculation
```bash
# What percent of lines contain "ERROR"?
TOTAL=$(wc -l < log.txt)
ERRORS=$(grep -c "ERROR" log.txt)
echo "scale=2; $ERRORS * 100 / $TOTAL" | bc

# Output: 5.23 (percent)
```

### Example 20: Line Count Statistics
```bash
# Min, max, average line length
awk '{print length}' file.txt | \
sort -n | \
awk '{sum+=$1; if(NR==1) min=$1; max=$1} END {print "Min:", min, "Max:", max, "Avg:", sum/NR}'

# Line length statistics
```

### Example 21: Count Pattern Frequency
```bash
# How many times does each word appear?
tr ' ' '\n' < file.txt | sort | uniq -c | sort -nr | head -10

# Top 10 words
```

### Example 22: Compare Directory Sizes (Line Count)
```bash
# Line count by directory
for dir in */; do
    count=$(find "$dir" -name "*.txt" -exec cat {} \; | wc -l)
    echo "$dir: $count lines"
done

# Per-directory metrics
```

### Example 23: Validate File Size
```bash
# Check if file exceeds size limit
MAX_SIZE=1000000
SIZE=$(wc -c < file.txt)
if [ $SIZE -gt $MAX_SIZE ]; then
    echo "File too large: $SIZE bytes"
fi

# Size validation
```

### Example 24: Count Code vs Comments
```bash
# Code lines vs comment lines
CODE=$(grep -v "^\s*#\|^\s*$" script.py | wc -l)
COMMENTS=$(grep "^\s*#" script.py | wc -l)
echo "Code: $CODE, Comments: $COMMENTS"

# Code statistics
```

---

## Expert Level

### Example 25: Comprehensive File Metrics
```bash
# Complete file analysis
FILE="document.txt"
echo "File: $FILE"
echo "Lines: $(wc -l < $FILE)"
echo "Words: $(wc -w < $FILE)"
echo "Characters: $(wc -m < $FILE)"
echo "Bytes: $(wc -c < $FILE)"
echo "Longest line: $(wc -L < $FILE)"
echo "Unique lines: $(sort $FILE | uniq | wc -l)"
echo "Empty lines: $(grep -c "^$" $FILE)"

# Full report
```

### Example 26: Performance Metrics
```bash
# Process large file efficiently
time wc -l hugefile.txt

# Benchmark line counting
```

### Example 27: Parallel Counting
```bash
# Count multiple files in parallel
find . -name "*.log" -print0 | \
xargs -0 -P 4 -I {} sh -c 'echo "{}:$(wc -l < {})"'

# Parallel line counting
```

### Example 28: Stream Counting
```bash
# Real-time line count
tail -f application.log | \
while read line; do
    COUNT=$((COUNT + 1))
    echo "Lines processed: $COUNT"
done

# Live counter
```

### Example 29: Memory-Efficient Counting
```bash
# Count without loading file
wc -l < /dev/stdin < hugefile.txt

# Streams through file
```

### Example 30: Multi-Dimensional Counting
```bash
# Count by multiple criteria
echo "=== File Analysis ==="
echo "Total lines: $(wc -l < file.txt)"
echo "Non-empty: $(grep -cv "^$" file.txt)"
echo "With 'ERROR': $(grep -c "ERROR" file.txt)"
echo "With 'WARN': $(grep -c "WARN" file.txt)"
echo "With 'INFO': $(grep -c "INFO" file.txt)"

# Categorized counts
```

### Example 31: Database-Style Aggregation
```bash
# Count and group by field
cut -d ',' -f 2 data.csv | sort | uniq -c | \
awk '{sum+=$1; print} END {print "Total:", sum}'

# Aggregate counting
```

### Example 32: Verify File Integrity
```bash
# Check if file line count matches expected
EXPECTED=1000
ACTUAL=$(wc -l < data.txt)
if [ $ACTUAL -eq $EXPECTED ]; then
    echo "✓ Line count correct"
else
    echo "✗ Expected $EXPECTED, got $ACTUAL"
    exit 1
fi

# Data integrity check
```

---

## Salesforce-Specific Examples

### Example 33: Count Apex Classes
```bash
# Number of Apex classes in project
find force-app -name "*.cls" | wc -l

# Class inventory
```

### Example 34: Count Lines of Apex Code
```bash
# Total Apex lines
find force-app -name "*.cls" -exec cat {} \; | wc -l

# Code volume metric
```

### Example 35: Count SOQL Query Results
```bash
# Number of records returned
sf data query --query "SELECT Id FROM Account" --json | \
jq '.result.records | length'

# Or using wc:
sf data query --query "SELECT Id FROM Account" | \
grep -v "^---\|^Id" | wc -l

# Record count
```

### Example 36: Count Test Classes
```bash
# Number of test classes
find force-app -name "*Test.cls" -o -name "*_Test.cls" | wc -l

# Test coverage inventory
```

### Example 37: Count Errors in Debug Log
```bash
# Error frequency
sf apex get log | grep -c "ERROR"

# Error count
```

### Example 38: Count Metadata Components
```bash
# Components by type
for type in cls trigger lwc; do
    count=$(find force-app -name "*.$type" | wc -l)
    echo "$type: $count"
done

# Metadata inventory
```

---

## Generic Real-World Examples

### Example 39: Count User Accounts
```bash
# Number of user accounts
wc -l < /etc/passwd

# System user count
```

### Example 40: Monitor Log Growth
```bash
# Check log file size over time
while true; do
    echo "$(date): $(wc -l < app.log) lines"
    sleep 60
done

# Log growth monitoring
```

### Example 41: Count HTTP Requests
```bash
# Total requests in access log
wc -l < /var/log/apache2/access.log

# Request volume
```

### Example 42: Count Unique IPs
```bash
# Distinct visitors
awk '{print $1}' access.log | sort -u | wc -l

# Unique IP count
```

### Example 43: Count Git Commits
```bash
# Total commits in repository
git log --oneline | wc -l

# Commit count
```

### Example 44: Count Docker Containers
```bash
# Running containers
docker ps | wc -l
# Subtract 1 for header

# Container count
```

---

## Common Patterns & Recipes

### Pattern 1: Quick File Summary
```bash
# One-line file report
echo "$(wc -l < file.txt) lines, $(wc -w < file.txt) words, $(wc -c < file.txt) bytes"
```

### Pattern 2: Progress Tracking
```bash
# Show processing progress
TOTAL=$(wc -l < tasks.txt)
CURRENT=0
while read task; do
    process_task "$task"
    CURRENT=$((CURRENT + 1))
    echo "Progress: $CURRENT/$TOTAL"
done < tasks.txt
```

### Pattern 3: Size Comparison
```bash
# Compare file sizes
for file in *.log; do
    printf "%-20s %10s lines\n" "$file" "$(wc -l < $file)"
done | sort -k 2 -nr
```

### Pattern 4: Data Quality Check
```bash
# Validate CSV row count
HEADER_COUNT=$(head -1 file.csv | tr ',' '\n' | wc -l)
while read line; do
    FIELD_COUNT=$(echo "$line" | tr ',' '\n' | wc -l)
    if [ $FIELD_COUNT -ne $HEADER_COUNT ]; then
        echo "Invalid row: $line"
    fi
done < file.csv
```

### Pattern 5: Summary Statistics
```bash
# Generate statistics report
{
    echo "=== FILE STATISTICS ==="
    echo "Files: $(find . -type f | wc -l)"
    echo "Directories: $(find . -type d | wc -l)"
    echo "Total lines: $(find . -name "*.txt" -exec cat {} \; | wc -l)"
    echo "Total size: $(find . -type f -exec cat {} \; | wc -c) bytes"
} > report.txt
```

---

## Practice Problems

### Beginner (1-8)

1. Count lines in a file
2. Count words in a file
3. Count bytes in a file
4. Count characters in a file
5. Find longest line length
6. Count files in current directory
7. Count lines matching "ERROR" in log file
8. Count total words across multiple files

### Intermediate (9-16)

9. Count lines in multiple files with total
10. Count lines without showing filename
11. Count unique lines in a file
12. Count non-empty lines only
13. Count files recursively
14. Calculate average line length
15. Calculate percentage of lines with pattern
16. Compare file sizes using wc

### Advanced (17-24)

17. Count files by extension type
18. Generate line length statistics (min/max/avg)
19. Count word frequency (top 10)
20. Count lines by directory
21. Validate file size against limit
22. Count code lines vs comment lines
23. Count files and group by type
24. Multi-criteria line counting

### Expert (25-32)

25. Generate comprehensive file metrics report
26. Parallel file counting across directories
27. Real-time streaming line counter
28. Memory-efficient counting for huge files
29. Multi-dimensional categorized counting
30. Database-style aggregation with counts
31. Verify file integrity with line count check
32. Monitor and track log growth over time

---

**Solutions**: [wc Practice Solutions](../04-practice/wc-solutions.md)

**Next**: [tr - Translate Characters](./tr.md)
