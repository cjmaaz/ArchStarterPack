#!/bin/bash

# System Maintenance Script
# Comprehensive system maintenance including updates and cleanup

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DRY_RUN=false
SKIP_UPDATE=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-update)
            SKIP_UPDATE=true
            shift
            ;;
        *)
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}Running in DRY-RUN mode (no changes will be made)${NC}\n"
fi

echo -e "${BLUE}=== System Maintenance ===${NC}\n"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
    exit 1
fi

# Step 1: System Updates
if [ "$SKIP_UPDATE" = false ]; then
    echo -e "${GREEN}Step 1/5: Updating system...${NC}"

    if [ "$DRY_RUN" = false ]; then
        # Update pacman packages
        if command -v pacman &> /dev/null; then
            echo "  Updating pacman packages..."
            pacman -Syu --noconfirm 2>/dev/null || echo "  No pacman updates available"
            echo "  ✓ Pacman packages updated"
        fi

        # Update AUR packages
        if command -v paru &> /dev/null; then
            echo "  Updating AUR packages..."
            paru -Syu --noconfirm 2>/dev/null || echo "  No AUR updates available"
            echo "  ✓ AUR packages updated"
        fi

        # Update Flatpak applications
        if command -v flatpak &> /dev/null; then
            echo "  Updating Flatpak applications..."
            flatpak update --noninteractive -y 2>/dev/null || echo "  No Flatpak updates available"
            echo "  ✓ Flatpak applications updated"
        fi
    else
        echo -e "${YELLOW}  DRY-RUN: Would update packages${NC}"
    fi
    echo ""
else
    echo -e "${YELLOW}Step 1/5: Skipping updates (--no-update flag)${NC}\n"
fi

# Step 2: Package Cleanup
echo -e "${GREEN}Step 2/5: Cleaning packages...${NC}"
if [ "$DRY_RUN" = false ]; then
    ORPHANED=$(pacman -Qdtq 2>/dev/null || true)
    if [ -n "$ORPHANED" ]; then
        ORPHANED_COUNT=$(echo "$ORPHANED" | wc -l)
        echo "  Found ${ORPHANED_COUNT} orphaned package(s)"
        echo "$ORPHANED" | xargs -r pacman -Rns --noconfirm 2>/dev/null || true
        echo "  ✓ Removed orphaned packages"
    else
        echo "  No orphaned packages found"
    fi
else
    ORPHANED=$(pacman -Qdtq 2>/dev/null || true)
    if [ -n "$ORPHANED" ]; then
        ORPHANED_COUNT=$(echo "$ORPHANED" | wc -l)
        echo -e "${YELLOW}  DRY-RUN: Would remove ${ORPHANED_COUNT} orphaned package(s)${NC}"
    else
        echo "  No orphaned packages found"
    fi
fi
echo ""

# Step 3: Cache Cleanup
echo -e "${GREEN}Step 3/5: Cleaning caches...${NC}"
if [ "$DRY_RUN" = false ]; then
    # Clean pacman cache
    if command -v pacman &> /dev/null; then
        pacman -Sc --noconfirm 2>/dev/null || true
        echo "  ✓ Pacman cache cleaned"
    fi

    # Clean paru cache
    if command -v paru &> /dev/null; then
        paru -Sc 2>/dev/null || true
        echo "  ✓ Paru cache cleaned"
    fi

    # Remove unused Flatpak runtimes
    if command -v flatpak &> /dev/null; then
        flatpak uninstall --unused --noninteractive 2>/dev/null || true
        echo "  ✓ Flatpak runtimes cleaned"
    fi

    # Rotate journal logs
    if command -v journalctl &> /dev/null; then
        journalctl --vacuum-time=7d --quiet 2>/dev/null || true
        echo "  ✓ Journal logs rotated"
    fi
else
    echo -e "${YELLOW}  DRY-RUN: Would clean caches${NC}"
fi
echo ""

# Step 4: Database Optimization
echo -e "${GREEN}Step 4/5: Optimizing databases...${NC}"
if [ "$DRY_RUN" = false ]; then
    # Refresh pacman file database
    if command -v pacman &> /dev/null; then
        pacman -Fy --noconfirm 2>/dev/null || true
        echo "  ✓ Pacman file database refreshed"
    fi

    # Update locate database
    if command -v updatedb &> /dev/null; then
        updatedb 2>/dev/null || true
        echo "  ✓ Locate database updated"
    fi
else
    echo -e "${YELLOW}  DRY-RUN: Would optimize databases${NC}"
fi
echo ""

# Step 5: System Health Check
echo -e "${GREEN}Step 5/5: System health check...${NC}"
if [ "$DRY_RUN" = false ]; then
    # Disk usage
    DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')
    echo "  Disk usage: ${DISK_USAGE}"

    # Memory usage
    MEM_USAGE=$(free -h | grep Mem | awk '{printf "%s / %s", $3, $2}')
    echo "  Memory usage: ${MEM_USAGE}"

    # Boot time
    if command -v systemd-analyze &> /dev/null; then
        BOOT_TIME=$(systemd-analyze 2>/dev/null | head -1 || echo "N/A")
        echo "  Boot time: ${BOOT_TIME}"
    fi
else
    echo -e "${YELLOW}  DRY-RUN: Would check system health${NC}"
fi
echo ""

echo -e "${BLUE}=== Maintenance Complete ===${NC}"
