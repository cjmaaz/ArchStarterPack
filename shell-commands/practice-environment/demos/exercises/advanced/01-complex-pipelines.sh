#!/usr/bin/env bash

# ============================================
# Advanced Pipeline Construction
# ============================================
# Build complex multi-stage data pipelines

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Advanced Pipeline Construction${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Build production-ready data processing pipelines"
echo ""

# Exercise 1
echo -e "${YELLOW}Challenge 1: Multi-Source Error Aggregation${NC}"
echo "Task: Combine errors from all logs, count by type, show top 10"
echo ""
echo "Requirements:"
echo "  • Process all log files"
echo "  • Extract error messages only"
echo "  • Group and count"
echo "  • Sort by frequency"
echo ""
read -p "Try it yourself, then press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
cat data/logs/*.log | \
  grep -i 'error' | \
  awk '{for(i=4;i<=NF;i++) printf $i" "; print ""}' | \
  sed 's/^[ \t]*//' | \
  sort | \
  uniq -c | \
  sort -nr | \
  head -10
EOF
echo ""
echo "Output:"
cat data/logs/*.log | \
  grep -i 'error' | \
  awk '{for(i=4;i<=NF;i++) printf $i" "; print ""}' | \
  sed 's/^[ \t]*//' | \
  sort | \
  uniq -c | \
  sort -nr | \
  head -10
echo ""
echo -e "${GREEN}✓ Multi-source aggregation complete!${NC}"
echo ""

# Exercise 2
echo -e "${YELLOW}Challenge 2: Time-Series Analysis${NC}"
echo "Task: Create hourly error rate chart (errors per hour)"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
grep 'ERROR' data/logs/application.log | \
  awk '{print $1 " " $2}' | \
  awk '{print substr($2, 1, 2)}' | \
  sort | \
  uniq -c | \
  awk '{printf "%02d:00 | %s\n", $2, $1}'
EOF
echo ""
echo "Hourly Error Distribution:"
grep 'ERROR' data/logs/application.log | \
  awk '{print $1 " " $2}' | \
  awk '{print substr($2, 1, 2)}' | \
  sort | \
  uniq -c | \
  awk '{printf "%02d:00 | Errors: %s\n", $2, $1}'
echo ""
echo -e "${GREEN}✓ Time-series analysis complete!${NC}"
echo ""

# Exercise 3
echo -e "${YELLOW}Challenge 3: Cross-Reference Data Sources${NC}"
echo "Task: Find accounts that appear in CSV but not in JSON"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
# Extract names from CSV
tail -n +2 data/csv/accounts.csv | cut -d',' -f2 | sort > /tmp/csv_names.txt

# Extract names from JSON
jq -r '.result.records[].Name' data/json/sf-query-result.json | sort > /tmp/json_names.txt

# Find difference
comm -23 /tmp/csv_names.txt /tmp/json_names.txt
EOF
echo ""
echo "Accounts in CSV but not in JSON:"
tail -n +2 data/csv/accounts.csv | cut -d',' -f2 | sort > /tmp/csv_names.txt
jq -r '.result.records[].Name' data/json/sf-query-result.json | sort > /tmp/json_names.txt
comm -23 /tmp/csv_names.txt /tmp/json_names.txt
echo ""
echo -e "${GREEN}✓ Cross-reference complete!${NC}"
rm -f /tmp/csv_names.txt /tmp/json_names.txt
echo ""

# Exercise 4
echo -e "${YELLOW}Challenge 4: Generate Detailed Report${NC}"
echo "Task: Create formatted report of web traffic analysis"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
echo "=== Web Traffic Analysis Report ==="
echo ""
echo "Total Requests:"
wc -l < data/logs/web-access.log
echo ""
echo "Unique IPs:"
awk '{print $1}' data/logs/web-access.log | sort -u | wc -l
echo ""
echo "Status Code Distribution:"
awk '{print $9}' data/logs/web-access.log | sort | uniq -c | sort -nr
echo ""
echo "Top 5 Requested URLs:"
awk '{print $7}' data/logs/web-access.log | sort | uniq -c | sort -nr | head -5
EOF
echo ""
echo "=== Web Traffic Analysis Report ==="
echo ""
echo "Total Requests:"
wc -l < data/logs/web-access.log
echo ""
echo "Unique IPs:"
awk '{print $1}' data/logs/web-access.log | sort -u | wc -l
echo ""
echo "Status Code Distribution:"
awk '{print $9}' data/logs/web-access.log | sort | uniq -c | sort -nr
echo ""
echo "Top 5 Requested URLs:"
awk '{print $7}' data/logs/web-access.log | sort | uniq -c | sort -nr | head -5
echo ""
echo -e "${GREEN}✓ Report generated!${NC}"
echo ""

# Exercise 5
echo -e "${YELLOW}Challenge 5: Data Quality Check${NC}"
echo "Task: Find incomplete or invalid records in accounts.csv"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
# Check for records with empty fields
awk -F',' 'NF != 7 || /,,/ {print NR ": " $0}' data/csv/accounts.csv

# Check for invalid revenue (non-numeric)
tail -n +2 data/csv/accounts.csv | awk -F',' '$4 !~ /^[0-9]+$/ && $4 != "" {print "Invalid revenue on line " NR+1 ": " $2}'
EOF
echo ""
echo "Quality check results:"
awk -F',' 'NF != 7 || /,,/ {print "Line " NR " incomplete: " $0}' data/csv/accounts.csv | head -5
echo "(Showing first 5 if any)"
echo ""
echo -e "${GREEN}✓ Quality check complete!${NC}"
echo ""

# Exercise 6
echo -e "${YELLOW}Challenge 6: Performance Optimization${NC}"
echo "Task: Compare performance of different approaches"
echo ""
echo "Counting errors - Method 1 (grep + wc):"
time (grep -c 'ERROR' data/logs/application.log > /dev/null) 2>&1 | grep real
echo ""
echo "Counting errors - Method 2 (awk):"
time (awk '/ERROR/ {count++} END {print count}' data/logs/application.log > /dev/null) 2>&1 | grep real
echo ""
echo -e "${GREEN}✓ Performance comparison complete!${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Advanced Pipelines Mastered! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Skills Mastered:"
echo "  • Multi-file aggregation"
echo "  • Time-series analysis"
echo "  • Data cross-referencing with comm"
echo "  • Report generation"
echo "  • Data quality validation"
echo "  • Performance optimization"
echo ""
echo "Next: Try 02-automation-scripts.sh"
echo ""
