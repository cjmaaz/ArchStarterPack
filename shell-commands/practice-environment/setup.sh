#!/usr/bin/env bash

# ============================================
# Shell Commands Practice Environment Setup
# ============================================
# Last Updated: December 2025
# Purpose: One-command setup for practice environment
# Usage: ./setup.sh

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Shell Commands Practice Environment${NC}"
echo -e "${BLUE}  Setup Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if setup already run
if [ -f ".setup_complete" ]; then
    echo -e "${YELLOW}⚠️  Environment already set up!${NC}"
    echo -e "${YELLOW}   Run ./reset.sh to start fresh${NC}"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

echo -e "${GREEN}✓${NC} Verifying directory structure..."
# Directories should already exist from git, but verify
required_dirs=(
    "data/logs"
    "data/json"
    "data/csv"
    "data/text"
    "data/xml"
    "data/archives"
    "generators"
    "helpers"
    "exercises/beginner/solutions"
    "exercises/intermediate/solutions"
    "exercises/advanced/solutions"
    "exercises/expert/solutions"
    "scenarios/deployment-failure"
    "scenarios/log-investigation"
    "scenarios/data-migration"
    "scenarios/performance-tuning"
)

for dir in "${required_dirs[@]}"; do
    mkdir -p "$dir"
done

echo -e "${GREEN}✓${NC} Directory structure verified"
echo ""

echo -e "${GREEN}✓${NC} Generating sample data files..."
# Run all generator scripts if they exist
if [ -f "generators/generate-all.sh" ]; then
    bash generators/generate-all.sh
else
    echo -e "${YELLOW}   Generator scripts not yet available${NC}"
    echo -e "${YELLOW}   Sample data will be loaded from git${NC}"
fi

echo ""
echo -e "${GREEN}✓${NC} Setting executable permissions..."
# Make all scripts executable
find generators -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
find helpers -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
find exercises -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true
chmod +x reset.sh 2>/dev/null || true

echo -e "${GREEN}✓${NC} Permissions set"
echo ""

# Mark setup as complete
touch .setup_complete
echo "$(date)" > .setup_complete

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}📚 Getting Started:${NC}"
echo ""
echo "1. Explore sample data:"
echo "   ${GREEN}ls -la data/logs/${NC}     # Application and web logs"
echo "   ${GREEN}ls -la data/json/${NC}     # JSON data files"
echo "   ${GREEN}ls -la data/csv/${NC}      # CSV datasets"
echo ""
echo "2. Try basic commands:"
echo "   ${GREEN}grep \"ERROR\" data/logs/application.log${NC}"
echo "   ${GREEN}cat data/csv/accounts.csv | head -10${NC}"
echo "   ${GREEN}jq '.result.records[]' data/json/sf-query-result.json${NC}"
echo ""
echo "3. Practice exercises:"
echo "   ${GREEN}cd exercises/beginner${NC}"
echo "   ${GREEN}cat 01-grep-basics.sh${NC}"
echo ""
echo "4. Read the README:"
echo "   ${GREEN}cat README.md${NC}"
echo ""
echo -e "${YELLOW}💡 Tip: Start with beginner exercises and work your way up!${NC}"
echo ""
echo "To reset the environment:"
echo "   ${GREEN}./reset.sh${NC}"
echo ""
