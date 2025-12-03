# DRM, Power Management & USB Diagnostics Tool

**Last Updated:** November 2025  
**Script:** `drm-power-diagnostics.sh`  
**Purpose:** Collect comprehensive DRM/display, USB, PCI, and power management diagnostics

---

## Overview

This specialized diagnostic script collects detailed information about:
- **DRM subsystem:** Display connectors, EDID data, modes
- **USB devices:** Hubs, power states, autosuspend settings  
- **PCI graphics:** VGA controllers, drivers
- **Power management:** TLP configuration, runtime PM
- **System logs:** Kernel, systemd, udev related to displays and power

It's particularly useful for troubleshooting external monitor issues, USB hub power problems, display hotplug failures, and runtime power management conflicts.

---

## Quick Start

### Run locally:

```bash
chmod +x drm-power-diagnostics.sh
./drm-power-diagnostics.sh
```

### Run directly from URL:

**For Bash/Zsh:**
```bash
bash <(curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh)
```

**For Fish shell:**
```fish
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash
```

**Universal method (works in any shell):**
```bash
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash
```

---

## Output

The script creates a directory: `~/drm-power-diagnostics-YYYYMMDD-HHMMSS/` with multiple files:

### Files Created:

1. **`system-info.txt`** - System and session information
   - Date, kernel version, user ID
   - Display environment variables

2. **`sessions-processes.txt`** - Active sessions and display processes
   - Logged-in users
   - Compositor processes (KWin, Plasma, Xorg, Wayland)

3. **`drm-connectors.txt`** - DRM connector states and EDID data
   - Connector status (connected/disconnected)
   - Available display modes
   - EDID information (hexdump)

4. **`usb-sysfs.txt`** - USB device details
   - Vendor and product IDs
   - Power management states
   - Genesys Logic hub detection (05e3:*)

5. **`pci-vga.txt`** - PCI graphics devices
   - VGA controller information
   - Driver bindings
   - Vendor/device IDs

6. **`kernlog-filtered.txt`** - Filtered kernel logs
   - DRM, HDMI, EDID messages
   - Hotplug events
   - Display-related errors

7. **`systemd-udev-journal.txt`** - System service logs
   - TLP status
   - udev messages
   - Display manager logs

8. **`config-files.txt`** - Configuration snapshots
   - TLP configuration
   - GRUB kernel parameters
   - Current kernel command line

9. **`drm-raw-snapshot.txt`** - Raw DRM state snapshot
   - Real-time connector states
   - Mode information
   - EDID dumps

---

## Features

- **Command Visibility:** Shows commands before executing (educational and transparent)
- **Multiple Output Files:** Organized information by category
- **Safe Operation:** Read-only, no system modifications
- **Automatic Timestamping:** Each run creates a new dated directory
- **Comprehensive Coverage:** Display, USB, power management, and system state

---

## Use Cases

### External Monitor Issues
- Monitor not detected
- Incorrect resolution
- Display flickering
- Hotplug not working

### USB Hub Problems
- USB devices disconnecting
- Power management issues
- Hub autosuspend problems

### Power Management
- Runtime PM conflicts
- TLP configuration issues
- Device blacklisting needs

### EDID Problems
- Display identification issues
- Mode detection failures
- Resolution limitations

---

## Reading the Output

### Finding PCI Address for NVIDIA GPU

From `pci-vga.txt`:
```
PCI device: 0000:01:00.0
 vendor: 0x10de
 device: 0x174d
```
**Use:** `RUNTIME_PM_BLACKLIST="pci:0000:01:00.0"` in TLP config

### Finding USB Device IDs

From `usb-sysfs.txt`:
```
Device: 2-4 vendor:05e3 product:0610
```
**Use:** `USB_BLACKLIST="05e3:0610"` in TLP config

### Checking Display Connection

From `drm-connectors.txt`:
```
---- card0-HDMI-A-1 ----
status: connected
modes:
1920x1080
```

### Verifying EDID

From `drm-connectors.txt`:
```
edid: present (binary -> hexdump head)
00000000  00 ff ff ff ff ff ff 00  ...
```

---

## Troubleshooting

### Script Permission Denied
```bash
chmod +x drm-power-diagnostics.sh
```

### Missing Commands
Some commands may not be available on all systems. The script gracefully handles missing tools.

### Need Root Access
Some operations (like reading certain system files) may require sudo. The script will skip inaccessible files.

---

## Integration with TLP Configuration

Use this script's output to populate hardware-specific settings in `/etc/tlp.d/01-custom.conf`:

1. **Run diagnostics:**
   ```bash
   ./drm-power-diagnostics.sh
   ```

2. **Check `pci-vga.txt` for GPU PCI address:**
   ```
   PCI device: 0000:01:00.0  <- Use this
   ```

3. **Check `usb-sysfs.txt` for USB hub IDs:**
   ```
   vendor:05e3 product:0610  <- Use these
   ```

4. **Update TLP config:**
   ```bash
   sudo nano /etc/tlp.d/01-custom.conf
   
   # Add discovered values:
   RUNTIME_PM_BLACKLIST="pci:0000:01:00.0"
   USB_BLACKLIST="05e3:0610 05e3:0625"
   ```

5. **Restart TLP:**
   ```bash
   sudo systemctl restart tlp
   ```

---

## Related Files

- [`diagnostics.sh`](diagnostics.sh) - Full system diagnostics
- [`01-custom.conf`](01-custom.conf) - TLP configuration example
- [`extract.md`](extract.md) - Diagnostics toolkit documentation

---

## Privacy & Safety

- **Safe:** Read-only operations, no system modifications
- **Privacy:** No passwords or personal data collected
- **Hardware Info:** Contains PCI/USB IDs, system model, kernel version
- **Review:** Check output files before sharing publicly

---

## Example Usage Session

```bash
$ cd cachy_os_config/
$ ./drm-power-diagnostics.sh
[+] Starting DRM, power management, and USB diagnostics...
[+] Output directory: /home/user/drm-power-diagnostics-20251203-143022
[!] This script only reads information - no changes will be made

[+] Collecting system information...
[+] Collecting session and compositor information...
[+] Scanning DRM connectors and EDID data...
[+] Collecting USB device information...
[+] Scanning PCI VGA devices...
[+] Extracting filtered kernel logs...
[+] Collecting systemd and udev information...
[+] Reading configuration files...
[+] Creating raw DRM snapshot...

[✓] DRM, power management, and USB diagnostics complete!
[✓] Saved to directory: /home/user/drm-power-diagnostics-20251203-143022

Files created:
 - /home/user/drm-power-diagnostics-20251203-143022/system-info.txt
 - /home/user/drm-power-diagnostics-20251203-143022/sessions-processes.txt
 - /home/user/drm-power-diagnostics-20251203-143022/drm-connectors.txt
 - /home/user/drm-power-diagnostics-20251203-143022/usb-sysfs.txt
 - /home/user/drm-power-diagnostics-20251203-143022/pci-vga.txt
 - /home/user/drm-power-diagnostics-20251203-143022/kernlog-filtered.txt
 - /home/user/drm-power-diagnostics-20251203-143022/systemd-udev-journal.txt
 - /home/user/drm-power-diagnostics-20251203-143022/config-files.txt
 - /home/user/drm-power-diagnostics-20251203-143022/drm-raw-snapshot.txt
```

---

## Contributing

Found an issue or have suggestions? See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
