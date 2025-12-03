#!/usr/bin/env bash

# ============================================
# Linux Hardware/Kernel Diagnostics Collector
# Safe, read-only, information-gathering tool
# ============================================
# Last Updated: November 2025
# Purpose: Collect system information for troubleshooting

set -e

OUTPUT_FILE="diagnostics_$(date +%Y-%m-%d_%H-%M-%S).log"

log() {
    echo -e "\n\n==================== $1 ====================\n" | tee -a "$OUTPUT_FILE"
}

cmd() {
    echo -e "$ $1" | tee -a "$OUTPUT_FILE"
}

echo "[+] Starting diagnostics..."
echo "[+] Output file: $OUTPUT_FILE"
echo "[!] This script only reads information - no changes will be made"
echo ""
sleep 1

log "System Information (uname -a)"
cmd "uname -a"
uname -a | tee -a "$OUTPUT_FILE"

log "OS Release Information (/etc/os-release)"
cmd "cat /etc/os-release"
cat /etc/os-release | tee -a "$OUTPUT_FILE"

log "Kernel Modules (filtered for hardware/drivers)"
cmd "lsmod | grep -E \"asus|wmi|intel|i915|acpi|therm|fan|nvidia\""
lsmod | grep -E "asus|wmi|intel|i915|acpi|therm|fan|nvidia" 2>/dev/null || true | tee -a "$OUTPUT_FILE"

log "PCI Devices & Kernel Drivers (lspci -k)"
if command -v lspci &> /dev/null; then
    cmd "sudo lspci -k"
    sudo lspci -k | tee -a "$OUTPUT_FILE"
else
    echo "lspci not found - install pciutils" | tee -a "$OUTPUT_FILE"
fi

log "USB Devices (lsusb)"
if command -v lsusb &> /dev/null; then
    cmd "lsusb"
    lsusb | tee -a "$OUTPUT_FILE"
else
    echo "lsusb not found - install usbutils" | tee -a "$OUTPUT_FILE"
fi

log "CPU Info (first 10 lines)"
cmd "sed -n '1,10p' /proc/cpuinfo"
sed -n '1,10p' /proc/cpuinfo | tee -a "$OUTPUT_FILE"

log "Memory (free -h)"
cmd "free -h"
free -h | tee -a "$OUTPUT_FILE"

log "GPU / DRM Info (lshw -c video)"
if command -v lshw &> /dev/null; then
    cmd "sudo lshw -c video"
    sudo lshw -c video 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "lshw not found - install lshw" | tee -a "$OUTPUT_FILE"
fi

log "Intel/i915 Driver Logs"
cmd "dmesg | grep -iE \"i915|intel\" | tail -n 100"
dmesg | grep -iE "i915|intel" | tail -n 100 | tee -a "$OUTPUT_FILE"

log "NVIDIA Driver Logs (if applicable)"
cmd "dmesg | grep -iE \"nvidia|nvkm\" | tail -n 100"
dmesg | grep -iE "nvidia|nvkm" | tail -n 100 2>/dev/null || echo "No NVIDIA logs found" | tee -a "$OUTPUT_FILE"

log "Boot Errors (journalctl -b -p 3)"
if command -v journalctl &> /dev/null; then
    cmd "journalctl -b -p 3 --no-pager | sed -n '1,200p'"
    journalctl -b -p 3 --no-pager | sed -n '1,200p' | tee -a "$OUTPUT_FILE"
else
    echo "journalctl not available" | tee -a "$OUTPUT_FILE"
fi

log "Thermal Sensors (sensors)"
if command -v sensors &> /dev/null; then
    cmd "sensors"
    sensors 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "sensors not found - install lm_sensors and run 'sudo sensors-detect'" | tee -a "$OUTPUT_FILE"
fi

log "ACPI / Battery / Power"
if command -v acpi &> /dev/null; then
    cmd "acpi -V"
    acpi -V 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "acpi not found - install acpi" | tee -a "$OUTPUT_FILE"
fi

log "Fan / PWM Hardware in /sys"
cmd "find /sys/devices -type f -maxdepth 5 \\( -name '*fan*' -o -name 'pwm*' \\) | sed -n '1,200p'"
find /sys/devices -type f -maxdepth 5 \( -name '*fan*' -o -name 'pwm*' \) 2>/dev/null | sed -n '1,200p' | tee -a "$OUTPUT_FILE"

log "DMI / System Firmware Info"
if command -v dmidecode &> /dev/null; then
    cmd "sudo dmidecode -t system | sed -n '1,200p'"
    sudo dmidecode -t system | sed -n '1,200p' | tee -a "$OUTPUT_FILE"
else
    echo "dmidecode not found - install dmidecode" | tee -a "$OUTPUT_FILE"
fi

log "Storage Devices (lsblk)"
cmd "lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,ROTA"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,ROTA | tee -a "$OUTPUT_FILE"

log "Network Interfaces (ip link)"
if command -v ip &> /dev/null; then
    cmd "ip link"
    ip link | tee -a "$OUTPUT_FILE"
else
    echo "ip command not found" | tee -a "$OUTPUT_FILE"
fi

log "Network Status (nmcli)"
if command -v nmcli &> /dev/null; then
    cmd "nmcli -t -f GENERAL.STATE,DEVICE dev status"
    nmcli -t -f GENERAL.STATE,DEVICE dev status 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "nmcli not found" | tee -a "$OUTPUT_FILE"
fi

log "RFKill Status"
if command -v rfkill &> /dev/null; then
    cmd "rfkill list"
    rfkill list | tee -a "$OUTPUT_FILE"
else
    echo "rfkill not found" | tee -a "$OUTPUT_FILE"
fi

log "Audio Sinks"
cmd "pacmd list-sinks (or) pactl list short sinks"
(pacmd list-sinks 2>/dev/null || pactl list short sinks 2>/dev/null || echo "No audio commands available") | tee -a "$OUTPUT_FILE"

log "Installed Kernel Headers / DKMS Modules"
if command -v pacman &> /dev/null; then
    cmd "pacman -Qs \"linux-headers|dkms\""
    pacman -Qs "linux-headers|dkms" 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "Not an Arch-based system" | tee -a "$OUTPUT_FILE"
fi

log "Power Tools Status (tlp, thermald, power-profiles-daemon)"
if command -v systemctl &> /dev/null; then
    cmd "systemctl --no-pager status tlp thermald power-profiles-daemon"
    systemctl --no-pager status tlp thermald power-profiles-daemon 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "systemctl not available" | tee -a "$OUTPUT_FILE"
fi

log "Enabled Systemd Services"
if command -v systemctl &> /dev/null; then
    cmd "systemctl list-unit-files --state=enabled | sed -n '1,200p'"
    systemctl list-unit-files --state=enabled | sed -n '1,200p' | tee -a "$OUTPUT_FILE"
else
    echo "systemctl not available" | tee -a "$OUTPUT_FILE"
fi

log "Relevant Installed Packages (Arch)"
if command -v pacman &> /dev/null; then
    cmd "pacman -Qs \"inxi|lm_sensors|acpi|smartmontools|cpupower|powertop|tlp|thermald|fancontrol|asusctl|nvidia\""
    pacman -Qs "inxi|lm_sensors|acpi|smartmontools|cpupower|powertop|tlp|thermald|fancontrol|asusctl|nvidia" 2>/dev/null | tee -a "$OUTPUT_FILE"
else
    echo "Not an Arch-based system" | tee -a "$OUTPUT_FILE"
fi

log "Current Kernel Command Line"
cmd "cat /proc/cmdline"
cat /proc/cmdline | tee -a "$OUTPUT_FILE"

log "GRUB Configuration"
if [ -f /etc/default/grub ]; then
    cmd "grep -E \"^GRUB_CMDLINE|^GRUB_TIMEOUT|^GRUB_DEFAULT\" /etc/default/grub"
    grep -E "^GRUB_CMDLINE|^GRUB_TIMEOUT|^GRUB_DEFAULT" /etc/default/grub | tee -a "$OUTPUT_FILE"
else
    echo "/etc/default/grub not found" | tee -a "$OUTPUT_FILE"
fi

echo -e "\n[✓] Diagnostics complete!"
echo "[✓] Saved to: $OUTPUT_FILE"
echo ""
echo "Privacy Note: This log contains hardware information but no passwords or personal data."
echo "Review the file before sharing publicly."
echo ""
echo "To redact serial numbers or sensitive info, edit: $OUTPUT_FILE"
