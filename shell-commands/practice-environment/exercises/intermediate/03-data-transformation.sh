#!/usr/bin/env bash

# ============================================
# Data Transformation Tutorial
# ============================================
# Transform and reformat data between formats

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

if ! command -v jq &> /dev/null; then
    echo "This tutorial requires jq."
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Data Transformation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Exercise 1
echo -e "${YELLOW}Challenge 1: CSV to JSON${NC}"
echo "Task: Convert first 3 accounts to JSON format"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
tail -n +2 data/csv/accounts.csv | head -3 | awk -F',' '
{
  printf "{\n"
  printf "  \"Id\": \"%s\",\n", $1
  printf "  \"Name\": \"%s\",\n", $2
  printf "  \"Industry\": \"%s\",\n", $3
  printf "  \"AnnualRevenue\": %s\n", $4
  printf "},\n"
}'
EOF
echo ""
tail -n +2 data/csv/accounts.csv | head -3 | awk -F',' '{
  printf "{\n"
  printf "  \"Id\": \"%s\",\n", $1
  printf "  \"Name\": \"%s\",\n", $2
  printf "  \"Industry\": \"%s\",\n", $3
  printf "  \"AnnualRevenue\": %s\n", $4
  printf "},\n"
}'
echo ""
echo -e "${GREEN}✓ CSV → JSON Conversion!${NC}"
echo ""

# Exercise 2
echo -e "${YELLOW}Challenge 2: JSON to CSV${NC}"
echo "Task: Convert JSON users to CSV format"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "jq -r '.data.users[] | [.id, .name, .email, .active] | @csv' data/json/api-response.json"
echo ""
echo "Output:"
jq -r '.data.users[] | [.id, .name, .email, .active] | @csv' data/json/api-response.json
echo ""
echo -e "${GREEN}✓ JSON → CSV Conversion!${NC}"
echo ""

# Exercise 3
echo -e "${YELLOW}Challenge 3: Extract and Transform URLs${NC}"
echo "Task: Convert URLs to just domain names"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "cat data/text/urls.txt | sed -E 's|https?://([^/]+).*|\\1|'"
echo ""
cat data/text/urls.txt | sed -E 's|https?://([^/]+).*|\1|'
echo ""
echo -e "${GREEN}✓ URLs Transformed!${NC}"
echo ""

# Exercise 4
echo -e "${YELLOW}Challenge 4: Uppercase Transformation${NC}"
echo "Task: Convert all email addresses to uppercase"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "cat data/text/emails.txt | tr '[:lower:]' '[:upper:]' | head -5"
echo ""
cat data/text/emails.txt | tr '[:lower:]' '[:upper:]' | head -5
echo ""
echo -e "${GREEN}✓ Case Transformed!${NC}"
echo ""

# Exercise 5
echo -e "${YELLOW}Challenge 5: Date Reformatting${NC}"
echo "Task: Extract and reformat dates from log"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "grep 'INFO' data/logs/application.log | awk '{print \$1, \$2}' | head -5"
echo ""
grep 'INFO' data/logs/application.log | awk '{print $1, $2}' | head -5
echo ""
echo -e "${GREEN}✓ Dates Extracted!${NC}"
echo ""

# Exercise 6
echo -e "${YELLOW}Challenge 6: Create Markdown Table${NC}"
echo "Task: Convert CSV to Markdown table format"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
cat << 'EOF'
head -5 data/csv/accounts.csv | awk -F',' '
NR==1 {
  print "| " $2 " | " $3 " | " $4 " |"
  print "|---|---|---|"
  next
}
{
  print "| " $2 " | " $3 " | " $4 " |"
}'
EOF
echo ""
head -5 data/csv/accounts.csv | awk -F',' '
NR==1 {
  print "| " $2 " | " $3 " | " $4 " |"
  print "|---|---|---|"
  next
}
{
  print "| " $2 " | " $3 " | " $4 " |"
}'
echo ""
echo -e "${GREEN}✓ Markdown Table Created!${NC}"
echo ""

# Exercise 7
echo -e "${YELLOW}Challenge 7: Remove Duplicates and Sort${NC}"
echo "Task: Clean up and sort email list"
echo ""
read -p "Press Enter to see solution..."
echo ""
echo -e "${GREEN}Solution:${NC}"
echo "sort data/text/emails.txt | uniq | head -10"
echo ""
sort data/text/emails.txt | uniq | head -10
echo ""
echo -e "${GREEN}✓ Data Cleaned!${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Transformation Complete! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "What you practiced:"
echo "  • CSV to JSON conversion"
echo "  • JSON to CSV with jq"
echo "  • URL parsing and transformation"
echo "  • Case transformation with tr"
echo "  • Date extraction and formatting"
echo "  • Creating formatted tables"
echo "  • Data deduplication"
echo ""
echo "These skills are essential for:"
echo "  • Data migration"
echo "  • API integration"
echo "  • Report generation"
echo "  • Data cleanup"
echo ""
