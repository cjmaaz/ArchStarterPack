#!/usr/bin/env bash

# ============================================
# Interactive Piping Tutorial
# ============================================
# Learn to chain commands with pipes

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  Piping Basics - Chain Commands${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Exercise 1: Count and Sort${NC}"
echo "Task: Count how many ERROR lines exist and sort the output"
echo ""
echo -e "${GREEN}Command:${NC} grep \"ERROR\" data/logs/application.log | wc -l"
echo ""
read -p "Press Enter to see the result..."
grep "ERROR" data/logs/application.log | wc -l
echo ""
echo -e "${GREEN}✓ Complete!${NC} Pipe sends grep output to wc"
echo ""

# Exercise 2
echo -e "${YELLOW}Exercise 2: Extract and Sort Unique Values${NC}"
echo "Task: Get unique IP addresses from web access log"
echo ""
echo -e "${GREEN}Command:${NC} awk '{print \$1}' data/logs/web-access.log | sort -u"
echo ""
read -p "Press Enter to see the result..."
echo ""
awk '{print $1}' data/logs/web-access.log | sort -u
echo ""
echo -e "${GREEN}✓ Complete!${NC} Multi-stage pipeline: extract → sort → unique"
echo ""

# Exercise 3
echo -e "${YELLOW}Exercise 3: Filter and Count${NC}"
echo "Task: Count how many INFO lines DON'T contain DEBUG"
echo ""
echo -e "${GREEN}Command:${NC} grep \"INFO\" data/logs/application.log | grep -v \"DEBUG\" | wc -l"
echo ""
read -p "Press Enter to see the result..."
RESULT=$(grep "INFO" data/logs/application.log | grep -v "DEBUG" | wc -l)
echo -e "${GREEN}Result:${NC} $RESULT lines"
echo ""
echo -e "${GREEN}✓ Complete!${NC} Multiple filters in pipeline"
echo ""

# Exercise 4
echo -e "${YELLOW}Exercise 4: Top 5 Pattern${NC}"
echo "Task: Find the top 5 most common HTTP status codes"
echo ""
echo -e "${GREEN}Command:${NC} awk '{print \$9}' data/logs/web-access.log | sort | uniq -c | sort -nr | head -5"
echo ""
read -p "Press Enter to see the result..."
echo ""
awk '{print $9}' data/logs/web-access.log | sort | uniq -c | sort -nr | head -5
echo ""
echo -e "${GREEN}✓ Complete!${NC} Classic top-N pattern!"
echo ""

# Exercise 5
echo -e "${YELLOW}Exercise 5: CSV Column Extraction${NC}"
echo "Task: Extract just the Name column from accounts.csv"
echo ""
echo -e "${GREEN}Command:${NC} cut -d',' -f2 data/csv/accounts.csv | head -10"
echo ""
read -p "Press Enter to see the result..."
echo ""
cut -d',' -f2 data/csv/accounts.csv | head -10
echo ""
echo -e "${GREEN}✓ Complete!${NC} Column extraction with cut"
echo ""

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}  Tutorial Complete! 🎉${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "What you learned:"
echo "  • Basic piping with |"
echo "  • Chaining multiple commands"
echo "  • Common patterns: filter → sort → count"
echo "  • Top-N pattern with uniq -c"
echo "  • Column extraction from CSV"
echo ""
echo "Next: Try 03-json-processing.sh"
echo ""
