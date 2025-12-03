#!/usr/bin/env bash

# ============================================
# DRM, Power Management & USB Diagnostics Collector
# Safe, read-only, information-gathering tool
# ============================================
# Last Updated: December 2025
# Purpose: Collect DRM/display, USB, PCI, power management, and systemd/udev diagnostics
# Scope: Display connectors, EDID, USB hubs, TLP, runtime PM, kernel logs
# Output: Multiple text files in ~/drm-power-diagnostics-<TIMESTAMP>/
# Usage: ./drm-power-diagnostics.sh [--redact]

set -euo pipefail

# Parse arguments
REDACT_MODE=false
if [[ "${1:-}" == "--redact" ]]; then
    REDACT_MODE=true
fi

OUTDIR="$HOME/drm-power-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTDIR"

# Redaction function - masks sensitive personal information
redact_sensitive() {
    if [[ "$REDACT_MODE" == "true" ]]; then
        sed -E \
            -e 's/([0-9]{1,3}\.){3}[0-9]{1,3}/XXX.XXX.XXX.XXX/g' \
            -e 's/([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/XX:XX:XX:XX:XX:XX/g' \
            -e 's/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/gi' \
            -e "s|/home/[^/ ]+|/home/USER|g" \
            -e "s|/Users/[^/ ]+|/Users/USER|g" \
            -e 's/(Serial Number|S\/N|Serial #|iSerial):.*$/\1: [REDACTED]/gi' \
            -e 's/(SSID|essid)[=:].*/\1=[REDACTED]/gi' \
            -e 's/(hostname|Host)[=:].*/\1=[REDACTED]/gi' \
            -e 's/UUID=[0-9a-f-]*/UUID=[REDACTED]/gi'
    else
        cat
    fi
}

# Helper function to show commands before execution
cmd() {
    echo "$ $1"
}

echo "[+] Starting DRM, power management, and USB diagnostics..."
if [[ "$REDACT_MODE" == "true" ]]; then
    echo "[+] REDACTION MODE: Personal information will be masked"
fi
echo "[+] Output directory: $OUTDIR"
echo "[!] This script only reads information - no changes will be made"
echo ""
sleep 1

# 1) Basic system info
echo "[+] Collecting system information..."
{
  echo "==================== SYSTEM INFORMATION ===================="
  echo ""
  cmd "date"
  date
  echo ""
  cmd "uname -a"
  uname -a
  echo ""
  cmd "id"
  id
  echo ""
  echo "=== ENVIRONMENT VARIABLES ==="
  cmd "echo \$XDG_SESSION_TYPE, \$DISPLAY, \$XDG_SESSION_CLASS"
  echo "XDG_SESSION_TYPE=$XDG_SESSION_TYPE"
  echo "DISPLAY=$DISPLAY"
  echo "XDG_SESSION_CLASS=$XDG_SESSION_CLASS"
} | redact_sensitive > "$OUTDIR/system-info.txt"

# 2) Session and compositor info (processes)
echo "[+] Collecting session and compositor information..."
{
  echo "==================== SESSION & COMPOSITOR PROCESSES ===================="
  echo ""
  cmd "ps aux | grep -iE 'kwin|plasma|gnome-shell|Xorg|wayland|mutter'"
  ps aux | grep -iE 'kwin|plasma|gnome-shell|Xorg|wayland|mutter' | grep -v grep || echo "No compositor/session found"
  echo ""
  cmd "loginctl list-sessions"
  loginctl list-sessions 2>/dev/null || echo "loginctl not available"
  echo ""
  cmd "loginctl show-session \$XDG_SESSION_ID"
  loginctl show-session "$XDG_SESSION_ID" 2>/dev/null || echo "Session info not available"
} | redact_sensitive > "$OUTDIR/sessions-processes.txt"

# 3) DRM connectors & EDID
echo "[+] Scanning DRM connectors and EDID data..."
{
  echo "==================== DRM CONNECTORS & EDID ===================="
  echo ""
  cmd "ls -l /sys/class/drm/"
  ls -l /sys/class/drm/ 2>/dev/null || echo "No DRM connectors found"
  echo ""
  for connector in /sys/class/drm/card*/card*-*; do
    if [[ -d "$connector" ]]; then
      conn_name=$(basename "$connector")
      echo "---------- $conn_name ----------"
      cmd "cat $connector/status"
      echo "Status: $(cat "$connector/status" 2>/dev/null || echo "unavailable")"
      cmd "cat $connector/enabled"
      echo "Enabled: $(cat "$connector/enabled" 2>/dev/null || echo "unavailable")"
      
      edid="$connector/edid"
      if [[ -f "$edid" ]]; then
        cmd "edid-decode $edid"
        edid-decode "$edid" 2>/dev/null || echo "edid-decode not available or failed"
      else
        echo "No EDID data"
      fi
      echo ""
    fi
  done
  
  echo "=== DRM MODES FROM XRANDR ==="
  cmd "xrandr --verbose"
  xrandr --verbose 2>/dev/null || echo "xrandr not available or not in X session"
  
  echo ""
  echo "=== WAYLAND DISPLAY INFO (wlr-randr) ==="
  cmd "wlr-randr"
  wlr-randr 2>/dev/null || echo "wlr-randr not available (Wayland only)"
} | redact_sensitive > "$OUTDIR/drm-connectors.txt"

# 4) USB device info (sysfs attributes)
echo "[+] Collecting USB device information..."
{
  echo "==================== USB DEVICES (SYSFS) ===================="
  echo ""
  cmd "lsusb"
  lsusb 2>/dev/null || echo "lsusb not available"
  echo ""
  
  for usbdev in /sys/bus/usb/devices/*-*; do
    if [[ -d "$usbdev" && ! "$usbdev" =~ .*:.*  ]]; then
      devname=$(basename "$usbdev")
      echo "---------- $devname ----------"
      cmd "cat $usbdev/{idVendor,idProduct,manufacturer,product,power/control,power/autosuspend_delay_ms}"
      echo "idVendor: $(cat "$usbdev/idVendor" 2>/dev/null || echo "N/A")"
      echo "idProduct: $(cat "$usbdev/idProduct" 2>/dev/null || echo "N/A")"
      echo "Manufacturer: $(cat "$usbdev/manufacturer" 2>/dev/null || echo "N/A")"
      echo "Product: $(cat "$usbdev/product" 2>/dev/null || echo "N/A")"
      echo "Power Control: $(cat "$usbdev/power/control" 2>/dev/null || echo "N/A")"
      echo "Autosuspend Delay (ms): $(cat "$usbdev/power/autosuspend_delay_ms" 2>/dev/null || echo "N/A")"
      echo ""
    fi
  done
} | redact_sensitive > "$OUTDIR/usb-sysfs.txt"

# 5) PCI VGA devices
echo "[+] Scanning PCI VGA devices..."
{
  echo "==================== PCI VGA DEVICES ===================="
  echo ""
  cmd "lspci -nn | grep -i vga"
  lspci -nn | grep -i vga 2>/dev/null || echo "No VGA devices found"
  echo ""
  cmd "lspci -v -s \$(lspci | grep -i vga | cut -d' ' -f1)"
  for vga in $(lspci | grep -i vga | cut -d' ' -f1); do
    echo "---------- $vga ----------"
    lspci -v -s "$vga" 2>/dev/null
    echo ""
    runtime_pm_path="/sys/bus/pci/devices/0000:$vga/power/control"
    if [[ -f "$runtime_pm_path" ]]; then
      cmd "cat $runtime_pm_path"
      echo "Runtime PM: $(cat "$runtime_pm_path" 2>/dev/null)"
    fi
    echo ""
  done
} | redact_sensitive > "$OUTDIR/pci-vga.txt"

# 6) Filtered kernel logs (last 500 lines)
echo "[+] Extracting filtered kernel logs..."
{
  echo "==================== KERNEL LOGS (FILTERED) ===================="
  echo ""
  cmd "dmesg | grep -iE 'drm|edid|hdmi|dp-|usb|hub|runtime.*pm|tlp' | tail -500"
  dmesg | grep -iE 'drm|edid|hdmi|dp-|usb|hub|runtime.*pm|tlp' | tail -500 2>/dev/null || echo "dmesg not available"
} | redact_sensitive > "$OUTDIR/kernlog-filtered.txt"

# 7) systemd & udev journal
echo "[+] Collecting systemd and udev information..."
{
  echo "==================== SYSTEMD & UDEV JOURNAL ===================="
  echo ""
  cmd "journalctl -b -u systemd-udevd | tail -200"
  journalctl -b -u systemd-udevd 2>/dev/null | tail -200 || echo "journalctl not available"
  echo ""
  echo "=== UDEV RULES (DRM/USB) ==="
  cmd "find /etc/udev/rules.d /usr/lib/udev/rules.d -name '*drm*' -o -name '*usb*' 2>/dev/null"
  find /etc/udev/rules.d /usr/lib/udev/rules.d -name '*drm*' -o -name '*usb*' 2>/dev/null || echo "No relevant udev rules found"
} | redact_sensitive > "$OUTDIR/systemd-udev-journal.txt"

# 8) Configuration files (TLP, X11, etc.)
echo "[+] Reading configuration files..."
{
  echo "==================== CONFIGURATION FILES ===================="
  echo ""
  echo "=== TLP CONFIG ==="
  cmd "cat /etc/tlp.conf /etc/tlp.d/*.conf"
  cat /etc/tlp.conf 2>/dev/null || echo "/etc/tlp.conf not found"
  echo ""
  for tlp_custom in /etc/tlp.d/*.conf; do
    if [[ -f "$tlp_custom" ]]; then
      echo "--- $(basename "$tlp_custom") ---"
      cat "$tlp_custom"
      echo ""
    fi
  done
  
  echo "=== X11 CONFIGS ==="
  cmd "cat /etc/X11/xorg.conf /etc/X11/xorg.conf.d/*.conf"
  cat /etc/X11/xorg.conf 2>/dev/null || echo "/etc/X11/xorg.conf not found"
  echo ""
  for xconf in /etc/X11/xorg.conf.d/*.conf; do
    if [[ -f "$xconf" ]]; then
      echo "--- $(basename "$xconf") ---"
      cat "$xconf"
      echo ""
    fi
  done
  
  echo "=== GRUB CMDLINE ==="
  cmd "cat /proc/cmdline"
  cat /proc/cmdline 2>/dev/null || echo "/proc/cmdline not available"
} | redact_sensitive > "$OUTDIR/config-files.txt"

# 9) Raw DRM snapshot (for advanced debugging)
echo "[+] Creating raw DRM snapshot..."
{
  echo "==================== RAW DRM SNAPSHOT ===================="
  echo ""
  cmd "find /sys/class/drm -type f -exec echo '{}:' \\; -exec cat {} 2>/dev/null \\;"
  find /sys/class/drm -type f -exec echo '{}:' \; -exec cat {} 2>/dev/null \; | head -1000
} | redact_sensitive > "$OUTDIR/drm-raw-snapshot.txt"

# 10) Final note
echo ""
echo "[✓] DRM, power management, and USB diagnostics complete!"
echo "[✓] Saved to directory: $OUTDIR"
echo ""

if [[ "$REDACT_MODE" == "true" ]]; then
    echo "✓ Personal information has been redacted (IPs, MACs, hostnames, serials, UUIDs)"
else
    echo "ℹ  Privacy Note: These logs contain hardware information but no passwords."
    echo "   To redact personal info, run: ./drm-power-diagnostics.sh --redact"
fi

echo ""
echo "Files created:"
ls -1 "$OUTDIR" | sed 's/^/ - /'
echo ""
echo "Review files before sharing publicly."
echo ""
