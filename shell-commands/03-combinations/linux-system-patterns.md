# Linux System Administration Patterns

Real-world patterns for system administration, DevOps, and general Linux usage.

---

## Pattern 1: Log Analysis & Monitoring

### Basic Log Monitoring
```bash
# Watch system log for errors
tail -f /var/log/syslog | grep --color=always -iE "error|fail|critical"

# Monitor Apache access log for 404s
tail -f /var/log/apache2/access.log | grep " 404 "

# Watch multiple logs simultaneously
tail -f /var/log/{syslog,auth.log,apache2/error.log}
```

### Error Frequency Analysis
```bash
# Count errors by type in last hour
grep "$(date -d '1 hour ago' '+%Y-%m-%d %H')" /var/log/syslog | \
grep -i "error" | \
awk '{print $5}' | sort | uniq -c | sort -nr

# Daily error summary
for log in /var/log/*.log; do
    echo "=== $log ==="
    grep -c "error" "$log" 2>/dev/null || echo "0"
done | paste - - | sort -k2 -nr
```

### Failed Login Monitoring
```bash
# Find brute-force attempts
grep "Failed password" /var/log/auth.log | \
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | \
sort | uniq -c | sort -nr | \
awk '$1 > 5 {printf "⚠️  %s: %d attempts\n", $2, $1}'

# Alert on suspicious activity
#!/bin/bash
THRESHOLD=10
ALERT_EMAIL="admin@example.com"

count=$(grep "Failed password" /var/log/auth.log | tail -100 | wc -l)
if [ $count -gt $THRESHOLD ]; then
    echo "Alert: $count failed login attempts" | mail -s "Security Alert" $ALERT_EMAIL
fi
```

---

## Pattern 2: System Resource Monitoring

### Disk Space Monitoring
```bash
# Check partitions over 80% full
df -h | awk 'NR>1 {gsub("%","",$5); if($5>80) print "⚠️  "$6" is "$5"% full"}'

# Find large directories
du -h --max-depth=1 /var | sort -hr | head -10

# Find large files over 100MB
find /var/log -type f -size +100M -exec ls -lh {} \; | \
awk '{print $5, $9}' | sort -hr
```

### Memory Monitoring
```bash
# Show top memory consumers
ps aux | sort -k4 -nr | head -10 | \
awk '{printf "%-20s %6s%% %10s\n", $11, $4, $6}'

# Check for memory leaks (processes growing)
while true; do
    ps -eo pid,vsz,comm | grep -v PID | sort -k2 -nr | head -5
    echo "---"
    sleep 60
done
```

### CPU Monitoring
```bash
# Top CPU consumers
ps aux | sort -k3 -nr | head -10 | \
awk '{printf "%-20s %6s%% %s\n", $11, $3, $2}'

# CPU usage per core
mpstat -P ALL 1 5 | awk '/Average/ && $2 ~ /[0-9]/ {print "Core"$2": "$3"%"}'
```

---

## Pattern 3: Process Management

### Find and Kill Processes
```bash
# Kill all processes by name
pkill -f "process_name"

# More controlled approach
ps aux | grep "process_name" | grep -v grep | awk '{print $2}' | xargs kill

# Kill zombie processes
ps aux | awk '$8=="Z" {print $2}' | xargs kill -9 2>/dev/null
```

### Process Monitoring Script
```bash
#!/bin/bash
# monitor_process.sh
PROCESS_NAME="nginx"
LOG_FILE="/var/log/process_monitor.log"

while true; do
    if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
        echo "[$(date)] $PROCESS_NAME is down, restarting..." | tee -a "$LOG_FILE"
        systemctl restart "$PROCESS_NAME"
    fi
    sleep 60
done
```

---

## Pattern 4: File Operations

### Bulk File Renaming
```bash
# Add prefix to all files
for file in *.txt; do
    mv "$file" "backup_$file"
done

# Replace spaces with underscores
for file in *\ *; do
    mv "$file" "${file// /_}"
done

# Change extension
for file in *.jpeg; do
    mv "$file" "${file%.jpeg}.jpg"
done
```

### Find and Archive
```bash
# Archive files older than 30 days
find /data -name "*.log" -mtime +30 | \
xargs tar -czf old_logs_$(date +%Y%m%d).tar.gz && \
find /data -name "*.log" -mtime +30 -delete

# Archive by size
find /data -size +100M -type f | \
xargs tar -czf large_files_$(date +%Y%m%d).tar.gz
```

### File Comparison
```bash
# Find duplicate files
find . -type f -exec md5sum {} \; | sort | uniq -d -w32

# Compare directories
diff -qr /path/to/dir1 /path/to/dir2

# Find files in dir1 but not in dir2
comm -23 <(ls dir1 | sort) <(ls dir2 | sort)
```

---

## Pattern 5: Network Operations

### Connection Monitoring
```bash
# Show active connections
netstat -tunapl | grep ESTABLISHED

# Count connections by IP
netstat -an | grep :80 | awk '{print $5}' | \
cut -d: -f1 | sort | uniq -c | sort -nr

# Monitor bandwidth per process
nethogs eth0
```

### Port Checking
```bash
# Check if port is open
nc -zv hostname 80

# Find process using a port
lsof -i :8080

# Show all listening ports
netstat -tulpn | grep LISTEN
```

### Network Troubleshooting
```bash
# Trace network path
traceroute google.com | \
awk '{print $1, $2, $3}' | column -t

# DNS lookup multiple domains
for domain in google.com facebook.com github.com; do
    echo "$domain:"
    dig +short "$domain"
done

# Check response times
for host in google.com facebook.com github.com; do
    time curl -s -o /dev/null "$host" 2>&1 | grep real
done
```

---

## Pattern 6: User Management

### Audit User Activity
```bash
# List logged in users
who | awk '{print $1}' | sort | uniq -c

# User login history
last -10 | awk '{print $1, $3, $4, $5, $6, $7}' | column -t

# Failed sudo attempts
grep "sudo.*COMMAND" /var/log/auth.log | \
grep "user NOT in sudoers" | \
awk '{print $1, $2, $3, $9}'
```

### User Disk Usage
```bash
# Disk usage per user
for user in $(cut -d: -f1 /etc/passwd); do
    home=$(getent passwd "$user" | cut -d: -f6)
    if [ -d "$home" ]; then
        size=$(du -sh "$home" 2>/dev/null | awk '{print $1}')
        echo "$user: $size"
    fi
done | sort -k2 -hr
```

---

## Pattern 7: Backup & Recovery

### Automated Backup Script
```bash
#!/bin/bash
# backup.sh

SOURCE="/data"
DEST="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$DATE.tar.gz"
MAX_BACKUPS=7

# Create backup
tar -czf "$DEST/$BACKUP_NAME" "$SOURCE" 2>&1 | tee -a /var/log/backup.log

# Verify backup
if [ $? -eq 0 ]; then
    echo "[$(date)] Backup successful: $BACKUP_NAME" >> /var/log/backup.log
    
    # Rotate old backups
    ls -t "$DEST"/backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
    echo "[$(date)] Old backups cleaned" >> /var/log/backup.log
else
    echo "[$(date)] Backup failed!" >> /var/log/backup.log
    exit 1
fi
```

### Database Backup
```bash
# MySQL/MariaDB backup
mysqldump -u root -p database_name | \
gzip > backup_$(date +%Y%m%d).sql.gz

# PostgreSQL backup
pg_dump -U postgres database_name | \
gzip > backup_$(date +%Y%m%d).sql.gz

# Backup all databases
for db in $(mysql -u root -p -e "SHOW DATABASES;" | grep -Ev "Database|information_schema|performance_schema"); do
    mysqldump -u root -p "$db" | gzip > "${db}_$(date +%Y%m%d).sql.gz"
done
```

---

## Pattern 8: Docker Management

### Container Health Monitoring
```bash
# Check unhealthy containers
docker ps --filter "health=unhealthy" --format "table {{.Names}}\t{{.Status}}"

# Container resource usage
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Find stopped containers
docker ps -a --filter "status=exited" --format "{{.Names}}"
```

### Container Log Analysis
```bash
# Get errors from all containers
for container in $(docker ps --format '{{.Names}}'); do
    echo "=== $container ==="
    docker logs --tail 50 "$container" 2>&1 | grep -iE "error|exception|fail"
done

# Count errors per container
for container in $(docker ps --format '{{.Names}}'); do
    count=$(docker logs --since 1h "$container" 2>&1 | grep -ci "error")
    printf "%-20s: %d errors\n" "$container" "$count"
done | sort -k2 -nr
```

### Cleanup Docker Resources
```bash
# Remove stopped containers
docker ps -a --filter "status=exited" -q | xargs -r docker rm

# Remove unused images
docker images --filter "dangling=true" -q | xargs -r docker rmi

# Remove unused volumes
docker volume ls --filter "dangling=true" -q | xargs -r docker volume rm

# Complete cleanup
docker system prune -af --volumes
```

---

## Pattern 9: Git Operations

### Repository Statistics
```bash
# Commits per author
git log --format="%an" | sort | uniq -c | sort -nr

# Lines of code per author
git log --author="Author Name" --pretty=tformat: --numstat | \
awk '{add+=$1; del+=$2} END {print "Added:",add,"Deleted:",del,"Total:",add-del}'

# Files changed most often
git log --pretty=format: --name-only | sort | uniq -c | sort -nr | head -10
```

### Code Search
```bash
# Find TODOs across repository
git grep -n "TODO" | wc -l

# Find files containing specific text
git log -S "search_term" --source --all

# Find commits that introduced a bug
git log --all --grep="bug" --oneline
```

---

## Pattern 10: Performance Analysis

### System Performance Report
```bash
#!/bin/bash
# system_report.sh

echo "=== System Performance Report ==="
echo "Date: $(date)"
echo ""

echo "== CPU =="
top -bn1 | grep "Cpu(s)" | awk '{print "Usage: "$2}'

echo ""
echo "== Memory =="
free -h | grep Mem | awk '{print "Used: "$3" / "$2" ("$3/$2*100"%)"}'

echo ""
echo "== Disk =="
df -h / | tail -1 | awk '{print "Used: "$3" / "$2" ("$5")"}'

echo ""
echo "== Top Processes by CPU =="
ps aux | sort -k3 -nr | head -5 | awk '{print $3"%", $11}'

echo ""
echo "== Top Processes by Memory =="
ps aux | sort -k4 -nr | head -5 | awk '{print $4"%", $11}'

echo ""
echo "== Network Connections =="
netstat -an | grep ESTABLISHED | wc -l | awk '{print "Active: "$1}'
```

### Application Performance
```bash
# API response time monitoring
for endpoint in /api/users /api/products /api/orders; do
    echo -n "$endpoint: "
    time curl -s -o /dev/null "https://api.example.com$endpoint" 2>&1 | \
    grep real | awk '{print $2}'
done

# Database query performance
mysql -u root -p -e "SELECT * FROM information_schema.PROCESSLIST WHERE Time > 10;" | \
awk '{print $1, $6, $8}' | column -t
```

---

## Pattern 11: Automated Testing

### Health Check Script
```bash
#!/bin/bash
# health_check.sh

EXIT_CODE=0

# Check services
for service in nginx mysql redis; do
    if systemctl is-active --quiet "$service"; then
        echo "✓ $service is running"
    else
        echo "✗ $service is not running"
        EXIT_CODE=1
    fi
done

# Check disk space
df -h | awk 'NR>1 {gsub("%","",$5); if($5>90) {print "✗ "$6" is "$5"% full"; exit 1}}'
[ $? -eq 1 ] && EXIT_CODE=1

# Check ports
for port in 80 443 3306; do
    if nc -z localhost "$port" 2>/dev/null; then
        echo "✓ Port $port is open"
    else
        echo "✗ Port $port is closed"
        EXIT_CODE=1
    fi
done

exit $EXIT_CODE
```

---

## Pattern 12: Data Processing

### CSV Processing
```bash
# Extract specific columns
cut -d',' -f1,3 data.csv > filtered.csv

# Filter rows by condition
awk -F',' '$3 > 100 {print $1","$2","$3}' data.csv

# Calculate statistics
awk -F',' '{sum+=$3; count++} END {print "Avg:", sum/count}' data.csv

# Join two CSV files
join -t',' -1 1 -2 1 <(sort file1.csv) <(sort file2.csv)
```

### Log Aggregation
```bash
# Combine logs from multiple servers
for server in server1 server2 server3; do
    ssh "$server" "cat /var/log/app.log" >> combined.log
done

# Parse combined logs
grep "ERROR" combined.log | \
awk '{print $1, $2}' | \
cut -d: -f1 | \
sort | uniq -c
```

---

## Best Practices

### 1. Always Test First
```bash
# Preview before deletion
find . -name "*.tmp" -type f  # Preview
find . -name "*.tmp" -type f -delete  # Execute

# Dry-run for rsync
rsync -avun source/ dest/  # -n for dry-run
rsync -avu source/ dest/   # Actual sync
```

### 2. Use Logging
```bash
# Log all operations
command 2>&1 | tee -a operation.log

# Timestamped logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a script.log
}
log "Starting operation..."
```

### 3. Error Handling
```bash
# Exit on error
set -e

# Check exit codes
if command; then
    echo "Success"
else
    echo "Failed with code: $?"
    exit 1
fi
```

### 4. Use Configuration Files
```bash
# config.conf
BACKUP_DIR="/backups"
RETENTION_DAYS=7
MAX_SIZE="100M"

# script.sh
source config.conf
find "$BACKUP_DIR" -mtime +$RETENTION_DAYS -delete
```

---

**Next**: [Advanced Patterns](./advanced-patterns.md)
