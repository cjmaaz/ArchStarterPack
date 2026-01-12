#!/usr/bin/env bash

# ============================================
# udevadm Practice - 10 Interactive Exercises
# ============================================
# Master device management and udev rules

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

# Source the practice engine
source "../practice/practice-engine.sh"

COMMAND="udevadm"
TOTAL_EXERCISES=10

# Initialize practice session
init_practice "$COMMAND" "$TOTAL_EXERCISES"

# ============================================
# BEGINNER EXERCISES (1-4)
# ============================================

# Exercise 1: Extract Vendor ID
run_exercise 1 \
    "Extract the ID_VENDOR_ID from the udev info file" \
    "data/text/udev-info.txt" \
    "04d8" \
    "04d8" \
    "contains" \
    "Use grep to find the line with ID_VENDOR_ID=" \
    "grep \"ID_VENDOR_ID=\" data/text/udev-info.txt | head -1 | cut -d= -f2" \
    "We use cut to extract the value after the equals sign."

# Exercise 2: Find Subsystem
run_exercise 2 \
    "Find the SUBSYSTEM of the device 'eth0'" \
    "data/text/udev-info.txt" \
    "net" \
    "net" \
    "contains" \
    "Look at the entry for eth0 and find SUBSYSTEM" \
    "grep -A 5 \"N: eth0\" data/text/udev-info.txt | grep \"SUBSYSTEM=\"" \
    "The SUBSYSTEM key defines the device type."

# Exercise 3: Reload Command
run_exercise 3 \
    "What command reloads udev rules?" \
    "No file needed" \
    "udevadm control --reload-rules" \
    "udevadm control --reload-rules" \
    "exact" \
    "It's a subcommand of udevadm control" \
    "udevadm control --reload-rules" \
    "This tells the running daemon to reload config files."

# Exercise 4: Trigger Command
run_exercise 4 \
    "What command manually triggers udev events?" \
    "No file needed" \
    "udevadm trigger" \
    "udevadm trigger" \
    "exact" \
    "It's the 'trigger' subcommand" \
    "udevadm trigger" \
    "Useful for applying new rules to already plugged-in devices."

# ============================================
# INTERMEDIATE EXERCISES (5-8)
# ============================================

# Exercise 5: Match Key Syntax
run_exercise 5 \
    "Construct a rule part to match Vendor ID '04d8'. Use standard syntax." \
    "No file needed" \
    "ATTRS{idVendor}==\"04d8\"" \
    "ATTRS{idVendor}==\"04d8\"" \
    "exact" \
    "Use ATTRS{idVendor} and double equals" \
    "ATTRS{idVendor}==\"04d8\"" \
    "Match keys use ==, assignment keys use =."

# Exercise 6: User Access Tag
run_exercise 6 \
    "What TAG assignment gives the current console user access to a device?" \
    "No file needed" \
    "TAG+=\"uaccess\"" \
    "TAG+=\"uaccess\"" \
    "exact" \
    "It involves 'uaccess'" \
    "TAG+=\"uaccess\"" \
    "This relies on systemd-logind/ConsoleKit."

# Exercise 7: Permissions Mode
run_exercise 7 \
    "What rule key sets device permissions to world-readable/writable?" \
    "No file needed" \
    "MODE=\"0666\"" \
    "MODE=\"0666\"" \
    "exact" \
    "The key is MODE" \
    "MODE=\"0666\"" \
    "0666 allows read/write for everyone."

# Exercise 8: Find Device Path
run_exercise 8 \
    "Extract the DEVPATH for hidraw3 from the sample data" \
    "data/text/udev-info.txt" \
    "/devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/0003:04D8:EB2D.0003/hidraw/hidraw3" \
    "Full path starting with /devices..." \
    "contains" \
    "Look for E: DEVPATH=" \
    "grep \"DEVPATH=\" data/text/udev-info.txt | head -1 | cut -d= -f2" \
    "DEVPATH is the unique kernel path."

# ============================================
# ADVANCED EXERCISES (9-10)
# ============================================

# Exercise 9: Full Rule Construction
run_exercise 9 \
    "Write a rule to match SUBSYSTEM hidraw and Vendor 1234, setting Mode 0660" \
    "No file needed" \
    "SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"1234\", MODE=\"0660\"" \
    "SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"1234\", MODE=\"0660\"" \
    "exact" \
    "Combine SUBSYSTEM, ATTRS, and MODE with commas" \
    "SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"1234\", MODE=\"0660\"" \
    "Order typically doesn't matter, but this is the standard format."

# Exercise 10: Monitor Command
run_exercise 10 \
    "What command watches for udev events in real-time?" \
    "No file needed" \
    "udevadm monitor" \
    "udevadm monitor" \
    "exact" \
    "The subcommand is 'monitor'" \
    "udevadm monitor" \
    "Add --property or --kernel for more detail."

# Finish practice session
finish_practice
