#!/usr/bin/env bash

# ============================================
# Interactive Log Analysis Tutorial
# ============================================
# Real-world log analysis scenarios

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Real-World Log Analysis${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Scenario: You're investigating production issues"
echo ""

# Exercise 1
echo -e "${YELLOW}Challenge 1: Find Top Error Types${NC}"
echo "Task: What are the top 5 most common errors?"
echo ""
echo "Hint: Extract error messages, group them, count, and sort"
echo ""
read -p "Try it yourself, then press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep 'ERROR' data/logs/application.log | awk '{for(i=5;i<=NF;i++) printf \$i\" \"; print \"\"}' | sort | uniq -c | sort -nr | head -5"
echo ""
grep 'ERROR' data/logs/application.log | awk '{for(i=5;i<=NF;i++) printf $i" "; print ""}' | sort | uniq -c | sort -nr | head -5
echo ""
echo -e "${GREEN}✓ Analysis Complete!${NC}"
echo ""

# Exercise 2
echo -e "${YELLOW}Challenge 2: Error Timeline${NC}"
echo "Task: Show when errors occurred (hour by hour)"
echo ""
echo "Hint: Extract timestamp hour from ERROR lines"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep 'ERROR' data/logs/application.log | awk '{print \$2}' | cut -d':' -f1 | sort | uniq -c"
echo ""
grep 'ERROR' data/logs/application.log | awk '{print $2}' | cut -d':' -f1 | sort | uniq -c
echo ""
echo -e "${GREEN}✓ Timeline Generated!${NC}"
echo ""

# Exercise 3
echo -e "${YELLOW}Challenge 3: Find Slowest Requests${NC}"
echo "Task: Find requests that took > 1 second from web log"
echo ""
echo "Hint: Look for slow query warnings"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -i 'slow' data/logs/application.log"
echo ""
grep -i 'slow' data/logs/application.log
echo ""
echo -e "${GREEN}✓ Slow Queries Found!${NC}"
echo ""

# Exercise 4
echo -e "${YELLOW}Challenge 4: User Activity Analysis${NC}"
echo "Task: Extract all unique user emails from logs"
echo ""
echo "Hint: Email pattern matching"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' data/logs/application.log | sort -u"
echo ""
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' data/logs/application.log | sort -u
echo ""
echo -e "${GREEN}✓ Users Extracted!${NC}"
echo ""

# Exercise 5
echo -e "${YELLOW}Challenge 5: HTTP Status Code Distribution${NC}"
echo "Task: Count occurrences of each HTTP status code"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "awk '{print \$9}' data/logs/web-access.log | sort | uniq -c | sort -nr"
echo ""
awk '{print $9}' data/logs/web-access.log | sort | uniq -c | sort -nr
echo ""
echo -e "${GREEN}✓ Status Codes Analyzed!${NC}"
echo ""

# Exercise 6
echo -e "${YELLOW}Challenge 6: Find Failed Requests by IP${NC}"
echo "Task: Which IP addresses had 500 errors?"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "awk '\$9 >= 500 {print \$1}' data/logs/web-access.log | sort | uniq -c | sort -nr"
echo ""
awk '$9 >= 500 {print $1}' data/logs/web-access.log | sort | uniq -c | sort -nr
echo ""
echo -e "${GREEN}✓ Problem IPs Identified!${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Analysis Complete! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "What you practiced:"
echo "  • Complex text extraction"
echo "  • Time-based analysis"
echo "  • Pattern matching with regex"
echo "  • Multi-stage pipelines"
echo "  • HTTP log analysis"
echo "  • Error investigation workflows"
echo ""
echo "Next: Try 02-salesforce-analysis.sh"
echo ""
