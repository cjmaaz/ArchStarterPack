#!/usr/bin/env bash

# ============================================
# Interactive CSV Processing Tutorial
# ============================================
# Learn awk, cut, sort for CSV data

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  CSV Processing Tutorial${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Exercise 1: Extract Specific Columns${NC}"
echo "Task: Show only Name and Industry from accounts.csv"
echo ""
echo -e "${GREEN}Command:${NC} cut -d',' -f2,3 data/csv/accounts.csv | head -10"
echo ""
read -p "Press Enter to see the result..."
echo ""
cut -d',' -f2,3 data/csv/accounts.csv | head -10
echo ""
echo -e "${GREEN}✓ Complete!${NC} cut extracts columns by position"
echo ""

# Exercise 2
echo -e "${YELLOW}Exercise 2: Filter Rows by Value${NC}"
echo "Task: Find all Technology companies"
echo ""
echo -e "${GREEN}Command:${NC} awk -F',' '\$3 == \"Technology\" {print \$2}' data/csv/accounts.csv"
echo ""
read -p "Press Enter to see the result..."
echo ""
awk -F',' '$3 == "Technology" {print $2}' data/csv/accounts.csv
echo ""
echo -e "${GREEN}✓ Complete!${NC} awk can filter and extract"
echo ""

# Exercise 3
echo -e "${YELLOW}Exercise 3: Sort by Column${NC}"
echo "Task: Sort accounts by name (column 2)"
echo ""
echo -e "${GREEN}Command:${NC} sort -t',' -k2 data/csv/accounts.csv | head -10"
echo ""
read -p "Press Enter to see the result..."
echo ""
sort -t',' -k2 data/csv/accounts.csv | head -10
echo ""
echo -e "${GREEN}✓ Complete!${NC} sort -k specifies column"
echo ""

# Exercise 4
echo -e "${YELLOW}Exercise 4: Count by Category${NC}"
echo "Task: Count how many accounts per industry"
echo ""
echo -e "${GREEN}Command:${NC} tail -n +2 data/csv/accounts.csv | cut -d',' -f3 | sort | uniq -c | sort -nr"
echo ""
read -p "Press Enter to see the result..."
echo ""
tail -n +2 data/csv/accounts.csv | cut -d',' -f3 | sort | uniq -c | sort -nr
echo ""
echo -e "${GREEN}✓ Complete!${NC} Group and count pattern!"
echo ""

# Exercise 5
echo -e "${YELLOW}Exercise 5: Calculate Total${NC}"
echo "Task: Calculate total annual revenue of all accounts"
echo ""
echo -e "${GREEN}Command:${NC} awk -F',' 'NR>1 {sum+=\$4} END {print \"Total Revenue: $\" sum}' data/csv/accounts.csv"
echo ""
read -p "Press Enter to see the result..."
echo ""
awk -F',' 'NR>1 {sum+=$4} END {print "Total Revenue: $" sum}' data/csv/accounts.csv
echo ""
echo -e "${GREEN}✓ Complete!${NC} awk can do math!"
echo ""

# Exercise 6
echo -e "${YELLOW}Exercise 6: Filter by Number Range${NC}"
echo "Task: Find accounts with revenue > 10 million"
echo ""
echo -e "${GREEN}Command:${NC} awk -F',' 'NR>1 && \$4 > 10000000 {print \$2, \$4}' data/csv/accounts.csv"
echo ""
read -p "Press Enter to see the result..."
echo ""
awk -F',' 'NR>1 && $4 > 10000000 {print $2, $4}' data/csv/accounts.csv
echo ""
echo -e "${GREEN}✓ Complete!${NC} Numeric filtering with awk"
echo ""

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}  Tutorial Complete! 🎉${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "What you learned:"
echo "  • cut - extract columns by position"
echo "  • awk -F - specify delimiter"
echo "  • awk filtering with conditions"
echo "  • sort -t -k - sort by column"
echo "  • uniq -c - count occurrences"
echo "  • awk calculations (sum, average)"
echo ""
echo "Practice more:"
echo "  • Try: Calculate average revenue"
echo "  • Try: Find accounts in specific cities"
echo "  • Try: Count sales by region in sales-data.csv"
echo ""
