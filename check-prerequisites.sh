#!/usr/bin/env bash

# ============================================
# ArchStarterPack Prerequisites Checker
# ============================================
# Last Updated: November 2025
# Purpose: Validate system compatibility before applying configurations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS=0
WARN=0
FAIL=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  ArchStarterPack Prerequisites Checker${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to check and report
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

# Check 1: Operating System
echo -e "\n${BLUE}[1] Checking Operating System...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
        check_pass "Running Arch-based distribution: $NAME"
    else
        check_warn "Not running Arch-based distribution: $NAME (some configurations may need adaptation)"
    fi
else
    check_fail "Cannot determine OS distribution"
fi

# Check 2: Package Manager
echo -e "\n${BLUE}[2] Checking Package Manager...${NC}"
if command -v pacman &> /dev/null; then
    check_pass "pacman package manager found"
else
    check_fail "pacman not found - this project is designed for Arch-based systems"
fi

# Check 3: Shell Environment
echo -e "\n${BLUE}[3] Checking Shell Environment...${NC}"
if command -v bash &> /dev/null; then
    check_pass "bash shell available"
fi
if command -v fish &> /dev/null; then
    check_pass "fish shell available (required for Node.js setup module)"
else
    check_warn "fish shell not found (install if using Node.js setup: sudo pacman -S fish)"
fi

# Check 4: Root/Sudo Access
echo -e "\n${BLUE}[4] Checking Privileges...${NC}"
if sudo -n true 2>/dev/null; then
    check_pass "Passwordless sudo configured"
elif sudo -v &>/dev/null; then
    check_pass "sudo access available"
else
    check_fail "sudo access required for system configuration"
fi

# Check 5: Essential Tools
echo -e "\n${BLUE}[5] Checking Essential Tools...${NC}"
essential_tools=("git" "nano" "systemctl" "grep" "sed")
for tool in "${essential_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        check_pass "$tool found"
    else
        check_fail "$tool not found"
    fi
done

# Check 6: Hardware Detection Tools
echo -e "\n${BLUE}[6] Checking Hardware Detection Tools...${NC}"
hw_tools=("lspci" "lsusb" "lsmod" "sensors" "dmidecode")
for tool in "${hw_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        check_pass "$tool available"
    else
        check_warn "$tool not installed (recommended: install pciutils, usbutils, lm_sensors, dmidecode)"
    fi
done

# Check 7: Module-Specific Prerequisites
echo -e "\n${BLUE}[7] Checking Module-Specific Prerequisites...${NC}"

# CachyOS Module
if [ -d "$SCRIPT_DIR/cachy_os_config" ]; then
    echo -e "${BLUE}  CachyOS Configuration Module:${NC}"
    cachy_tools=("tlp" "thermald" "cpupower" "nvidia-smi")
    for tool in "${cachy_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            check_pass "  $tool installed"
        else
            check_warn "  $tool not installed (install before applying CachyOS configs)"
        fi
    done
fi

# LogiOps Module
if [ -d "$SCRIPT_DIR/logiops" ]; then
    echo -e "${BLUE}  LogiOps Module:${NC}"
    logiops_tools=("cmake" "make" "gcc" "g++")
    for tool in "${logiops_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            check_pass "  $tool available"
        else
            check_warn "  $tool not installed (required for building LogiOps: sudo pacman -S base-devel cmake)"
        fi
    done
fi

# Node.js Module
if [ -d "$SCRIPT_DIR/node_started" ]; then
    echo -e "${BLUE}  Node.js Setup Module:${NC}"
    if command -v fish &> /dev/null; then
        check_pass "  fish shell installed"
    else
        check_warn "  fish shell not installed (required: sudo pacman -S fish)"
    fi
    if [ -f /usr/share/nvm/init-nvm.sh ]; then
        check_pass "  nvm installed via pacman"
    else
        check_warn "  nvm not installed (install: sudo pacman -S nvm)"
    fi
fi

# Brother Printer Module
if [ -d "$SCRIPT_DIR/brother_dcp-t820dw" ]; then
    echo -e "${BLUE}  Brother Printer Setup Module:${NC}"
    printer_tools=("cups" "avahi-daemon")
    for tool in "${printer_tools[@]}"; do
        if command -v "$tool" &> /dev/null || systemctl list-unit-files | grep -q "$tool"; then
            check_pass "  $tool available"
        else
            check_warn "  $tool not installed (install: sudo pacman -S cups avahi)"
        fi
    done
fi

# Check 8: Hardware Compatibility (if on ASUS X507UF)
echo -e "\n${BLUE}[8] Checking Hardware Compatibility...${NC}"
if command -v dmidecode &> /dev/null; then
    system_model=$(sudo dmidecode -s system-product-name 2>/dev/null || echo "Unknown")
    if [[ "$system_model" == *"X507"* ]]; then
        check_pass "Running on ASUS X507 series - fully compatible"
    else
        check_warn "Running on: $system_model (configurations optimized for ASUS X507UF, may need adaptation)"
    fi
else
    check_warn "Cannot detect system model (dmidecode not available)"
fi

# Check 9: Disk Space
echo -e "\n${BLUE}[9] Checking Disk Space...${NC}"
available_space=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$available_space" -gt 5 ]; then
    check_pass "Sufficient disk space: ${available_space}GB available"
elif [ "$available_space" -gt 2 ]; then
    check_warn "Limited disk space: ${available_space}GB available"
else
    check_fail "Insufficient disk space: ${available_space}GB available (need at least 2GB)"
fi

# Check 10: Backup Tools
echo -e "\n${BLUE}[10] Checking Backup Capabilities...${NC}"
if command -v cp &> /dev/null && command -v rsync &> /dev/null; then
    check_pass "Backup tools available (cp, rsync)"
elif command -v cp &> /dev/null; then
    check_pass "Basic backup tool available (cp)"
    check_warn "rsync not installed (optional, but recommended for backups)"
fi

# Summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}  Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Passed:${NC} $PASS"
echo -e "${YELLOW}⚠ Warnings:${NC} $WARN"
echo -e "${RED}✗ Failed:${NC} $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}System is ready for ArchStarterPack configuration!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Review the README.md for module descriptions"
    echo "2. Choose the configuration module you want to apply"
    echo "3. Read the module's documentation thoroughly"
    echo "4. Create backups before making changes"
    echo "5. Follow the instructions step-by-step"
elif [ $FAIL -le 2 ]; then
    echo -e "${YELLOW}System has minor issues. Review failures above before proceeding.${NC}"
    echo ""
    echo "You may proceed with caution, but address the failed checks first."
else
    echo -e "${RED}System has significant issues. Address failures before proceeding.${NC}"
    echo ""
    echo "Install missing dependencies and re-run this script."
fi

if [ $WARN -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Note:${NC} Warnings indicate missing optional tools or potential compatibility issues."
    echo "Review warnings to ensure you have everything needed for your chosen modules."
fi

echo ""
echo "For detailed system diagnostics, run:"
echo "  ./cachy_os_config/diagnostics.sh"
echo ""
