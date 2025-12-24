# ASUS X507UF – CachyOS Performance & Power Optimization README

**Last Updated:** November 2025
**Tested On:** CachyOS (KDE Plasma 6.x), Linux Kernel 6.x
**Difficulty:** Intermediate
**Time Required:** 30-60 minutes

---

This README provides a complete, ordered, and safe guide for configuring your ASUS VivoBook X507UF (Intel i5‑8250U + Intel UHD 620 + NVIDIA MX130) for:

- 🔥 **Maximum performance when plugged in (AC mode)**
- 🕊️ **Lower power consumption when on battery**
- 🛡️ **Safe thermals**, using BIOS fan control + thermald
- ⚙️ **Correct kernel parameters** (GRUB config provided)

All commands are based on your hardware logs, sensor outputs, and driver status.

---

## ⚠️ Before You Begin: Backup & Safety

**IMPORTANT: Create backups before making any changes**

```bash
# Backup current GRUB configuration
sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d)

# Backup existing TLP config (if it exists)
[ -f /etc/tlp.conf ] && sudo cp /etc/tlp.conf /etc/tlp.conf.backup.$(date +%Y%m%d)

# Backup current modprobe settings
sudo cp -r /etc/modprobe.d /etc/modprobe.d.backup.$(date +%Y%m%d)

# Backup mkinitcpio config
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup.$(date +%Y%m%d)

echo "✓ Backups created successfully"
```

**Safe Points to Stop:**

- After each numbered section, you can safely reboot and test
- If something doesn't work, use the rollback instructions at the end
- Keep this terminal open to reference commands

---

# 1. Install Required Packages

These provide power management, thermals, GPU tools, and utilities.

### Why These Packages Are Needed

**thermald:**

- **What:** Thermal daemon for CPU temperature management
- **Why needed:** Prevents CPU overheating by throttling when hot
- **How it works:** Monitors CPU temperature, adjusts CPU frequency/power limits
- **When needed:** Laptops prone to overheating, systems with thermal issues

**tlp:**

- **What:** Advanced power management daemon for Linux laptops
- **Why needed:** Automatically switches between AC and battery power profiles
- **How it works:** Monitors power source (AC/battery), applies appropriate settings
- **When needed:** Laptop optimization, battery life improvement

**powertop:**

- **What:** Power consumption analysis tool
- **Why needed:** Identify power-hungry processes and devices
- **How it works:** Monitors power consumption, suggests optimizations
- **When needed:** Battery life optimization, power consumption analysis

**ethtool:**

- **What:** Network interface configuration tool
- **Why needed:** Configure network adapter power management
- **How it works:** Sets network adapter power saving modes
- **When needed:** Wi-Fi power management optimization

**lshw:**

- **What:** Hardware information tool
- **Why needed:** Identify hardware for configuration
- **How it works:** Reads hardware information from system
- **When needed:** Hardware identification, diagnostics

**Install packages:**

```bash
sudo pacman -S --needed thermald tlp powertop ethtool lshw
```

**If asked to remove `power-profiles-daemon`, choose **Y**.**

**Why remove power-profiles-daemon:**

- **Conflict:** power-profiles-daemon conflicts with TLP
- **TLP is better:** TLP provides more control and features
- **Single manager:** Only one power manager should run (TLP)
- **Result:** TLP manages power, power-profiles-daemon removed

---

# 2. Enable System Services

### Why Enable These Services

**System services** run in the background and automatically manage system behavior. Enabling them ensures they start on boot and run continuously.

**Enable services:**

```bash
sudo systemctl enable --now thermald
sudo systemctl enable --now tlp
sudo systemctl enable --now cpupower.service
```

**What each service does:**

**`thermald` (Thermal Daemon):**

- **What it does:** Manages CPU thermal behavior and cooling policies
- **How it works:**
  1. Monitors CPU temperature continuously
  2. When temperature rises, reduces CPU frequency/power
  3. When temperature drops, restores CPU performance
  4. Prevents overheating automatically
- **Why needed:** Prevents CPU damage from overheating, maintains performance
- **Real-world:** Like a car's cooling system - automatically manages temperature

**`tlp` (TLP Linux Advanced Power Management):**

- **What it does:** Handles AC/BAT power switching automatically
- **How it works:**
  1. Monitors power source (AC adapter or battery)
  2. When AC connected: Applies performance profile
  3. When on battery: Applies power-saving profile
  4. Manages CPU governor, GPU power, USB autosuspend, etc.
- **Why needed:** Automatic power management, better battery life
- **Real-world:** Like a smart thermostat - adjusts automatically based on conditions

**`cpupower` (CPU Power Service):**

- **What it does:** Applies CPU frequency governor settings
- **How it works:**
  1. Sets CPU frequency scaling governor
  2. Configures CPU performance states
  3. Manages CPU frequency limits
- **Why needed:** Ensures CPU governor settings persist across reboots
- **Real-world:** Like setting CPU performance mode - ensures it stays set

**Why `enable --now`:**

- **`enable`:** Start service on boot (persistent)
- **`--now`:** Start service immediately (don't wait for reboot)
- **Result:** Service starts now and on every boot

**Verify services are running:**

```bash
systemctl status thermald tlp cpupower
# Should show: "Active: active (running)"
```

**If service failed:**

- Check logs: `journalctl -u thermald` (or tlp, cpupower)
- Verify packages installed: `pacman -Qs thermald tlp cpupower`
- Check configuration: Verify config files exist and are correct

---

# 3. Set CPU Governor for Maximum Performance (AC Mode)

### Why Set CPU Governor

**CPU governor** controls how the CPU scales its frequency based on load.

**What CPU governors do:**

- **Performance:** CPU runs at maximum frequency (best performance)
- **Powersave:** CPU runs at minimum frequency (best battery life)
- **Ondemand:** CPU scales frequency based on load (balanced)
- **Schedutil:** Modern governor, scales based on scheduler load (recommended)

**Why set to performance on AC:**

- **AC power:** No battery concerns, want maximum performance
- **Performance governor:** CPU always at max frequency
- **Result:** Best performance when plugged in

**Set CPU governor:**

```bash
sudo cpupower frequency-set -g performance
```

**What this does:**

- Sets CPU frequency scaling governor to "performance"
- CPU runs at maximum frequency (no downclocking)
- Best performance, but higher power consumption

**This forces high-frequency performance when on AC.**

**How it works:**

- **Command:** `cpupower frequency-set -g performance`
- **Effect:** All CPU cores set to performance governor
- **Result:** CPU runs at maximum frequency

**TLP will override this automatically on battery.**

**Why TLP overrides:**

- **TLP monitors power source:** Detects AC vs battery
- **On battery:** TLP sets governor to `schedutil` (power-saving)
- **On AC:** TLP sets governor to `performance` (maximum performance)
- **Automatic:** No manual switching needed

**Verify governor:**

```bash
cpupower frequency-info | grep governor
# Should show: "governor: performance" (when on AC)
```

**Real-world example:**

**Without setting governor:**

- CPU uses default governor (may be `ondemand` or `schedutil`)
- CPU downclocks when idle (saves power but reduces performance)
- Example: CPU runs at 800 MHz when idle, boosts to 3.4 GHz under load

**With performance governor:**

- CPU always runs at maximum frequency
- No downclocking (maximum performance)
- Example: CPU runs at 3.4 GHz constantly (best performance)

---

# 4. Create Custom TLP Configuration

This ensures AC = performance and Battery = powersave.

```bash
sudo bash -c 'cat >/etc/tlp.d/01-custom.conf <<EOF
# ---------------- TLP Custom Config -----------------

# MAX performance on AC
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_BOOST_ON_AC=1
CPU_ENERGY_PERF_POLICY_ON_AC=performance

# POWER SAVE on battery
CPU_SCALING_GOVERNOR_ON_BAT=schedutil
CPU_BOOST_ON_BAT=0
CPU_ENERGY_PERF_POLICY_ON_BAT=powersave

# Platform profile (ASUS-supported)
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power

# Runtime power management
RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

# Nvidia GPU power mgmt
NVIDIA_ASPM=1

# Autosuspend USB devices on battery
USB_AUTOSUSPEND=1

# Battery care (improves battery life)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=90
EOF'
```

---

# 5. Optimize NVIDIA Behavior (Maximum Performance on AC)

Enable persistence mode:

```bash
sudo nvidia-smi -pm 1
```

Enable DRM modesetting:

```bash
sudo bash -c 'cat >/etc/modprobe.d/nvidia-power.conf <<EOF
options nvidia_drm modeset=1
EOF'
```

Rebuild initramfs:

```bash
sudo mkinitcpio -P
```

---

# 6. Enable Intel Turbo Boost on AC

Ensures max clock speeds.

```bash
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
```

---

# 7. SSD I/O Scheduler Optimization

```bash
sudo bash -c 'cat >/etc/udev/rules.d/60-ssd.rules <<EOF
ACTION=="add|change", KERNEL=="nvme0n1", ATTR{queue/scheduler}="mq-deadline"
ACTION=="add|change", KERNEL=="sda", ATTR{queue/scheduler}="deadline"
EOF'
```

```bash
sudo udevadm control --reload
```

---

# 8. Apply Kernel Optimization Flags (GRUB)

Below is your **full, separate GRUB config**.
It includes:

- intel_pstate improvements
- NVIDIA dynamic power management
- Intel iGPU firmware loading
- Performance tuning flags

Replace your GRUB defaults with this:

```bash
sudo nano /etc/default/grub
```

Paste:

```
GRUB_DEFAULT=0
GRUB_TIMEOUT=3
GRUB_DISTRIBUTOR="CachyOS"
GRUB_CMDLINE_LINUX_DEFAULT="intel_pstate=active i915.enable_guc=3 nvidia.NVreg_DynamicPowerManagement=3 quiet splash loglevel=3 rd.udev.log_priority=3"
GRUB_CMDLINE_LINUX=""
```

Apply the config:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

# 9. What Happens After These Changes

## On AC (Plugged In):

- CPU governor = **performance**
- Turbo enabled
- Intel P-state full range
- NVIDIA in performance mode
- thermald controls CPU thermals
- Highest available FPS, lowest latency

## On Battery:

- CPU governor = **schedutil**
- Turbo disabled
- USB autosuspend
- NVIDIA power-saver mode
- Battery charge limited to 75–90% for longevity

All switching is automatic.

---

# 10. Reboot

```bash
sudo reboot
```

---

# 11. Post-Reboot Verification Commands

Run these to confirm everything is active:

```bash
systemctl status tlp
systemctl status thermald
systemctl status cpupower

tlp-stat -s | grep Mode

tlp-stat -p | grep Governor

cpupower frequency-info | sed -n '1,40p'

cat /proc/cmdline

sudo nvidia-smi -q | egrep -i "Persistence|Power Management"
```

---

# 12. Rollback Instructions

If you need to undo these changes and restore your system to its original state:

### Restore GRUB Configuration

```bash
# Restore backup
sudo cp /etc/default/grub.backup.* /etc/default/grub

# Or manually edit to remove added kernel parameters
sudo nano /etc/default/grub
# Remove: intel_pstate=active i915.enable_guc=3 nvidia.NVreg_DynamicPowerManagement=3

# Apply changes
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Remove TLP Custom Config

```bash
sudo rm /etc/tlp.d/01-custom.conf
sudo systemctl restart tlp
```

### Remove NVIDIA Power Config

```bash
sudo rm /etc/modprobe.d/nvidia-power.conf
sudo mkinitcpio -P
```

### Remove SSD Scheduler Rules

```bash
sudo rm /etc/udev/rules.d/60-ssd.rules
sudo udevadm control --reload
```

### Disable Services (if needed)

```bash
sudo systemctl disable --now tlp
sudo systemctl disable --now thermald
```

### Restore from Full Backup

```bash
# If you created the full backup at the beginning:
sudo cp /etc/default/grub.backup.YYYYMMDD /etc/default/grub
sudo cp /etc/modprobe.d.backup.YYYYMMDD/* /etc/modprobe.d/
sudo cp /etc/mkinitcpio.conf.backup.YYYYMMDD /etc/mkinitcpio.conf

# Rebuild and reboot
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

---

# 13. Notes About Your ASUS X507UF Fan

Your hardware exposes:

- `fan1_input` (RPM)
- `pwm1_enable = 2` (BIOS-controlled)

No `pwm1` file exists → fan **cannot** be manually controlled.

Your fan is automatically controlled by ASUS BIOS and will ramp appropriately under load.

This README handles cooling safely via CPU/GPU power limits and thermald.

---

# 13. Important Safety Checks Before Running Commands

**These checks must be done before applying performance configs. Running commands blindly can cause overheating or unexpected behavior if the hardware does not expose required interfaces.**

---

## ✅ Check 1 — Confirm Fan RPM Sensor Exists

### Why This Check Exists

**The problem:** Fan hardware paths vary between laptop models. We need to verify the fan is detected before configuring thermal management.

**Why it's critical:**

- **Fan detection:** Ensures fan hardware is accessible
- **Path verification:** Confirms correct sysfs path for your model
- **Safety:** Prevents configuring non-existent hardware
- **Compatibility:** Verifies your laptop matches expected hardware

**What this check verifies:**

- Fan hardware is detected by kernel
- Fan RPM sensor exists and is readable
- Correct sysfs path for your model

**Run:**

```bash
cat /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/fan1_input
```

**Expected:**

```
A number like 2500, 3000, 3500 (RPM)
```

**What this means:**

- **Fan detected:** Kernel found fan hardware ✅
- **Sensor readable:** Can read fan speed ✅
- **Normal operation:** Fan is spinning (RPM > 0) ✅

**If you see:**

```
cat: ...fan1_input: No such file or directory
```

**STOP. Do not continue.**

**What this means:**

- **Fan not detected:** Kernel didn't find fan hardware
- **Wrong path:** Fan path is different for your model
- **Hardware issue:** Fan hardware may not be accessible

**Your laptop's fan sysfs path is different or missing → ask for help.**

**Why stop:**

- **Safety:** Can't verify fan operation without sensor
- **Compatibility:** Your model may have different hardware
- **Configuration:** Can't configure what doesn't exist
- **Risk:** Continuing without verification may cause issues

**What to do:**

- **Check alternative paths:** Try different sysfs paths
- **Check hardware:** Verify fan hardware exists
- **Get help:** Ask for assistance with your specific model
- **Don't proceed:** Don't continue with thermal configuration

---

## ✅ Check 2 — Confirm Fan Is BIOS-Controlled

Run:

```bash
cat /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/pwm1_enable
```

Expected output for ASUS X507UF:

```
2
```

This means:

- `2` → BIOS automatic control (CORRECT for this model)

If you get:

- `0` or `1`: **Do not proceed** — fan may be in manual/off mode.
- `3`: vendor/ACPI mode enabled → ask before changing anything.

---

## ❌ Check 3 — Confirm No PWM Control Exists

Run:

```bash
ls /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/pwm1 2>/dev/null
```

Expected:

```
No such file or directory
```

If PWM exists (rare on ASUS VivoBooks):

```
/sys/.../pwm1
```

**STOP.**
Your system supports manual fan control and must be configured differently.

---

## ⚠ Check 4 — Ensure `thermald`, `tlp`, and `cpupower` start correctly

Run:

```bash
systemctl status thermald tlp cpupower --no-pager
```

All three should show:

```
Active: active (running)
```

If one shows `failed`:

- Do NOT continue with performance tweaks.
- Fix the service first or ask for help.

---

## ⚠ Check 5 — Ensure NVIDIA driver is loaded

Run:

```bash
nvidia-smi
```

Expected:

```
Driver Version: XXXX
GPU: GeForce MX130
```

If you see:

```
NVIDIA-SMI has failed because it couldn't communicate with the driver
```

STOP — reinstall NVIDIA drivers.

---
