#!/bin/bash

# Package Cleanup Script
# Safely removes orphaned and unused packages

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN=false

# Parse arguments
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}Running in DRY-RUN mode (no changes will be made)${NC}\n"
fi

echo -e "${BLUE}=== Package Cleanup ===${NC}\n"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
    exit 1
fi

# Backup package list
BACKUP_DIR="$HOME/package-backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/packages-$(date +%Y%m%d-%H%M%S).txt"

echo -e "${GREEN}Creating package list backup...${NC}"
pacman -Qqe > "$BACKUP_FILE" 2>/dev/null || true
echo "  Backup saved to: $BACKUP_FILE"
echo ""

# Find orphaned packages
echo -e "${GREEN}Finding orphaned packages...${NC}"
ORPHANED=$(pacman -Qdtq 2>/dev/null || true)

if [ -z "$ORPHANED" ]; then
    echo -e "  ${GREEN}No orphaned packages found${NC}\n"
    exit 0
fi

ORPHANED_COUNT=$(echo "$ORPHANED" | wc -l)
echo "  Found ${ORPHANED_COUNT} orphaned package(s):"
echo ""

# List packages with sizes
TOTAL_SIZE=0
while IFS= read -r pkg; do
    if [ -n "$pkg" ]; then
        SIZE=$(pacman -Qi "$pkg" 2>/dev/null | grep "Installed Size" | awk '{print $4$5}' || echo "0")
        echo "  - $pkg ($SIZE)"
        # Extract numeric size (rough estimate)
        NUM_SIZE=$(echo "$SIZE" | grep -oE '[0-9.]+' | head -1 || echo "0")
        TOTAL_SIZE=$((TOTAL_SIZE + NUM_SIZE))
    fi
done <<< "$ORPHANED"

echo ""
echo "  Total packages: ${ORPHANED_COUNT}"
echo ""

# Confirmation
if [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}Remove these packages? [y/N]: ${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled${NC}"
        exit 0
    fi
    echo ""

    # Remove packages
    echo -e "${GREEN}Removing packages...${NC}"
    echo "$ORPHANED" | xargs -r pacman -Rns --noconfirm 2>/dev/null || {
        echo -e "${RED}Error removing some packages${NC}"
        echo "Check the list and remove manually if needed"
        exit 1
    }

    echo -e "${GREEN}✓ Packages removed successfully${NC}"
else
    echo -e "${YELLOW}DRY-RUN: Would remove ${ORPHANED_COUNT} package(s)${NC}"
fi

echo ""
echo -e "${BLUE}=== Cleanup Complete ===${NC}"
