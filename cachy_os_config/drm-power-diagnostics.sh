#!/usr/bin/env bash

# ============================================
# DRM, Power Management & USB Diagnostics Collector
# Safe, read-only, information-gathering tool
# ============================================
# Last Updated: November 2025
# Purpose: Collect DRM/display, USB, PCI, power management, and systemd/udev diagnostics
# Scope: Display connectors, EDID, USB hubs, TLP, runtime PM, kernel logs
# Output: Multiple text files in ~/drm-power-diagnostics-<TIMESTAMP>/

set -euo pipefail

OUTDIR="$HOME/drm-power-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTDIR"

# Helper function to show commands before execution
cmd() {
    echo "$ $1"
}

echo "[+] Starting DRM, power management, and USB diagnostics..."
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
} > "$OUTDIR/system-info.txt"

# 2) Session and compositor info (processes)
echo "[+] Collecting session and compositor information..."
{
  echo "==================== SESSIONS & PROCESSES ===================="
  echo ""
  cmd "who"
  who || true
  echo ""
  echo "=== LOGGED-IN SESSIONS ==="
  cmd "ps -eo pid,uid,user,cmd --sort=-uid | head -n 200"
  ps -eo pid,uid,user,cmd --sort=-uid | head -n 200
  echo ""
  echo "=== COMPOSITOR / DISPLAY RELATED PROCESSES ==="
  cmd "ps -eo pid,uid,user,cmd | egrep -i \"kwin|kwin_wayland|plasmashell|gnome-shell|mutter|Xwayland|Xorg|sddm|gdm|wayland\""
  ps -eo pid,uid,user,cmd | egrep -i "kwin|kwin_wayland|plasmashell|gnome-shell|mutter|Xwayland|Xorg|sddm|gdm|wayland" --color=never || true
} > "$OUTDIR/sessions-processes.txt"

# 3) DRM connectors and EDID (sysfs-based)
echo "[+] Scanning DRM connectors and EDID data..."
{
  echo "==================== DRM CONNECTORS ===================="
  echo ""
  cmd "Scanning /sys/class/drm/* for connector status, modes, and EDID"
  echo ""
  for d in /sys/class/drm/*; do
    [ -e "$d" ] || continue
    name=$(basename "$d")
    echo "---- $name ----"
    if [ -r "$d/status" ]; then
      echo "status: $(cat "$d/status")"
    else
      echo "status: (no status file)"
    fi
    if [ -r "$d/modes" ]; then
      echo "modes:"
      sed -n '1,200p' "$d/modes"
    else
      echo "modes: (none)"
    fi
    if [ -s "$d/edid" ]; then
      echo "edid: present (binary -> hexdump head)"
      hexdump -C -n 128 "$d/edid" | sed -n '1,20p'
    else
      echo "edid: not present"
    fi
    echo
  done
} > "$OUTDIR/drm-connectors.txt"

# 4) USB devices via sysfs (find Genesys Logic and show details)
echo "[+] Collecting USB device information..."
{
  echo "==================== USB DEVICES ===================="
  echo ""
  cmd "Scanning /sys/bus/usb/devices/* for vendor/product IDs and power states"
  echo ""
  # list all USB device dirs with vendor/product info
  for dev in /sys/bus/usb/devices/*; do
    [ -d "$dev" ] || continue
    if [ -f "$dev/idVendor" ]; then
      v=$(cat "$dev/idVendor" 2>/dev/null || echo "")
      p=$(cat "$dev/idProduct" 2>/dev/null || echo "")
      if [ -n "$v" ]; then
        echo "Device: $(basename "$dev") vendor:$v product:$p"
        # show product strings if available
        grep -H . "$dev"/product "$dev"/manufacturer 2>/dev/null || true
        # show power state if available
        if [ -f "$dev/power/level" ]; then
          echo " power/level: $(cat "$dev/power/level" 2>/dev/null || true)"
        fi
        if [ -f "$dev/power/autosuspend_delay_ms" ]; then
          echo " power/autosuspend_delay_ms: $(cat "$dev/power/autosuspend_delay_ms" 2>/dev/null || true)"
        fi
        echo
      fi
    fi
  done

  echo "=== Quick grep for vendor 05e3 (Genesys) ==="
  grep -R --line-number --no-messages -I "05e3" /sys/bus/usb/devices/*/uevent 2>/dev/null || true
} > "$OUTDIR/usb-sysfs.txt"

# 5) PCI devices (simple sysfs scan for VGA/NVIDIA/Intel)
echo "[+] Scanning PCI VGA devices..."
{
  echo "==================== PCI VGA DEVICES ===================="
  echo ""
  cmd "Scanning /sys/bus/pci/devices/* for VGA/3D controllers"
  echo ""
  for d in /sys/bus/pci/devices/*; do
    [ -d "$d" ] || continue
    if [ -f "$d/class" ]; then
      cls=$(cat "$d/class" 2>/dev/null || echo "")
      # VGA class codes: 0x030000, 0x030200 etc.
      case "$cls" in
        *0300*|*0302*)
          echo "PCI device: $(basename "$d")"
          echo " vendor: $(cat "$d/vendor" 2>/dev/null || true)"
          echo " device: $(cat "$d/device" 2>/dev/null || true)"
          echo " class: $cls"
          # show device name if available
          if [ -f "$d/driver/module" ]; then echo " driver/module: $(basename $(readlink -f "$d/driver/module"))"; fi
          echo
        ;;
      esac
    fi
  done
} > "$OUTDIR/pci-vga.txt"

# 6) Kernel logs: attempt to extract drm/hdmi/edid/connector/hotplug lines from /var/log
echo "[+] Extracting filtered kernel logs..."
{
  echo "==================== KERNEL LOGS (FILTERED) ===================="
  echo ""
  cmd "grep -iE \"drm|hdmi|edid|connector|hotplug|genesys|05e3|intel\" /var/log/*"
  echo ""
  # Try common log files
  LOGFILES="/var/log/kern.log /var/log/syslog /var/log/messages"
  for f in $LOGFILES; do
    if [ -r "$f" ]; then
      echo "---- source: $f ----"
      # filter for display keywords
      grep -iE "drm|hdmi|edid|connector|hotplug|genesys|05e3|intel" "$f" | tail -n 400 || true
      echo
    fi
  done

  # Fallback: try /proc/kmsg (requires root)
  if [ -r /proc/kmsg ]; then
    echo "---- /proc/kmsg (head) ----"
    head -n 200 /proc/kmsg 2>/dev/null || true
  fi
} > "$OUTDIR/kernlog-filtered.txt"

# 7) systemd & udev: unit statuses and recent udevd messages (using systemctl and journalctl)
echo "[+] Collecting systemd and udev information..."
{
  echo "==================== SYSTEMD & UDEV ===================="
  echo ""
  cmd "systemctl status tlp"
  echo ""
  systemctl status tlp --no-pager || true
  echo
  echo "=== systemctl --type=service --state=running | grep udev/sys" 
  systemctl list-units --type=service --state=running | egrep "udev|tlp|display-manager|sddm|gdm|lightdm" --color=never || true
  echo
  echo "=== Recent systemd-udevd messages (journalctl, last 400 lines) ==="
  journalctl -b -u systemd-udevd --no-pager | tail -n 400 || true
  echo
  echo "=== Recent display-manager / compositor journal lines (last 800 lines) ==="
  journalctl -b --no-pager | egrep -i "kwin|kwin_wayland|plasmashell|Xwayland|sddm|gdm|display-manager" | tail -n 800 || true
} > "$OUTDIR/systemd-udev-journal.txt"

# 8) Show key files (tlp conf and grub line, if readable)
echo "[+] Reading configuration files..."
{
  echo "==================== CONFIGURATION FILES ===================="
  echo ""
  cmd "cat /etc/tlp.d/01-custom.conf"
  echo ""
  if [ -r /etc/tlp.d/01-custom.conf ]; then
    sed -n '1,240p' /etc/tlp.d/01-custom.conf || true
  else
    echo "(no /etc/tlp.d/01-custom.conf)"
  fi
  echo
  echo "=== /proc/cmdline ==="
  cat /proc/cmdline || true
  echo
  echo "=== /etc/default/grub (GRUB_CMDLINE_LINUX_DEFAULT line) ==="
  if [ -r /etc/default/grub ]; then
    grep -i '^GRUB_CMDLINE_LINUX_DEFAULT' /etc/default/grub || true
  else
    echo "(no /etc/default/grub)"
  fi
} > "$OUTDIR/config-files.txt"

# 9) DRM connector raw status snapshot (additional)
echo "[+] Creating raw DRM snapshot..."
{
  echo "==================== DRM RAW SNAPSHOT ===================="
  echo ""
  cmd "Reading raw status, modes, and EDID from /sys/class/drm/*"
  echo ""
  for d in /sys/class/drm/*; do
    [ -e "$d" ] || continue
    name=$(basename "$d")
    echo "---- $name ----"
    for f in status modes edid; do
      if [ -r "$d/$f" ]; then
        echo " $f :"
        if [ "$f" = "edid" ]; then
          hexdump -C -n 64 "$d/$f" | sed -n '1,20p'
        else
          sed -n '1,200p' "$d/$f"
        fi
      fi
    done
    echo
  done
} > "$OUTDIR/drm-raw-snapshot.txt"

# 10) Final note
echo ""
echo "[✓] DRM, power management, and USB diagnostics complete!"
echo "[✓] Saved to directory: $OUTDIR"
echo ""
echo "Privacy Note: These logs contain hardware information but no passwords or personal data."
echo "Review the files before sharing publicly."
echo ""
echo "Files created:"
echo " - $OUTDIR/system-info.txt"
echo " - $OUTDIR/sessions-processes.txt"
echo " - $OUTDIR/drm-connectors.txt"
echo " - $OUTDIR/usb-sysfs.txt"
echo " - $OUTDIR/pci-vga.txt"
echo " - $OUTDIR/kernlog-filtered.txt"
echo " - $OUTDIR/systemd-udev-journal.txt"
echo " - $OUTDIR/config-files.txt"
echo " - $OUTDIR/drm-raw-snapshot.txt"
