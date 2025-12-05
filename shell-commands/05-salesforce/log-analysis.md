# Apex Log Analysis - Parse & Filter Logs

Master Apex debug log analysis using shell commands.

---

## 📋 Overview

Salesforce debug logs contain valuable information about Apex execution, SOQL queries, DML operations, and system performance. This guide shows how to extract insights using command-line tools.

---

## Getting Debug Logs

### Retrieve Logs

```bash
# List available logs
sf apex list log

# Get latest log
sf apex get log

# Get specific log by ID
sf apex get log --log-id 07L...

# Get last N logs
sf apex list log --json | jq -r '.[]' | head -5 | xargs -I {} sf apex get log --log-id {}

# Save log to file
sf apex get log > debug.log
```

---

## Basic Log Filtering

### Pattern 1: Find All Errors
```bash
# Extract error lines
sf apex get log | grep "ERROR"

# Count errors
sf apex get log | grep -c "ERROR"

# Errors with context
sf apex get log | grep -C 3 "ERROR"

# Save errors to file
sf apex get log | grep "ERROR" > errors.txt
```

### Pattern 2: Filter by Log Level
```bash
# Find all FATAL messages
sf apex get log | grep "FATAL"

# Multiple levels
sf apex get log | grep -E "ERROR|FATAL|WARN"

# Exclude DEBUG
sf apex get log | grep -v "DEBUG"

# Show only specific levels
sf apex get log | awk '/\|(ERROR|FATAL)\|/ {print}'
```

### Pattern 3: Extract Timestamps
```bash
# Lines with timestamps
sf apex get log | grep "^[0-9][0-9]:[0-9][0-9]"

# Extract time only
sf apex get log | grep "^[0-9][0-9]:[0-9][0-9]" | cut -c 1-12

# Events in specific time range
sf apex get log | awk '$1 >= "10:30:00" && $1 <= "10:35:00"'
```

---

## SOQL Analysis

### Pattern 4: Extract All SOQL Queries
```bash
# Find SOQL execute statements
sf apex get log | grep "SOQL_EXECUTE_BEGIN"

# Extract just the query
sf apex get log | grep "SOQL_EXECUTE_BEGIN" | sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | sed 's/Aggregations:.*//'

# Count queries
sf apex get log | grep -c "SOQL_EXECUTE_BEGIN"
```

### Pattern 5: Find Most Expensive Queries
```bash
# Get queries with row counts
sf apex get log | grep -A 1 "SOQL_EXECUTE_BEGIN" | grep -E "SOQL_EXECUTE_BEGIN|Number of rows"

# Extract queries and their row counts
sf apex get log | awk '
/SOQL_EXECUTE_BEGIN/ {query=$0; getline; if (/rows/) print query, $0}
'

# Sort by row count
sf apex get log | awk '
/SOQL_EXECUTE_BEGIN/ {
    sub(/.*SOQL_EXECUTE_BEGIN\[.*\] /, "", $0)
    query = $0
}
/Number of rows: / {
    rows = $NF
    print rows, query
}
' | sort -nr | head -10
```

### Pattern 6: Query Frequency Analysis
```bash
# Most frequently executed queries
sf apex get log | \
grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sed 's/ FROM.*/FROM/' | \
sort | \
uniq -c | \
sort -nr | \
head -10

# Count queries per object
sf apex get log | \
grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*FROM \([^ ]*\).*/\1/' | \
sort | \
uniq -c | \
sort -nr
```

### Pattern 7: Identify N+1 Query Problems
```bash
# Find repeated similar queries
sf apex get log | \
grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sed 's/WHERE.*/WHERE .../' | \
sort | \
uniq -c | \
awk '$1 > 5 {print "Potential N+1:", $0}'

# Queries executed more than 10 times
sf apex get log | \
grep "SOQL_EXECUTE_BEGIN" | \
sed 's/.*FROM \([^ ]*\).*/\1/' | \
sort | \
uniq -c | \
awk '$1 > 10 {print "N+1 detected on", $2, "(" $1, "times)"}'
```

---

## DML Analysis

### Pattern 8: Extract DML Operations
```bash
# All DML statements
sf apex get log | grep "DML_BEGIN"

# Count by type
sf apex get log | grep "DML_BEGIN" | awk '{print $2}' | sort | uniq -c

# DML on specific object
sf apex get log | grep "DML_BEGIN.*Account"

# DML with row counts
sf apex get log | awk '/DML_BEGIN/ {dml=$0} /rows affected/ {print dml, $0}'
```

### Pattern 9: Find Bulk DML Operations
```bash
# Large DML operations (>100 rows)
sf apex get log | awk '
/DML_BEGIN/ {dml=$0}
/rows affected: ([0-9]+)/ {
    if ($NF > 100) print dml, "Rows:", $NF
}
'

# Sum total records affected
sf apex get log | grep "rows affected" | awk '{sum += $NF} END {print "Total rows:", sum}'
```

### Pattern 10: DML Limit Tracking
```bash
# Track DML statement count
sf apex get log | grep -c "DML_BEGIN"

# Check for limit warnings
sf apex get log | grep -i "dml.*limit"

# DML usage report
{
    echo "=== DML Analysis ==="
    echo "Total DML statements: $(sf apex get log | grep -c 'DML_BEGIN')"
    echo "Total rows affected: $(sf apex get log | grep 'rows affected' | awk '{sum += $NF} END {print sum}')"
    echo
    echo "By operation type:"
    sf apex get log | grep "DML_BEGIN" | awk '{print $2}' | sort | uniq -c | sort -nr
}
```

---

## Exception Analysis

### Pattern 11: Extract All Exceptions
```bash
# Find exceptions
sf apex get log | grep "EXCEPTION_THROWN"

# Extract exception type
sf apex get log | grep "EXCEPTION_THROWN" | sed 's/.*EXCEPTION_THROWN\[.*\]|\([^:]*\):.*/\1/'

# Count by exception type
sf apex get log | \
grep "EXCEPTION_THROWN" | \
sed 's/.*EXCEPTION_THROWN.*|\([^:]*\):.*/\1/' | \
sort | \
uniq -c | \
sort -nr
```

### Pattern 12: Exception with Stack Trace
```bash
# Exception with context
sf apex get log | grep -A 10 "EXCEPTION_THROWN"

# Full stack trace for specific exception
sf apex get log | awk '
/EXCEPTION_THROWN.*NullPointerException/ {print; getline; while (/Class\./) {print; getline}}
'
```

### Pattern 13: Catch Block Analysis
```bash
# Find caught exceptions
sf apex get log | grep "CATCH_BEGIN"

# Exceptions that were caught vs uncaught
{
    echo "Thrown: $(sf apex get log | grep -c 'EXCEPTION_THROWN')"
    echo "Caught: $(sf apex get log | grep -c 'CATCH_BEGIN')"
}
```

---

## Performance Analysis

### Pattern 14: Method Execution Time
```bash
# Extract CODE_UNIT timing
sf apex get log | awk '
/CODE_UNIT_STARTED/ {start[$NF] = $1}
/CODE_UNIT_FINISHED/ {
    name = $NF
    if (start[name]) {
        duration = $1 - start[name]
        print name, duration "ms"
    }
}
' | sort -k 2 -nr | head -20
```

### Pattern 15: CPU Time Analysis
```bash
# Find CPU-intensive operations
sf apex get log | grep "CUMULATIVE_LIMIT_USAGE"

# Extract CPU time
sf apex get log | awk '/CUMULATIVE_LIMIT_USAGE.*Cpu/ {print}'

# Track CPU usage over time
sf apex get log | awk '
/CUMULATIVE_LIMIT_USAGE.*Cpu:([0-9]+)/ {
    match($0, /Cpu:([0-9]+)/, arr)
    print $1, "CPU:", arr[1], "ms"
}
'
```

### Pattern 16: Governor Limit Analysis
```bash
# All limit usage
sf apex get log | grep "CUMULATIVE_LIMIT_USAGE"

# Specific limits
sf apex get log | grep "LIMIT_USAGE_FOR_NS" | grep -E "SOQL|DML|CPU"

# Create limit summary
sf apex get log | awk '
/CUMULATIVE_LIMIT_USAGE/ {
    if (match($0, /SOQL queries:([0-9]+) out of ([0-9]+)/)) {
        soql_used = substr($0, RSTART+13, RLENGTH)
    }
    if (match($0, /DML statements:([0-9]+) out of ([0-9]+)/)) {
        dml_used = substr($0, RSTART+15, RLENGTH)
    }
    if (match($0, /Cpu:([0-9]+)/)) {
        cpu = substr($0, RSTART+4, RLENGTH)
    }
}
END {
    print "SOQL:", soql_used
    print "DML:", dml_used
    print "CPU:", cpu, "ms"
}
'
```

### Pattern 17: Heap Size Monitoring
```bash
# Track heap usage
sf apex get log | grep "HEAP_ALLOCATE" | awk '{print $1, $NF}'

# Maximum heap size
sf apex get log | grep "HEAP_ALLOCATE" | awk '{print $NF}' | sort -n | tail -1

# Heap growth over time
sf apex get log | awk '/HEAP_ALLOCATE/ {print $1, $NF}' | \
awk '{
    time = $1
    size = $2
    if (size > max) max = size
    print time, size, "(max:", max ")"
}'
```

---

## Complete Log Analysis Scripts

### Script 1: Comprehensive Log Report
```bash
#!/bin/bash
# Generate complete log analysis

LOG_FILE="debug.log"
sf apex get log > "$LOG_FILE"

{
    echo "============================================"
    echo "   APEX LOG ANALYSIS REPORT"
    echo "   Generated: $(date)"
    echo "============================================"
    echo
    
    echo "=== ERROR SUMMARY ==="
    echo "Total Errors: $(grep -c 'ERROR' $LOG_FILE)"
    echo "Total Exceptions: $(grep -c 'EXCEPTION_THROWN' $LOG_FILE)"
    echo
    echo "Top Exception Types:"
    grep "EXCEPTION_THROWN" $LOG_FILE | \
    sed 's/.*|\([^:]*\):.*/\1/' | \
    sort | uniq -c | sort -nr | head -5
    echo
    
    echo "=== SOQL ANALYSIS ==="
    echo "Total Queries: $(grep -c 'SOQL_EXECUTE_BEGIN' $LOG_FILE)"
    echo
    echo "Queries per Object:"
    grep "SOQL_EXECUTE_BEGIN" $LOG_FILE | \
    sed 's/.*FROM \([^ ]*\).*/\1/' | \
    sort | uniq -c | sort -nr | head -10
    echo
    
    echo "=== DML ANALYSIS ==="
    echo "Total DML Operations: $(grep -c 'DML_BEGIN' $LOG_FILE)"
    echo "Total Rows Affected: $(grep 'rows affected' $LOG_FILE | awk '{sum+=$NF} END {print sum}')"
    echo
    echo "Operations by Type:"
    grep "DML_BEGIN" $LOG_FILE | awk '{print $2}' | sort | uniq -c | sort -nr
    echo
    
    echo "=== GOVERNOR LIMITS ==="
    grep "CUMULATIVE_LIMIT_USAGE" $LOG_FILE | tail -1
    echo
    
    echo "=== PERFORMANCE ==="
    echo "Maximum Heap Size: $(grep 'HEAP_ALLOCATE' $LOG_FILE | awk '{print $NF}' | sort -n | tail -1) bytes"
    echo
    echo "Top 5 Slowest Methods:"
    awk '
    /CODE_UNIT_STARTED/ {start[$NF] = $1}
    /CODE_UNIT_FINISHED/ {
        name = $NF
        if (start[name]) {
            duration = $1 - start[name]
            print duration, name
        }
    }
    ' $LOG_FILE | sort -nr | head -5
    echo
    
    echo "============================================"
    
} | tee log_report_$(date +%Y%m%d_%H%M%S).txt
```

### Script 2: Real-Time Log Monitoring
```bash
#!/bin/bash
# Monitor logs in real-time

echo "Starting real-time log monitoring..."
echo "Press Ctrl+C to stop"

while true; do
    clear
    echo "=== Real-Time Apex Log Monitor ==="
    echo "Updated: $(date '+%H:%M:%S')"
    echo
    
    # Get latest log
    LOG_ID=$(sf apex list log --json | jq -r '.[0].Id')
    sf apex get log --log-id "$LOG_ID" > /tmp/current.log
    
    # Show summary
    echo "Errors: $(grep -c 'ERROR' /tmp/current.log)"
    echo "Exceptions: $(grep -c 'EXCEPTION_THROWN' /tmp/current.log)"
    echo "SOQL Queries: $(grep -c 'SOQL_EXECUTE_BEGIN' /tmp/current.log)"
    echo "DML Operations: $(grep -c 'DML_BEGIN' /tmp/current.log)"
    echo
    
    # Show recent errors
    echo "=== Recent Errors ==="
    grep "ERROR" /tmp/current.log | tail -5
    echo
    
    # Show recent exceptions
    echo "=== Recent Exceptions ==="
    grep "EXCEPTION_THROWN" /tmp/current.log | tail -3
    
    sleep 10
done
```

### Script 3: N+1 Query Detector
```bash
#!/bin/bash
# Detect N+1 query patterns

LOG_FILE="${1:-debug.log}"

echo "=== N+1 Query Pattern Detection ==="
echo "Analyzing: $LOG_FILE"
echo

# Extract all SOQL queries
grep "SOQL_EXECUTE_BEGIN" "$LOG_FILE" | \
sed 's/.*SOQL_EXECUTE_BEGIN\[.*\]//' | \
sed 's/ WHERE.*//' > /tmp/queries.txt

# Find patterns
echo "Queries executed more than 10 times:"
sort /tmp/queries.txt | uniq -c | awk '$1 > 10 {print "⚠️ ", $0}'
echo

echo "Potential N+1 Patterns:"
sort /tmp/queries.txt | uniq -c | awk '
$1 > 5 {
    gsub(/[0-9]+/, "?", $0)  # Replace numbers with ?
    print "Pattern:", substr($0, index($0,$2)), "Count:", $1
}
' | sort -u

rm /tmp/queries.txt
```

---

## Multi-Log Analysis

### Pattern 18: Compare Multiple Logs
```bash
# Compare error rates across logs
for log_id in $(sf apex list log --json | jq -r '.[0:5].Id'); do
    ERROR_COUNT=$(sf apex get log --log-id "$log_id" | grep -c 'ERROR')
    echo "$log_id: $ERROR_COUNT errors"
done | sort -t: -k2 -nr
```

### Pattern 19: Trend Analysis
```bash
# Track metrics over time
{
    echo "timestamp,errors,exceptions,soql,dml"
    
    sf apex list log --json | jq -r '.[] | .Id' | head -20 | while read log_id; do
        LOG=$(sf apex get log --log-id "$log_id")
        TIMESTAMP=$(echo "$LOG" | head -1 | cut -c 1-19)
        ERRORS=$(echo "$LOG" | grep -c 'ERROR')
        EXCEPTIONS=$(echo "$LOG" | grep -c 'EXCEPTION_THROWN')
        SOQL=$(echo "$LOG" | grep -c 'SOQL_EXECUTE_BEGIN')
        DML=$(echo "$LOG" | grep -c 'DML_BEGIN')
        
        echo "$TIMESTAMP,$ERRORS,$EXCEPTIONS,$SOQL,$DML"
    done
} > log_metrics.csv

# Analyze trends
echo "=== Trend Analysis ==="
awk -F',' 'NR>1 {
    errors += $2
    exceptions += $3
    soql += $4
    dml += $5
    count++
} END {
    print "Average Errors:", errors/count
    print "Average Exceptions:", exceptions/count
    print "Average SOQL:", soql/count
    print "Average DML:", dml/count
}' log_metrics.csv
```

---

## Best Practices

### 1. Save Logs Locally
```bash
# Create log archive
mkdir -p logs/$(date +%Y%m)
sf apex get log > "logs/$(date +%Y%m)/log_$(date +%Y%m%d_%H%M%S).txt"
```

### 2. Automated Log Analysis in CI/CD
```bash
# In deployment script
sf project deploy start --target-org production

# Analyze deployment logs
sleep 10
sf apex get log | grep -i "error" > deployment_errors.txt

if [ -s deployment_errors.txt ]; then
    echo "⚠️ Errors detected in deployment logs"
    cat deployment_errors.txt
    exit 1
fi
```

### 3. Regular Log Cleanup
```bash
# Delete old logs from org
sf apex list log --json | jq -r '.[] | select(.StartTime < "'$(date -d '7 days ago' -Iseconds)'") | .Id' | \
xargs -I {} sf apex delete log --log-id {}
```

---

**Next**: [Deployment Scripts](./deployment-scripts.md)
