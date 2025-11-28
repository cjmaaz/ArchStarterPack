# Glossary of Terms

**Last Updated:** November 2025

A comprehensive glossary of technical terms used throughout the ArchStarterPack documentation.

---

## A

### AC Power
**Definition:** Alternating Current - refers to when laptop is plugged into wall power  
**Context:** In power management, AC mode enables maximum performance

### ACPI
**Definition:** Advanced Configuration and Power Interface  
**Context:** Firmware interface for power management, hardware configuration, and thermal management  
**Used in:** CachyOS power configurations

### Arch Linux
**Definition:** A lightweight, flexible Linux distribution that follows a rolling-release model  
**Context:** ArchStarterPack is designed for Arch-based systems  
**Related:** Manjaro, EndeavourOS, CachyOS

---

## B

### BAT (Battery)
**Definition:** Battery power mode  
**Context:** Power management configurations optimize for battery life when on BAT

### Bass
**Definition:** A Fish shell plugin that allows running bash scripts in Fish  
**Context:** ArchStarterPack's Node.js setup avoids using bass for simplicity

### BIOS
**Definition:** Basic Input/Output System  
**Context:** Firmware that initializes hardware during boot; controls fan speed on ASUS X507UF

---

## C

### CachyOS
**Definition:** Arch-based Linux distribution optimized for performance  
**Context:** Repository tested on CachyOS; configurations work on any Arch-based system

### CID (Control ID)
**Definition:** Button identifier in LogiOps for Logitech devices  
**Context:** Each physical button on mouse has a unique CID (e.g., 0x52 for scroll wheel click)

### CPU Governor
**Definition:** Kernel component that controls CPU frequency scaling  
**Types:**
- `performance` - Maximum frequency always
- `powersave` - Minimum frequency prioritized
- `schedutil` - Dynamic based on load (balanced)

### CPUFreq
**Definition:** Legacy CPU frequency scaling driver  
**Context:** Replaced by Intel P-State on modern Intel CPUs

### cpupower
**Definition:** Tool to examine and tune CPU frequency scaling  
**Usage:** `cpupower frequency-info`, `cpupower frequency-set`

---

## D

### DKMS
**Definition:** Dynamic Kernel Module Support  
**Context:** Automatically rebuilds kernel modules (like NVIDIA) when kernel updates  
**Why important:** Prevents broken drivers after kernel updates

### DPI (Dots Per Inch)
**Definition:** Mouse sensitivity setting  
**Context:** Higher DPI = faster cursor movement  
**Typical range:** 800-2000 for desktop use

### DRM (Direct Rendering Manager)
**Definition:** Kernel subsystem responsible for interfacing with GPUs  
**Context:** `nvidia_drm.modeset=1` enables NVIDIA DRM support

---

## E

### eDP (Embedded DisplayPort)
**Definition:** Internal laptop display connector  
**Context:** `eDP-1` typically refers to the built-in laptop screen  
**Used in:** Display management and disabling internal screen

---

## F

### Fish Shell
**Definition:** Friendly Interactive SHell - user-friendly command-line shell  
**Context:** ArchStarterPack provides minimal NVM setup for Fish  
**Website:** https://fishshell.com/

### Fisher
**Definition:** Plugin manager for Fish shell  
**Context:** ArchStarterPack's Node.js setup avoids fisher for simplicity

---

## G

### Governor
**See:** CPU Governor

### GRUB
**Definition:** GRand Unified Bootloader  
**Context:** Boot loader that loads Linux kernel; configured via `/etc/default/grub`  
**Usage:** Set kernel parameters, choose boot options

### GuC (Graphics Micro Controller)
**Definition:** Intel GPU microcontroller for power management  
**Context:** `i915.enable_guc=3` enables GuC and HuC for better efficiency

---

## H

### HID (Human Interface Device)
**Definition:** Device class for user input devices (mouse, keyboard)  
**Context:** LogiOps uses HID++ protocol to communicate with Logitech devices

### HID++
**Definition:** Logitech's proprietary protocol for advanced mouse features  
**Context:** Required for LogiOps to configure Logitech mice

### HDMI
**Definition:** High-Definition Multimedia Interface  
**Context:** External display connector; on Optimus laptops, wired to NVIDIA GPU

### HuC (HDCP Micro Controller)
**Definition:** Intel GPU microcontroller for media DRM  
**Context:** Enabled with GuC for hardware-accelerated media playback

### HWP (Hardware P-States)
**Definition:** Hardware-managed CPU frequency states (Intel 6th gen+)  
**Context:** Enabled with `intel_pstate=active`

---

## I

### i915
**Definition:** Intel integrated graphics driver  
**Context:** Controls Intel UHD/Iris graphics  
**Parameters:** `i915.enable_guc`, `i915.disable_display`

### iGPU (Integrated Graphics Processing Unit)
**Definition:** GPU built into CPU chip  
**Context:** Intel UHD 620 is iGPU; works alongside discrete NVIDIA GPU

### initramfs
**Definition:** Initial RAM filesystem loaded before root filesystem  
**Context:** Must include required drivers (NVIDIA, NVMe) for early boot  
**Command:** `mkinitcpio -P` rebuilds initramfs

---

## K

### Kernel
**Definition:** Core of Linux operating system; manages hardware and resources  
**Context:** Kernel parameters configured in GRUB affect kernel behavior

### Kernel Mode Setting (KMS)
**Definition:** Display resolution/mode initialization in kernel space  
**Context:** `nvidia_drm.modeset=1` enables NVIDIA KMS  
**Benefits:** Earlier graphics init, Wayland support

### KDE Plasma
**Definition:** Desktop environment  
**Context:** LogiOps gestures configured for KDE shortcuts by default

---

## L

### LogiOps
**Definition:** Linux driver for advanced Logitech mouse features  
**Context:** Enables button remapping, gestures, SmartShift on Linux  
**Repository:** https://github.com/PixlOne/logiops

### LTS (Long Term Support)
**Definition:** Kernel version with extended support/stability  
**Context:** `linux-lts` package provides LTS kernel

---

## M

### mkinitcpio
**Definition:** Tool to create initramfs images  
**Usage:** `mkinitcpio -P` rebuilds all initramfs after driver changes

### Modprobe
**Definition:** Tool to manage kernel modules  
**Context:** `/etc/modprobe.d/` contains module configuration files

---

## N

### NVIDIA Optimus
**Definition:** Hybrid graphics technology (Intel iGPU + NVIDIA dGPU)  
**Context:** ASUS X507UF has Optimus; requires special power management  
**Challenge:** Proper configuration needed for good battery life

### NVM (Node Version Manager)
**Definition:** Tool to install/manage multiple Node.js versions  
**Context:** ArchStarterPack provides minimal Fish integration  
**Website:** https://github.com/nvm-sh/nvm

### NVMe
**Definition:** Non-Volatile Memory Express - high-speed SSD interface  
**Context:** `nvme_load=YES` ensures NVMe driver loads early

---

## O

### Optimus
**See:** NVIDIA Optimus

---

## P

### PAT (Page Attribute Table)
**Definition:** CPU feature for memory cache management  
**Context:** `nvidia.NVreg_UsePageAttributeTable=1` improves NVIDIA memory performance

### pacman
**Definition:** Package manager for Arch Linux  
**Usage:** `sudo pacman -S package` installs, `pacman -Syu` updates system

### P-State
**Definition:** Performance state - CPU frequency/voltage combination  
**Context:** Intel P-State driver manages modern Intel CPU frequencies

### PWM (Pulse Width Modulation)
**Definition:** Technique to control fan speed  
**Context:** ASUS X507UF doesn't expose PWM control (BIOS-managed)

---

## R

### Rolling Release
**Definition:** Distribution model with continuous updates (no version numbers)  
**Context:** Arch Linux and derivatives use rolling release

---

## S

### SmartShift
**Definition:** Logitech scroll wheel technology  
**Context:** Automatically switches between ratchet (tactile) and free-spin modes  
**Configuration:** `threshold` determines switching speed

### SDDM
**Definition:** Simple Desktop Display Manager - login screen  
**Context:** Common display manager on KDE Plasma

### systemd
**Definition:** System and service manager for Linux  
**Usage:** `systemctl` manages services  
**Examples:** `systemctl start tlp`, `systemctl enable thermald`

---

## T

### thermald
**Definition:** Linux thermal daemon  
**Context:** Monitors temperatures and adjusts cooling  
**Usage:** Works with BIOS fan control on ASUS X507UF

### TLP
**Definition:** Advanced power management tool for Linux  
**Context:** Automatically adjusts settings based on AC/battery  
**Config:** `/etc/tlp.d/01-custom.conf`

### Turbo Boost
**Definition:** Intel technology to temporarily increase CPU frequency  
**Context:** Enabled on AC, disabled on battery for power savings  
**Control:** `/sys/devices/system/cpu/intel_pstate/no_turbo`

---

## U

### udev
**Definition:** Device manager for Linux kernel  
**Context:** Creates device nodes, handles hardware events  
**Usage:** Rules in `/etc/udev/rules.d/` configure device behavior

---

## V

### VSync (Vertical Synchronization)
**Definition:** Synchronizes frame rate with monitor refresh rate  
**Context:** Eliminates screen tearing  
**Configuration:** Set in compositor (picom, KWin)

---

## W

### Wayland
**Definition:** Modern display server protocol (replacement for X11)  
**Context:** Requires `nvidia_drm.modeset=1` for NVIDIA support

### Watchdog
**Definition:** Hardware timer that triggers reboot if system hangs  
**Context:** `nowatchdog` disables for lower overhead on desktops

---

## X

### X11 / Xorg
**Definition:** Traditional display server for Linux  
**Context:** Alternative to Wayland; more mature NVIDIA support  
**Config:** `/etc/X11/xorg.conf.d/`

### xrandr
**Definition:** Command-line tool to manage displays  
**Usage:** `xrandr --listproviders`, `xrandr --output HDMI-1 --auto`

---

## Z

### zswap
**Definition:** Compressed cache for swap pages in RAM  
**Context:** Disabled in configurations (`zswap.enabled=0`)  
**Reason:** Not needed with adequate RAM

---

## Acronyms Quick Reference

| Acronym | Full Name | Category |
|---------|-----------|----------|
| AC | Alternating Current | Power |
| ACPI | Advanced Configuration and Power Interface | Firmware |
| BAT | Battery | Power |
| BIOS | Basic Input/Output System | Firmware |
| CID | Control ID | Input Devices |
| CPU | Central Processing Unit | Hardware |
| dGPU | Discrete GPU | Graphics |
| DKMS | Dynamic Kernel Module Support | Drivers |
| DPI | Dots Per Inch | Input Devices |
| DRM | Direct Rendering Manager | Graphics |
| eDP | Embedded DisplayPort | Display |
| GPU | Graphics Processing Unit | Hardware |
| GRUB | GRand Unified Bootloader | Boot |
| GuC | Graphics Micro Controller | Graphics |
| HDMI | High-Definition Multimedia Interface | Display |
| HID | Human Interface Device | Input Devices |
| HuC | HDCP Micro Controller | Graphics |
| HWP | Hardware P-States | CPU |
| iGPU | Integrated GPU | Graphics |
| KDE | K Desktop Environment | Desktop |
| KMS | Kernel Mode Setting | Graphics |
| LTS | Long Term Support | Kernel |
| NVMe | Non-Volatile Memory Express | Storage |
| NVM | Node Version Manager | Development |
| PAT | Page Attribute Table | Memory |
| PWM | Pulse Width Modulation | Hardware |
| RAM | Random Access Memory | Hardware |
| SSD | Solid State Drive | Storage |
| TLP | (No expansion - just TLP) | Power |
| USB | Universal Serial Bus | Hardware |

---

## Related Resources

- [Arch Wiki](https://wiki.archlinux.org/) - Comprehensive Linux documentation
- [Kernel Documentation](https://www.kernel.org/doc/html/latest/) - Official Linux kernel docs
- [Intel Graphics Documentation](https://01.org/linuxgraphics) - Intel GPU information
- [NVIDIA Documentation](https://download.nvidia.com/XFree86/Linux-x86_64/latest/README/) - NVIDIA driver docs

---

## Contributing to Glossary

Missing a term? Found an error?  
Open an issue or submit a pull request to add or improve definitions!

**Format for new entries:**

```markdown
### Term Name
**Definition:** Brief explanation  
**Context:** How it's used in ArchStarterPack  
**Related:** Other relevant terms  
**Learn More:** [Link if applicable](URL)
```
