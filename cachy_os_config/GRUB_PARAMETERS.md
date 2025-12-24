# GRUB Kernel Parameters Explained

**Last Updated:** November 2025
**Applicable To:** CachyOS, Arch Linux, and Arch-based distributions
**Hardware Context:** ASUS X507UF (Intel i5-8250U + Intel UHD 620 + NVIDIA MX130)

---

## Overview

This guide explains each kernel parameter used in the ArchStarterPack GRUB configurations. Understanding these parameters helps you make informed decisions about system optimization and troubleshooting.

## Table of Contents

- [Performance Parameters](#performance-parameters)
- [Power Management Parameters](#power-management-parameters)
- [Graphics Parameters](#graphics-parameters)
- [Display Parameters](#display-parameters)
- [Logging Parameters](#logging-parameters)
- [Quick Reference Table](#quick-reference-table)

---

## Performance Parameters

### `intel_pstate=active` Explained

**Purpose:** Activates Intel P-State driver for CPU frequency scaling

**What it does:** Enables Intel's native CPU frequency scaling driver with hardware-managed P-states

**Why it exists:**

- **Problem:** Legacy ACPI CPUFreq driver is generic and less efficient
- **Solution:** Intel P-State uses CPU-specific features for better control
- **Benefit:** Better performance and power efficiency on Intel CPUs

**How it works:**

- **Intel P-State:** Intel's native CPU frequency driver
- **Hardware P-States:** CPU manages frequencies in hardware (more efficient)
- **Active mode:** Driver actively manages frequencies using hardware features
- **HWP support:** Hardware-managed P-states (Skylake and newer)

**Effect:** Better CPU performance management with hardware P-States

**Performance impact:**

- **Better efficiency:** Hardware-managed frequencies are more efficient
- **Faster response:** Hardware responds faster than software
- **Better performance:** Optimized frequency scaling for Intel CPUs

**Use Case:** Intel 6th gen and newer processors

**Compatibility:**

- **Intel 6th gen (Skylake) and newer:** Full support, recommended
- **Intel 4th-5th gen:** Supported but may have limitations
- **Older Intel CPUs:** May not support, use ACPI CPUFreq instead
- **AMD CPUs:** Not applicable (AMD uses different driver)

**Details:**

- Intel P-State is Intel's native CPU frequency driver
- Provides finer control over CPU frequencies than legacy ACPI CPUFreq
- Supports hardware-managed P-states (HWP) for better efficiency
- Essential for modern Intel CPUs (Skylake and newer)

**Alternatives:**

- **`intel_pstate=passive`:** Uses ACPI CPUFreq governors (older behavior, less efficient)
- **Omitting parameter:** Kernel auto-detects best mode (may not choose optimal)

**Real-world example:**

**Without `intel_pstate=active`:**

- CPU uses generic ACPI CPUFreq driver
- Less efficient frequency scaling
- Slower response to load changes
- Example: CPU takes longer to boost frequency under load

**With `intel_pstate=active`:**

- CPU uses Intel-specific driver
- Hardware-managed frequencies
- Faster response to load changes
- Example: CPU boosts frequency immediately when needed

**Troubleshooting:**

**Problem:** CPU frequency not scaling properly

**Check:**

```bash
cpupower frequency-info
# Should show: "driver: intel_pstate"
```

**If wrong driver:** Add `intel_pstate=active` to GRUB parameters

**Learn More:**

- [Linux kernel documentation](https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html)
- [Arch Wiki: CPU frequency scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling)

---

### `nowatchdog` Explained

**Purpose:** Disables hardware watchdog timers

**What it does:** Turns off hardware watchdog timers that monitor system health

**Why it exists:**

- **Problem:** Watchdog timers add overhead (CPU wakeups, interrupts)
- **Solution:** Disable watchdogs on desktop systems (not needed)
- **Benefit:** Slight performance improvement, reduced overhead

**How it works:**

- **Watchdog timer:** Hardware timer that monitors system health
- **Function:** If system hangs, watchdog triggers automatic reboot
- **`nowatchdog`:** Disables all watchdog timers
- **Result:** No automatic reboot on hang, but less overhead

**Effect:** Slight performance improvement, reduced overhead

**Performance impact:**

- **Fewer interrupts:** Watchdog timers cause periodic interrupts
- **Lower CPU wakeups:** Less CPU time spent on watchdog checks
- **Slight improvement:** Usually <1% performance gain, but measurable

**Use Case:** Desktop/laptop systems where automatic reboot on hang isn't needed

**When to use:**

- **Desktop systems:** Watchdog not needed (you can manually reboot)
- **Laptop systems:** Watchdog not needed (battery-powered, manual control)
- **Performance optimization:** Want maximum performance

**When NOT to use:**

- **Servers:** Need automatic recovery from hangs
- **Embedded systems:** Need watchdog for reliability
- **Critical systems:** Need automatic recovery

**Details:**

- Watchdog timers monitor system health and trigger reboot if system hangs
- Useful for servers, unnecessary for desktops
- Reduces CPU wakeups and power consumption slightly
- Disabled in most performance-focused configurations

**Trade-offs:**

- **Pro:** Lower system overhead, fewer interrupts, slight performance gain
- **Con:** No automatic recovery from system hangs (manual reboot needed)

**Real-world example:**

**Without `nowatchdog`:**

- Watchdog timer active, checking system health periodically
- Causes periodic interrupts (overhead)
- If system hangs, automatic reboot after timeout
- Example: Server system needs automatic recovery

**With `nowatchdog`:**

- No watchdog overhead
- Slight performance improvement
- If system hangs, must manually reboot
- Example: Desktop system, you can manually reboot if needed

**Troubleshooting:**

**Problem:** System has periodic stutters

**Check:** Remove `nowatchdog` temporarily to see if watchdog was causing issues

**Note:** Usually `nowatchdog` improves performance, but test if you have issues

---

## Power Management Parameters

### `nvidia.NVreg_DynamicPowerManagement=3`

**Purpose:** Enables NVIDIA dynamic power management (Optimus laptops)
**Effect:** GPU powers down when not in use, saves battery
**Use Case:** NVIDIA Optimus laptops (hybrid graphics)

**Details:**

- Mode 3 = "Fine-Grained Power Management"
- Allows GPU to enter low-power states automatically
- Works with NVIDIA driver 450+ and kernel 5.5+
- Critical for battery life on laptops with NVIDIA GPUs

**Power Modes:**

- `0` = Disabled (GPU always powered)
- `1` = Coarse-grained (deprecated)
- `2` = Fine-grained (older)
- `3` = Fine-grained with runtime D3 (recommended)

**Learn More:**

- [NVIDIA Official Documentation](https://download.nvidia.com/XFree86/Linux-x86_64/latest/README/dynamicpowermanagement.html)

---

### `nvidia.NVreg_UsePageAttributeTable=1`

**Purpose:** Enables PAT (Page Attribute Table) support for NVIDIA driver
**Effect:** Improves memory performance, better cache utilization
**Use Case:** Most NVIDIA GPU configurations

**Details:**

- PAT allows more precise control over memory caching
- Improves performance in memory-intensive operations
- Generally safe and recommended for modern systems
- May improve VRAM access patterns

---

## Graphics Parameters

### `i915.enable_guc=3` Explained

**Purpose:** Enables Intel GuC (Graphics Micro Controller) and HuC (HDCP Micro Controller) firmware loading

**What it does:** Loads Intel GPU microcode firmware for power management and media acceleration

**Why it exists:**

- **Problem:** GPU power management and media DRM handled in software (inefficient)
- **Solution:** Offload to dedicated microcontroller (GuC/HuC) in GPU
- **Benefit:** Better power efficiency, hardware-accelerated media

**How it works:**

- **GuC:** Graphics Micro Controller (handles GPU power management, scheduling)
- **HuC:** HDCP Micro Controller (handles media DRM, content protection)
- **Firmware loading:** Kernel loads microcode into GPU microcontroller
- **Value 3:** Enable both GuC (bit 1) and HuC (bit 2)

**Effect:** Offloads GPU tasks to dedicated microcontroller, improves efficiency

**Performance impact:**

- **Power efficiency:** GuC manages GPU power states more efficiently
- **Media acceleration:** HuC enables hardware-accelerated video decoding
- **Lower CPU usage:** GPU handles tasks instead of CPU
- **Better battery life:** More efficient GPU power management

**Use Case:** Intel Gen 9+ graphics (Skylake and newer)

**Compatibility:**

- **Intel Gen 9+ (Skylake and newer):** Full support, recommended
- **Intel Gen 8 (Broadwell):** May have limited support
- **Older Intel GPUs:** Not supported
- **NVIDIA/AMD GPUs:** Not applicable

**Details:**

- GuC = Graphics Micro Controller (handles GPU power management)
- HuC = HDCP Micro Controller (handles media DRM)
- Value 3 = Enable both GuC and HuC
- Improves power efficiency and enables hardware media acceleration

**Bit Values Explained:**

- **`0`:** Disabled (no microcode loading)
- **`1`:** Enable GuC submission (power management)
- **`2`:** Enable HuC loading (media DRM)
- **`3`:** Enable both (1 + 2) ← Recommended

**Trade-offs:**

- **Pro:** Better power efficiency, hardware-accelerated media, lower CPU usage
- **Con:** Requires GuC/HuC firmware (usually included), may cause issues on older kernels

**Real-world example:**

**Without `i915.enable_guc=3`:**

- GPU power management handled in software (CPU)
- Media decoding in software (CPU-intensive)
- Higher CPU usage, worse battery life
- Example: Video playback uses more CPU, drains battery faster

**With `i915.enable_guc=3`:**

- GPU power management handled by GuC (hardware)
- Media decoding accelerated by HuC (hardware)
- Lower CPU usage, better battery life
- Example: Video playback uses less CPU, better battery life

**Troubleshooting:**

**Problem:** GPU errors after enabling GuC/HuC

**Check:**

```bash
dmesg | grep -iE "guc|huc"
# Look for firmware loading errors
```

**Solution:** Ensure firmware packages installed (`linux-firmware`), update kernel if needed

**Learn More:**

- [Arch Wiki: Intel graphics](https://wiki.archlinux.org/title/Intel_graphics#Enable_GuC_/_HuC_firmware_loading)

---

### `nvidia_drm.modeset=1`

**Purpose:** Enables NVIDIA DRM kernel mode setting
**Effect:** Better Wayland support, smoother display management
**Use Case:** NVIDIA GPUs with modern display servers

**Details:**

- KMS = Kernel Mode Setting (display initialization in kernel space)
- Required for Wayland compositors with NVIDIA
- Enables early console framebuffer (splash screens work)
- Allows NVIDIA GPU to drive displays from boot

**Requirements:**

- NVIDIA driver 364.12 or newer
- Add nvidia modules to initramfs for early loading

---

## Display Parameters

### `video=eDP-1:d`

**Purpose:** Disables internal laptop display (eDP-1)
**Effect:** Internal screen remains off, external display becomes primary
**Use Case:** Desktop-replacement mode, docking stations

**Details:**

- eDP = Embedded DisplayPort (internal laptop screen connector)
- `:d` = disable flag
- Prevents internal display from initializing
- Useful when permanently using external monitors

**Syntax:**

- `video=<connector>:d` - Disable display
- `video=<connector>:e` - Enable display
- `video=<connector>:<resolution>` - Force resolution

**Common Connectors:**

- `eDP-1` - Internal laptop screen
- `HDMI-A-1` - HDMI port
- `DP-1` - DisplayPort

**⚠️ Warning:** Only use if you're certain you don't need the internal display. Can make troubleshooting difficult.

---

## Storage Parameters

### `nvme_load=YES`

**Purpose:** Forces early NVMe driver loading
**Effect:** Ensures NVMe SSDs are available early in boot
**Use Case:** Systems with NVMe storage, especially with encryption

**Details:**

- Loads NVMe driver in initramfs stage
- Prevents race conditions during boot
- Necessary for some NVMe RAID or encryption setups

---

### `zswap.enabled=0`

**Purpose:** Disables zswap (compressed swap cache in RAM)
**Effect:** Uses disk-based swap only, simpler memory management
**Use Case:** Systems with traditional swap partitions

**Details:**

- zswap = compressed cache for swap pages in RAM
- Can improve performance on systems with slow storage
- Disabled here because we're not using heavy swapping
- Alternative: Enable zswap if you have limited RAM

**Learn More:**

- [Arch Wiki: Zswap](https://wiki.archlinux.org/title/Zswap)

---

## Logging Parameters

### `quiet`

**Purpose:** Reduces kernel boot messages
**Effect:** Cleaner boot screen, shows only critical errors
**Use Case:** Normal desktop usage

**Details:**

- Suppresses non-critical kernel messages during boot
- Doesn't affect logging (messages still go to journal)
- Remove during troubleshooting to see detailed boot messages

---

### `splash`

**Purpose:** Shows graphical splash screen during boot
**Effect:** Pretty boot screen instead of text scrolling
**Use Case:** User-friendly desktop systems

**Details:**

- Works with plymouth or other splash screen systems
- Requires proper theme configuration
- Can be disabled if you prefer seeing boot messages

---

### `loglevel=3`

**Purpose:** Sets kernel log verbosity level
**Effect:** Shows only errors and critical messages
**Use Case:** Reduce boot noise, faster boot

**Levels:**

- `0` = Emergency (system unusable)
- `1` = Alert (action must be taken)
- `2` = Critical (critical conditions)
- `3` = Error (error conditions)
- `4` = Warning (warning conditions)
- `5` = Notice (normal but significant)
- `6` = Informational (informational messages)
- `7` = Debug (debug-level messages)

**Troubleshooting:** Change to `loglevel=7` when debugging boot issues.

---

### `rd.udev.log_priority=3`

**Purpose:** Sets udev log level during early boot (initramfs)
**Effect:** Quieter boot process, fewer udev messages
**Use Case:** Clean boot screens

**Details:**

- `rd.` prefix means "initramfs/early boot"
- Controls device discovery messages
- Same priority levels as loglevel

---

## Quick Reference Table

| Parameter                               | Purpose                 | Impact                | When to Use           |
| --------------------------------------- | ----------------------- | --------------------- | --------------------- |
| `intel_pstate=active`                   | Intel P-State driver    | Better CPU management | Intel 6th gen+ CPUs   |
| `nowatchdog`                            | Disable watchdog        | Lower overhead        | Desktop systems       |
| `i915.enable_guc=3`                     | Intel GPU microcode     | Better GPU efficiency | Intel Gen 9+ graphics |
| `nvidia.NVreg_DynamicPowerManagement=3` | NVIDIA power mgmt       | Battery savings       | Optimus laptops       |
| `nvidia_drm.modeset=1`                  | NVIDIA KMS              | Wayland support       | NVIDIA GPUs           |
| `video=eDP-1:d`                         | Disable internal screen | External only         | Docking station use   |
| `nvme_load=YES`                         | Early NVMe loading      | Reliable NVMe boot    | NVMe SSDs             |
| `zswap.enabled=0`                       | Disable zswap           | Simpler swap          | Adequate RAM          |
| `quiet splash`                          | Quiet boot              | Clean UI              | Normal use            |
| `loglevel=3`                            | Reduce logging          | Faster boot           | Normal use            |

---

## Configuration Examples

### Performance-Focused (AC Power)

```
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=active i915.enable_guc=3 nowatchdog quiet splash loglevel=3"
```

**Use when:** Maximum performance on desktop/plugged laptop

---

### Battery-Optimized (Laptop)

```
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=active i915.enable_guc=3 nvidia.NVreg_DynamicPowerManagement=3 quiet splash"
```

**Use when:** Balancing performance and battery life

---

### External Monitor Only (Docking Station)

```
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=active nvidia_drm.modeset=1 video=eDP-1:d quiet splash"
```

**Use when:** Laptop permanently docked with external display

---

### Troubleshooting/Debug

```
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=active i915.enable_guc=3 loglevel=7"
```

**Use when:** Debugging boot or hardware issues (verbose output)

---

## How to Apply Changes

1. **Edit GRUB configuration:**

   ```bash
   sudo nano /etc/default/grub
   ```

2. **Modify the line:**

   ```
   GRUB_CMDLINE_LINUX_DEFAULT="<your parameters here>"
   ```

3. **Apply changes:**

   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

4. **Reboot:**

   ```bash
   sudo reboot
   ```

5. **Verify active parameters:**
   ```bash
   cat /proc/cmdline
   ```

---

## Troubleshooting

### Boot Issues After Adding Parameters

**Problem:** System doesn't boot or boots to black screen

**Solution:**

1. Boot into GRUB menu (press ESC during boot)
2. Press 'e' to edit boot entry
3. Remove problematic parameters
4. Press Ctrl+X to boot
5. Once booted, fix `/etc/default/grub` and regenerate

### Parameters Not Taking Effect

**Problem:** Changes don't seem to apply

**Solution:**

```bash
# Verify GRUB was regenerated
ls -l /boot/grub/grub.cfg

# Check current parameters
cat /proc/cmdline

# Ensure you ran grub-mkconfig
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Performance Not Improved

**Problem:** Added performance parameters but no change

**Solution:**

- Parameters affect kernel behavior, not always user-visible
- Check with specific tools (e.g., `cpupower frequency-info` for P-State)
- Combine with userspace tools (TLP, thermald) for best results

---

## Additional Resources

### Official Documentation

- [Linux Kernel Parameters](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
- [GRUB Documentation](https://www.gnu.org/software/grub/manual/)

### Arch Linux Resources

- [Arch Wiki: GRUB](https://wiki.archlinux.org/title/GRUB)
- [Arch Wiki: Kernel parameters](https://wiki.archlinux.org/title/Kernel_parameters)
- [Arch Wiki: Power management](https://wiki.archlinux.org/title/Power_management)

### Hardware-Specific

- [Intel Graphics Documentation](https://01.org/linuxgraphics/documentation)
- [NVIDIA Linux Driver Documentation](https://download.nvidia.com/XFree86/Linux-x86_64/latest/README/)

---

**Note:** Always backup your GRUB configuration before making changes:

```bash
sudo cp /etc/default/grub /etc/default/grub.backup
```
