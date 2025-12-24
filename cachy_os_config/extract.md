# 📘 README — Hardware & System Diagnostics Toolkit

This toolkit provides comprehensive diagnostic tools to gather system information for debugging Linux hardware, ACPI, thermal, GPU, audio, storage, display, and kernel-related issues.

## What Are Diagnostics?

### Why Diagnostics Exist

**The problem:** When something goes wrong with your Linux system, how do you figure out what's wrong?

**Without diagnostics:**

- Guess what might be wrong
- Try random fixes
- Waste time on wrong solutions
- Risk making things worse

**With diagnostics:**

- Gather system information systematically
- Identify the actual problem
- Make informed decisions
- Fix issues efficiently

**Real-world analogy:**

- **Diagnostics = Car diagnostic tool**
- **System = Your car**
- **Problem = Car won't start**
- **Diagnostic tool = Checks engine, battery, fuel system**
- **Result = Identifies actual problem (dead battery)**

**Linux diagnostics work the same way:**

- **Diagnostic scripts = Diagnostic tools**
- **System = Your Linux computer**
- **Problem = Display not working, system slow, etc.**
- **Diagnostic scripts = Check hardware, drivers, configuration**
- **Result = Identifies actual problem (missing driver, wrong config, etc.)**

### What Diagnostics Do

**1. Gather System Information:**

- Hardware details (CPU, GPU, RAM, storage)
- Software configuration (kernel version, drivers, services)
- System state (temperatures, power states, device status)

**2. Identify Issues:**

- Missing drivers or modules
- Configuration problems
- Hardware failures
- Performance bottlenecks

**3. Provide Insights:**

- System capabilities
- Optimization opportunities
- Compatibility information
- Troubleshooting clues

### When to Use Diagnostics

**1. Before Making Changes:**

- Understand your system first
- Verify hardware compatibility
- Check current configuration
- **Example:** Before optimizing power management, run diagnostics to see current power states

**2. When Troubleshooting:**

- System won't boot → Check kernel logs
- Display not working → Check DRM/GPU info
- Performance issues → Check CPU/thermal info
- **Example:** External monitor not detected → Run DRM diagnostics

**3. For Optimization:**

- Identify optimization opportunities
- Verify hardware capabilities
- Check current performance
- **Example:** Want better battery life → Check power management status

**4. Hardware Verification:**

- Verify hardware is detected
- Check driver compatibility
- Confirm device functionality
- **Example:** New USB device not working → Check USB diagnostics

### How Diagnostics Work

**Step-by-step process:**

1. **Run diagnostic script:** Executes commands to gather information
2. **Collect system data:** Reads from `/proc`, `/sys`, system commands
3. **Organize information:** Groups related information together
4. **Output results:** Saves to file or displays on screen
5. **Interpret results:** You analyze output to find issues

**What diagnostics check:**

- **Hardware:** CPU, GPU, RAM, storage, USB devices
- **Drivers:** Kernel modules, driver status, device bindings
- **Configuration:** Kernel parameters, service status, power settings
- **Logs:** Kernel messages, systemd journal, error logs
- **Performance:** Temperatures, frequencies, power states

**Real-world example:**

**Problem:** External monitor not working

**Diagnostic process:**

1. Run `drm-power-diagnostics.sh`
2. Script checks: DRM connectors, EDID data, GPU status
3. Output shows: HDMI connector disconnected, no EDID detected
4. **Result:** Identifies problem (cable issue or GPU not driving HDMI)
5. **Solution:** Check cable, verify GPU driver, check kernel parameters

## Available Diagnostic Tools:

1. **[`diagnostics.sh`](diagnostics.sh)** - Full system diagnostics

   - Complete hardware and software information
   - Single output log file
   - Runs all checks in one pass

2. **[`drm-power-diagnostics.sh`](drm-power-diagnostics.sh)** - DRM, power management, and USB diagnostics ([Documentation](DRM_POWER_DIAGNOSTICS.md))
   - DRM connectors and EDID data
   - USB devices and power states
   - PCI graphics devices
   - TLP and power management configuration
   - systemd/udev logs
   - Multiple organized output files
   - Specialized for display, power, and USB issues

## Features:

- **Command visibility** - see exactly what's being executed
- **Safe operation** - read-only, no system modifications
- **Educational** - learn diagnostic commands as they run
- **Comprehensive coverage** - all major subsystems
- **Multiple formats** - single file or directory-based output

---

# 🛠️ Features

- Collects **GPU/CPU/PCI/ACPI/fan/kernel** debug info
- **Shows commands before output** for transparency and learning
- Safe: **read-only**, does not modify system state
- Fast: prints only important parts
- Works on **any Linux distro** (Arch, Debian, Fedora, etc.)
- Automatically handles missing commands without breaking
- Uses sane limits (no huge logs)

---

# 🚀 Quick Start

Make the script executable and run it:

```bash
chmod +x diagnostics.sh
./diagnostics.sh              # Normal mode
./diagnostics.sh --redact     # Redact personal information
```

OR run directly from URL without downloading:

**For Bash/Zsh:**

```bash
# Normal mode
bash <(curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh)

# With redaction
bash <(curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh) --redact
```

**For Fish shell:**

```fish
# Normal mode
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh | bash

# With redaction
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh | bash -s -- --redact
```

**Universal method (works in any shell):**

```bash
# Normal mode
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh | bash

# With redaction
curl -s https://raw.githubusercontent.com/cjmaaz/ArchStarterPack/master/cachy_os_config/diagnostics.sh | bash -s -- --redact
```

---

# 📦 Optional Packages

Install these for full output:

### Arch Linux

```bash
sudo pacman -S lshw lm_sensors acpi dmidecode usbutils pciutils iproute2 nmcli
```

### Debian/Ubuntu

```bash
sudo apt install lshw lm-sensors acpi dmidecode usbutils pciutils iproute2 network-manager
```

---

# 📄 diagnostics.sh (FULL SCRIPT — SAFE & READY TO USE)

Save this as `diagnostics.sh`:

```bash
#!/usr/bin/env bash

# ============================================
# Linux Hardware/Kernel Diagnostics Collector
# Safe, read-only, information-gathering tool
# ============================================

set -e

OUTPUT_FILE="diagnostics_$(date +%Y-%m-%d_%H-%M-%S).log"

log() {
    echo -e "\n\n==================== $1 ====================\n" | tee -a "$OUTPUT_FILE"
}

echo "[+] Starting diagnostics..."
echo "[+] Output file: $OUTPUT_FILE"
sleep 1

log "System Information (uname -a)"
uname -a | tee -a "$OUTPUT_FILE"

log "OS Release Information (/etc/os-release)"
cat /etc/os-release | tee -a "$OUTPUT_FILE"

log "Kernel Modules (filtered for hardware/drivers)"
lsmod | grep -E "asus|wmi|intel|i915|acpi|therm|fan" 2>/dev/null || true | tee -a "$OUTPUT_FILE"

log "PCI Devices & Kernel Drivers (lspci -k)"
sudo lspci -k | tee -a "$OUTPUT_FILE"

log "USB Devices (lsusb)"
lsusb | tee -a "$OUTPUT_FILE"

log "CPU Info (first 10 lines)"
sed -n '1,10p' /proc/cpuinfo | tee -a "$OUTPUT_FILE"

log "Memory (free -h)"
free -h | tee -a "$OUTPUT_FILE"

log "GPU / DRM Info (lshw -c video)"
sudo lshw -c video 2>/dev/null | tee -a "$OUTPUT_FILE"

log "Intel/i915 Driver Logs"
dmesg | grep -iE "i915|intel" | tail -n 100 | tee -a "$OUTPUT_FILE"

log "Boot Errors (journalctl -b -p 3)"
journalctl -b -p 3 --no-pager | sed -n '1,200p' | tee -a "$OUTPUT_FILE"

log "Thermal Sensors (sensors)"
sensors 2>/dev/null | tee -a "$OUTPUT_FILE"

log "ACPI / Battery / Power"
acpi -V 2>/dev/null | tee -a "$OUTPUT_FILE"

log "Fan / PWM Hardware in /sys"
find /sys/devices -type f -maxdepth 5 -name '*fan*' -o -name 'pwm*' 2>/dev/null | sed -n '1,200p' | tee -a "$OUTPUT_FILE"

log "DMI / System Firmware Info"
sudo dmidecode -t system | sed -n '1,200p' | tee -a "$OUTPUT_FILE"

log "Storage Devices (lsblk)"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,ROTA | tee -a "$OUTPUT_FILE"

log "Network Interfaces"
ip link | tee -a "$OUTPUT_FILE"
nmcli -t -f GENERAL.STATE,DEVICE dev status 2>/dev/null | tee -a "$OUTPUT_FILE"

log "RFKill Status"
rfkill list | tee -a "$OUTPUT_FILE"

log "Audio Sinks"
(pacmd list-sinks 2>/dev/null || pactl list short sinks 2>/dev/null || true) | tee -a "$OUTPUT_FILE"

log "Installed Kernel Headers / DKMS Modules"
(pacman -Qs "linux-headers|dkms" 2>/dev/null) | tee -a "$OUTPUT_FILE"

log "Power Tools (tlp, thermald, powertop)"
systemctl --no-pager status tlp thermald powertop.service 2>/dev/null | tee -a "$OUTPUT_FILE"

log "Enabled Systemd Services"
systemctl list-unit-files --state=enabled | sed -n '1,200p' | tee -a "$OUTPUT_FILE"

log "Relevant Installed Packages"
pacman -Qs "(inxi|lm_sensors|acpi|smartmontools|cpupower|powertop|tlp|thermald|fancontrol|lm_sensors|i8kutils|asusctl|asus-fan-control|acpi_call)" 2>/dev/null | tee -a "$OUTPUT_FILE"

echo -e "\n[✓] Diagnostics complete!"
echo "[✓] Saved to: $OUTPUT_FILE"
```

---

# 📌 Quick Use (One-Shot Command)

Copy and paste this **entire block** into your terminal:

```bash
echo "===uname==="; uname -a
echo "===lsb_release==="; cat /etc/os-release
echo "===kernel modules (interesting)==="; lsmod | grep -E "asus|wmi|intel|i915|acpi|therm|fan" || true
echo "===PCI devices & kernel drivers==="; sudo lspci -k
echo "===USB devices==="; lsusb
echo "===CPU info==="; cat /proc/cpuinfo | sed -n '1,8p'
echo "===Memory==="; free -h
echo "===drm / GPU info==="; sudo lshw -c video || true
echo "===Loaded intel driver / i915 logs==="; dmesg | grep -iE "i915|intel" | tail -n 100
echo "===systemd journal for boot errors==="; journalctl -b -p 3 --no-pager | sed -n '1,200p'
echo "===thermal sensors status==="; sensors || true
echo "===ACPI / battery / power status==="; acpi -V || true
echo "===fan hardware (if any) / pwm devices==="; find /sys/devices -type f -maxdepth 5 -name '*fan*' -o -name 'pwm*' 2>/dev/null | sed -n '1,200p'
echo "===dmidecode summary==="; sudo dmidecode -t system | sed -n '1,200p'
echo "===storage devices==="; lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,ROTA
echo "===network info==="; ip link; nmcli -t -f GENERAL.STATE,DEVICE dev status || true
echo "===rfkill==="; rfkill list
echo "===alsa / pulseaudio sinks==="; pacmd list-sinks 2>/dev/null || pactl list short sinks 2>/dev/null || true
echo "===installed kernel headers and dkms==="; pacman -Qs "linux-headers|dkms" || true
echo "===installed power tools (tlp, thermald, powertop) state==="; systemctl --no-pager status tlp thermald powertop.service || true
echo "===services enabled==="; systemctl list-unit-files --state=enabled | sed -n '1,200p'
echo "===pacman -Qs relevant pkgs==="; pacman -Qs "(inxi|lm_sensors|acpi|smartmontools|cpupower|powertop|tlp|thermald|fancontrol|lm_sensors|i8kutils|asusctl|asus-fan-control|acpi_call)" || true
```

---

# 📚 Full Command Reference & Explanations

Below is a detailed explanation of each diagnostic section collected by the script.

---

## 1. System Kernel & OS Info

### `uname -a` Explained

**What it does:** Shows complete system information (kernel version, architecture, hostname, build date)

**Why it's needed:**

- **Kernel version mismatch:** Kernel, headers, and DKMS modules must match
- **Architecture verification:** Ensure correct packages for your CPU (x86_64, ARM, etc.)
- **Build date:** Helps identify if kernel is outdated
- **Hostname:** Identifies system in logs

**How it works:**

- Reads kernel information from `/proc/version`
- Displays: kernel version, architecture, hostname, build date
- Format: `Linux hostname kernel-version architecture build-info`

**What output means:**

**Example output:**

```
Linux mylaptop 6.1.0-cachyos #1 SMP PREEMPT_DYNAMIC Wed Nov 15 10:30:00 UTC 2023 x86_64 GNU/Linux
```

**Breaking it down:**

- `Linux` = Operating system
- `mylaptop` = Hostname (your computer's name)
- `6.1.0-cachyos` = Kernel version (6.1.0, CachyOS custom build)
- `#1 SMP PREEMPT_DYNAMIC` = Build configuration
- `Wed Nov 15 10:30:00 UTC 2023` = Build date
- `x86_64` = Architecture (64-bit Intel/AMD)
- `GNU/Linux` = OS type

**When to use:**

- **Before installing DKMS modules:** Verify kernel version matches headers
- **Troubleshooting driver issues:** Check if kernel is compatible
- **System identification:** Know what system you're working with
- **Version verification:** Ensure kernel is up to date

**Real-world example:**

**Problem:** NVIDIA driver won't compile

**Diagnostic:**

```bash
uname -a
# Output: Linux mylaptop 6.2.0-cachyos ... x86_64 GNU/Linux
```

**Check:**

```bash
pacman -Qs linux-headers
# Output: linux-headers 6.1.0 (WRONG - version mismatch!)
```

**Solution:** Install matching kernel headers (`linux-headers 6.2.0`)

### `/etc/os-release` Explained

**What it does:** Shows Linux distribution name, version, and identification information

**Why it's needed:**

- **Distribution identification:** Know which Linux distro you're using
- **Version information:** Check distro version
- **Package manager:** Determines which package manager to use
- **Compatibility:** Some tools/distros have specific requirements

**How it works:**

- Reads from `/etc/os-release` file (standard Linux file)
- Contains distribution metadata
- Used by many tools to identify system

**What output means:**

**Example output:**

```
NAME="CachyOS"
ID=cachyos
PRETTY_NAME="CachyOS"
VERSION_ID="2023.11.15"
```

**Breaking it down:**

- `NAME` = Distribution name
- `ID` = Distribution identifier (used by scripts)
- `PRETTY_NAME` = Human-readable name
- `VERSION_ID` = Version number

**When to use:**

- **Package installation:** Know which package manager (pacman for Arch/CachyOS)
- **Script compatibility:** Some scripts check distro
- **Documentation:** Reference correct distro-specific docs
- **Troubleshooting:** Some issues are distro-specific

**Real-world example:**

**Problem:** Following Ubuntu guide on CachyOS

**Diagnostic:**

```bash
cat /etc/os-release
# Output: NAME="CachyOS" (not Ubuntu!)
```

**Solution:** Use Arch/CachyOS-specific instructions instead

---

## 2. Kernel Modules (Filtered)

### `lsmod | grep -E "asus|wmi|intel|i915|acpi|therm|fan"` Explained

**What it does:** Shows which hardware-related kernel modules are currently loaded

**Why it's needed:**

- **Driver verification:** Check if required drivers are loaded
- **Hardware support:** Verify hardware is supported
- **Troubleshooting:** Missing modules indicate driver problems
- **Compatibility:** Some features require specific modules

**How it works:**

- `lsmod` = List all loaded kernel modules
- `grep -E` = Filter for specific patterns (asus, wmi, intel, etc.)
- Shows module name, size, and dependencies

**What output means:**

**Example output:**

```
i915                 1234567  45
asus_wmi               12345   2
acpi_thermal            1234   1 thermal
```

**Breaking it down:**

- **Module name** (first column) = Driver name
- **Size** (second column) = Memory used by module
- **Dependencies** (third column) = Other modules this depends on

**Key modules explained:**

**`asus_wmi` / `asus_nb_wmi`:**

- **What:** ASUS laptop hardware interface driver
- **Why needed:** Enables ASUS-specific features (fan control, keyboard backlight, etc.)
- **When missing:** ASUS features won't work
- **Example:** Fan control, function keys, battery management

**`i915`:**

- **What:** Intel integrated graphics driver
- **Why needed:** Required for Intel GPU to work
- **When missing:** No display output, graphics won't work
- **Example:** Intel UHD 620, Intel Iris graphics

**`thermal` / `acpi_thermal`:**

- **What:** Thermal management drivers
- **Why needed:** CPU/GPU temperature monitoring and throttling
- **When missing:** Overheating risk, no temperature readings
- **Example:** CPU temperature sensors, thermal throttling

**`fan`:**

- **What:** Fan control driver
- **Why needed:** Fan speed control and monitoring
- **When missing:** Can't control fan speed manually
- **Example:** Fan RPM reading, PWM control

**`wmi`:**

- **What:** Windows Management Instrumentation interface
- **Why needed:** Vendor-specific hardware management
- **When missing:** Some laptop features won't work
- **Example:** ASUS, Dell, Lenovo specific features

**When to use:**

- **Hardware not working:** Check if driver module is loaded
- **Feature missing:** Verify required module exists
- **After kernel update:** Ensure modules still load
- **Troubleshooting:** Identify missing drivers

**Real-world example:**

**Problem:** Fan control not working on ASUS laptop

**Diagnostic:**

```bash
lsmod | grep -E "asus|fan"
# Output: (empty - no modules found!)
```

**Solution:** Load missing module:

```bash
sudo modprobe asus_wmi
```

**Verify:**

```bash
lsmod | grep asus
# Output: asus_wmi 12345 2 (now loaded!)
```

---

## 3. PCI Devices & Drivers

### `sudo lspci -k` Explained

**What it does:** Shows all PCI devices connected to your system and which kernel drivers they're using

**Why it's needed:**

- **Hardware detection:** Verify hardware is detected by system
- **Driver identification:** See which driver controls each device
- **Troubleshooting:** Identify missing or wrong drivers
- **Device conflicts:** Detect driver conflicts

**How it works:**

- `lspci` = List PCI devices (reads from `/proc/bus/pci/devices`)
- `-k` = Show kernel drivers for each device
- Requires `sudo` to read some device information

**What output means:**

**Example output:**

```
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 620 (rev 07)
	Subsystem: ASUSTeK Computer Inc. Device 1c52
	Kernel driver in use: i915
	Kernel modules: i915

01:00.0 VGA compatible controller: NVIDIA Corporation GM108M [GeForce MX130] (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 1c52
	Kernel driver in use: nvidia
	Kernel modules: nvidia
```

**Breaking it down:**

- **PCI address** (`00:02.0`) = Device location on PCI bus
- **Device type** (`VGA compatible controller`) = What the device is
- **Vendor/Model** (`Intel Corporation UHD Graphics 620`) = Hardware details
- **Kernel driver in use** = Currently active driver
- **Kernel modules** = Available drivers for this device

**Absolutely essential for:**

**1. Discrete GPU vs Integrated GPU Diagnosis:**

- **Problem:** Which GPU is being used?
- **Diagnostic:** `lspci -k | grep VGA`
- **Shows:** Both Intel (integrated) and NVIDIA (discrete) GPUs
- **Use case:** Optimus/hybrid graphics troubleshooting

**2. NVMe Issues:**

- **Problem:** NVMe SSD not detected
- **Diagnostic:** `lspci -k | grep -i nvme`
- **Shows:** NVMe controller and driver status
- **Use case:** Boot issues, storage problems

**3. Wi-Fi/Bluetooth Module Detection:**

- **Problem:** Wi-Fi not working
- **Diagnostic:** `lspci -k | grep -i network`
- **Shows:** Wi-Fi card and driver
- **Use case:** Network connectivity issues

**4. Conflicting Driver Loading:**

- **Problem:** Device not working, wrong driver loaded
- **Diagnostic:** Check "Kernel driver in use" vs "Kernel modules"
- **Shows:** Driver mismatch or missing driver
- **Use case:** Driver conflicts, hardware not working

**When to use:**

- **Hardware not detected:** Verify PCI device exists
- **Driver problems:** Check which driver is loaded
- **GPU issues:** Identify which GPU is active
- **Device conflicts:** Find driver conflicts

**Real-world example:**

**Problem:** External monitor not working, suspect GPU issue

**Diagnostic:**

```bash
sudo lspci -k | grep VGA
# Output:
# 00:02.0 VGA: Intel UHD 620 (driver: i915) ✅
# 01:00.0 VGA: NVIDIA MX130 (driver: nouveau) ❌ WRONG!
```

**Problem identified:** NVIDIA using wrong driver (`nouveau` instead of `nvidia`)

**Solution:** Install NVIDIA proprietary driver, blacklist nouveau

---

## 4. USB Devices

### `lsusb`

Detects:

- Mouse / keyboard
- Camera
- Touchpad controller
- Dongles (Logitech, Razer, Bluetooth)

---

## 5. CPU Information

### `/proc/cpuinfo | head` Explained

**What it does:** Shows detailed information about your CPU(s)

**Why it's needed:**

- **CPU identification:** Know which CPU you have
- **Feature verification:** Check CPU capabilities (virtualization, encryption, etc.)
- **Performance tuning:** Understand CPU features for optimization
- **Compatibility:** Verify CPU supports required features

**How it works:**

- Reads from `/proc/cpuinfo` (kernel-provided CPU information)
- Shows per-core information (repeated for each core)
- `head` shows first few lines (first core's info)

**What output means:**

**Example output:**

```
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 142
model name	: Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
stepping	: 10
microcode	: 0x96
cpu MHz		: 800.000
cache size	: 6144 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp md_clear flush_l1d
```

**Breaking it down:**

**Key fields:**

**`model name`:** CPU model and base frequency

- **Example:** `Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz`
- **Meaning:** Intel Core i5-8250U, base frequency 1.60GHz
- **Use:** Identify CPU model

**`cpu MHz`:** Current CPU frequency

- **Example:** `800.000` (800 MHz)
- **Meaning:** CPU currently running at 800 MHz (power-saving mode)
- **Use:** Check CPU frequency scaling

**`cache size`:** CPU cache size

- **Example:** `6144 KB` (6 MB)
- **Meaning:** L3 cache size
- **Use:** Performance optimization

**`flags`:** CPU feature flags (most important!)

- **Example:** `vmx` (Intel VT-x), `aes` (AES-NI), `avx2` (AVX2 instructions)
- **Meaning:** CPU capabilities
- **Use:** Verify features for virtualization, encryption, performance

**Important flags explained:**

**`vmx` (Intel) / `svm` (AMD):**

- **What:** Hardware virtualization support
- **Why needed:** Required for KVM/VMs
- **When missing:** Can't use virtualization

**`aes`:**

- **What:** AES encryption acceleration
- **Why needed:** Faster disk encryption
- **When missing:** Slower encryption performance

**`avx` / `avx2`:**

- **What:** Advanced vector instructions
- **Why needed:** Performance optimization
- **When missing:** Some optimizations unavailable

**When to use:**

- **Virtualization setup:** Verify VT-x/AMD-V support
- **Performance tuning:** Check available CPU features
- **Compatibility:** Verify CPU supports required features
- **Troubleshooting:** Check CPU frequency scaling

**Real-world example:**

**Problem:** VM won't start, "KVM not available"

**Diagnostic:**

```bash
grep -E "vmx|svm" /proc/cpuinfo
# Output: (empty - no virtualization flags!)
```

**Problem identified:** Virtualization disabled in BIOS or CPU doesn't support it

**Solution:** Enable VT-x/AMD-V in BIOS, or CPU doesn't support virtualization

---

## 6. Memory (RAM)

### `free -h` Explained

**What it does:** Shows memory (RAM) usage statistics in human-readable format

**Why it's needed:**

- **Memory monitoring:** Check if system has enough RAM
- **Performance troubleshooting:** Identify memory bottlenecks
- **Swap usage:** Check if system is using swap (indicates low RAM)
- **Resource planning:** Understand memory requirements

**How it works:**

- Reads from `/proc/meminfo` (kernel-provided memory information)
- Shows total, used, free, available, and swap memory
- `-h` flag = Human-readable format (GB, MB instead of bytes)

**What output means:**

**Example output:**

```
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       2.1Gi       1.2Gi       234Mi       4.4Gi       5.1Gi
Swap:          2.0Gi          0B       2.0Gi
```

**Breaking it down:**

**Memory (Mem) row:**

- **total** = Total installed RAM (7.7 GB)
- **used** = RAM currently in use by applications (2.1 GB)
- **free** = Unused RAM (1.2 GB)
- **shared** = RAM shared between processes (234 MB)
- **buff/cache** = RAM used for buffers and cache (4.4 GB)
- **available** = RAM available for new applications (5.1 GB)

**Swap row:**

- **total** = Total swap space (2.0 GB)
- **used** = Swap currently in use (0B = not using swap)
- **free** = Unused swap (2.0 GB)

**Key concepts:**

**Buffers vs Cache:**

- **Buffers:** RAM used for temporary data (file I/O)
- **Cache:** RAM used to cache frequently accessed data
- **Both are reclaimable:** Can be freed if applications need RAM
- **Not "wasted":** Improves performance by caching data

**Available vs Free:**

- **Free:** Completely unused RAM
- **Available:** RAM that can be used (free + reclaimable cache)
- **Available is more important:** Shows actual usable RAM

**Swap usage:**

- **0B used:** Good (system has enough RAM)
- **>0B used:** System is using swap (may indicate low RAM)
- **High swap usage:** Performance degradation (swap is slower than RAM)

**When to use:**

- **Performance issues:** Check if low RAM is causing slowdowns
- **Memory planning:** Understand memory requirements
- **Troubleshooting:** Identify memory-related problems
- **Monitoring:** Track memory usage over time

**Real-world example:**

**Problem:** System feels slow, applications lagging

**Diagnostic:**

```bash
free -h
# Output:
# Mem: 7.7Gi total, 2.1Gi used, 1.2Gi free, 5.1Gi available ✅
# Swap: 2.0Gi total, 1.5Gi used ❌ HIGH SWAP USAGE!
```

**Problem identified:** System using swap heavily (1.5GB) → Low available RAM

**Solution:** Close applications, add more RAM, or optimize memory usage

---

## 7. GPU Details

### `sudo lshw -c video` Explained

**What it does:** Shows detailed information about graphics/video hardware

**Why it's needed:**

- **GPU identification:** Know which GPU(s) you have
- **Driver verification:** Check if correct driver is loaded
- **Memory information:** See GPU memory (VRAM)
- **Initialization check:** Verify GPU initialized correctly

**How it works:**

- `lshw` = List hardware (reads hardware information)
- `-c video` = Show only video/graphics devices
- Requires `sudo` to read hardware details

**What output means:**

**Example output:**

```
*-display
     description: VGA compatible controller
     product: UHD Graphics 620
     vendor: Intel Corporation
     physical id: 2
     bus info: pci@0000:00:02.0
     version: 07
     width: 64 bits
     clock: 33MHz
     capabilities: vga_controller bus_master cap_list rom
     configuration: driver=i915 latency=0
     resources: irq:131 memory:f6000000-f6ffffff memory:e0000000-efffffff ioport:f000(size=64) memory:c0000-dffff
```

**Breaking it down:**

**Key fields:**

**`product`:** GPU model name

- **Example:** `UHD Graphics 620`
- **Meaning:** Intel UHD Graphics 620 integrated GPU
- **Use:** Identify GPU model

**`vendor`:** GPU manufacturer

- **Example:** `Intel Corporation`
- **Meaning:** Intel GPU
- **Use:** Identify GPU vendor (Intel, AMD, NVIDIA)

**`driver`:** Currently loaded driver

- **Example:** `driver=i915`
- **Meaning:** Intel i915 driver is loaded
- **Use:** Verify correct driver is active

**`memory`:** GPU memory addresses

- **Example:** `memory:f6000000-f6ffffff`
- **Meaning:** GPU memory mapped addresses
- **Use:** Memory allocation information

**`capabilities`:** GPU features

- **Example:** `vga_controller bus_master`
- **Meaning:** GPU capabilities
- **Use:** Feature verification

**Useful to check Intel/AMD/NVIDIA initialization:**

**Intel GPU:**

- **Driver:** Should show `driver=i915`
- **When missing:** Display won't work, black screen
- **Check:** `lshw -c video` shows driver status

**AMD GPU:**

- **Driver:** Should show `driver=amdgpu` or `driver=radeon`
- **When missing:** Display issues, performance problems
- **Check:** Verify driver loaded correctly

**NVIDIA GPU:**

- **Driver:** Should show `driver=nvidia`
- **When missing:** Using nouveau (open-source, slower)
- **Check:** Verify proprietary driver loaded

**When to use:**

- **Display issues:** Check GPU initialization
- **Driver problems:** Verify correct driver loaded
- **GPU identification:** Know which GPU you have
- **Performance issues:** Check GPU driver status

**Real-world example:**

**Problem:** External monitor not detected

**Diagnostic:**

```bash
sudo lshw -c video
# Output:
# *-display: Intel UHD 620 (driver=i915) ✅
# *-display: NVIDIA MX130 (driver=nouveau) ❌ WRONG DRIVER!
```

**Problem identified:** NVIDIA using wrong driver (nouveau instead of nvidia)

**Solution:** Install NVIDIA proprietary driver, blacklist nouveau

---

## 8. Intel GPU / i915 Logs

### `dmesg | grep -iE "i915|intel" | tail -100` Explained

**What it does:** Shows kernel messages related to Intel graphics driver (i915)

**Why it's needed:**

- **Error detection:** Find GPU-related errors and warnings
- **Initialization issues:** Check if GPU initialized correctly
- **Driver problems:** Identify driver crashes or failures
- **Troubleshooting:** Find clues about display issues

**How it works:**

- `dmesg` = Display kernel messages (reads from kernel ring buffer)
- `grep -iE "i915|intel"` = Filter for Intel/i915 messages (case-insensitive)
- `tail -100` = Show last 100 lines (most recent messages)

**What output means:**

**Example output (successful initialization):**

```
[    1.234567] i915 0000:00:02.0: [drm] Initialized i915 1.6.0
[    1.234890] i915 0000:00:02.0: [drm] GuC firmware version X.Y.Z
[    1.235123] i915 0000:00:02.0: [drm] HuC firmware loaded
```

**Example output (errors):**

```
[    2.345678] i915 0000:00:02.0: [drm] *ERROR* Display pipe A failed
[    2.345890] i915 0000:00:02.0: [drm] *ERROR* GTT allocation failed
[    2.346123] i915 0000:00:02.0: [drm] *ERROR* Panel power sequence timeout
```

**Breaking it down:**

**Successful messages:**

- **`Initialized i915`:** Driver loaded successfully ✅
- **`GuC firmware version`:** GPU microcontroller firmware loaded ✅
- **`HuC firmware loaded`:** HDCP microcontroller firmware loaded ✅

**Error messages:**

**`Display pipe A failed`:**

- **What:** Display output pipe (A, B, or C) failed to initialize
- **Meaning:** Display won't work on that pipe
- **Cause:** Hardware issue, driver bug, or configuration problem
- **Solution:** Check hardware, update driver, try different kernel parameters

**`GTT allocation failed`:**

- **What:** Graphics Translation Table (GPU memory management) allocation failed
- **Meaning:** GPU can't allocate memory
- **Cause:** Out of memory, driver bug, or hardware issue
- **Solution:** Check system memory, update driver, check hardware

**`Panel power sequence timeout`:**

- **What:** Display panel power-on sequence timed out
- **Meaning:** Display panel didn't power on correctly
- **Cause:** Hardware issue, wrong panel configuration, or driver bug
- **Solution:** Check display hardware, verify panel configuration

**Especially useful when dealing with:**

**1. Black Screens:**

- **Problem:** Screen stays black after boot
- **Check:** Look for `*ERROR*` messages in i915 logs
- **Common errors:** Display pipe failures, panel power issues
- **Solution:** Check errors, update driver, try kernel parameters

**2. Wayland Crashes:**

- **Problem:** Wayland compositor crashes
- **Check:** Look for GPU errors in i915 logs
- **Common errors:** VRAM allocation failures, display pipe errors
- **Solution:** Check GPU errors, update driver, disable problematic features

**3. eDP/HDMI Port Issues:**

- **Problem:** Internal display (eDP) or external monitor (HDMI) not working
- **Check:** Look for port-specific errors
- **Common errors:** Port initialization failures, EDID read errors
- **Solution:** Check port-specific errors, verify connections, check kernel parameters

**When to use:**

- **Display not working:** Check for GPU errors
- **Wayland crashes:** Look for GPU-related errors
- **External monitor issues:** Check for port-specific errors
- **After kernel update:** Verify GPU still initializes correctly

**Real-world example:**

**Problem:** External HDMI monitor not detected

**Diagnostic:**

```bash
dmesg | grep -iE "i915|intel" | tail -100
# Output:
# [ERROR] i915: HDMI-A-1: EDID read failed
# [ERROR] i915: Display pipe B failed
```

**Problem identified:** HDMI port (pipe B) failed, EDID read error

**Solution:** Check HDMI cable, try different port, check kernel parameters for HDMI

---

## 9. Boot Errors

### `journalctl -b -p 3` Explained

**What it does:** Shows only error-level messages from the current boot session

**Why it's needed:**

- **Error detection:** Find critical errors that occurred during boot
- **Troubleshooting:** Identify what went wrong during system startup
- **System health:** Check if system has critical issues
- **Problem diagnosis:** Find root cause of boot or runtime issues

**How it works:**

- `journalctl` = Query systemd journal (system logs)
- `-b` = Current boot only (since last reboot)
- `-p 3` = Priority level 3 (errors and above)
- Shows only critical messages (errors, not warnings/info)

**Priority levels:**

- `0` = Emergency (system unusable)
- `1` = Alert (action must be taken)
- `2` = Critical (critical conditions)
- `3` = Error (error conditions) ← This level
- `4` = Warning (warning conditions)
- `5` = Notice (normal but significant)
- `6` = Informational
- `7` = Debug

**What output means:**

**Example output (no errors):**

```
(empty - no errors, system is healthy!)
```

**Example output (with errors):**

```
Dec 03 14:30:15 mylaptop kernel: ACPI Error: [\_SB_.PCI0.XHC_.RHUB.HS11] Namespace lookup failure
Dec 03 14:30:16 mylaptop systemd[1]: Failed to start NetworkManager.service
Dec 03 14:30:17 mylaptop kernel: i915 0000:00:02.0: [drm] *ERROR* Display pipe A failed
```

**Breaking it down:**

**Error format:**

- **Timestamp:** When error occurred
- **Hostname:** Which system (mylaptop)
- **Component:** What caused error (kernel, systemd, service)
- **Error message:** What went wrong

**Helps detect:**

**1. ACPI Issues:**

- **What:** Advanced Configuration and Power Interface errors
- **Example:** `ACPI Error: Namespace lookup failure`
- **Meaning:** BIOS ACPI tables have problems
- **Impact:** Power management issues, device detection problems
- **Solution:** Update BIOS, add kernel parameters to work around ACPI bugs

**2. Driver Failures:**

- **What:** Hardware driver failed to load or initialize
- **Example:** `i915: [drm] *ERROR* Display pipe failed`
- **Meaning:** GPU driver failed to initialize display
- **Impact:** Display won't work, GPU features unavailable
- **Solution:** Update driver, check hardware, try kernel parameters

**3. Firmware Bugs:**

- **What:** Firmware (BIOS/UEFI) related errors
- **Example:** `firmware: failed to load i915/...`
- **Meaning:** Firmware files missing or incompatible
- **Impact:** Hardware features unavailable
- **Solution:** Install firmware packages, update BIOS

**4. Service Failures:**

- **What:** Systemd service failed to start
- **Example:** `Failed to start NetworkManager.service`
- **Meaning:** Service couldn't start (dependency issue, configuration error)
- **Impact:** Service unavailable (network, display, etc.)
- **Solution:** Check service dependencies, fix configuration, check logs

**When to use:**

- **System won't boot:** Check for critical errors
- **Hardware not working:** Look for driver errors
- **Services not starting:** Check for service failures
- **Performance issues:** Look for recurring errors
- **After system changes:** Verify no new errors introduced

**Real-world example:**

**Problem:** System boots but display is black

**Diagnostic:**

```bash
journalctl -b -p 3
# Output:
# Dec 03 14:30:17 mylaptop kernel: i915: [drm] *ERROR* Display pipe A failed
# Dec 03 14:30:18 mylaptop kernel: i915: [drm] *ERROR* Panel power sequence timeout
```

**Problem identified:** GPU display pipe failed, panel power sequence timeout

**Solution:** Check GPU driver, try kernel parameters (`i915.enable_guc=3`), check hardware

---

## 10. Thermal Sensors

### `sensors` Explained

**What it does:** Displays temperature readings from hardware sensors (CPU, GPU, motherboard) and fan speeds

**Why it's needed:**

- **Temperature monitoring:** Check if system is overheating
- **Thermal troubleshooting:** Identify thermal issues
- **Performance optimization:** Understand thermal limits
- **Fan control:** Verify fan operation

**How it works:**

- Reads from `/sys/class/hwmon/` (hardware monitoring interface)
- Requires `lm_sensors` package and sensor drivers
- Shows temperatures in Celsius, fan speeds in RPM

**What output means:**

**Example output:**

```
acpitz-acpi-0
Adapter: ACPI interface
temp1:        +45.0°C  (crit = +95.0°C)

coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +42.0°C  (high = +80.0°C, crit = +100.0°C)
Core 0:        +40.0°C  (high = +80.0°C, crit = +100.0°C)
Core 1:        +41.0°C  (high = +80.0°C, crit = +100.0°C)

asus-isa-0000
Adapter: ISA adapter
fan1:        2800 RPM
```

**Breaking it down:**

**Temperature readings:**

- **Current temperature:** `+45.0°C` (actual temperature)
- **High threshold:** `high = +80.0°C` (warning temperature)
- **Critical threshold:** `crit = +100.0°C` (dangerous temperature)

**Fan speeds:**

- **RPM:** Rotations per minute (fan speed)
- **Example:** `2800 RPM` (fan spinning at 2800 RPM)

**What temperatures mean:**

**Normal temperatures:**

- **CPU idle:** 30-50°C (cool)
- **CPU load:** 50-80°C (warm but acceptable)
- **GPU idle:** 30-50°C
- **GPU load:** 60-85°C

**Warning temperatures:**

- **CPU:** >80°C (throttling may occur)
- **GPU:** >85°C (performance may degrade)

**Critical temperatures:**

- **CPU:** >100°C (system may shutdown to prevent damage)
- **GPU:** >90°C (may cause damage)

**When to use:**

- **Overheating issues:** Check if temperatures are too high
- **Performance problems:** Verify thermal throttling
- **Fan troubleshooting:** Check if fans are spinning
- **System optimization:** Understand thermal behavior

**Real-world example:**

**Problem:** System feels slow, applications lagging

**Diagnostic:**

```bash
sensors
# Output:
# Core 0: +95.0°C (high = +80.0°C, crit = +100.0°C) ❌ TOO HOT!
# fan1: 0 RPM ❌ FAN NOT SPINNING!
```

**Problem identified:** CPU overheating (95°C), fan not spinning

**Solution:** Check fan hardware, enable fan control, check thermal management

---

## 11. ACPI / Battery / Power

### `acpi -V` Explained

**What it does:** Shows Advanced Configuration and Power Interface (ACPI) information, including battery status, power adapter status, and thermal information

**Why it's needed:**

- **Battery monitoring:** Check battery health and charge level
- **Power management:** Verify power adapter connection
- **Thermal status:** Check thermal zones and cooling
- **Troubleshooting:** Identify power-related issues

**How it works:**

- Reads from `/proc/acpi/` and `/sys/class/power_supply/`
- Requires `acpi` package
- Shows battery, AC adapter, and thermal information

**What output means:**

**Example output (on battery):**

```
Battery 0: Discharging, 75%, 02:30:00 remaining
Battery 0: design capacity 4200 mAh, last full capacity 3800 mAh = 90%
Adapter 0: off-line
Thermal 0: ok, 45.0 degrees C
```

**Example output (on AC power):**

```
Battery 0: Charging, 85%, 00:15:00 until charged
Battery 0: design capacity 4200 mAh, last full capacity 3800 mAh = 90%
Adapter 0: on-line
Thermal 0: ok, 42.0 degrees C
```

**Breaking it down:**

**Battery status:**

- **State:** `Discharging` (on battery) or `Charging` (on AC)
- **Charge level:** `75%` (current battery percentage)
- **Time remaining:** `02:30:00` (2 hours 30 minutes)
- **Design capacity:** `4200 mAh` (original battery capacity)
- **Last full capacity:** `3800 mAh` (current maximum capacity)
- **Health:** `90%` (3800/4200 = battery health)

**Adapter status:**

- **`on-line`:** AC adapter connected, charging
- **`off-line`:** AC adapter disconnected, on battery

**Thermal status:**

- **Temperature:** `45.0 degrees C` (current temperature)
- **Status:** `ok` (temperature within normal range)

**What battery health means:**

**100% health:**

- Battery holds full design capacity
- Example: 4200 mAh design, 4200 mAh actual

**90% health:**

- Battery holds 90% of design capacity
- Example: 4200 mAh design, 3800 mAh actual
- **Normal:** Batteries degrade over time

**<80% health:**

- Battery significantly degraded
- **Consider:** Battery replacement if <70%

**When to use:**

- **Battery issues:** Check battery health and charge level
- **Power problems:** Verify AC adapter connection
- **Battery life:** Monitor battery degradation
- **Thermal issues:** Check thermal status

**Real-world example:**

**Problem:** Battery drains very quickly

**Diagnostic:**

```bash
acpi -V
# Output:
# Battery 0: Discharging, 50%, 00:30:00 remaining ❌ SHORT BATTERY LIFE
# Battery 0: design capacity 4200 mAh, last full capacity 2100 mAh = 50% ❌ DEGRADED!
```

**Problem identified:** Battery health at 50% (severely degraded)

**Solution:** Consider battery replacement, optimize power management settings

---

## 12. Fan Hardware Detection

### `find /sys/devices ... fan/pwm` Explained

**What it does:** Searches for fan and PWM (Pulse Width Modulation) control devices in the system

**Why it's needed:**

- **Fan detection:** Verify fans are detected by kernel
- **Fan control capability:** Check if manual fan control is possible
- **Hardware verification:** Identify fan hardware paths
- **Troubleshooting:** Find fan-related sysfs interfaces

**How it works:**

- `find` = Search for files/directories
- `/sys/devices` = System device tree (kernel device information)
- Searches for files/directories containing "fan" or "pwm" in name
- Shows paths to fan control interfaces

**What output means:**

**Example output:**

```
/sys/devices/platform/asus-nb-wmi/hwmon/hwmon0/fan1_input
/sys/devices/platform/asus-nb-wmi/hwmon/hwmon0/pwm1_enable
/sys/devices/platform/asus-nb-wmi/hwmon/hwmon0/pwm1
```

**Breaking it down:**

**Fan files:**

- **`fan1_input`:** Fan speed reading (RPM)
- **Example:** Read `cat fan1_input` → `2800` (2800 RPM)
- **Use:** Monitor fan speed

**PWM control files:**

- **`pwm1_enable`:** Fan control mode
  - `0` = Manual control disabled
  - `1` = Manual control enabled
  - `2` = BIOS/automatic control (most common)
- **`pwm1`:** PWM value (fan speed control)
  - Range: 0-255 (0 = off, 255 = max speed)
  - Only writable if `pwm1_enable = 1`

**Useful to determine if manual fan control is possible:**

**If `pwm1` exists:**

- Manual fan control possible
- Can set fan speed programmatically
- Requires `pwm1_enable = 1`

**If `pwm1` doesn't exist:**

- No manual fan control
- Fan controlled by BIOS/hardware
- Common on many laptops (including ASUS X507UF)

**When to use:**

- **Fan not working:** Check if fan hardware detected
- **Fan control setup:** Verify manual control capability
- **Thermal troubleshooting:** Check fan hardware paths
- **Hardware verification:** Confirm fan detection

**Real-world example:**

**Problem:** System overheating, fan not spinning

**Diagnostic:**

```bash
find /sys/devices -type f -name '*fan*' -o -name 'pwm*' 2>/dev/null
# Output:
# /sys/.../fan1_input ✅ (fan detected)
# /sys/.../pwm1_enable ✅ (control file exists)
# (no pwm1 file) ❌ (manual control not available)
```

**Check fan speed:**

```bash
cat /sys/.../fan1_input
# Output: 0 ❌ (fan not spinning!)
```

**Check control mode:**

```bash
cat /sys/.../pwm1_enable
# Output: 2 (BIOS control - can't manually control)
```

**Problem identified:** Fan hardware detected but not spinning, BIOS-controlled (can't manually fix)

**Solution:** Check BIOS fan settings, verify hardware, use thermal management (thermald) instead

---

## 13. System Firmware Info

### `sudo dmidecode -t system`

Shows:

- Manufacturer
- BIOS version
- Laptop model
- Serial # (use `--redact` to mask)

---

## 14. Storage

### `lsblk`

Shows all disks, partitions, SSD/HDD rotation speed.

---

## 15. Network

### `ip link`

### `nmcli ...`

Shows:

- Network interfaces
- Whether they are connected
- States

---

## 16. RFKill (Wireless Kill Switches)

### `rfkill list`

Detects soft/hard blocks for:

- Wi-Fi
- Bluetooth
- WWAN

---

## 17. Audio Output Devices

### `pacmd list-sinks` / `pactl list short sinks`

Shows all audio output routes and PulseAudio devices.

---

## 18. Kernel Headers & DKMS

### `pacman -Qs "linux-headers|dkms"`

Ensures DKMS builds correctly for NVIDIA, ZFS, VirtualBox, etc.

---

## 19. Power/Thermal Services

### `systemctl status tlp thermald powertop`

Shows if they are running or conflicting.

---

## 20. Enabled Services

### `systemctl list-unit-files --state=enabled`

Shows important services that may interfere with:

- Power
- Audio
- Fan control
- GPU drivers

---

## 21. Package Search for Important Tools

### `pacman -Qs "(inxi|acpi|smartmontools|cpupower|...)"`

Checks if important diagnostic tools are installed.

# ⚠️ Safety Notes

- **This script is 100% safe** → it only _reads_ information.
- It uses only standard Linux tools + basic privileges.
- Some commands need `sudo` (lspci, dmidecode, lshw).
- No configuration files are modified.
- No services are restarted.

---

# 📑 What This Script Helps Diagnose (Examples)

### ✔ GPU issues

- Black screen
- HDMI/eDP not detected
- i915 crashes
- NVIDIA/Intel hybrid issues

### ✔ Thermal + ACPI problems

- Overheating
- Fan not spinning
- Broken ACPI tables

### ✔ Audio device issues

- No sound output
- Wrong default sink

### ✔ Power issues

- Poor battery life
- TLP/thermald conflicts

### ✔ Kernel mismatch issues

- Missing headers
- DKMS module failures

---

## Next Steps

After running diagnostics and understanding your system:

1. **Configure your system:** See [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md) for ASUS X507UF optimization
2. **Understand GRUB parameters:** See [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md) for kernel parameter explanations
3. **Troubleshoot display issues:** See [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md) for display diagnostics
4. **Explore optional diagnostics:** See [`optional_extract.md`](optional_extract.md) for advanced diagnostics
5. **Return to main guide:** See [`README.md`](README.md) for overview and navigation
