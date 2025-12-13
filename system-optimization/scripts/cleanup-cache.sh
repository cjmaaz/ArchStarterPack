#!/bin/bash

# Cache Cleanup Script
# Cleans package manager caches and temporary files

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

echo -e "${BLUE}=== Cache Cleanup ===${NC}\n"

# Check if running as root (for pacman cache)
NEED_ROOT=false
if [ -d "/var/cache/pacman/pkg" ]; then
    NEED_ROOT=true
fi

if [ "$NEED_ROOT" = true ] && [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root (use sudo) for pacman cache cleanup${NC}"
    exit 1
fi

# Function to get directory size
get_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1 || echo "0"
    else
        echo "N/A"
    fi
}

# Show cache sizes before cleanup
echo -e "${GREEN}Before cleanup:${NC}"
PACMAN_BEFORE=$(get_size "/var/cache/pacman/pkg")
PARU_BEFORE=$(get_size "$HOME/.cache/paru")
FLATPAK_BEFORE=$(get_size "$HOME/.var/app")
JOURNAL_BEFORE=$(journalctl --disk-usage 2>/dev/null | awk '{print $7}' || echo "N/A")

echo "  Pacman cache: ${PACMAN_BEFORE}"
echo "  Paru cache: ${PARU_BEFORE}"
echo "  Flatpak cache: ${FLATPAK_BEFORE}"
echo "  Journal logs: ${JOURNAL_BEFORE}"
echo ""

# Clean pacman cache
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}Cleaning pacman cache...${NC}"
    if command -v pacman &> /dev/null; then
        pacman -Sc --noconfirm 2>/dev/null || echo "  No pacman cache to clean"
        echo "  ✓ Pacman cache cleaned"
    fi
else
    echo -e "${YELLOW}DRY-RUN: Would clean pacman cache${NC}"
fi

# Clean paru cache
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}Cleaning paru cache...${NC}"
    if command -v paru &> /dev/null; then
        paru -Sc 2>/dev/null || echo "  No paru cache to clean"
        echo "  ✓ Paru cache cleaned"
    elif [ -d "$HOME/.cache/paru" ]; then
        rm -rf "$HOME/.cache/paru/build"/* 2>/dev/null || true
        echo "  ✓ Paru build cache cleaned"
    fi
else
    echo -e "${YELLOW}DRY-RUN: Would clean paru cache${NC}"
fi

# Clean Flatpak unused runtimes
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}Removing unused Flatpak runtimes...${NC}"
    if command -v flatpak &> /dev/null; then
        UNUSED=$(flatpak uninstall --unused --noninteractive 2>/dev/null || true)
        if [ -n "$UNUSED" ]; then
            echo "  ✓ Unused Flatpak runtimes removed"
        else
            echo "  No unused runtimes found"
        fi
    fi
else
    echo -e "${YELLOW}DRY-RUN: Would remove unused Flatpak runtimes${NC}"
fi

# Clean journal logs
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}Rotating journal logs...${NC}"
    if command -v journalctl &> /dev/null; then
        journalctl --vacuum-time=7d --quiet 2>/dev/null || true
        echo "  ✓ Journal logs rotated (kept last 7 days)"
    fi
else
    echo -e "${YELLOW}DRY-RUN: Would rotate journal logs${NC}"
fi

# Clean temporary files
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}Cleaning temporary files...${NC}"
    if [ -w "/tmp" ]; then
        rm -rf /tmp/* /tmp/.* 2>/dev/null || true
        echo "  ✓ Temporary files cleaned"
    fi
else
    echo -e "${YELLOW}DRY-RUN: Would clean temporary files${NC}"
fi

echo ""

# Show cache sizes after cleanup
if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}After cleanup:${NC}"
    PACMAN_AFTER=$(get_size "/var/cache/pacman/pkg")
    PARU_AFTER=$(get_size "$HOME/.cache/paru")
    FLATPAK_AFTER=$(get_size "$HOME/.var/app")
    JOURNAL_AFTER=$(journalctl --disk-usage 2>/dev/null | awk '{print $7}' || echo "N/A")

    echo "  Pacman cache: ${PACMAN_AFTER}"
    echo "  Paru cache: ${PARU_AFTER}"
    echo "  Flatpak cache: ${FLATPAK_AFTER}"
    echo "  Journal logs: ${JOURNAL_AFTER}"
    echo ""
    echo -e "${GREEN}Cache cleanup complete!${NC}"
else
    echo -e "${YELLOW}DRY-RUN: No changes made${NC}"
fi

echo ""
echo -e "${BLUE}=== Cleanup Complete ===${NC}"
