#!/bin/bash

# System Health Check Script
# Checks system health and optimization status without making changes

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== System Health Check ===${NC}\n"

# Disk Usage
echo -e "${GREEN}Disk Usage:${NC}"
df -h / | tail -1 | awk '{printf "  %s: %s used, %s available (%s)\n", $1, $3, $4, $5}'
echo ""

# Memory Usage
echo -e "${GREEN}Memory Usage:${NC}"
free -h | grep -E "^Mem|^Swap" | awk '{printf "  %s: %s / %s (%s used)\n", $1, $3, $2, ($3/$2*100)"%"}'
echo ""

# Cache Sizes
echo -e "${GREEN}Cache Sizes:${NC}"
if [ -d "/var/cache/pacman/pkg" ]; then
    PACMAN_CACHE=$(du -sh /var/cache/pacman/pkg/ 2>/dev/null | cut -f1 || echo "0")
    echo "  Pacman cache: ${PACMAN_CACHE}"
fi

if [ -d "$HOME/.cache/paru" ]; then
    PARU_CACHE=$(du -sh "$HOME/.cache/paru/" 2>/dev/null | cut -f1 || echo "0")
    echo "  Paru cache: ${PARU_CACHE}"
fi

if command -v flatpak &> /dev/null; then
    FLATPAK_CACHE=$(du -sh "$HOME/.var/app/" 2>/dev/null | cut -f1 || echo "0")
    echo "  Flatpak cache: ${FLATPAK_CACHE}"
fi

JOURNAL_SIZE=$(journalctl --disk-usage 2>/dev/null | awk '{print $7}' || echo "N/A")
echo "  Journal logs: ${JOURNAL_SIZE}"
echo ""

# Package Information
echo -e "${GREEN}Packages:${NC}"
if command -v pacman &> /dev/null; then
    ORPHANED=$(pacman -Qdtq 2>/dev/null | wc -l || echo "0")
    echo "  Orphaned packages: ${ORPHANED}"

    OUTDATED=$(pacman -Qu 2>/dev/null | wc -l || echo "0")
    echo "  Outdated packages: ${OUTDATED}"
fi
echo ""

# Boot Time
echo -e "${GREEN}Boot Time:${NC}"
if command -v systemd-analyze &> /dev/null; then
    systemd-analyze 2>/dev/null | head -1 || echo "  Unable to analyze boot time"
else
    echo "  systemd-analyze not available"
fi
echo ""

# Service Status
echo -e "${GREEN}Service Status:${NC}"
if command -v systemctl &> /dev/null; then
    FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l || echo "0")
    if [ "$FAILED" -gt 0 ]; then
        echo -e "  ${RED}Failed services: ${FAILED}${NC}"
        systemctl --failed --no-legend 2>/dev/null | head -5 | awk '{printf "    - %s\n", $1}'
    else
        echo -e "  ${GREEN}No failed services${NC}"
    fi
fi
echo ""

# Warnings
echo -e "${YELLOW}Warnings:${NC}"
WARNINGS=0

# Check disk space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo -e "  ${RED}⚠ Disk usage is above 90%${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# Check memory
MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2*100}')
if [ "$MEM_USAGE" -gt 90 ]; then
    echo -e "  ${RED}⚠ Memory usage is above 90%${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# Check orphaned packages
if [ "${ORPHANED:-0}" -gt 10 ]; then
    echo -e "  ${YELLOW}⚠ More than 10 orphaned packages found${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

if [ "$WARNINGS" -eq 0 ]; then
    echo -e "  ${GREEN}No warnings${NC}"
fi

echo ""
echo -e "${BLUE}=== Health Check Complete ===${NC}"
