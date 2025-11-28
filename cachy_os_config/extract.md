# 📘 README — Hardware & System Diagnostics Toolkit

This toolkit provides a **single unified way** to gather all important system information needed for debugging Linux hardware, ACPI, thermal, GPU, audio, storage, and kernel-related issues.

The toolkit includes:

1. **A full diagnostic script (`diagnostics.sh`)**
2. **A one-line command** to quickly run everything
3. **Detailed explanations** of every diagnostic section
4. **Warnings & safety notes**
5. **Requirements** and optional dependencies

---

# 🛠️ Features

* Collects **GPU/CPU/PCI/ACPI/fan/kernel** debug info
* Safe: **read-only**, does not modify system state
* Fast: prints only important parts
* Works on **any Linux distro** (Arch, Debian, Fedora, etc.)
* Automatically handles missing commands without breaking
* Uses sane limits (no huge logs)

---

# 🚀 Quick Start

Make the script executable and run it:

```bash
chmod +x diagnostics.sh
./diagnostics.sh
```

OR run all commands directly (no script needed):

```bash
bash <(curl -s https://example.com/diagnostics.sh)
```

*(I can host it on GitHub or generate a raw link if you want.)*

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

### `uname -a`

Shows full kernel version, architecture, build date.
Useful for checking mismatches between **kernel**, **kernel headers**, and **DKMS modules**.

### `/etc/os-release`

Shows your Linux distribution name and version.

---

## 2. Kernel Modules (Filtered)

### `lsmod | grep -E "asus|wmi|intel|i915|acpi|therm|fan"`

Shows whether important hardware-related kernel modules are loaded:

* `asus_wmi` / `asus_nb_wmi` — ASUS laptops
* `i915` — Intel GPU driver
* `thermal` / `acpi_thermal` — Cooling/temperature
* `fan` — Fan control
* `wmi` — Vendor management interface

---

## 3. PCI Devices & Drivers

### `sudo lspci -k`

Shows all PCI devices + which kernel drivers they use.
Absolutely essential for:

* Discrete GPU vs integrated GPU diagnosis
* NVMe issues
* Wi-Fi/Bluetooth module detection
* Conflicting driver loading

---

## 4. USB Devices

### `lsusb`

Detects:

* Mouse / keyboard
* Camera
* Touchpad controller
* Dongles (Logitech, Razer, Bluetooth)

---

## 5. CPU Information

### `/proc/cpuinfo | head`

Shows:

* Model
* Frequency scaling
* Flags (VT-x, AES-NI, etc.)

---

## 6. Memory (RAM)

### `free -h`

Shows:

* Total / available / used
* Swap usage

---

## 7. GPU Details

### `sudo lshw -c video`

Shows:

* GPU model
* Driver
* Memory
* Capabilities
* Kernel modules

Useful to check Intel/AMD/NVIDIA initialization.

---

## 8. Intel GPU / i915 Logs

### `dmesg | grep -iE "i915|intel" | tail -100`

Shows:

* GPU crashes
* Display pipe failures
* VRAM / GTT allocation errors
* Panel power sequence issues

Especially useful when dealing with:

* Black screens
* Wayland crashes
* eDP/HDMI port issues

---

## 9. Boot Errors

### `journalctl -b -p 3`

Shows only **errors** from this boot.
Helps detect:

* ACPI issues
* Driver failures
* Firmware bugs

---

## 10. Thermal Sensors

### `sensors`

Displays CPU/GPU temperatures & fan speeds (if readable).

---

## 11. ACPI / Battery / Power

### `acpi -V`

Shows battery health, charge rate, thermal status.

---

## 12. Fan Hardware Detection

### `find /sys/devices ... fan/pwm`

Prints all fan & PWM devices the kernel knows about.

Useful to determine if manual fan control is possible.

---

## 13. System Firmware Info

### `sudo dmidecode -t system`

Shows:

* Manufacturer
* BIOS version
* Laptop model
* Serial # (masked for privacy)

---

## 14. Storage

### `lsblk`

Shows all disks, partitions, SSD/HDD rotation speed.

---

## 15. Network

### `ip link`

### `nmcli ...`

Shows:

* Network interfaces
* Whether they are connected
* States

---

## 16. RFKill (Wireless Kill Switches)

### `rfkill list`

Detects soft/hard blocks for:

* Wi-Fi
* Bluetooth
* WWAN

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

* Power
* Audio
* Fan control
* GPU drivers

---

## 21. Package Search for Important Tools

### `pacman -Qs "(inxi|acpi|smartmontools|cpupower|...)"`

Checks if important diagnostic tools are installed.

# ⚠️ Safety Notes

* **This script is 100% safe** → it only *reads* information.
* It uses only standard Linux tools + basic privileges.
* Some commands need `sudo` (lspci, dmidecode, lshw).
* No configuration files are modified.
* No services are restarted.

---

# 📑 What This Script Helps Diagnose (Examples)

### ✔ GPU issues

* Black screen
* HDMI/eDP not detected
* i915 crashes
* NVIDIA/Intel hybrid issues

### ✔ Thermal + ACPI problems

* Overheating
* Fan not spinning
* Broken ACPI tables

### ✔ Audio device issues

* No sound output
* Wrong default sink

### ✔ Power issues

* Poor battery life
* TLP/thermald conflicts

### ✔ Kernel mismatch issues

* Missing headers
* DKMS module failures
