#!/usr/bin/env bash

# ============================================
# Interactive grep Tutorial
# ============================================
# Learn grep through hands-on practice with real files

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  grep Basics - Interactive Tutorial${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Exercise 1: Basic Search${NC}"
echo "Find all lines containing 'ERROR' in the application log"
echo ""
echo -e "${GREEN}Command:${NC} grep \"ERROR\" data/logs/application.log | wc -l"
echo ""
read -p "Press Enter to see the result..."
RESULT=$(grep "ERROR" data/logs/application.log | wc -l)
echo -e "${GREEN}Result:${NC} $RESULT lines found"
echo ""

if [ "$RESULT" -eq 47 ]; then
    echo -e "${GREEN}✓ Correct!${NC} Found 47 ERROR lines"
else
    echo -e "${YELLOW}Expected: 47 lines${NC}"
fi
echo ""

# Exercise 2
echo -e "${YELLOW}Exercise 2: Case-Insensitive Search${NC}"
echo "Find 'error' in any case (ERROR, Error, error)"
echo ""
echo -e "${GREEN}Command:${NC} grep -i \"error\" data/logs/application.log | head -3"
echo ""
read -p "Press Enter to see the result..."
echo ""
grep -i "error" data/logs/application.log | head -3
echo ""
echo -e "${GREEN}✓ Complete!${NC} Case-insensitive search works"
echo ""

# Exercise 3
echo -e "${YELLOW}Exercise 3: Count Matches${NC}"
echo "Count how many times 'INFO' appears"
echo ""
echo -e "${GREEN}Command:${NC} grep -c \"INFO\" data/logs/application.log"
echo ""
read -p "Press Enter to see the result..."
INFO_COUNT=$(grep -c "INFO" data/logs/application.log)
echo -e "${GREEN}Result:${NC} $INFO_COUNT lines with INFO"
echo ""

# Exercise 4
echo -e "${YELLOW}Exercise 4: Extract Specific Patterns${NC}"
echo "Extract IP addresses from web access log"
echo ""
echo -e "${GREEN}Command:${NC} grep -oE \"\\b([0-9]{1,3}\\.){3}[0-9]{1,3}\\b\" data/logs/web-access.log | head -5"
echo ""
read -p "Press Enter to see the result..."
echo ""
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" data/logs/web-access.log | head -5
echo ""
echo -e "${GREEN}✓ Complete!${NC} Regex pattern matching works"
echo ""

# Exercise 5
echo -e "${YELLOW}Exercise 5: Context Lines${NC}"
echo "Show ERROR with 2 lines of context"
echo ""
echo -e "${GREEN}Command:${NC} grep -C 2 \"NullPointerException\" data/logs/application.log"
echo ""
read -p "Press Enter to see the result..."
echo ""
grep -C 2 "NullPointerException" data/logs/application.log | head -10
echo ""
echo -e "${GREEN}✓ Complete!${NC} Context lines help understand errors"
echo ""

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}  Tutorial Complete! 🎉${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "What you learned:"
echo "  • Basic grep searching"
echo "  • Case-insensitive matching (-i)"
echo "  • Counting matches (-c)"
echo "  • Regex patterns (-E)"
echo "  • Context lines (-C)"
echo ""
echo "Next steps:"
echo "  • Try more grep commands on sample files"
echo "  • Read: ../02-commands/grep.md"
echo "  • Practice: ../04-practice/beginner.md"
echo ""
