# Piping Patterns - Chain Commands with `|`

Master the art of connecting commands together for powerful data processing.

---

## 📋 What is Piping?

The pipe operator `|` connects the **stdout** of one command to the **stdin** of the next:

```bash
command1 | command2 | command3
```

```
command1 → stdout → | → stdin → command2 → stdout → | → stdin → command3
```

---

## Basic Piping Patterns

### Pattern 1: Filter and Count
```bash
# Count error lines
grep "ERROR" application.log | wc -l

# Pipeline: search → count
```

### Pattern 2: Sort and Display
```bash
# Sort files by name
ls | sort

# Pipeline: list → sort
```

### Pattern 3: Search and Display Top Results
```bash
# Top 10 largest files
du -h * | sort -rh | head -10

# Pipeline: size → sort → limit
```

### Pattern 4: Extract and Format
```bash
# Show usernames only
cat /etc/passwd | cut -d ':' -f 1 | sort

# Pipeline: read → extract → sort
```

### Pattern 5: Filter Multiple Conditions
```bash
# Errors that aren't deprecation warnings
cat log.txt | grep "ERROR" | grep -v "Deprecation"

# Pipeline: read → filter → exclude
```

---

## Intermediate Piping Patterns

### Pattern 6: Transform and Save
```bash
# Convert to uppercase and save
cat input.txt | tr '[:lower:]' '[:upper:]' | sort > output.txt

# Pipeline: read → transform → sort → save
```

### Pattern 7: Count Unique Values
```bash
# Unique error types with count
grep "ERROR" log.txt | awk '{print $3}' | sort | uniq -c | sort -nr

# Pipeline: filter → extract → sort → count → sort by frequency
```

### Pattern 8: Multi-Stage Filtering
```bash
# Complex filtering
ps aux | grep python | grep -v grep | awk '{print $2, $11}'

# Pipeline: processes → filter1 → filter2 → format
```

### Pattern 9: Data Transformation Chain
```bash
# CSV to formatted report
cat data.csv | cut -d ',' -f 1,3 | sort | column -t

# Pipeline: read → extract → sort → format
```

### Pattern 10: Aggregation Pipeline
```bash
# Count occurrences by type
cat access.log | awk '{print $9}' | sort | uniq -c | sort -nr | head -20

# Pipeline: read → extract status → sort → count → sort by count → top 20
```

---

## Advanced Piping Patterns

### Pattern 11: Nested Extraction
```bash
# Extract domain from URLs
cat urls.txt | cut -d '/' -f 3 | cut -d '.' -f 2- | sort -u

# Pipeline: read → extract path → extract domain → unique
```

### Pattern 12: Conditional Processing
```bash
# Process only large files
find . -type f -size +1M | while read file; do
    wc -l "$file"
done | sort -k 1 -nr

# Pipeline: find → process → sort
```

### Pattern 13: Parallel Processing Pipeline
```bash
# Process multiple files in parallel
cat filelist.txt | xargs -P 4 -I {} sh -c 'process {} | filter' | aggregate

# Pipeline: read → parallel process → aggregate
```

### Pattern 14: Real-Time Monitoring
```bash
# Live error monitoring with counts
tail -f application.log | grep --line-buffered "ERROR" | \
while read line; do
    echo "[$(date '+%H:%M:%S')] $line"
done

# Pipeline: follow → filter → timestamp
```

### Pattern 15: Complex Data Extraction
```bash
# Extract and analyze log patterns
cat debug.log | \
grep "SOQL_EXECUTE" | \
sed 's/.*FROM \([^ ]*\).*/\1/' | \
sort | uniq -c | sort -nr

# Pipeline: read → filter → extract → sort → count → sort by frequency
```

---

## Expert Piping Patterns

### Pattern 16: Multi-Source Aggregation
```bash
# Combine multiple sources
{
    grep "ERROR" app1.log
    grep "ERROR" app2.log
    grep "ERROR" app3.log
} | sort | uniq -c | sort -nr

# Pipeline: combined streams → sort → count → rank
```

### Pattern 17: Streaming Transformation
```bash
# Process streaming data
tail -f input.stream | \
sed 's/old/new/g' | \
awk '$3 > 100' | \
tee processed.log | \
send_to_api.sh

# Pipeline: stream → transform → filter → log → send
```

### Pattern 18: Recursive Processing
```bash
# Deep directory analysis
find . -name "*.txt" -print0 | \
xargs -0 -P 4 cat | \
tr '[:space:]' '\n' | \
grep -v '^$' | \
sort | \
uniq -c | \
sort -nr | \
head -100

# Pipeline: find → read → tokenize → filter → sort → count → rank → top
```

### Pattern 19: Database-Like Operations
```bash
# Join-like operation
sort file1.txt > /tmp/f1
sort file2.txt > /tmp/f2
comm -12 /tmp/f1 /tmp/f2 | process_matches.sh

# Pipeline: sort both → intersect → process
```

### Pattern 20: Performance Analysis Pipeline
```bash
# Analyze command performance
find . -name "*.log" | \
xargs grep "DURATION" | \
awk '{print $NF}' | \
sort -n | \
awk '{sum+=$1; count++; values[count]=$1} END {
    print "Count:", count;
    print "Sum:", sum;
    print "Avg:", sum/count;
    print "Median:", values[int(count/2)];
    print "Max:", values[count]
}'

# Pipeline: find → search → extract → sort → statistics
```

---

## Salesforce-Specific Piping

### Pattern 21: Apex Log Analysis
```bash
# Find most expensive SOQL queries
sf apex get log | \
grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sort | \
uniq -c | \
sort -nr | \
head -10

# Pipeline: get log → filter → clean → sort → count → rank → top 10
```

### Pattern 22: Deployment Error Analysis
```bash
# Extract and categorize deployment errors
sf project deploy start --json 2>&1 | \
jq -r '.result.details.componentFailures[]' | \
awk -F: '{print $1}' | \
sort | \
uniq -c | \
sort -nr

# Pipeline: deploy → extract errors → categorize → sort → count → rank
```

### Pattern 23: Test Coverage Report
```bash
# Find classes below coverage threshold
sf apex run test --code-coverage --json | \
jq -r '.result.coverage.coverage[] | select(.coveredPercent < 75) | "\(.name):\(.coveredPercent)"' | \
sort -t: -k2 -n | \
column -t -s:

# Pipeline: test → filter low coverage → sort → format
```

### Pattern 24: Org Comparison
```bash
# Compare metadata between orgs
sf org list --json | \
jq -r '.result.nonScratchOrgs[].username' | \
while read org; do
    echo "=== $org ==="
    sf project retrieve start --target-org "$org" --metadata ApexClass 2>&1 | grep "Retrieved"
done

# Pipeline: list orgs → retrieve from each → filter results
```

---

## Common Piping Recipes

### Recipe 1: Top N Pattern
```bash
# Template for finding top N of anything
<source> | <transform> | sort | uniq -c | sort -nr | head -<N>

# Examples:
# Top 10 IP addresses
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10

# Top 20 error messages
grep ERROR app.log | cut -d: -f2 | sort | uniq -c | sort -nr | head -20
```

### Recipe 2: Real-Time Filtering
```bash
# Template for live monitoring
tail -f <file> | grep --line-buffered <pattern> | <process>

# Example:
tail -f /var/log/syslog | grep --line-buffered "ERROR" | \
while read line; do
    alert_system "$line"
done
```

### Recipe 3: Data Normalization
```bash
# Template for cleaning data
<source> | tr -s ' ' | tr '[:upper:]' '[:lower:]' | sort -u

# Example:
cat raw_data.txt | tr -s ' ' | tr '[:upper:]' '[:lower:]' | sort -u > clean_data.txt
```

### Recipe 4: Aggregation with Stats
```bash
# Template for statistics
<source> | <extract> | sort -n | awk '{
    sum+=$1; 
    count++; 
    values[count]=$1
} END {
    print "Count:", count;
    print "Sum:", sum;
    print "Average:", sum/count;
    print "Min:", values[1];
    print "Max:", values[count];
    print "Median:", values[int(count/2)]
}'
```

### Recipe 5: Multi-File Analysis
```bash
# Template for batch processing
find <path> -name <pattern> | while read file; do
    echo "=== $file ==="
    cat "$file" | <pipeline>
done
```

---

## Generic Real-World Examples

### Example 25: Web Server Log Analysis
```bash
# Find most accessed pages
cat access.log | \
awk '{print $7}' | \
sort | \
uniq -c | \
sort -nr | \
head -20 | \
awk '{printf "%s %s\n", $1, $2}'

# Shows top 20 URLs by hit count
```

### Example 26: System Resource Monitoring
```bash
# Processes using most memory
ps aux | \
sort -k 4 -nr | \
head -10 | \
awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $4"%", $11}'

# Top 10 memory consumers
```

### Example 27: Git Repository Analysis
```bash
# Most active contributors
git log --format='%an' | \
sort | \
uniq -c | \
sort -nr | \
head -10

# Top 10 committers
```

### Example 28: Network Connection Analysis
```bash
# Connections by state
netstat -an | \
grep "^tcp" | \
awk '{print $6}' | \
sort | \
uniq -c | \
sort -nr

# Connection state distribution
```

### Example 29: Disk Usage Analysis
```bash
# Largest directories
du -sh */ | \
sort -rh | \
head -10 | \
column -t

# Top 10 space consumers
```

### Example 30: Docker Container Monitoring
```bash
# Container resource usage
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | \
sort -k2 -nr | \
head -10

# Top resource-using containers
```

---

## Piping Best Practices

### 1. Use Line Buffering for Real-Time Processing
```bash
# Without line buffering (slow)
tail -f log.txt | grep "ERROR" | process.sh

# With line buffering (immediate)
tail -f log.txt | grep --line-buffered "ERROR" | process.sh
```

### 2. Avoid Useless Use of Cat (UUOC)
```bash
# Inefficient
cat file.txt | grep "pattern"

# Efficient
grep "pattern" file.txt

# Exception: Multiple files or combining with other input
cat file1.txt file2.txt | grep "pattern"  # OK
```

### 3. Check Pipeline Errors
```bash
# Pipefail option
set -o pipefail

# Now pipeline fails if any command fails
command1 | command2 | command3
if [ $? -ne 0 ]; then
    echo "Pipeline failed"
fi
```

### 4. Use Process Substitution for Complex Pipes
```bash
# Instead of temporary files
diff <(sort file1.txt) <(sort file2.txt)

# Cleaner than:
sort file1.txt > /tmp/f1
sort file2.txt > /tmp/f2
diff /tmp/f1 /tmp/f2
rm /tmp/f1 /tmp/f2
```

### 5. Optimize Pipeline Order
```bash
# Inefficient: processes all lines first
cat huge.log | process_expensive | grep "pattern"

# Efficient: filters early
grep "pattern" huge.log | process_expensive

# Rule: Filter early, process less data
```

---

## Performance Considerations

### Pipeline Optimization Tips

1. **Filter Early**: Reduce data volume as soon as possible
2. **Avoid Redundant Sorting**: Sort once, not multiple times
3. **Use Efficient Tools**: `grep` is faster than `awk` for simple pattern matching
4. **Consider Parallel Processing**: Use `xargs -P` for independent operations
5. **Monitor Memory**: Long pipelines can accumulate data in buffers

### Example: Optimized vs Unoptimized
```bash
# Unoptimized (processes 1M lines)
cat huge.log | \
expensive_transform | \
grep "ERROR" | \
sort | \
uniq -c

# Optimized (processes ~1000 error lines)
grep "ERROR" huge.log | \
sort | \
uniq -c | \
expensive_transform
```

---

## Practice Exercises

### Beginner (1-10)
1. Count lines containing "ERROR" in a log file
2. Sort a file and display top 5 lines
3. List files and count them
4. Extract usernames from /etc/passwd and sort
5. Find processes containing "python" (exclude grep itself)
6. Display first 3 columns of CSV file
7. Count unique values in column 2
8. Convert text to uppercase and save
9. Show last 20 lines of sorted file
10. Extract and count file extensions

### Intermediate (11-20)
11. Find top 10 largest files in directory
12. Count occurrences of each word in file
13. Extract unique IP addresses from log and count
14. Show processes sorted by memory usage
15. Find most common error types
16. Transform CSV to formatted table
17. Monitor log file for errors in real-time
18. Extract domains from list of URLs
19. Compare two sorted files
20. Aggregate data by category

### Advanced (21-30)
21. Multi-file word frequency analysis
22. Real-time log monitoring with timestamps
23. Complex SOQL query analysis from Apex logs
24. Generate statistics from numeric data
25. Parallel processing with aggregation
26. Stream processing with transformation
27. Join-like operation on two files
28. Performance metrics from logs
29. Network connection state analysis
30. Docker container resource ranking

---

**Next**: [Command Chaining](./chaining.md)
