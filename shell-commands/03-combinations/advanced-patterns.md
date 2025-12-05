# Advanced Shell Patterns

Complex workflows combining multiple techniques for production-grade automation.

---

## 📋 Table of Contents
- [Process Substitution](#process-substitution)
- [Named Pipes (FIFOs)](#named-pipes-fifos)
- [File Descriptor Manipulation](#file-descriptor-manipulation)
- [Loop-Based Patterns](#loop-based-patterns)
- [Parallel Execution](#parallel-execution)
- [Error Handling](#error-handling)
- [Data Processing](#data-processing)
- [Monitoring & Alerting](#monitoring--alerting)

---

## Process Substitution

Treat command output as a file using `<()` or `>()`.

### Basic Usage

#### Pattern 1: Compare Command Outputs
```bash
# Compare sorted versions without temp files
diff <(sort file1.txt) <(sort file2.txt)

# <(...) creates virtual file from command output
```

#### Pattern 2: Multiple Input Sources
```bash
# Merge multiple sources
cat <(echo "Header") <(cat data1.txt) <(cat data2.txt) <(echo "Footer")

# Combines without temp files
```

#### Pattern 3: Join Files on-the-fly
```bash
# Join after processing
join <(sort users.txt) <(sort emails.txt)

# Sorts and joins in one step
```

### Advanced Usage

#### Pattern 4: Multi-Way Comparison
```bash
# Compare three files
comm -12 <(sort file1.txt) <(sort file2.txt) | \
comm -12 - <(sort file3.txt)

# Finds common lines across all three
```

#### Pattern 5: Output to Multiple Processes
```bash
# Send output to multiple filters
command | tee >(grep "ERROR" > errors.txt) >(grep "WARN" > warnings.txt) > all.txt

# Splits output three ways
```

---

## Named Pipes (FIFOs)

Inter-process communication using named pipes.

### Basic Patterns

#### Pattern 6: Simple Producer-Consumer
```bash
# Create pipe
mkfifo mypipe

# Producer (background)
producer_command > mypipe &

# Consumer (foreground)
consumer_command < mypipe

# Cleanup
rm mypipe
```

#### Pattern 7: Bidirectional Communication
```bash
# Create two pipes
mkfifo pipe_request pipe_response

# Server
while true; do
    read request < pipe_request
    process "$request" > pipe_response
done &

# Client
echo "data" > pipe_request
read response < pipe_response
```

### Advanced Patterns

#### Pattern 8: Multi-Producer Aggregation
```bash
# Create pipe
mkfifo aggregator

# Multiple producers
producer1 > aggregator &
producer2 > aggregator &
producer3 > aggregator &

# Single aggregator
cat aggregator | process_all > results.txt
```

#### Pattern 9: Rate-Limited Processing
```bash
# Create buffer pipe
mkfifo buffer

# Fast producer
find / -name "*.txt" > buffer &

# Slow, controlled consumer
while read file; do
    process_file "$file"
    sleep 0.1  # Rate limit
done < buffer
```

---

## File Descriptor Manipulation

Advanced stream control using file descriptors.

### Intermediate Patterns

#### Pattern 10: Preserve Original stdout
```bash
# Save stdout to FD 3
exec 3>&1

# Redirect stdout
exec > output.log

# Commands go to file
echo "This goes to file"

# Restore stdout
exec 1>&3

# Back to terminal
echo "This goes to terminal"

# Close FD 3
exec 3>&-
```

#### Pattern 11: Custom Logging Levels
```bash
# Open log files
exec 3> debug.log
exec 4> info.log
exec 5> error.log

# Logging functions
debug() { echo "[DEBUG] $*" >&3; }
info() { echo "[INFO] $*" >&4; }
error() { echo "[ERROR] $*" >&5; }

# Use them
debug "Detailed information"
info "General message"
error "Something went wrong"

# Close all
exec 3>&- 4>&- 5>&-
```

### Advanced Patterns

#### Pattern 12: Bidirectional Communication with Process
```bash
# Open process for read and write
exec 3<> /dev/tcp/example.com/80

# Write request
echo -e "GET / HTTP/1.0\n\n" >&3

# Read response
cat <&3

# Close
exec 3>&-
```

#### Pattern 13: Stream Multiplexing
```bash
# Create FDs for different outputs
exec 3> output1.txt
exec 4> output2.txt
exec 5> output3.txt

# Route based on condition
while read line; do
    case "$line" in
        ERROR*) echo "$line" >&5 ;;
        WARN*)  echo "$line" >&4 ;;
        *)      echo "$line" >&3 ;;
    esac
done < input.log

# Close all
exec 3>&- 4>&- 5>&-
```

---

## Loop-Based Patterns

Powerful iteration patterns for bulk operations.

### Data Processing Loops

#### Pattern 14: Parallel File Processing
```bash
# Process files with concurrency control
MAX_JOBS=4

for file in *.dat; do
    # Wait if too many jobs
    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        wait -n 2>/dev/null || true
    done
    
    # Process in background
    process_file "$file" > "${file}.out" 2>&1 &
done

# Wait for all to complete
wait

echo "All files processed"
```

#### Pattern 15: Progress Bar
```bash
# Process with progress indicator
TOTAL=$(ls *.txt | wc -l)
COUNT=0

for file in *.txt; do
    process_file "$file"
    COUNT=$((COUNT + 1))
    
    # Calculate percentage
    PERCENT=$((COUNT * 100 / TOTAL))
    BAR=$(printf "%-${PERCENT}s" "#" | tr ' ' '#')
    
    # Display progress
    printf "\r[%-100s] %d%%" "$BAR" "$PERCENT"
done

echo  # Newline after completion
```

### Advanced Loops

#### Pattern 16: Retry with Backoff
```bash
# Exponential backoff retry
MAX_ATTEMPTS=5
DELAY=1

for attempt in $(seq 1 $MAX_ATTEMPTS); do
    if command_that_might_fail; then
        echo "Success on attempt $attempt"
        break
    else
        if [ $attempt -lt $MAX_ATTEMPTS ]; then
            echo "Attempt $attempt failed, waiting ${DELAY}s..."
            sleep $DELAY
            DELAY=$((DELAY * 2))  # Exponential backoff
        else
            echo "All $MAX_ATTEMPTS attempts failed"
            exit 1
        fi
    fi
done
```

#### Pattern 17: Distributed Processing
```bash
# Process across multiple servers
SERVERS=("server1" "server2" "server3")

for server in "${SERVERS[@]}"; do
    {
        echo "Processing on $server..."
        ssh "$server" "cd /data && process_local_files.sh"
        echo "$server complete"
    } &
done

wait
echo "All servers processed"
```

---

## Parallel Execution

Efficient concurrent processing patterns.

### Basic Parallelism

#### Pattern 18: xargs Parallel Processing
```bash
# Process files in parallel
find . -name "*.jpg" -print0 | \
xargs -0 -P 4 -I {} convert {} -resize 800x600 output/{}

# -P 4 = 4 parallel processes
```

#### Pattern 19: GNU Parallel (if available)
```bash
# More sophisticated parallel processing
cat urls.txt | parallel -j 4 'curl -O {}'

# Automatic load balancing
```

### Advanced Parallelism

#### Pattern 20: Dynamic Worker Pool
```bash
# Worker pool pattern
WORKERS=4
QUEUE=work_queue.txt

# Worker function
worker() {
    local id=$1
    while true; do
        # Atomic read from queue
        TASK=$(flock queue.lock head -1 "$QUEUE" 2>/dev/null)
        [ -z "$TASK" ] && break
        
        # Remove task from queue
        flock queue.lock sed -i '1d' "$QUEUE"
        
        # Process task
        echo "Worker $id processing: $TASK"
        process_task "$TASK"
    done
}

# Start workers
for i in $(seq 1 $WORKERS); do
    worker $i &
done

# Wait for completion
wait
```

#### Pattern 21: Map-Reduce Pattern
```bash
# Map phase: parallel processing
for file in data/*.csv; do
    {
        cat "$file" | \
        awk -F',' '{sum[$1] += $2} END {for(k in sum) print k","sum[k]}' \
        > "temp/map_$(basename $file)"
    } &
done
wait

# Reduce phase: aggregate results
cat temp/map_* | \
awk -F',' '{sum[$1] += $2} END {for(k in sum) print k","sum[k]}' | \
sort -t',' -k2 -nr > final_results.csv
```

---

## Error Handling

Robust error handling patterns.

### Comprehensive Error Handling

#### Pattern 22: Try-Catch-Finally Equivalent
```bash
# Try block
{
    set -e  # Exit on error
    
    critical_operation_1
    critical_operation_2
    critical_operation_3
    
    set +e  # Disable exit on error
    
} || {
    # Catch block
    echo "Error occurred at line $LINENO"
    cleanup_partial_state
    send_alert "Operation failed"
    
} && {
    # Finally block (always runs)
    cleanup_temp_files
    close_connections
}
```

#### Pattern 23: Error Stack Trace
```bash
# Enable error tracking
set -E
trap 'echo "Error on line $LINENO in function ${FUNCNAME[0]}"' ERR

# Your functions
function step1() {
    echo "Step 1"
    failing_command
}

function step2() {
    echo "Step 2"
    step1
}

# Call chain
step2  # Shows full error trace
```

### Production Error Handling

#### Pattern 24: Graceful Degradation
```bash
# Try primary, fallback to secondary, use default
DATA=$(primary_source 2>/dev/null) || \
DATA=$(secondary_source 2>/dev/null) || \
DATA="default_value"

echo "Using data: $DATA"
```

#### Pattern 25: Circuit Breaker Pattern
```bash
# Circuit breaker for external service
FAILURE_COUNT=0
FAILURE_THRESHOLD=3
CIRCUIT_OPEN=false

call_external_service() {
    if [ "$CIRCUIT_OPEN" = true ]; then
        echo "Circuit open, using fallback"
        return 1
    fi
    
    if ! external_service_call; then
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
        
        if [ $FAILURE_COUNT -ge $FAILURE_THRESHOLD ]; then
            echo "Circuit breaker triggered"
            CIRCUIT_OPEN=true
        fi
        return 1
    fi
    
    # Success - reset counter
    FAILURE_COUNT=0
    return 0
}
```

---

## Data Processing

Complex data transformation pipelines.

### Stream Processing

#### Pattern 26: Real-Time Data Enrichment
```bash
# Enrich streaming data
tail -f access.log | \
while read line; do
    # Extract IP
    IP=$(echo "$line" | awk '{print $1}')
    
    # Enrich with geolocation
    LOCATION=$(geoip_lookup "$IP" 2>/dev/null || echo "Unknown")
    
    # Output enriched data
    echo "$line | Location: $LOCATION"
done | tee enriched.log
```

#### Pattern 27: Windowed Aggregation
```bash
# 5-second window aggregation
tail -f metrics.log | \
awk -v window=5 '
{
    current_time = systime()
    window_start = int(current_time / window) * window
    
    # Aggregate in current window
    sum[window_start] += $1
    count[window_start]++
    
    # Output completed windows
    for (w in sum) {
        if (w < window_start) {
            print w, sum[w] / count[w]
            delete sum[w]
            delete count[w]
        }
    }
}'
```

### Batch Processing

#### Pattern 28: Large File Processing
```bash
# Process huge file in chunks
CHUNK_SIZE=10000

split -l $CHUNK_SIZE hugefile.txt chunk_

# Process chunks in parallel
for chunk in chunk_*; do
    {
        process_chunk "$chunk" > "${chunk}.out"
        rm "$chunk"  # Clean up after processing
    } &
    
    # Limit concurrency
    while [ $(jobs -r | wc -l) -ge 4 ]; do
        wait -n
    done
done

wait

# Combine results
cat chunk_*.out > final_output.txt
rm chunk_*.out
```

#### Pattern 29: Distributed Data Processing
```bash
# Split data across servers
SERVERS=("node1" "node2" "node3" "node4")
NUM_SERVERS=${#SERVERS[@]}

# Partition data
cat bigdata.csv | \
awk -v n=$NUM_SERVERS 'NR%n==0{print > "partition_"n; next} {print > "partition_"(NR%n)}'

# Distribute and process
for i in $(seq 0 $((NUM_SERVERS-1))); do
    server="${SERVERS[$i]}"
    {
        scp "partition_$i" "$server:/tmp/"
        ssh "$server" "process_data.sh /tmp/partition_$i > /tmp/result_$i"
        scp "$server:/tmp/result_$i" .
    } &
done

wait

# Aggregate results
cat result_* > final_results.csv
```

---

## Monitoring & Alerting

Production monitoring patterns.

### Health Monitoring

#### Pattern 30: Service Health Check
```bash
# Comprehensive health monitoring
check_service_health() {
    local service=$1
    local threshold=$2
    
    # Check if running
    if ! pgrep -x "$service" > /dev/null; then
        alert "CRITICAL: $service not running"
        restart_service "$service"
        return 1
    fi
    
    # Check CPU usage
    CPU=$(ps -C "$service" -o %cpu= | awk '{sum+=$1} END {print sum}')
    if (( $(echo "$CPU > $threshold" | bc -l) )); then
        alert "WARNING: $service CPU at ${CPU}%"
    fi
    
    # Check memory
    MEM=$(ps -C "$service" -o %mem= | awk '{sum+=$1} END {print sum}')
    if (( $(echo "$MEM > 80" | bc -l) )); then
        alert "WARNING: $service memory at ${MEM}%"
    fi
    
    # Check responsiveness
    if ! timeout 5 check_endpoint "$service"; then
        alert "CRITICAL: $service not responding"
        return 1
    fi
    
    return 0
}

# Run continuous monitoring
while true; do
    check_service_health "myapp" 75 || escalate_alert
    sleep 60
done
```

### Anomaly Detection

#### Pattern 31: Baseline Comparison
```bash
# Detect anomalies by comparing to baseline
BASELINE_FILE="baseline_metrics.txt"
CURRENT=$(get_current_metrics)
BASELINE=$(cat "$BASELINE_FILE" 2>/dev/null || echo "$CURRENT")

# Calculate deviation
DEVIATION=$(echo "scale=2; ($CURRENT - $BASELINE) / $BASELINE * 100" | bc)

# Alert if > 20% deviation
if (( $(echo "${DEVIATION#-} > 20" | bc -l) )); then
    alert "Anomaly detected: ${DEVIATION}% deviation from baseline"
fi

# Update baseline (rolling average)
NEW_BASELINE=$(echo "scale=2; ($BASELINE * 0.9) + ($CURRENT * 0.1)" | bc)
echo "$NEW_BASELINE" > "$BASELINE_FILE"
```

---

## Salesforce-Specific Advanced Patterns

### Pattern 32: Multi-Org Deployment Pipeline
```bash
# Deploy to multiple orgs with validation
ORGS=("dev" "qa" "uat" "prod")

for org in "${ORGS[@]}"; do
    echo "=== Deploying to $org ==="
    
    # Run tests first
    sf apex run test --target-org "$org" --test-level RunLocalTests || {
        echo "Tests failed on $org, stopping pipeline"
        exit 1
    }
    
    # Deploy
    sf project deploy start --target-org "$org" || {
        echo "Deployment failed on $org"
        
        # Rollback previous if not first
        if [ "$org" != "${ORGS[0]}" ]; then
            echo "Rolling back previous orgs..."
            # Implement rollback logic
        fi
        
        exit 1
    }
    
    # Smoke test
    smoke_test "$org" || {
        echo "Smoke test failed on $org"
        rollback_deployment "$org"
        exit 1
    }
    
    echo "✓ $org deployment successful"
done

send_notification "All orgs deployed successfully"
```

### Pattern 33: Apex Log Aggregation and Analysis
```bash
# Aggregate logs from multiple orgs
for org in dev qa prod; do
    {
        echo "=== Logs from $org ==="
        
        # Get recent logs
        sf apex list log --target-org "$org" --json | \
        jq -r '.[] | select(.StartTime > "'$(date -d '1 hour ago' -Iseconds)'") | .Id' | \
        while read log_id; do
            sf apex get log --log-id "$log_id" --target-org "$org"
        done | \
        
        # Extract errors
        grep "ERROR\|EXCEPTION" | \
        
        # Categorize
        awk '{
            if ($0 ~ /NullPointerException/) category["NullPointer"]++
            else if ($0 ~ /DML/) category["DML"]++
            else if ($0 ~ /SOQL/) category["SOQL"]++
            else category["Other"]++
        } END {
            for (c in category) print c":", category[c]
        }'
    } > "log_analysis_$org.txt" &
done

wait

# Generate summary report
{
    echo "=== Error Summary ==="
    echo "Generated: $(date)"
    echo
    for report in log_analysis_*.txt; do
        cat "$report"
        echo
    done
} | tee error_summary_$(date +%Y%m%d).txt
```

---

## Practice Exercises

### Intermediate (1-15)
1. Compare two command outputs without temp files
2. Create producer-consumer with named pipe
3. Save and restore stdout using file descriptors
4. Process files with progress bar
5. Implement retry with exponential backoff
6. Parallel file processing with xargs
7. Try-catch-finally pattern
8. Circuit breaker for external service
9. Real-time data enrichment
10. Service health check
11. Multi-way file comparison
12. Rate-limited processing with named pipe
13. Custom logging levels with FDs
14. Windowed aggregation
15. Anomaly detection with baseline

### Advanced (16-30)
16. Dynamic worker pool
17. Map-reduce pattern
18. Distributed data processing
19. Large file chunk processing
20. Stream multiplexing
21. Comprehensive health monitoring
22. Error stack trace
23. Graceful degradation chain
24. Bidirectional communication
25. Multi-org deployment pipeline
26. Parallel distributed processing
27. Real-time monitoring dashboard
28. Automated rollback on failure
29. Log aggregation and analysis
30. Complex ETL pipeline

---

**Next**: [Salesforce CLI Integration](../05-salesforce/sf-cli-patterns.md)
