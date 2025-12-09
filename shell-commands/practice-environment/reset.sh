#!/usr/bin/env bash

# ============================================
# Shell Commands Practice Environment Reset
# ============================================
# Last Updated: December 2025
# Purpose: Reset environment to clean state
# Usage: ./reset.sh

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Reset Practice Environment${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}⚠️  This will:${NC}"
echo "  • Remove all temporary practice files"
echo "  • Clear exercise progress"
echo "  • Regenerate sample data"
echo "  • Reset to clean state"
echo ""

read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Reset cancelled."
    exit 0
fi

echo ""
echo -e "${BLUE}Cleaning up...${NC}"

# Remove temporary files created during exercises
echo -e "${GREEN}✓${NC} Removing temporary files..."
find . -name "*.tmp" -type f -delete 2>/dev/null || true
find . -name "*.temp" -type f -delete 2>/dev/null || true
find . -name "output-*.txt" -type f -delete 2>/dev/null || true
find . -name "test-*.log" -type f -delete 2>/dev/null || true

# Remove progress tracking files
echo -e "${GREEN}✓${NC} Clearing progress..."
rm -f .setup_complete
rm -f exercises/*/.progress 2>/dev/null || true
rm -f exercises/*/*/.progress 2>/dev/null || true

# Remove any dynamically generated large files
echo -e "${GREEN}✓${NC} Removing generated files..."
rm -f data/csv/large-dataset-temp.csv 2>/dev/null || true
rm -f data/logs/stress-test*.log 2>/dev/null || true

# Clean up any test directories created by exercises
echo -e "${GREEN}✓${NC} Cleaning test directories..."
rm -rf test-files-* 2>/dev/null || true
rm -rf practice-temp-* 2>/dev/null || true

echo ""
echo -e "${BLUE}Regenerating sample data...${NC}"
# Re-run generators if they exist
if [ -f "generators/generate-all.sh" ]; then
    bash generators/generate-all.sh --reset
else
    echo -e "${YELLOW}   Generator scripts not available${NC}"
    echo -e "${YELLOW}   Using existing sample data${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ Reset Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Environment is now in clean state."
echo ""
echo "Run setup again to initialize:"
echo "   ${GREEN}./setup.sh${NC}"
echo ""
