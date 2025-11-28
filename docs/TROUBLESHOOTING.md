# Troubleshooting Guide

**Last Updated:** November 2025

This guide covers common issues encountered when using ArchStarterPack configurations and their solutions.

---

## Table of Contents

- [Boot Issues](#boot-issues)
- [Display Issues](#display-issues)
- [Power Management Issues](#power-management-issues)
- [NVIDIA/Graphics Issues](#nvidiagraphics-issues)
- [LogiOps/Mouse Issues](#logiops mouse-issues)
- [Node.js/NVM Issues](#nodejsnvm-issues)
- [General System Issues](#general-system-issues)
- [Recovery Procedures](#recovery-procedures)

---

## Boot Issues

### System Won't Boot After GRUB Changes

**Symptoms:** Black screen, kernel panic, or system hangs during boot

**Causes:**
- Incorrect kernel parameters
- Missing initramfs modules
- Conflicting driver settings

**Solutions:**

**Quick Fix (Boot once):**
1. At GRUB menu, press `e` to edit
2. Find line starting with `linux` or `linuxefi`
3. Remove recently added parameters (especially `video=`, `nvidia_drm.modeset`, `i915.disable_display`)
4. Press `Ctrl+X` to boot

**Permanent Fix:**
```bash
# Restore GRUB backup
sudo cp /etc/default/grub.backup.* /etc/default/grub

# Regenerate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Reboot
sudo reboot
```

---

### GRUB Menu Doesn't Appear

**Symptoms:** System boots directly without showing GRUB menu

**Solution:**
```bash
# Edit GRUB config
sudo nano /etc/default/grub

# Set timeout higher
GRUB_TIMEOUT=5

# Change timeout style
GRUB_TIMEOUT_STYLE=menu

# Regenerate
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Emergency:** Hold `Shift` or press `ESC` repeatedly during boot to show GRUB.

---

### Kernel Panic on Boot

**Symptoms:** System shows kernel panic message

**Common Causes:**
1. Missing kernel modules in initramfs
2. Wrong root filesystem parameter
3. Corrupted initramfs

**Solution:**
```bash
# Boot from live USB

# Mount root filesystem
sudo mount /dev/sdXY /mnt

# Arch-chroot into system
sudo arch-chroot /mnt

# Rebuild initramfs
mkinitcpio -P

# Check GRUB config
nano /etc/default/grub

# Regenerate GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Exit and reboot
exit
reboot
```

---

## Display Issues

### Black Screen After Applying NVIDIA Configuration

**Symptoms:** Screen goes black after login or during boot

**Causes:**
- `nvidia_drm.modeset=1` conflicts
- Missing NVIDIA modules in initramfs
- Display manager issues

**Solution 1 - Remove KMS:**
```bash
# Edit GRUB
sudo nano /etc/default/grub

# Remove nvidia_drm.modeset=1 from GRUB_CMDLINE_LINUX_DEFAULT

# Regenerate
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Reboot
sudo reboot
```

**Solution 2 - Rebuild initramfs:**
```bash
# Check if NVIDIA modules are loaded early
cat /etc/mkinitcpio.conf.d/nvidia.conf

# Should contain:
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# Rebuild
sudo mkinitcpio -P
sudo reboot
```

---

### Internal Display Not Working (After Deprecated Config)

**Symptoms:** Laptop screen is blank, only external monitor works

**Cause:** Applied `video=eDP-1:d` parameter

**Solution:**
```bash
# Edit GRUB
sudo nano /etc/default/grub

# Remove video=eDP-1:d from GRUB_CMDLINE_LINUX_DEFAULT

# Remove Xorg config
sudo rm /etc/X11/xorg.conf.d/20-disable-edp.conf

# Remove i915 display disable
sudo rm /etc/modprobe.d/i915-disable-display.conf

# Rebuild and regenerate
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

---

### Screen Tearing

**Symptoms:** Horizontal lines/tearing during video or scrolling

**Solution for Intel:**
```bash
# Create compositor config
mkdir -p ~/.config
nano ~/.config/picom.conf

# Add:
backend = "glx";
vsync = true;
```

**Solution for NVIDIA:**
```bash
# Create Xorg config
sudo nano /etc/X11/xorg.conf.d/20-nvidia.conf

# Add:
Section "Device"
    Identifier "NVIDIA Card"
    Driver "nvidia"
    Option "NoFlip" "false"
    Option "TripleBuffer" "true"
EndSection

Section "Screen"
    Identifier "NVIDIA Screen"
    Option "MetaModes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
EndSection
```

---

## Power Management Issues

### TLP and power-profiles-daemon Conflict

**Symptoms:** Warning about conflicting services, unpredictable power behavior

**Cause:** Both services try to control power management

**Solution:**
```bash
# Check what's running
systemctl status tlp
systemctl status power-profiles-daemon

# Disable power-profiles-daemon (recommended)
sudo systemctl disable --now power-profiles-daemon
sudo systemctl enable --now tlp

# OR disable TLP (if you prefer power-profiles-daemon)
sudo systemctl disable --now tlp
sudo systemctl enable --now power-profiles-daemon
```

---

### Battery Not Charging Past Threshold

**Symptoms:** Battery stops charging at 75% or 90%

**Cause:** Battery care threshold configured in TLP

**This is normal!** The configuration limits charge to extend battery lifespan.

**To change thresholds:**
```bash
sudo nano /etc/tlp.d/01-custom.conf

# Modify:
START_CHARGE_THRESH_BAT0=75  # Start charging at 75%
STOP_CHARGE_THRESH_BAT0=90   # Stop charging at 90%

# Set to 100 to disable
STOP_CHARGE_THRESH_BAT0=100

# Restart TLP
sudo tlp start
```

---

### CPU Not Reaching Max Frequency

**Symptoms:** CPU stuck at low frequencies even under load

**Check current governor:**
```bash
cpupower frequency-info
```

**Fix:**
```bash
# On AC power, set performance
sudo cpupower frequency-set -g performance

# Verify
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check if turbo is enabled
cat /sys/devices/system/cpu/intel_pstate/no_turbo
# Should be 0 (turbo enabled)

# Enable turbo if disabled
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
```

---

### System Overheating

**Symptoms:** High temperatures, thermal throttling

**Check temperatures:**
```bash
sensors
watch -n1 sensors
```

**Solutions:**

1. **Verify thermald is running:**
   ```bash
   systemctl status thermald
   sudo systemctl enable --now thermald
   ```

2. **Clean dust from vents** (physical maintenance)

3. **Repaste thermal compound** (if old laptop)

4. **Limit max CPU frequency:**
   ```bash
   # Temporary
   sudo cpupower frequency-set --max 3.0GHz
   
   # Permanent - add to /etc/tlp.d/01-custom.conf:
   CPU_MAX_PERF_ON_AC=80
   CPU_MAX_PERF_ON_BAT=50
   ```

---

## NVIDIA/Graphics Issues

### NVIDIA Driver Not Loading

**Symptoms:** `nvidia-smi` shows error, no NVIDIA modules loaded

**Check:**
```bash
lsmod | grep nvidia
dmesg | grep -i nvidia
```

**Solution:**
```bash
# Reinstall NVIDIA driver
sudo pacman -S nvidia-dkms nvidia-utils

# Install kernel headers
sudo pacman -S linux-headers

# Rebuild initramfs
sudo mkinitcpio -P

# Reboot
sudo reboot
```

---

### Poor GPU Performance

**Symptoms:** Low FPS, sluggish graphics

**Check GPU is being used:**
```bash
nvidia-smi
glxinfo | grep "OpenGL vendor"
```

**Solution:**
```bash
# Enable NVIDIA performance mode
sudo nvidia-smi -pm 1

# Run app with NVIDIA (Optimus)
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia your-application

# Set NVIDIA as default (not recommended for battery)
sudo nano /etc/environment
# Add: __GLX_VENDOR_LIBRARY_NAME=nvidia
```

---

## LogiOps/Mouse Issues

### logid Service Fails to Start

**Symptoms:** `systemctl status logid` shows failed

**Check logs:**
```bash
journalctl -u logid -b
```

**Common causes:**

1. **Config syntax error:**
   ```bash
   # Test configuration
   sudo logid -t
   ```
   Fix any syntax errors in `/etc/logid.cfg`

2. **Mouse not detected:**
   ```bash
   # Run in debug mode
   sudo systemctl stop logid
   sudo logid -v
   ```
   Ensure mouse is powered on and connected

3. **Missing dependencies:**
   ```bash
   # Reinstall
   cd ~/logiops/build
   sudo make uninstall
   sudo make install
   ```

---

### Buttons Not Working as Configured

**Symptoms:** Button presses don't do what config specifies

**Debug:**
```bash
# Stop service
sudo systemctl stop logid

# Run in verbose mode
sudo logid -v

# Press buttons and observe CID codes in output
```

**Solution:**
- Update CID codes in `/etc/logid.cfg` to match observed values
- Verify button syntax in config
- Check that keyboard shortcuts exist in your DE

---

### Gestures Not Working

**Symptoms:** Swipes don't trigger actions

**Check:**
1. **KDE shortcuts exist:**
   System Settings → Shortcuts → Global Shortcuts
   
2. **Gesture button CID is correct:**
   ```bash
   sudo logid -v
   # Press gesture button and note CID
   ```

3. **Mode is correct:**
   Gestures need `mode = "OnRelease"` typically

**Example fix:**
```bash
sudo nano /etc/logid.cfg

# Verify gesture section has correct structure:
{
    cid = 0xc3;  # Your gesture button CID
    action = {
        type = "Gestures";
        gestures = (
            {
                direction = "Left";
                mode = "OnRelease";
                action = { ... };
            }
        );
    };
}

# Restart
sudo systemctl restart logid
```

---

## Node.js/NVM Issues

### `node` Command Not Found

**Symptoms:** After Fish setup, `node` isn't recognized

**Solution:**
```bash
# Load NVM manually
nvm-load

# Check
node -v
which node

# If still not working, set default version
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'

# Reload Fish
exec fish
```

---

### VSCode Terminal Shows NVM Errors

**Symptoms:** VSCode integrated terminal shows `csource` or `bass` errors

**Solution:**
```bash
# Check for conflicting config
cat ~/.config/fish/config.fish

# Remove any csource or bass references

# Ensure only our minimal config exists
cat ~/.config/fish/functions/nvm.fish

# Reload VSCode
# Command Palette → Reload Window
```

---

### NVM Version Doesn't Switch

**Symptoms:** `nvm use 16` runs but `node -v` shows different version

**Solution:**
```bash
# Our wrapper syncs environment - should work
# If not, reload shell after switch
nvm use 16
exec fish
node -v

# Verify PATH
echo $PATH | tr ':' '\n' | grep nvm
```

---

## General System Issues

### Slow Boot Time

**Check boot time:**
```bash
systemd-analyze
systemd-analyze blame
```

**Common slow services:**
- NetworkManager-wait-online.service (can disable)
- plymouth (can disable if no splash needed)

**Disable unwanted services:**
```bash
sudo systemctl disable NetworkManager-wait-online.service
```

---

### High CPU Usage

**Check what's using CPU:**
```bash
top
htop  # If installed
```

**Common causes:**
- Runaway process
- Background indexing (baloo on KDE)
- System updates

**Solution:**
```bash
# Disable KDE indexing
balooctl disable

# Kill problematic process
kill <PID>
```

---

## Recovery Procedures

### Full System Restore from Backups

```bash
# Restore all backed-up configs
sudo cp /etc/default/grub.backup.* /etc/default/grub
sudo rm -rf /etc/modprobe.d
sudo cp -r /etc/modprobe.d.backup.* /etc/modprobe.d
sudo cp /etc/mkinitcpio.conf.backup.* /etc/mkinitcpio.conf

# Rebuild everything
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Restore TLP (if modified)
[ -f /etc/tlp.conf.backup.* ] && sudo cp /etc/tlp.conf.backup.* /etc/tlp.conf
sudo rm /etc/tlp.d/01-custom.conf

# Restart services
sudo systemctl restart tlp thermald

# Reboot
sudo reboot
```

---

### Boot from Live USB and Repair

1. **Boot from Arch/CachyOS live USB**

2. **Mount your system:**
   ```bash
   # Find your root partition
   lsblk
   
   # Mount it
   sudo mount /dev/sdXY /mnt
   
   # Mount EFI (if UEFI)
   sudo mount /dev/sdXZ /mnt/boot/efi
   ```

3. **Chroot into system:**
   ```bash
   sudo arch-chroot /mnt
   ```

4. **Fix configurations** (restore backups, edit files)

5. **Rebuild:**
   ```bash
   mkinitcpio -P
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

6. **Exit and reboot:**
   ```bash
   exit
   reboot
   ```

---

### Create Emergency Backup Script

Save this as `emergency-backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR="$HOME/archstarterpack-emergency-backup"
mkdir -p "$BACKUP_DIR"

sudo cp /etc/default/grub "$BACKUP_DIR/"
sudo cp -r /etc/modprobe.d "$BACKUP_DIR/"
sudo cp /etc/mkinitcpio.conf "$BACKUP_DIR/"
sudo cp -r /etc/X11/xorg.conf.d "$BACKUP_DIR/" 2>/dev/null
sudo cp /etc/tlp.conf "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/fish "$BACKUP_DIR/" 2>/dev/null

echo "Backup created in $BACKUP_DIR"
ls -lh "$BACKUP_DIR/"
```

---

## Getting More Help

If your issue isn't covered here:

1. **Run diagnostics:**
   ```bash
   ./cachy_os_config/diagnostics.sh
   ```

2. **Check logs:**
   ```bash
   journalctl -b -p 3  # Boot errors
   dmesg | grep -i error  # Kernel errors
   ```

3. **Search existing issues:**
   [GitHub Issues](https://github.com/yourusername/ArchStarterPack/issues)

4. **Open a new issue** with:
   - Problem description
   - Steps to reproduce
   - Diagnostic output
   - System info from `./check-prerequisites.sh`

5. **Community resources:**
   - [Arch Forums](https://bbs.archlinux.org/)
   - [Arch Wiki](https://wiki.archlinux.org/)
   - [CachyOS Discord](https://discord.gg/cachyos)

---

**Remember:** Most issues are reversible. Keep backups, stay calm, and work through solutions methodically.
