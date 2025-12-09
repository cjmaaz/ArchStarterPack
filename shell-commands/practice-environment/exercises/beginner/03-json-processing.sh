#!/usr/bin/env bash

# ============================================
# Interactive jq Tutorial (JSON Processing)
# ============================================
# Learn to parse JSON with jq

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠️  jq is not installed${NC}"
    echo "Install it first:"
    echo "  Arch Linux: sudo pacman -S jq"
    echo "  macOS: brew install jq"
    echo "  Ubuntu: sudo apt install jq"
    exit 1
fi

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  JSON Processing with jq${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Exercise 1: Extract Total Records${NC}"
echo "Task: Get the total number of records from SF query result"
echo ""
echo -e "${GREEN}Command:${NC} jq '.result.totalSize' data/json/sf-query-result.json"
echo ""
read -p "Press Enter to see the result..."
jq '.result.totalSize' data/json/sf-query-result.json
echo ""
echo -e "${GREEN}✓ Complete!${NC} Basic field access"
echo ""

# Exercise 2
echo -e "${YELLOW}Exercise 2: Extract Array of Names${NC}"
echo "Task: Get all account names"
echo ""
echo -e "${GREEN}Command:${NC} jq -r '.result.records[].Name' data/json/sf-query-result.json"
echo ""
read -p "Press Enter to see the result..."
echo ""
jq -r '.result.records[].Name' data/json/sf-query-result.json
echo ""
echo -e "${GREEN}✓ Complete!${NC} Array iteration with []"
echo ""

# Exercise 3
echo -e "${YELLOW}Exercise 3: Filter by Field Value${NC}"
echo "Task: Get accounts where Industry is 'Technology'"
echo ""
echo -e "${GREEN}Command:${NC} jq '.result.records[] | select(.Industry == \"Technology\")' data/json/sf-query-result.json"
echo ""
read -p "Press Enter to see the result..."
echo ""
jq '.result.records[] | select(.Industry == "Technology")' data/json/sf-query-result.json
echo ""
echo -e "${GREEN}✓ Complete!${NC} Filtering with select()"
echo ""

# Exercise 4
echo -e "${YELLOW}Exercise 4: Format Output${NC}"
echo "Task: Create formatted output: 'Name: Revenue'"
echo ""
echo -e "${GREEN}Command:${NC} jq -r '.result.records[] | \"\\(.Name): $\\(.AnnualRevenue)\"' data/json/sf-query-result.json"
echo ""
read -p "Press Enter to see the result..."
echo ""
jq -r '.result.records[] | "\(.Name): $\(.AnnualRevenue)"' data/json/sf-query-result.json | head -5
echo ""
echo -e "${GREEN}✓ Complete!${NC} String interpolation"
echo ""

# Exercise 5
echo -e "${YELLOW}Exercise 5: Count Active Users${NC}"
echo "Task: Count how many users are active in API response"
echo ""
echo -e "${GREEN}Command:${NC} jq '[.data.users[] | select(.active == true)] | length' data/json/api-response.json"
echo ""
read -p "Press Enter to see the result..."
jq '[.data.users[] | select(.active == true)] | length' data/json/api-response.json
echo ""
echo -e "${GREEN}✓ Complete!${NC} Filtering and counting"
echo ""

# Exercise 6
echo -e "${YELLOW}Exercise 6: Extract Nested Fields${NC}"
echo "Task: Get all user emails from nested structure"
echo ""
echo -e "${GREEN}Command:${NC} jq -r '.data.users[].email' data/json/api-response.json"
echo ""
read -p "Press Enter to see the result..."
echo ""
jq -r '.data.users[].email' data/json/api-response.json
echo ""
echo -e "${GREEN}✓ Complete!${NC} Accessing nested data"
echo ""

echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}  Tutorial Complete! 🎉${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""
echo "What you learned:"
echo "  • Basic jq field access"
echo "  • Array iteration with []"
echo "  • Filtering with select()"
echo "  • String formatting"
echo "  • Counting results"
echo "  • Nested field access"
echo ""
echo "Next: Try 04-file-operations.sh"
echo ""
