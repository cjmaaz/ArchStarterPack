#!/usr/bin/env bash
# display-diagnostics.sh
# Collect display-related diagnostics in plain text files (no tar.gz).
# Output directory: ~/display-diagnostics-<TIMESTAMP>/
set -euo pipefail

OUTDIR="$HOME/display-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUTDIR"

echo "Saving diagnostics to $OUTDIR"

# 1) Basic system info
{
  echo "=== DATE ==="
  date
  echo
  echo "=== UNAME ==="
  uname -a
  echo
  echo "=== CURRENT USER / UID ==="
  id
  echo
  echo "=== ENV (selected) ==="
  echo "XDG_SESSION_TYPE=$XDG_SESSION_TYPE"
  echo "DISPLAY=$DISPLAY"
  echo "XDG_SESSION_CLASS=$XDG_SESSION_CLASS"
} > "$OUTDIR/system-info.txt"

# 2) Session and compositor info (processes)
{
  echo "=== WHO / W ==="
  who || true
  echo
  echo "=== LOGGED-IN SESSIONS (simple ps scan) ==="
  ps -eo pid,uid,user,cmd --sort=-uid | head -n 200
  echo
  echo "=== COMPOSITOR / DISPLAY RELATED PROCESSES ==="
  ps -eo pid,uid,user,cmd | egrep -i "kwin|kwin_wayland|plasmashell|gnome-shell|mutter|Xwayland|Xorg|sddm|gdm|wayland" --color=never || true
} > "$OUTDIR/sessions-processes.txt"

# 3) DRM connectors and EDID (sysfs-based)
{
  echo "=== /sys/class/drm connector statuses and EDID presence ==="
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
{
  echo "=== USB devices (sysfs scan for vendor 05e3 and monitor hubs) ==="
  echo
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
{
  echo "=== PCI devices (sysfs scan for VGA/3D devices) ==="
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
{
  echo "=== Kernel/boot logs (filtered) ==="
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
{
  echo "=== systemctl status tlp (if present) ==="
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
{
  echo "=== /etc/tlp.d/01-custom.conf ==="
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
{
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
echo "Diagnostics saved under: $OUTDIR"
echo "Please upload the following files for review:"
echo " - $OUTDIR/drm-connectors.txt"
echo " - $OUTDIR/usb-sysfs.txt"
echo " - $OUTDIR/pci-vga.txt"
echo " - $OUTDIR/kernlog-filtered.txt"
echo " - $OUTDIR/systemd-udev-journal.txt"
echo " - $OUTDIR/config-files.txt"
