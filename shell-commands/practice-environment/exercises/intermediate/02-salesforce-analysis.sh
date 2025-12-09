#!/usr/bin/env bash

# ============================================
# Salesforce Data Analysis Tutorial
# ============================================
# Analyze Salesforce logs, data, and deployments

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

if ! command -v jq &> /dev/null; then
    echo "This tutorial requires jq. Please install it first."
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Salesforce Data Analysis${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Challenge 1: Find SOQL Queries in Apex Log${NC}"
echo "Task: Extract all SOQL queries from the debug log"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep 'SOQL_EXECUTE_BEGIN' data/logs/apex-debug.log | sed 's/.*SOQL_EXECUTE_BEGIN|//'"
echo ""
grep 'SOQL_EXECUTE_BEGIN' data/logs/apex-debug.log | sed 's/.*SOQL_EXECUTE_BEGIN|//'
echo ""
echo -e "${GREEN}✓ SOQL Queries Extracted!${NC}"
echo ""

# Exercise 2
echo -e "${YELLOW}Challenge 2: Count DML Operations${NC}"
echo "Task: How many INSERT, UPDATE, DELETE operations occurred?"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -E 'DML_(INSERT|UPDATE|DELETE)' data/logs/apex-debug.log | awk -F'|' '{print \$1}' | sort | uniq -c"
echo ""
grep -E 'DML_(INSERT|UPDATE|DELETE)' data/logs/apex-debug.log | awk -F'|' '{print $1}' | sort | uniq -c
echo ""
echo -e "${GREEN}✓ DML Operations Counted!${NC}"
echo ""

# Exercise 3
echo -e "${YELLOW}Challenge 3: Governor Limits Check${NC}"
echo "Task: Find any lines mentioning limits or exceeded"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -i 'limit' data/logs/apex-debug.log | head -10"
echo ""
grep -i 'limit' data/logs/apex-debug.log | head -10
echo ""
echo -e "${GREEN}✓ Limits Checked!${NC}"
echo ""

# Exercise 4
echo -e "${YELLOW}Challenge 4: Deployment Success Rate${NC}"
echo "Task: Analyze deployment results"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -E 'Component(Success|Failure)' data/logs/deployment.log | awk -F':' '{print \$1}' | sort | uniq -c"
echo ""
grep -E 'Component(Success|Failure)' data/logs/deployment.log | awk -F':' '{print $1}' | sort | uniq -c
echo ""
echo -e "${GREEN}✓ Deployment Analysis Complete!${NC}"
echo ""

# Exercise 5
echo -e "${YELLOW}Challenge 5: Extract Failed Components${NC}"
echo "Task: List all components that failed to deploy"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep 'ComponentFailure' data/logs/deployment.log | awk -F':' '{print \$2}' | sed 's/^ //'"
echo ""
grep 'ComponentFailure' data/logs/deployment.log | awk -F':' '{print $2}' | sed 's/^ //'
echo ""
echo -e "${GREEN}✓ Failed Components Listed!${NC}"
echo ""

# Exercise 6
echo -e "${YELLOW}Challenge 6: JSON Query Result Analysis${NC}"
echo "Task: Find high-revenue Technology accounts"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "jq -r '.result.records[] | select(.Industry == \"Technology\" and .AnnualRevenue > 4000000) | \"\\(.Name): $\\(.AnnualRevenue)\"' data/json/sf-query-result.json"
echo ""
jq -r '.result.records[] | select(.Industry == "Technology" and .AnnualRevenue > 4000000) | "\(.Name): $\(.AnnualRevenue)"' data/json/sf-query-result.json
echo ""
echo -e "${GREEN}✓ Accounts Found!${NC}"
echo ""

# Exercise 7
echo -e "${YELLOW}Challenge 7: Test Coverage Analysis${NC}"
echo "Task: Extract test coverage from deployment log"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep -i 'coverage' data/logs/deployment.log"
echo ""
grep -i 'coverage' data/logs/deployment.log || echo "No coverage info in this log"
echo ""
echo -e "${GREEN}✓ Coverage Checked!${NC}"
echo ""

# Exercise 8
echo -e "${YELLOW}Challenge 8: Account Revenue by Industry${NC}"
echo "Task: Calculate total revenue by industry (CSV)"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "tail -n +2 data/csv/accounts.csv | awk -F',' '{industry[\$3]+=\$4} END {for (i in industry) print i \": $\" industry[i]}'"
echo ""
tail -n +2 data/csv/accounts.csv | awk -F',' '{industry[$3]+=$4} END {for (i in industry) print i ": $" industry[i]}'
echo ""
echo -e "${GREEN}✓ Revenue Calculated!${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Salesforce Analysis Complete! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "What you practiced:"
echo "  • Apex debug log analysis"
echo "  • SOQL query extraction"
echo "  • DML operation counting"
echo "  • Deployment log parsing"
echo "  • JSON data filtering with jq"
echo "  • CSV aggregation by category"
echo "  • Test coverage analysis"
echo ""
echo "Next: Try 03-data-transformation.sh"
echo ""
