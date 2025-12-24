# CachyOS Configuration & Diagnostics

This module provides comprehensive tools and guides for configuring and troubleshooting CachyOS (Arch-based Linux distribution) systems, with a focus on performance optimization, power management, and hardware diagnostics.

---

## What This Module Provides

### 🔧 Configuration Guides

- **ASUS X507UF optimization:** Complete setup guide for ASUS VivoBook X507UF laptops
- **GRUB kernel parameters:** Detailed explanations of boot parameters for performance and power management
- **TLP power management:** Custom power profiles for AC and battery modes
- **NVIDIA Optimus setup:** Hybrid graphics configuration for laptops

### 🔍 Diagnostic Tools

- **System diagnostics:** Comprehensive hardware and software information gathering
- **DRM/Power diagnostics:** Specialized tools for display and power management issues
- **USB diagnostics:** USB device detection and power state analysis
- **Hardware verification:** Safety checks before applying configurations

### 📚 Learning Resources

- **Step-by-step guides:** Detailed explanations of every command and configuration
- **Concept explanations:** Why things exist, how they work, when to use them
- **Troubleshooting:** Common issues and solutions
- **Real-world examples:** Concrete scenarios and use cases

---

## Quick Start

### For ASUS X507UF Users

1. **Read the main guide:** [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md)
2. **Run diagnostics first:** Use [`diagnostics.sh`](diagnostics.sh) to gather system info
3. **Follow configuration steps:** Apply optimizations step-by-step
4. **Verify changes:** Use verification commands after reboot

### For General Users

1. **Run diagnostics:** Use [`diagnostics.sh`](diagnostics.sh) to understand your system
2. **Review GRUB parameters:** Learn about kernel parameters in [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md)
3. **Configure power management:** Set up TLP using [`01-custom.conf`](01-custom.conf) as reference
4. **Troubleshoot issues:** Use diagnostic tools when problems arise

---

## Prerequisites

Before using this module, you should have:

- **CachyOS or Arch-based distribution** installed
- **Basic Linux command-line knowledge** (cd, ls, nano, sudo)
- **Root/sudo access** (for system configuration)
- **Understanding of your hardware** (laptop model, GPU, CPU)

**Recommended but not required:**

- Basic understanding of Linux system administration
- Familiarity with GRUB bootloader
- Knowledge of power management concepts

---

## Reading Order (Recommended Path)

### 1. Start Here: Understanding Your System

**Diagnostics Toolkit** → [`extract.md`](extract.md)

- Learn what diagnostics are and why they're needed
- Understand how to gather system information
- Learn to interpret diagnostic output
- **Practice:** Run [`diagnostics.sh`](diagnostics.sh) on your system

### 2. Kernel Parameters & Boot Configuration

**GRUB Parameters Guide** → [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md)

- Understand what kernel parameters do
- Learn when to use each parameter
- Understand performance vs power trade-offs
- **Reference:** [`grub`](grub) file shows example configuration

### 3. Power Management & Optimization

**ASUS X507UF Guide** → [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md)

- Complete step-by-step optimization guide
- AC vs battery mode configuration
- Thermal management setup
- **Configuration:** [`01-custom.conf`](01-custom.conf) shows TLP settings

### 4. Advanced Diagnostics

**DRM/Power Diagnostics** → [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md)

- Display and power management diagnostics
- USB device troubleshooting
- Runtime power management analysis
- **Tool:** [`drm-power-diagnostics.sh`](drm-power-diagnostics.sh)

### 5. Optional Extensions

**Optional Features** → [`optional_extract.md`](optional_extract.md)

- Advanced diagnostic modules
- Optional integrations
- Extended troubleshooting tools

---

## Key Concepts

### Diagnostics

**What:** Tools that gather system information for troubleshooting and optimization

**Why:** Help identify issues, verify hardware, understand system state

**When to use:** Before making changes, when troubleshooting, for optimization

**Learn more:** [`extract.md`](extract.md)

### GRUB Kernel Parameters

**What:** Boot-time options that configure kernel behavior

**Why:** Control performance, power management, hardware initialization

**When to use:** System optimization, troubleshooting, hardware-specific fixes

**Learn more:** [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md)

### Power Management

**What:** System configuration for battery life and performance

**Why:** Balance performance (AC) vs battery life (battery)

**When to use:** Laptop optimization, thermal management, battery preservation

**Learn more:** [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md)

### DRM (Direct Rendering Manager)

**What:** Linux kernel subsystem for graphics hardware management

**Why:** Handles display initialization, mode setting, GPU access

**When to use:** Display issues, external monitor problems, graphics troubleshooting

**Learn more:** [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md)

### TLP (TLP Linux Advanced Power Management)

**What:** Power management daemon for Linux laptops

**Why:** Automatically switches between AC and battery profiles

**When to use:** Laptop optimization, battery life improvement

**Learn more:** [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md) (Section 4)

---

## Files Overview

### Configuration Files

| File                               | Purpose                       | When to Use                   |
| ---------------------------------- | ----------------------------- | ----------------------------- |
| [`01-custom.conf`](01-custom.conf) | TLP power management config   | Setting up power profiles     |
| [`grub`](grub)                     | GRUB bootloader configuration | Configuring kernel parameters |

### Diagnostic Scripts

| File                                                   | Purpose                   | When to Use             |
| ------------------------------------------------------ | ------------------------- | ----------------------- |
| [`diagnostics.sh`](diagnostics.sh)                     | Full system diagnostics   | General troubleshooting |
| [`drm-power-diagnostics.sh`](drm-power-diagnostics.sh) | Display/power diagnostics | Display or power issues |

### Documentation

| File                                                   | Purpose                      | Read When              |
| ------------------------------------------------------ | ---------------------------- | ---------------------- |
| [`extract.md`](extract.md)                             | Diagnostics toolkit guide    | Learning diagnostics   |
| [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md)             | Kernel parameters explained  | Configuring GRUB       |
| [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md) | DRM/power diagnostics guide  | Display/power issues   |
| [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md)   | ASUS X507UF optimization     | Optimizing ASUS laptop |
| [`optional_extract.md`](optional_extract.md)           | Optional diagnostic features | Advanced diagnostics   |

---

## How This Connects to Other Modules

### Networking Module

- **Connection:** Power management affects network adapter behavior
- **Use case:** Wi-Fi power saving settings in TLP
- **See:** [`../networking/README.md`](../networking/README.md)

### VM Module

- **Connection:** Host power management affects VM performance
- **Use case:** CPU governor settings impact VM CPU allocation
- **See:** [`../vm/README.md`](../vm/README.md)

### System Optimization

- **Connection:** Kernel parameters and power management are system optimizations
- **Use case:** GRUB parameters optimize kernel behavior
- **See:** System-level optimization guides

---

## Safety & Best Practices

### ⚠️ Always Backup First

Before making any changes:

```bash
# Backup GRUB
sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d)

# Backup TLP config
[ -f /etc/tlp.conf ] && sudo cp /etc/tlp.conf /etc/tlp.conf.backup.$(date +%Y%m%d)
```

### ✅ Verify Before Applying

1. **Run diagnostics first:** Understand your system
2. **Read documentation:** Understand what changes do
3. **Test incrementally:** Apply changes one at a time
4. **Verify after changes:** Confirm everything works

### 🔄 Rollback Plan

Every guide includes rollback instructions. Keep backups and know how to restore.

---

## Troubleshooting

### Common Issues

**Problem:** System won't boot after GRUB changes

- **Solution:** Boot from GRUB menu, edit entry, remove problematic parameters
- **See:** [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md) troubleshooting section

**Problem:** Power management not working

- **Solution:** Check TLP service status, verify configuration syntax
- **See:** [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md) verification section

**Problem:** Display issues after configuration

- **Solution:** Run DRM diagnostics, check kernel parameters
- **See:** [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md)

### Getting Help

1. **Run diagnostics:** Gather system information
2. **Check documentation:** Review relevant guides
3. **Verify configuration:** Check for syntax errors
4. **Review logs:** Check systemd journal and dmesg

---

## Next Steps

1. **New to diagnostics?** Start with [`extract.md`](extract.md)
2. **Want to optimize your system?** Read [`asus_x_507_uf_readme.md`](asus_x_507_uf_readme.md)
3. **Need to understand GRUB?** Check [`GRUB_PARAMETERS.md`](GRUB_PARAMETERS.md)
4. **Having display issues?** See [`DRM_POWER_DIAGNOSTICS.md`](DRM_POWER_DIAGNOSTICS.md)

---

## Contributing

Found an issue or have improvements? Contributions welcome! See the main repository contributing guidelines.

---

## License & Disclaimer

These configurations are provided as-is. Always backup your system before making changes. Test configurations on non-critical systems first.
