# uniq - Filter Duplicate Lines

Report or filter out repeated lines in a file.

---

## 📋 Quick Reference

```bash
uniq file.txt                      # Remove consecutive duplicates
uniq -c file.txt                   # Count occurrences
uniq -d file.txt                   # Show only duplicate lines
uniq -u file.txt                   # Show only unique lines
uniq -i file.txt                   # Case-insensitive comparison
uniq -f 2 file.txt                 # Skip first 2 fields
uniq -s 5 file.txt                 # Skip first 5 characters
sort file.txt | uniq               # Remove all duplicates
sort file.txt | uniq -c | sort -nr # Frequency count (most common first)
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-c` | Count occurrences | `uniq -c file.txt` |
| `-d` | Show only duplicates | `uniq -d file.txt` |
| `-u` | Show only unique | `uniq -u file.txt` |
| `-i` | Case-insensitive | `uniq -i file.txt` |
| `-f N` | Skip N fields | `uniq -f 2 file.txt` |
| `-s N` | Skip N characters | `uniq -s 5 file.txt` |
| `-w N` | Compare only N characters | `uniq -w 10 file.txt` |
| `-D` | Show all duplicates | `uniq -D file.txt` |

---

## Important Note

**uniq only removes CONSECUTIVE duplicate lines**. Always use `sort` before `uniq` to catch all duplicates:

```bash
# Wrong: misses non-consecutive duplicates
uniq file.txt

# Right: catches all duplicates
sort file.txt | uniq
```

---

## Beginner Level

### Example 1: Remove Consecutive Duplicates
```bash
# Basic deduplication
uniq file.txt

# Input:
# apple
# apple
# banana
# apple

# Output:
# apple
# banana
# apple  <- Not removed (not consecutive)
```

### Example 2: Remove All Duplicates
```bash
# Sort first to catch all duplicates
sort file.txt | uniq

# Input:        Output:
# apple         apple
# apple         banana
# banana        orange
# apple
# orange
```

### Example 3: Count Occurrences
```bash
# Show count for each line
sort file.txt | uniq -c

# Output:
#   3 apple
#   1 banana
#   1 orange
```

### Example 4: Show Only Duplicates
```bash
# Lines that appear more than once
sort file.txt | uniq -d

# Output:
# apple  <- Appeared multiple times
```

### Example 5: Show Only Unique Lines
```bash
# Lines that appear exactly once
sort file.txt | uniq -u

# Output:
# banana
# orange
```

### Example 6: Case-Insensitive Deduplication
```bash
# Ignore case when comparing
uniq -i file.txt

# Input:        Output:
# Apple         Apple
# apple
# APPLE
# Banana        Banana
```

### Example 7: Save Output to File
```bash
# Deduplicate and save
sort file.txt | uniq > unique.txt

# Creates new file with unique lines
```

### Example 8: Inline Deduplication with sort
```bash
# sort has built-in unique option
sort -u file.txt

# Equivalent to: sort file.txt | uniq
```

---

## Intermediate Level

### Example 9: Frequency Count (Sorted)
```bash
# Most common lines first
sort file.txt | uniq -c | sort -nr

# Output:
#   5 apple
#   3 banana
#   1 orange

# Great for log analysis
```

### Example 10: Show All Duplicate Occurrences
```bash
# Show every duplicate line, not just one
sort file.txt | uniq -D

# Input:        Output:
# apple         apple
# apple         apple
# apple         apple
# banana        (not shown - only 1 occurrence)
# apple
```

### Example 11: Skip First N Fields
```bash
# Ignore first 2 fields when comparing
uniq -f 2 data.txt

# Input:
# 1 2025 error log
# 2 2025 error log  <- Same from field 3 onward
# 3 2025 debug log

# Output:
# 1 2025 error log
# 3 2025 debug log
```

### Example 12: Skip First N Characters
```bash
# Ignore first 5 characters
uniq -s 5 file.txt

# Input:
# 2025-apple
# 2024-apple  <- Same after position 5
# 2025-banana

# Output:
# 2025-apple
# 2025-banana
```

### Example 13: Compare Only N Characters
```bash
# Compare only first 3 characters
uniq -w 3 file.txt

# Input:        Output:
# apple         apple
# app
# application   banana
# banana
```

### Example 14: Count with Filtering
```bash
# Count only duplicates
sort file.txt | uniq -cd

# Shows count only for lines appearing >1 time
```

### Example 15: Unique Count
```bash
# Count unique lines only (appearing once)
sort file.txt | uniq -cu

# Shows count for lines appearing exactly once
```

### Example 16: Deduplicate with Prefix
```bash
# Add prefix to each unique line
sort file.txt | uniq | sed 's/^/- /'

# Creates bullet list
```

---

## Advanced Level

### Example 17: Multi-Column Deduplication
```bash
# Skip timestamp, deduplicate on message
awk '{$1=$2=""; print}' log.txt | sort | uniq

# Ignores first two fields (timestamp)
```

### Example 18: Case-Insensitive Count
```bash
# Count ignoring case
sort -f file.txt | uniq -ci

# Apple, apple, APPLE counted together
```

### Example 19: Find Lines Repeated N Times
```bash
# Find lines appearing exactly 3 times
sort file.txt | uniq -c | awk '$1 == 3 {print $2}'

# Specific frequency filter
```

### Example 20: Deduplicate Preserving Order
```bash
# Keep first occurrence order
awk '!seen[$0]++' file.txt

# Better than sort | uniq for order preservation
```

### Example 21: Complex Field-Based Deduplication
```bash
# Deduplicate CSV by column 2
sort -t ',' -k 2 file.csv | uniq -f 1

# Removes duplicates based on specific column
```

### Example 22: Show Duplicate Count Summary
```bash
# Summary of duplicate levels
sort file.txt | uniq -c | awk '{print $1}' | sort | uniq -c

# Shows how many lines appear N times
```

### Example 23: Percentage Calculation
```bash
# What percent of lines are unique?
TOTAL=$(wc -l < file.txt)
UNIQUE=$(sort file.txt | uniq | wc -l)
echo "scale=2; $UNIQUE * 100 / $TOTAL" | bc

# Uniqueness percentage
```

### Example 24: Adjacent Duplicate Detection
```bash
# Flag consecutive duplicates
awk 'NR > 1 && $0 == prev {print "Duplicate:", $0} {prev=$0}' file.txt

# Identifies consecutive repeats
```

---

## Expert Level

### Example 25: Streaming Deduplication
```bash
# Deduplicate stream in real-time
tail -f application.log | awk '!seen[$0]++'

# Filters duplicate lines from live stream
```

### Example 26: Time-Window Deduplication
```bash
# Deduplicate within 5-second windows
tail -f app.log | while read line; do
    timestamp=$(date +%s)
    echo "$timestamp $line"
done | awk '{if ($1 - last[$0] > 5) {print $0; last[$0]=$1}}'

# Advanced time-based filtering
```

### Example 27: Multi-File Deduplication
```bash
# Deduplicate across multiple files
sort -u file1.txt file2.txt file3.txt > unique_all.txt

# Global deduplication
```

### Example 28: Conditional Deduplication
```bash
# Deduplicate only if certain field matches
awk -F, '{key=$1$3; if (!seen[key]++) print}' file.csv

# Custom key-based deduplication
```

### Example 29: Memory-Efficient Large File Deduplication
```bash
# Handle huge files
sort -u -S 50% -T /tmp largefile.txt -o unique.txt

# Uses external sort with memory limit
```

### Example 30: Hierarchical Deduplication
```bash
# Remove duplicates at multiple levels
sort file.txt | uniq | while read line; do
    echo "$line" | normalize | deduplicate
done

# Multi-pass refinement
```

### Example 31: Probabilistic Deduplication
```bash
# Use hash for approximate deduplication
awk '{h=0; for(i=1;i<=length($0);i++) h=h*31+ord(substr($0,i,1)); if(!seen[h]++) print}' file.txt

# Fast approximate dedup for huge datasets
```

### Example 32: Smart Log Deduplication
```bash
# Deduplicate log messages, keep first timestamp
sort -k3 log.txt | awk '{msg=$3; for(i=4;i<=NF;i++) msg=msg" "$i; if (!seen[msg]++) print}'

# Preserves context, removes message duplicates
```

---

## Salesforce-Specific Examples

### Example 33: Deduplicate Apex Log Events
```bash
# Remove duplicate log events
sf apex get log | grep "CODE_UNIT" | sort | uniq

# Unique code units executed
```

### Example 34: Count Unique SOQL Queries
```bash
# Find most frequent queries
sf apex get log | grep "SOQL_EXECUTE_BEGIN" | sort | uniq -c | sort -nr

# Query frequency analysis
```

### Example 35: Unique Error Messages
```bash
# List distinct errors
sf apex get log | grep "ERROR" | cut -d: -f2- | sort | uniq

# All unique error types
```

### Example 36: Deduplicate Object Names from Query
```bash
# Unique objects queried
sf data query --query "SELECT Id FROM Account" --json | \
jq -r '.result.records[].attributes.type' | \
sort | uniq

# Distinct object types
```

### Example 37: Find Duplicate Metadata Names
```bash
# Identify duplicate component names
find force-app -name "*.cls" -exec basename {} .cls \; | \
sort | uniq -d

# Duplicate class names
```

### Example 38: Count Test Method Executions
```bash
# Frequency of test method runs
sf apex run test --test-level RunLocalTests --json | \
jq -r '.result.tests[].MethodName' | \
sort | uniq -c | sort -nr

# Test execution frequency
```

---

## Generic Real-World Examples

### Example 39: Unique IP Addresses
```bash
# List unique IPs from access log
awk '{print $1}' access.log | sort | uniq

# Distinct visitors
```

### Example 40: Most Common HTTP Codes
```bash
# HTTP status code frequency
awk '{print $9}' access.log | sort | uniq -c | sort -nr

# Response code distribution
```

### Example 41: Deduplicate Email List
```bash
# Remove duplicate emails
sort -f emails.txt | uniq -i > unique_emails.txt

# Case-insensitive email dedup
```

### Example 42: Find Duplicate Files
```bash
# Find files with same content
find . -type f -exec md5sum {} \; | \
sort | uniq -w 32 -D

# Shows duplicate files by hash
```

### Example 43: Unique Commands from History
```bash
# Most used shell commands
history | awk '{print $2}' | sort | uniq -c | sort -nr | head -20

# Top 20 commands
```

### Example 44: Database Query Analysis
```bash
# Unique queries from slow query log
grep "Query_time" mysql-slow.log | \
awk '{for(i=3;i<=NF;i++)printf "%s ", $i; print ""}' | \
sort | uniq -c | sort -nr

# Most common slow queries
```

---

## Common Patterns & Recipes

### Pattern 1: Frequency Analysis
```bash
# Complete frequency report
sort file.txt | uniq -c | sort -nr | head -20 | \
awk '{printf "%3d times: %s\n", $1, substr($0, index($0,$2))}'
```

### Pattern 2: Duplicate Detection Report
```bash
# Generate duplicate report
{
    echo "=== DUPLICATE ANALYSIS ==="
    echo "Total lines: $(wc -l < file.txt)"
    echo "Unique lines: $(sort file.txt | uniq | wc -l)"
    echo "Duplicate lines: $(sort file.txt | uniq -d | wc -l)"
} > report.txt
```

### Pattern 3: Data Quality Check
```bash
# Check data consistency
TOTAL=$(wc -l < data.csv)
UNIQUE=$(sort data.csv | uniq | wc -l)
DUPES=$((TOTAL - UNIQUE))
echo "Duplicates: $DUPES ($((DUPES * 100 / TOTAL))%)"
```

### Pattern 4: Log Sampling
```bash
# Get unique error samples
grep ERROR app.log | \
cut -d: -f2- | \
sort | uniq | \
head -50 > error_samples.txt
```

### Pattern 5: Two-Pass Deduplication
```bash
# First pass: deduplicate
sort -u file.txt > pass1.txt
# Second pass: normalize and deduplicate again
cat pass1.txt | tr '[:upper:]' '[:lower:]' | sort -u > final.txt
```

---

## Practice Problems

### Beginner (1-8)

1. Remove consecutive duplicate lines
2. Remove all duplicates (use sort first)
3. Count occurrences of each line
4. Show only lines that appear more than once
5. Show only lines that appear exactly once
6. Case-insensitive deduplication
7. Save deduplicated output to file
8. Use sort's built-in unique option

### Intermediate (9-16)

9. Create frequency count (most common first)
10. Show all occurrences of duplicate lines
11. Skip first 2 fields when comparing
12. Skip first 10 characters when comparing
13. Compare only first 5 characters
14. Count only duplicate lines
15. Count only unique lines
16. Deduplicate and add prefix to each line

### Advanced (17-24)

17. Multi-column CSV deduplication
18. Case-insensitive frequency count
19. Find lines appearing exactly N times
20. Preserve original order while deduplicating
21. Calculate uniqueness percentage
22. Detect adjacent duplicates with flagging
23. Show summary of duplicate levels
24. Complex field-based deduplication

### Expert (25-32)

25. Real-time stream deduplication
26. Time-window based deduplication
27. Multi-file global deduplication
28. Conditional deduplication by custom key
29. Memory-efficient large file processing
30. Hierarchical multi-pass deduplication
31. Probabilistic hash-based deduplication
32. Smart log deduplication with context preservation

---

**Solutions**: [uniq Practice Solutions](../04-practice/uniq-solutions.md)

**Next**: [cut - Extract Columns](./cut.md)
