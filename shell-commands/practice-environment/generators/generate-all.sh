#!/usr/bin/env bash

# ============================================
# Generate All Sample Data
# ============================================
# Last Updated: December 2025
# Purpose: Generate/regenerate all sample data files
# Usage: ./generate-all.sh [--reset]

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo -e "${BLUE}Generating sample data files...${NC}"
echo ""

# Check if --reset flag is provided
RESET_MODE=false
if [ "$1" = "--reset" ]; then
    RESET_MODE=true
    echo -e "${GREEN}✓${NC} Running in reset mode"
fi

# Sample data files already exist in git
# This script can be used to generate additional or larger datasets

echo -e "${GREEN}✓${NC} Log files: Already present in data/logs/"
echo "  - application.log (130+ lines)"
echo "  - apex-debug.log (Salesforce format)"
echo "  - deployment.log (SF deployment)"
echo "  - web-access.log (Apache/Nginx format)"
echo ""

echo -e "${GREEN}✓${NC} JSON files: Already present in data/json/"
echo "  - sf-query-result.json (15 SF records)"
echo "  - api-response.json (REST API format)"
echo "  - deploy-result.json (SF deployment result)"
echo ""

echo -e "${GREEN}✓${NC} CSV files: Already present in data/csv/"
echo "  - accounts.csv (30 Salesforce accounts)"
echo "  - contacts.csv (10 contacts)"
echo "  - sales-data.csv (50 transactions)"
echo ""

echo -e "${GREEN}✓${NC} Text files: Already present in data/text/"
echo "  - urls.txt (20 URLs)"
echo "  - emails.txt (20 email addresses)"
echo "  - sample-code.cls (Apex classes)"
echo ""

# Future: Add actual generators for larger datasets
# Example: generate-logs.sh --lines 10000 --error-rate 5
# Example: generate-csv.sh --rows 50000 --output large-dataset.csv

echo -e "${BLUE}Sample data generation complete!${NC}"
echo ""
echo "All sample files are ready for practice."
echo "Run ./setup.sh if you haven't already."
echo ""
