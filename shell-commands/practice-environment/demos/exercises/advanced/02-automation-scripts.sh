#!/usr/bin/env bash

# ============================================
# Script Automation Tutorial
# ============================================
# Build reusable automation scripts

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Automation Scripts${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Learn to build production-ready automation"
echo ""

# Example 1: Log Monitoring Script
echo -e "${YELLOW}Example 1: Log Monitor Script${NC}"
echo "Create a script that alerts on error threshold"
echo ""
cat << 'SCRIPT_EOF'
#!/bin/bash
# log-monitor.sh - Alert on high error rates

LOGFILE="$1"
THRESHOLD="${2:-10}"

if [ ! -f "$LOGFILE" ]; then
    echo "Error: Log file not found: $LOGFILE"
    exit 1
fi

ERROR_COUNT=$(grep -c 'ERROR' "$LOGFILE" || echo "0")

if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    echo "⚠️  ALERT: $ERROR_COUNT errors found (threshold: $THRESHOLD)"
    echo "Recent errors:"
    grep 'ERROR' "$LOGFILE" | tail -3
    exit 1
else
    echo "✓ OK: $ERROR_COUNT errors (under threshold: $THRESHOLD)"
    exit 0
fi
SCRIPT_EOF
echo ""
echo "Testing the script:"
echo ""

# Create temp script
cat > /tmp/log-monitor.sh << 'SCRIPT_EOF'
#!/bin/bash
LOGFILE="$1"
THRESHOLD="${2:-10}"
if [ ! -f "$LOGFILE" ]; then
    echo "Error: Log file not found: $LOGFILE"
    exit 1
fi
ERROR_COUNT=$(grep -c 'ERROR' "$LOGFILE" || echo "0")
if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    echo "⚠️  ALERT: $ERROR_COUNT errors found (threshold: $THRESHOLD)"
    echo "Recent errors:"
    grep 'ERROR' "$LOGFILE" | tail -3
    exit 1
else
    echo "✓ OK: $ERROR_COUNT errors (under threshold: $THRESHOLD)"
    exit 0
fi
SCRIPT_EOF
chmod +x /tmp/log-monitor.sh

/tmp/log-monitor.sh data/logs/application.log 100
echo ""
echo -e "${GREEN}✓ Log monitor created!${NC}"
echo ""

# Example 2: Data Backup Script
echo -e "${YELLOW}Example 2: Automated Backup Script${NC}"
echo "Create timestamped backups with rotation"
echo ""
cat << 'SCRIPT_EOF'
#!/bin/bash
# backup-data.sh - Backup with timestamp

SOURCE_DIR="$1"
BACKUP_DIR="${2:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Backup created: $BACKUP_FILE"
    ls -lh "$BACKUP_FILE"

    # Keep only last 5 backups
    ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs rm -f 2>/dev/null
    echo "✓ Old backups cleaned (kept last 5)"
else
    echo "✗ Backup failed"
    exit 1
fi
SCRIPT_EOF
echo ""
echo -e "${GREEN}✓ Backup automation created!${NC}"
echo ""

# Example 3: Health Check Script
echo -e "${YELLOW}Example 3: System Health Check${NC}"
echo "Comprehensive health monitoring"
echo ""
cat << 'SCRIPT_EOF'
#!/bin/bash
# health-check.sh - System health verification

echo "=== Health Check Report ==="
echo "Timestamp: $(date)"
echo ""

# Check log files exist
echo "1. File Availability:"
for file in data/logs/*.log; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file MISSING"
    fi
done
echo ""

# Check error rates
echo "2. Error Rates:"
for log in data/logs/*.log; do
    ERROR_COUNT=$(grep -c 'ERROR' "$log" 2>/dev/null || echo "0")
    echo "  $(basename $log): $ERROR_COUNT errors"
done
echo ""

# Check disk usage
echo "3. Data Size:"
du -sh data/* 2>/dev/null | column -t
echo ""

echo "=== Health Check Complete ==="
SCRIPT_EOF
echo ""
echo "Running health check:"
echo ""
echo "=== Health Check Report ==="
echo "Timestamp: $(date)"
echo ""
echo "1. File Availability:"
for file in data/logs/*.log; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    fi
done
echo ""
echo "2. Error Rates:"
for log in data/logs/*.log; do
    ERROR_COUNT=$(grep -c 'ERROR' "$log" 2>/dev/null || echo "0")
    echo "  $(basename $log): $ERROR_COUNT errors"
done
echo ""
echo "3. Data Size:"
du -sh data/* 2>/dev/null | column -t
echo ""
echo -e "${GREEN}✓ Health check complete!${NC}"
echo ""

# Example 4: Report Generator
echo -e "${YELLOW}Example 4: Automated Report Generator${NC}"
echo "Generate daily reports with email-ready format"
echo ""
cat << 'SCRIPT_EOF'
#!/bin/bash
# daily-report.sh - Generate daily summary

REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="daily_report_$REPORT_DATE.txt"

{
    echo "Daily Report - $REPORT_DATE"
    echo "================================"
    echo ""

    echo "Error Summary:"
    grep -h 'ERROR' data/logs/*.log 2>/dev/null | wc -l
    echo ""

    echo "Top Errors:"
    grep -h 'ERROR' data/logs/*.log 2>/dev/null | \
        awk '{for(i=4;i<=NF;i++) printf $i" "; print ""}' | \
        sort | uniq -c | sort -nr | head -5
    echo ""

    echo "Web Traffic:"
    echo "  Total requests: $(wc -l < data/logs/web-access.log)"
    echo "  Unique visitors: $(awk '{print $1}' data/logs/web-access.log | sort -u | wc -l)"
    echo ""

    echo "Report generated at: $(date)"
} > /tmp/"$REPORT_FILE"

echo "✓ Report saved to: /tmp/$REPORT_FILE"
cat /tmp/"$REPORT_FILE"
SCRIPT_EOF
echo ""
echo -e "${GREEN}✓ Report generator created!${NC}"
echo ""

# Clean up
rm -f /tmp/log-monitor.sh

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Automation Scripts Complete! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Automation Patterns Learned:"
echo "  • Error handling with exit codes"
echo "  • Input validation"
echo "  • Timestamp generation"
echo "  • File rotation"
echo "  • Health monitoring"
echo "  • Report generation"
echo ""
echo "Apply these patterns to:"
echo "  • CI/CD pipelines"
echo "  • Monitoring systems"
echo "  • Backup automation"
echo "  • Log rotation"
echo "  • Daily reports"
echo ""
