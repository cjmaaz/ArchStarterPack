
# ASUS X507UF + CachyOS (KDE Plasma) External Monitor-Only & NVIDIA Optimization Guide

> **⚠️ DEPRECATED CONFIGURATION**  
> **This configuration is provided for specialized use cases only.**  
>   
> **Use this guide ONLY if:**
> - You exclusively use an external monitor and never use the laptop screen
> - Your laptop is permanently docked/connected to an external display
> - You want to reduce power consumption by completely disabling the internal display
>
> **For most users:** Use the main [Performance & Power Optimization Guide](asus_x_507_uf_readme.md) instead, which provides optimal performance while maintaining display flexibility.
>
> **Why is this deprecated?**  
> Disabling the internal display at the driver level makes troubleshooting difficult and removes flexibility. Modern power management (TLP + thermald) can achieve similar battery efficiency without permanently disabling hardware.

---

**Last Updated:** November 2025  
**Tested On:** CachyOS (KDE Plasma 6.x), Linux Kernel 6.x, NVIDIA Driver 550+  
**Difficulty:** Advanced  
**Time Required:** 45-60 minutes

---

This README documents all steps performed to configure:
- Full NVIDIA support (MX130 + Intel UHD 620 Optimus)
- Disable internal laptop screen (eDP-1)
- Make HDMI external monitor the only active display (GRUB → Boot → Login → KDE)
- Performance tuning for always-plugged usage
- Thermal + driver setup

---

## ⚠️ Before You Begin: Critical Backups

**WARNING: These changes modify critical system files. Create backups first!**

```bash
# Backup GRUB configuration
sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d)

# Backup mkinitcpio configuration
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup.$(date +%Y%m%d)

# Backup modprobe configurations
sudo cp -r /etc/modprobe.d /etc/modprobe.d.backup.$(date +%Y%m%d)

# Backup X11 configurations (if they exist)
[ -d /etc/X11/xorg.conf.d ] && sudo cp -r /etc/X11/xorg.conf.d /etc/X11/xorg.conf.d.backup.$(date +%Y%m%d)

echo "✓ Backups created successfully"
```

**Recovery Plan:**
- Keep a bootable USB ready in case the internal display is needed
- Test external monitor connection before proceeding
- Have access to these instructions from another device

---

## 1. Hardware Detection & Base Setup

### Install base tools
```bash
sudo pacman -Syu
sudo pacman -S inxi lm_sensors psensor thermald cpupower --noconfirm
```

### Detect hardware
```bash
inxi -Fxx
lspci -nnk
lsusb
lsmod | egrep "asus|i915|intel|nvidia"
```

### Detect temperature sensors
```bash
sudo sensors-detect
sensors
```

---

## 2. NVIDIA Driver (DKMS) Installation

### Remove conflicting kernel-specific Nvidia module
```bash
sudo pacman -Rns linux-cachyos-lts-nvidia
```

### Install DKMS-based NVIDIA modules
```bash
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings --noconfirm
```

### Install kernel headers (required for DKMS)
```bash
sudo pacman -S linux-cachyos-headers linux-cachyos-lts-headers --noconfirm
```

### Rebuild initramfs
```bash
sudo mkinitcpio -P
```

### Reboot
```bash
sudo reboot
```

---

## 3. Enable Early NVIDIA KMS (Needed for HDMI-first boot)

### Add NVIDIA KMS to GRUB
Edit:
```bash
sudo nano /etc/default/grub
```

Modify:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia_drm.modeset=1 nvidia.NVreg_UsePageAttributeTable=1 video=eDP-1:d"
```

Apply:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 4. Load NVIDIA Modules Early (Initramfs)

Create file:
```bash
sudo nano /etc/mkinitcpio.conf.d/nvidia.conf
```

Paste:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Apply:
```bash
sudo mkinitcpio -P
```

Reboot:
```bash
sudo reboot
```

---

## 5. Disable Internal Display (eDP-1) at Xorg Level

```bash
sudo nano /etc/X11/xorg.conf.d/20-disable-edp.conf
```

Paste:
```
Section "Monitor"
    Identifier "eDP-1"
    Option "Ignore" "true"
EndSection
```

---

## 6. Disable Intel iGPU Display Initialization

Create:
```bash
sudo nano /etc/modprobe.d/i915-disable-display.conf
```

Paste:
```
options i915 enable_dpcd_backlight=0
options i915 disable_display=1
```

Apply:
```bash
sudo mkinitcpio -P
```

Reboot.

---

## 7. NVIDIA Environment Fix for Apps (X11 Only)

Create:
```bash
mkdir -p ~/.config/environment.d
nano ~/.config/environment.d/99-nvidia.conf
```

Paste:
```
__GLX_VENDOR_LIBRARY_NAME=nvidia
```

Reboot.

Verify:
```bash
echo $__GLX_VENDOR_LIBRARY_NAME
glxinfo | grep "OpenGL vendor"
```

Expected:
```
nvidia
OpenGL vendor string: NVIDIA Corporation
```

---

## 8. Set Performance Mode (Always Plugged-In Optimization)

### CPU Governor
```bash
sudo pacman -S cpupower --noconfirm
sudo cpupower frequency-set -g performance
sudo systemctl enable --now cpupower.service
```

### Power-Profiles-Daemon (Recommended)
```bash
powerprofilesctl set performance
powerprofilesctl get
```

### Thermal Daemon
```bash
sudo systemctl enable --now thermald
```

---

## 9. Verify Boot Output

```bash
cat /proc/cmdline
ls /sys/class/drm/
xrandr | grep " connected"
```

You should only see HDMI-A-1 active.

---

## 10. Final Behavior Achieved

✔ GRUB loads on external HDMI  
✔ Linux kernel boot messages show on HDMI  
✔ SDDM login screen on HDMI  
✔ Plasma session on HDMI  
✔ Internal eDP panel fully disabled  
✔ NVIDIA used for rendering  
✔ Better performance, safer thermals  

---

## 11. Rollback Instructions

**IMPORTANT: Follow these steps carefully to restore your system**

### Remove GRUB kernel args
Edit:
```bash
sudo nano /etc/default/grub
```

Remove these parameters from `GRUB_CMDLINE_LINUX_DEFAULT`:
```
nvidia_drm.modeset=1 nvidia.NVreg_UsePageAttributeTable=1 video=eDP-1:d
```

Apply:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Remove NVIDIA Early Loading
```bash
sudo rm /etc/mkinitcpio.conf.d/nvidia.conf
sudo mkinitcpio -P
```

### Remove Intel display block
```bash
sudo rm /etc/modprobe.d/i915-disable-display.conf
sudo mkinitcpio -P
```

### Remove Xorg disable eDP rule
```bash
sudo rm /etc/X11/xorg.conf.d/20-disable-edp.conf
```

### Remove NVIDIA environment variable
```bash
rm ~/.config/environment.d/99-nvidia.conf
```

### Restore from Backup (Alternative Method)
```bash
# Restore GRUB from backup
sudo cp /etc/default/grub.backup.* /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Restore modprobe from backup  
sudo rm -rf /etc/modprobe.d
sudo cp -r /etc/modprobe.d.backup.* /etc/modprobe.d

# Restore mkinitcpio from backup
sudo cp /etc/mkinitcpio.conf.backup.* /etc/mkinitcpio.conf
sudo mkinitcpio -P

# Restore X11 from backup (if it exists)
[ -d /etc/X11/xorg.conf.d.backup.* ] && sudo rm -rf /etc/X11/xorg.conf.d && sudo cp -r /etc/X11/xorg.conf.d.backup.* /etc/X11/xorg.conf.d
```

Reboot:
```bash
sudo reboot
```

After reboot, both internal and external displays should work normally.

---

## 12. Troubleshooting

### Issue: Black screen after applying changes
**Solution:**
1. Boot into recovery mode (select from GRUB menu)
2. Mount root filesystem as read-write: `mount -o remount,rw /`
3. Follow rollback instructions above
4. Reboot

### Issue: External monitor not detected
**Solution:**
- Verify HDMI cable is connected before booting
- Check `xrandr` output: `xrandr --listproviders`
- Verify NVIDIA driver is loaded: `lsmod | grep nvidia`

### Issue: Can't see GRUB menu
**Solution:**
- Press ESC repeatedly during boot to show GRUB menu
- Edit GRUB timeout: `GRUB_TIMEOUT=5` in `/etc/default/grub`

---

## 13. Notes

- On Optimus laptops, HDMI is wired to NVIDIA GPU, while eDP is wired to Intel iGPU.
- GRUB cannot select HDMI directly; disabling eDP + enabling early NVIDIA KMS forces HDMI.
- This configuration turns the laptop into a “desktop-only” system.
