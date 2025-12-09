#!/usr/bin/env bash

# ============================================
# Interactive File Operations Tutorial
# ============================================
# Learn cat, head, tail, wc

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  File Operations Tutorial${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Exercise 1: View First Lines${NC}"
echo "Task: View the first 5 lines of accounts.csv"
echo ""
echo -e "${GREEN}Command:${NC} head -5 data/csv/accounts.csv"
echo ""
read -p "Press Enter to see the result..."
echo ""
head -5 data/csv/accounts.csv
echo ""
echo -e "${GREEN}✓ Complete!${NC} head shows beginning of file"
echo ""

# Exercise 2
echo -e "${YELLOW}Exercise 2: View Last Lines${NC}"
echo "Task: View the last 5 lines of application log"
echo ""
echo -e "${GREEN}Command:${NC} tail -5 data/logs/application.log"
echo ""
read -p "Press Enter to see the result..."
echo ""
tail -5 data/logs/application.log
echo ""
echo -e "${GREEN}✓ Complete!${NC} tail shows end of file"
echo ""

# Exercise 3
echo -e "${YELLOW}Exercise 3: Count Lines, Words, Characters${NC}"
echo "Task: Get statistics for urls.txt"
echo ""
echo -e "${GREEN}Command:${NC} wc data/text/urls.txt"
echo ""
read -p "Press Enter to see the result..."
echo ""
wc data/text/urls.txt
echo ""
echo "Output format: lines  words  characters  filename"
echo -e "${GREEN}✓ Complete!${NC} wc provides file statistics"
echo ""

# Exercise 4
echo -e "${YELLOW}Exercise 4: Count Lines Only${NC}"
echo "Task: Count total lines in application.log"
echo ""
echo -e "${GREEN}Command:${NC} wc -l data/logs/application.log"
echo ""
read -p "Press Enter to see the result..."
echo ""
wc -l data/logs/application.log
echo ""
echo -e "${GREEN}✓ Complete!${NC} -l flag for lines only"
echo ""

# Exercise 5
echo -e "${YELLOW}Exercise 5: View File with Line Numbers${NC}"
echo "Task: View emails.txt with line numbers"
echo ""
echo -e "${GREEN}Command:${NC} cat -n data/text/emails.txt | head -10"
echo ""
read -p "Press Enter to see the result..."
echo ""
cat -n data/text/emails.txt | head -10
echo ""
echo -e "${GREEN}✓ Complete!${NC} cat -n adds line numbers"
echo ""

# Exercise 6
echo -e "${YELLOW}Exercise 6: Combine Multiple Files${NC}"
echo "Task: Display all CSV files together"
echo ""
echo -e "${GREEN}Command:${NC} cat data/csv/*.csv | head -15"
echo ""
read -p "Press Enter to see the result..."
echo ""
cat data/csv/*.csv | head -15
echo ""
echo -e "${GREEN}✓ Complete!${NC} cat can combine files"
echo ""

# Exercise 7
echo -e "${YELLOW}Exercise 7: Skip Header and View Data${NC}"
echo "Task: Show accounts without the CSV header"
echo ""
echo -e "${GREEN}Command:${NC} tail -n +2 data/csv/accounts.csv | head -5"
echo ""
read -p "Press Enter to see the result..."
echo ""
tail -n +2 data/csv/accounts.csv | head -5
echo ""
echo -e "${GREEN}✓ Complete!${NC} tail -n +2 skips first line"
echo ""

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}  Tutorial Complete! 🎉${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "What you learned:"
echo "  • head - view beginning of files"
echo "  • tail - view end of files"
echo "  • wc - count lines, words, chars"
echo "  • cat - view and combine files"
echo "  • Line numbering with cat -n"
echo "  • Skipping headers with tail -n +2"
echo ""
echo "Practice more:"
echo "  • Try: tail -f helpers/slow-process.sh & (then kill it)"
echo "  • Try: wc -l data/logs/*.log"
echo "  • Try: head -20 data/csv/sales-data.csv"
echo ""
