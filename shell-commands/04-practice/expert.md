# Expert Level Practice - 20 Exercises

Master production-grade shell scripting and complex automation.

---

## Exercise 1: Distributed Log Aggregation
**Task**: Aggregate logs from 5 remote servers, parse errors, deduplicate, and generate a comprehensive report with error frequency, affected servers, and time distribution.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
SERVERS=("server1" "server2" "server3" "server4" "server5")
TEMP_DIR="/tmp/log_aggregation_$$"
mkdir -p "$TEMP_DIR"

# Fetch logs in parallel
for server in "${SERVERS[@]}"; do
    {
        ssh "$server" "cat /var/log/application.log" > "$TEMP_DIR/${server}.log"
        echo "$server fetch complete"
    } &
done
wait

# Aggregate and analyze
{
    echo "=== DISTRIBUTED LOG ANALYSIS ==="
    echo "Generated: $(date)"
    echo "Servers: ${#SERVERS[@]}"
    echo
    
    # Extract errors with server context
    for server in "${SERVERS[@]}"; do
        grep "ERROR" "$TEMP_DIR/${server}.log" | \
        sed "s/^/$server|/"
    done | \
    awk -F'|' '{
        # Extract timestamp and error message
        timestamp = substr($2, 1, 19)
        hour = substr(timestamp, 12, 2)
        error_msg = substr($2, 21)
        
        # Normalize error message
        gsub(/[0-9]+/, "N", error_msg)
        gsub(/"[^"]*"/, "\"...\"", error_msg)
        
        # Aggregate
        errors[error_msg]++
        servers_affected[error_msg] = servers_affected[error_msg] " " $1
        hour_dist[error_msg "_" hour]++
    }
    END {
        print "=== TOP 10 ERRORS ==="
        for (err in errors) {
            # Count unique servers
            split(servers_affected[err], srv_arr, " ")
            srv_count = 0
            for (s in srv_arr) {
                if (srv_arr[s] != "" && !seen[err "_" srv_arr[s]]++) {
                    srv_count++
                }
            }
            printf "%4d occurrences | %d servers | %s\n", errors[err], srv_count, err
        }
    }' | sort -nr | head -10
    
} > distributed_log_report.txt

# Cleanup
rm -rf "$TEMP_DIR"

cat distributed_log_report.txt
```

**Explanation**:
- Parallel SSH log fetching
- Error message normalization
- Multi-dimensional aggregation
- Server and time distribution analysis

</details>

---

## Exercise 2: Custom Shell Framework
**Task**: Create a reusable shell framework with logging, error handling, configuration management, and parallel task execution.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# framework.sh - Reusable shell framework

# Configuration
CONFIG_FILE="${CONFIG_FILE:-.config}"
LOG_DIR="${LOG_DIR:-logs}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"  # DEBUG, INFO, WARN, ERROR

# Initialize
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/app_$(date +%Y%m%d).log"

# Logging with levels
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Level filtering
    case "$LOG_LEVEL" in
        DEBUG) ;;
        INFO) [ "$level" = "DEBUG" ] && return ;;
        WARN) [[ "$level" =~ ^(DEBUG|INFO)$ ]] && return ;;
        ERROR) [[ "$level" =~ ^(DEBUG|INFO|WARN)$ ]] && return ;;
    esac
    
    # Color output
    case "$level" in
        DEBUG) color="\033[36m" ;;
        INFO)  color="\033[32m" ;;
        WARN)  color="\033[33m" ;;
        ERROR) color="\033[31m" ;;
    esac
    
    printf "${color}[%s] [%s] %s\033[0m\n" "$timestamp" "$level" "$message" | tee -a "$LOG_FILE"
}

# Convenience functions
debug() { log DEBUG "$@"; }
info() { log INFO "$@"; }
warn() { log WARN "$@"; }
error() { log ERROR "$@"; }

# Error handling
set -E
trap 'error "Error on line $LINENO: $BASH_COMMAND"; exit 1' ERR

# Configuration management
config_get() {
    local key="$1"
    local default="${2:-}"
    
    if [ -f "$CONFIG_FILE" ]; then
        grep "^${key}=" "$CONFIG_FILE" | cut -d= -f2- || echo "$default"
    else
        echo "$default"
    fi
}

config_set() {
    local key="$1"
    local value="$2"
    
    if [ -f "$CONFIG_FILE" ] && grep -q "^${key}=" "$CONFIG_FILE"; then
        sed -i "s/^${key}=.*/${key}=${value}/" "$CONFIG_FILE"
    else
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi
}

# Parallel task execution
parallel_exec() {
    local max_jobs="${1:-4}"
    shift
    local tasks=("$@")
    
    info "Executing ${#tasks[@]} tasks with max $max_jobs parallel jobs"
    
    for task in "${tasks[@]}"; do
        while [ $(jobs -r | wc -l) -ge $max_jobs ]; do
            wait -n 2>/dev/null || true
        done
        
        {
            debug "Starting: $task"
            eval "$task"
            debug "Completed: $task"
        } &
    done
    
    wait
    info "All tasks completed"
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    
    local percent=$((current * 100 / total))
    local filled=$((width * current / total))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '#'
    printf "%$((width - filled))s" | tr ' ' '-'
    printf "] %3d%% (%d/%d)" "$percent" "$current" "$total"
    
    [ $current -eq $total ] && echo
}

# Retry mechanism
retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-5}"
    shift 2
    local command="$@"
    
    local attempt=1
    until eval "$command"; do
        if [ $attempt -eq $max_attempts ]; then
            error "Command failed after $max_attempts attempts: $command"
            return 1
        fi
        
        warn "Attempt $attempt failed, retrying in ${delay}s..."
        sleep $delay
        attempt=$((attempt + 1))
        delay=$((delay * 2))  # Exponential backoff
    done
    
    info "Command succeeded on attempt $attempt"
    return 0
}

# Export functions
export -f log debug info warn error
export -f config_get config_set
export -f parallel_exec progress_bar retry
```

**Usage Example**:
```bash
#!/bin/bash
source framework.sh

info "Application started"

# Set configuration
config_set "database_host" "localhost"
config_set "max_connections" "100"

# Parallel execution
tasks=(
    "process_file file1.txt"
    "process_file file2.txt"
    "process_file file3.txt"
)
parallel_exec 2 "${tasks[@]}"

# Retry example
retry 3 5 "curl -f https://api.example.com/data"

info "Application completed"
```

</details>

---

## Exercise 3: Real-Time Salesforce Metrics Dashboard
**Task**: Create a real-time dashboard that monitors multiple Salesforce orgs, displaying API usage, limits, recent errors, and deployment status.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# sf-dashboard.sh

ORGS=("dev" "qa" "uat" "production")
REFRESH_INTERVAL=30

get_org_metrics() {
    local org=$1
    
    # API Usage
    local api_usage=$(sf limits api display --target-org "$org" --json 2>/dev/null | \
        jq -r '.result.apiUsage | "\(.used)/\(.max)"' || echo "N/A")
    
    # Recent errors
    local errors=$(sf apex list log --target-org "$org" --json 2>/dev/null | \
        jq -r '.[0].Id' | \
        xargs -I {} sf apex get log --log-id {} --target-org "$org" 2>/dev/null | \
        grep -c "ERROR" || echo "0")
    
    # Org status
    local status=$(sf org display --target-org "$org" --json 2>/dev/null | \
        jq -r '.result.status' || echo "UNKNOWN")
    
    echo "$org|$api_usage|$errors|$status"
}

while true; do
    clear
    
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         SALESFORCE MULTI-ORG DASHBOARD                    ║"
    echo "║         $(date '+%Y-%m-%d %H:%M:%S')                          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo
    
    printf "%-12s %-15s %-10s %-10s\n" "ORG" "API Usage" "Errors" "Status"
    printf "%-12s %-15s %-10s %-10s\n" "---" "---------" "------" "------"
    
    # Fetch metrics in parallel
    for org in "${ORGS[@]}"; do
        get_org_metrics "$org" &
    done | while IFS='|' read org api errors status; do
        # Color code status
        case "$status" in
            "Active") status_color="\033[32m" ;;
            "UNKNOWN") status_color="\033[33m" ;;
            *) status_color="\033[31m" ;;
        esac
        
        # Color code errors
        if [ "$errors" -gt 10 ]; then
            error_color="\033[31m"
        elif [ "$errors" -gt 5 ]; then
            error_color="\033[33m"
        else
            error_color="\033[32m"
        fi
        
        printf "%-12s %-15s ${error_color}%-10s\033[0m ${status_color}%-10s\033[0m\n" \
            "$org" "$api" "$errors" "$status"
    done
    
    echo
    echo "═══════════════════════════════════════════════════════════"
    echo "Refreshing in ${REFRESH_INTERVAL}s... (Ctrl+C to exit)"
    
    sleep $REFRESH_INTERVAL
done
```

**Explanation**:
- Multi-org monitoring
- Parallel metrics collection
- Color-coded status indicators
- Real-time refresh

</details>

---

## Exercise 4: Advanced ETL Pipeline
**Task**: Create an ETL pipeline that extracts data from multiple sources (CSV, JSON, API), transforms it, validates quality, and loads to multiple destinations with error recovery.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# etl-pipeline.sh

set -eE
trap 'handle_error $LINENO' ERR

PIPELINE_ID="pipeline_$(date +%Y%m%d_%H%M%S)"
LOG_DIR="logs/$PIPELINE_ID"
mkdir -p "$LOG_DIR"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_DIR/pipeline.log"; }
handle_error() { log "ERROR at line $1"; cleanup; exit 1; }

# Extract phase
extract() {
    log "=== EXTRACT PHASE ==="
    
    # CSV extraction
    log "Extracting CSV data..."
    cat source1.csv > "$LOG_DIR/extract_csv.tmp"
    
    # JSON extraction
    log "Extracting JSON data..."
    curl -s https://api.example.com/data | \
    jq -r '.records[] | [.id,.name,.value] | @csv' > "$LOG_DIR/extract_json.tmp"
    
    # Database extraction
    log "Extracting database data..."
    psql -h localhost -U user -d database -t -A -F',' \
        -c "SELECT id,name,value FROM table" > "$LOG_DIR/extract_db.tmp"
    
    # Combine all sources
    cat "$LOG_DIR"/extract_*.tmp > "$LOG_DIR/raw_data.csv"
    log "Extracted $(wc -l < $LOG_DIR/raw_data.csv) records"
}

# Transform phase
transform() {
    log "=== TRANSFORM PHASE ==="
    
    awk -F',' '
    BEGIN {
        OFS=","
        print "id,name,value,category,processed_date"
    }
    {
        # Skip invalid records
        if (NF != 3 || $1 == "") next
        
        # Normalize data
        id = $1
        name = toupper($2)
        value = $3
        
        # Add derived fields
        if (value > 1000) category = "HIGH"
        else if (value > 500) category = "MEDIUM"
        else category = "LOW"
        
        processed_date = strftime("%Y-%m-%d")
        
        print id, name, value, category, processed_date
    }
    ' "$LOG_DIR/raw_data.csv" > "$LOG_DIR/transformed_data.csv"
    
    log "Transformed $(wc -l < $LOG_DIR/transformed_data.csv) records"
}

# Validate phase
validate() {
    log "=== VALIDATION PHASE ==="
    
    local errors=0
    
    # Check for duplicates
    local duplicates=$(cut -d',' -f1 "$LOG_DIR/transformed_data.csv" | \
        sort | uniq -d | wc -l)
    if [ $duplicates -gt 0 ]; then
        log "WARNING: $duplicates duplicate IDs found"
        errors=$((errors + 1))
    fi
    
    # Check for nulls
    local nulls=$(grep -c ',,' "$LOG_DIR/transformed_data.csv" || echo 0)
    if [ $nulls -gt 0 ]; then
        log "WARNING: $nulls records with null values"
        errors=$((errors + 1))
    fi
    
    # Data quality threshold
    local total=$(wc -l < "$LOG_DIR/transformed_data.csv")
    local quality=$((100 - (errors * 100 / total)))
    log "Data quality: ${quality}%"
    
    if [ $quality -lt 90 ]; then
        log "ERROR: Data quality below threshold"
        return 1
    fi
}

# Load phase
load() {
    log "=== LOAD PHASE ==="
    
    # Load to database
    log "Loading to database..."
    psql -h localhost -U user -d database \
        -c "\COPY target_table FROM '$LOG_DIR/transformed_data.csv' CSV HEADER"
    
    # Load to S3
    if command -v aws &> /dev/null; then
        log "Uploading to S3..."
        aws s3 cp "$LOG_DIR/transformed_data.csv" \
            "s3://bucket/data/$PIPELINE_ID.csv"
    fi
    
    # Generate manifest
    {
        echo "Pipeline: $PIPELINE_ID"
        echo "Records: $(wc -l < $LOG_DIR/transformed_data.csv)"
        echo "Completed: $(date)"
    } > "$LOG_DIR/manifest.txt"
    
    log "Load completed successfully"
}

# Cleanup
cleanup() {
    log "Cleaning up temporary files..."
    rm -f "$LOG_DIR"/*.tmp
}

# Main pipeline
main() {
    log "Starting ETL pipeline: $PIPELINE_ID"
    
    extract
    transform
    validate
    load
    cleanup
    
    log "Pipeline completed successfully"
    
    # Archive logs
    tar -czf "${LOG_DIR}.tar.gz" "$LOG_DIR"
    rm -rf "$LOG_DIR"
}

main "$@"
```

**Explanation**:
- Multi-source extraction
- Complex transformations
- Data quality validation
- Multi-destination loading
- Comprehensive logging and error handling

</details>

---

## Exercise 5: Intelligent Deployment Orchestrator
**Task**: Create a deployment orchestrator that determines optimal deployment order based on dependencies, handles parallel deployments where possible, and manages rollbacks.

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
# deployment-orchestrator.sh

declare -A DEPENDENCIES
declare -A DEPLOY_STATUS
declare -A DEPLOY_ORDER

# Define component dependencies
DEPENDENCIES=(
    ["database"]=""
    ["backend"]="database"
    ["cache"]="database"
    ["api"]="backend cache"
    ["frontend"]="api"
    ["monitoring"]="backend api"
)

# Calculate deployment order using topological sort
calculate_deploy_order() {
    local -A indegree
    local -A graph
    local queue=()
    local order=()
    local level=0
    
    # Build graph and calculate indegree
    for component in "${!DEPENDENCIES[@]}"; do
        indegree[$component]=0
    done
    
    for component in "${!DEPENDENCIES[@]}"; do
        for dep in ${DEPENDENCIES[$component]}; do
            graph["$dep"]+=" $component"
            indegree[$component]=$((indegree[$component] + 1))
        done
    done
    
    # Find components with no dependencies
    for component in "${!indegree[@]}"; do
        if [ ${indegree[$component]} -eq 0 ]; then
            queue+=("$component")
        fi
    done
    
    # Process queue
    while [ ${#queue[@]} -gt 0 ]; do
        local batch=("${queue[@]}")
        queue=()
        
        DEPLOY_ORDER[$level]="${batch[*]}"
        level=$((level + 1))
        
        for component in "${batch[@]}"; do
            for dependent in ${graph[$component]}; do
                indegree[$dependent]=$((indegree[$dependent] - 1))
                if [ ${indegree[$dependent]} -eq 0 ]; then
                    queue+=("$dependent")
                fi
            done
        done
    done
}

# Deploy component
deploy_component() {
    local component=$1
    
    echo "Deploying $component..."
    
    # Simulate deployment
    if [ "$component" = "fail_component" ]; then
        return 1
    fi
    
    sleep $((RANDOM % 5 + 1))
    
    echo "✓ $component deployed successfully"
    return 0
}

# Rollback component
rollback_component() {
    local component=$1
    echo "Rolling back $component..."
    # Rollback logic here
    sleep 1
    echo "✓ $component rolled back"
}

# Main orchestration
main() {
    echo "=== DEPLOYMENT ORCHESTRATOR ==="
    
    # Calculate order
    calculate_deploy_order
    
    echo
    echo "Deployment Plan:"
    for level in $(seq 0 $((${#DEPLOY_ORDER[@]} - 1))); do
        echo "  Level $level: ${DEPLOY_ORDER[$level]}"
    done
    echo
    
    read -p "Proceed with deployment? (yes/no): " confirm
    [ "$confirm" != "yes" ] && exit 0
    
    # Execute deployment
    local failed_components=()
    
    for level in $(seq 0 $((${#DEPLOY_ORDER[@]} - 1))); do
        echo
        echo "=== Deploying Level $level ==="
        
        local components=(${DEPLOY_ORDER[$level]})
        local pids=()
        
        # Deploy level components in parallel
        for component in "${components[@]}"; do
            {
                if deploy_component "$component"; then
                    DEPLOY_STATUS[$component]="SUCCESS"
                else
                    DEPLOY_STATUS[$component]="FAILED"
                    failed_components+=("$component")
                fi
            } &
            pids+=($!)
        done
        
        # Wait for level completion
        for pid in "${pids[@]}"; do
            wait $pid || true
        done
        
        # Check for failures
        if [ ${#failed_components[@]} -gt 0 ]; then
            echo
            echo "✗ Deployment failed: ${failed_components[*]}"
            echo "Initiating rollback..."
            
            # Rollback in reverse order
            for level in $(seq $((level)) -1 0); do
                for component in ${DEPLOY_ORDER[$level]}; do
                    if [ "${DEPLOY_STATUS[$component]}" = "SUCCESS" ]; then
                        rollback_component "$component"
                    fi
                done
            done
            
            exit 1
        fi
    done
    
    echo
    echo "✓ All components deployed successfully"
}

main "$@"
```

**Explanation**:
- Topological sort for dependency resolution
- Parallel deployment within dependency levels
- Automatic rollback on failure
- Interactive confirmation

</details>

---

*[Exercises 6-20 would continue with similar expert-level patterns including: distributed systems monitoring, custom protocol handlers, advanced state machines, real-time data processing, infrastructure automation, security auditing, performance optimization frameworks, chaos engineering tools, etc.]*

---

## Exercise 6-20: Additional Expert Topics

6. **Distributed Lock Manager**: Implement distributed locking using filesystem or Redis
7. **Custom Load Balancer**: Create intelligent request distribution system
8. **Circuit Breaker Pattern**: Implement resilient service communication
9. **Event-Driven Architecture**: Build pub/sub system with named pipes
10. **Memory-Efficient Big Data**: Process TB-scale files with constant memory
11. **Custom Monitoring Agent**: System metrics collection and alerting
12. **Automated Capacity Planning**: Predictive resource allocation
13. **Security Audit Framework**: Comprehensive security checks
14. **Custom Package Manager**: Dependency resolution and installation
15. **Stream Processing Engine**: Real-time data transformation
16. **Chaos Engineering Tool**: Automated failure injection
17. **Performance Profiler**: Application performance analysis
18. **Custom Scheduler**: Cron-like job scheduling with dependencies
19. **Distributed Tracing**: Request tracking across systems
20. **Infrastructure as Code**: Automated environment provisioning

---

**Next**: [Advanced Solutions](./advanced-solutions.md)
