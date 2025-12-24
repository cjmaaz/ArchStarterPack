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

### What is DRM? (Direct Rendering Manager)

**What DRM is:**

**DRM (Direct Rendering Manager)** is the Linux kernel subsystem that manages graphics hardware and display output.

**Why DRM exists:**

- **Graphics hardware management:** Controls GPUs, display outputs, framebuffers
- **Display initialization:** Sets up displays during boot (KMS - Kernel Mode Setting)
- **GPU access:** Provides interface for applications to access GPU
- **Display management:** Handles multiple displays, resolution changes, hotplug

**How DRM works:**

**Step-by-step display pipeline:**

1. **Kernel boots:** DRM subsystem initializes
2. **GPU detection:** DRM detects graphics hardware (Intel, AMD, NVIDIA)
3. **Display detection:** DRM detects connected displays (eDP, HDMI, DisplayPort)
4. **EDID reading:** DRM reads display capabilities from displays
5. **Mode setting:** DRM sets display resolution and refresh rate
6. **Framebuffer creation:** DRM creates framebuffer for display output
7. **Display active:** Display shows output

**Real-world analogy:**

- **DRM = Graphics manager** for your computer
- **GPU = Artist** (creates images)
- **Display = Canvas** (shows images)
- **DRM = Manager** (coordinates artist and canvas)

**Key DRM concepts:**

**Connectors:**

- **What:** Physical display outputs (eDP-1, HDMI-A-1, DP-1)
- **Purpose:** Represent physical display connections
- **Example:** `eDP-1` = Internal laptop screen, `HDMI-A-1` = HDMI port

**EDID (Extended Display Identification Data):**

- **What:** Display capabilities information (resolution, refresh rate, etc.)
- **Purpose:** Tells system what display can do
- **Example:** Display says "I support 1920x1080 @ 60Hz"

**Modes:**

- **What:** Display resolution and refresh rate combinations
- **Purpose:** Available display configurations
- **Example:** `1920x1080@60Hz`, `1366x768@60Hz`

**Why DRM diagnostics are needed:**

- **Display issues:** Check if displays are detected
- **Resolution problems:** Verify EDID data is read correctly
- **Hotplug failures:** Check connector states
- **GPU problems:** Verify GPU is driving displays correctly

---

## Quick Start

### Run locally:

```bash
chmod +x drm-power-diagnostics.sh
./drm-power-diagnostics.sh              # Normal mode
./drm-power-diagnostics.sh --redact     # Redact personal information
```

### Run directly from URL:

**For Bash/Zsh:**

```bash
# Normal mode
bash <(curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh)

# With redaction
bash <(curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh) --redact
```

**For Fish shell:**

```fish
# Normal mode
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash

# With redaction
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash -s -- --redact
```

**Universal method (works in any shell):**

```bash
# Normal mode
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash

# With redaction
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/drm-power-diagnostics.sh | bash -s -- --redact
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
   - Genesys Logic hub detection (05e3:\*)

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

**Monitor not detected:**

- **Problem:** External monitor doesn't show up
- **Diagnostic:** Check `drm-connectors.txt` for connector status
- **Look for:** Connector shows "disconnected" when monitor is plugged in
- **Solution:** Check cable, verify GPU driver, check kernel parameters

**Incorrect resolution:**

- **Problem:** External monitor shows wrong resolution
- **Diagnostic:** Check `drm-connectors.txt` for available modes
- **Look for:** EDID data, available resolutions
- **Solution:** Check EDID data, verify display capabilities, set correct resolution

**Display flickering:**

- **Problem:** External monitor flickers or shows artifacts
- **Diagnostic:** Check `kernlog-filtered.txt` for GPU errors
- **Look for:** Display pipe errors, VRAM allocation failures
- **Solution:** Check GPU driver, update kernel, check cable

**Hotplug not working:**

- **Problem:** Monitor doesn't work when plugged in after boot
- **Diagnostic:** Check `drm-connectors.txt` for hotplug events
- **Look for:** Connector state changes, hotplug detection
- **Solution:** Check udev rules, verify hotplug support, check kernel parameters

### USB Hub Problems

**USB devices disconnecting:**

- **Problem:** USB devices randomly disconnect
- **Diagnostic:** Check `usb-sysfs.txt` for power states
- **Look for:** Devices in "suspended" state, autosuspend enabled
- **Solution:** Add to TLP USB blacklist, disable autosuspend

**Power management issues:**

- **Problem:** USB devices not getting enough power
- **Diagnostic:** Check `usb-sysfs.txt` for power states
- **Look for:** Power state information, autosuspend settings
- **Solution:** Disable autosuspend for affected devices, check USB hub power

**Hub autosuspend problems:**

- **Problem:** USB hub suspends, devices on hub stop working
- **Diagnostic:** Check `usb-sysfs.txt` for hub power states
- **Look for:** Hub in suspended state (Genesys Logic hubs: 05e3:\*)
- **Solution:** Add hub to TLP USB blacklist, prevent hub autosuspend

### Power Management

**Runtime PM conflicts:**

- **Problem:** Devices power down when they shouldn't
- **Diagnostic:** Check `config-files.txt` for TLP configuration
- **Look for:** Runtime PM settings, device blacklists
- **Solution:** Add devices to runtime PM blacklist, adjust TLP settings

**TLP configuration issues:**

- **Problem:** Power management not working as expected
- **Diagnostic:** Check `config-files.txt` for TLP settings
- **Look for:** TLP configuration, runtime PM settings
- **Solution:** Verify TLP configuration, check service status, adjust settings

**Device blacklisting needs:**

- **Problem:** Need to prevent specific devices from power management
- **Diagnostic:** Check `pci-vga.txt` and `usb-sysfs.txt` for device IDs
- **Look for:** PCI addresses, USB vendor:product IDs
- **Solution:** Add devices to TLP blacklists using discovered IDs

### EDID Problems

**Display identification issues:**

- **Problem:** System doesn't recognize display correctly
- **Diagnostic:** Check `drm-connectors.txt` for EDID data
- **Look for:** EDID present/absent, EDID hexdump
- **Solution:** Check EDID data, verify cable, check display

**Mode detection failures:**

- **Problem:** Display modes not detected correctly
- **Diagnostic:** Check `drm-connectors.txt` for available modes
- **Look for:** Mode list, resolution/refresh rate information
- **Solution:** Check EDID data, verify display capabilities, manually set modes

**Resolution limitations:**

- **Problem:** Can't set desired resolution
- **Diagnostic:** Check `drm-connectors.txt` for available modes
- **Look for:** Mode list, check if desired resolution is available
- **Solution:** Verify display supports resolution, check EDID data, use different resolution

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
- **No passwords collected:** Never asks for or stores credentials
- **Redaction available:** Use `--redact` flag to mask:
  - IP addresses
  - MAC addresses
  - Hostnames
  - Serial numbers
  - WiFi SSIDs
  - UUIDs
  - Usernames in paths
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
