# ArchStarterPack

A curated collection of configuration files, setup guides, and optimization scripts for Arch Linux-based systems. This repository provides battle-tested configurations for CachyOS, hardware peripherals, and development environments.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Configuration Modules](#configuration-modules)
  - [CachyOS Configuration](#1-cachyos-configuration)
  - [LogiOps - Logitech Mouse Configuration](#2-logiops---logitech-mouse-configuration)
  - [Node.js Development Setup](#3-nodejs-development-setup)
  - [Brother Printer Setup](#4-brother-printer-setup)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Troubleshooting & FAQ](#troubleshooting--faq)
- [License](#license)
- [Contributing](#contributing)

## Overview

ArchStarterPack is a collection of production-ready configuration files and comprehensive guides designed to streamline the setup process for Arch-based Linux distributions. Whether you're configuring a new system, optimizing performance, or setting up development tools, this repository provides tested solutions.

**Key Features:**
- 🚀 Performance optimization for CachyOS/Arch systems
- 🖱️ Advanced mouse configuration for Logitech devices
- 🔧 Minimal, clean development environment setup
- 🖨️ Brother printer and scanner setup guides
- 📚 Detailed documentation with safety checks
- 🛡️ Tested configurations for ASUS VivoBook hardware

## Prerequisites

- **Operating System:** Arch Linux or Arch-based distribution (CachyOS, Manjaro, EndeavourOS, etc.)
- **Hardware:** Configurations optimized for ASUS X507UF, but adaptable to other systems
- **Package Manager:** `pacman` (standard Arch package manager)
- **Shell:** Fish shell (for Node.js configuration) or Bash
- **Permissions:** Root/sudo access for system configuration

## Configuration Modules

### 1. CachyOS Configuration

**Location:** [`cachy_os_config/`](cachy_os_config/)  
**Difficulty:** Intermediate to Advanced  
**Time Required:** 30-60 minutes  

Comprehensive guides for configuring and optimizing CachyOS on ASUS X507UF (Intel i5-8250U + Intel UHD 620 + NVIDIA MX130) hardware. These configurations provide maximum performance when plugged in and power efficiency on battery.

#### What's Included

- **[Performance & Power Optimization](cachy_os_config/asus_x_507_uf_readme.md)** - Complete guide for AC/battery power management
  - TLP configuration for automatic AC/battery switching
  - CPU governor optimization (performance/powersave)
  - Intel Turbo Boost management
  - NVIDIA power management
  - Thermal management with `thermald`
  - Battery care settings (charge thresholds)

- **[External Monitor-Only Setup](cachy_os_config/asus_x_507_uf_nvidia_deprecated.md)** - Configure laptop to use external display exclusively
  - NVIDIA Optimus configuration
  - Disable internal eDP display
  - Early KMS (Kernel Mode Setting)
  - GRUB kernel parameters
  - HDMI-first boot configuration

- **[Hardware Diagnostics Toolkit](cachy_os_config/extract.md)** - Comprehensive system diagnostics script
  - Shows commands before executing (transparent and educational)
  - GPU/CPU/PCI/ACPI information gathering
  - Thermal sensor readings
  - Kernel module status
  - Boot error detection
  - Safe, read-only diagnostics

- **[Optional Diagnostics Extensions](cachy_os_config/optional_extract.md)** - Advanced diagnostic modules
  - Auto-upload to pastebin
  - Vulkan/OpenGL info collection
  - Network diagnostics suite
  - SMART disk health reports
  - Wayland/X11 logs

- **[GRUB Configuration](cachy_os_config/grub)** - Production GRUB config with optimized kernel parameters

#### Key Features

✅ Maximum performance on AC power  
✅ Power efficiency on battery  
✅ Safe thermal management  
✅ NVIDIA Optimus support  
✅ Intel P-state optimization  
✅ Automatic power profile switching  
✅ Battery longevity features  

#### Quick Start

```bash
cd cachy_os_config/
# Read the main guide first
cat asus_x_507_uf_readme.md

# Follow the numbered steps carefully
# Always run safety checks before applying configurations
```

---

### 2. LogiOps - Logitech Mouse Configuration

**Location:** [`logiops/`](logiops/)  
**Difficulty:** Intermediate  
**Time Required:** 20-30 minutes  

Configuration and setup guide for Logitech MX Master 3S mouse using LogiOps on Linux. Provides gesture controls, button remapping, and scroll wheel optimization.

#### What's Included

- **[LogiOps Setup Guide](logiops/readme.md)** - Complete installation and configuration instructions
  - Building from source
  - Dependency installation for various distros
  - Safety checks and validation
  - Common issues and troubleshooting
  - Tips for advanced configurations

- **[MX Master 3S Configuration](logiops/logid.cfg)** - Production-ready `logid.cfg`
  - SmartShift configuration (ratchet/free-spin toggle)
  - Hi-res scroll wheel settings
  - Gesture button mappings
  - Workspace switching gestures
  - KDE Plasma integration
  - Thumb wheel configuration

#### Features

🖱️ **Button Mappings:**
- Scroll wheel middle-click
- Back/Forward buttons
- SmartShift toggle button
- Gesture button with swipe controls

🎯 **Gestures:**
- Click: Overview (Meta+W)
- Swipe Left/Right: Workspace switching
- Swipe Up: Task switcher (Meta+Tab)
- Swipe Down: Show desktop (Meta+D)

⚙️ **Advanced Settings:**
- DPI: 2000
- SmartShift threshold: 30
- Scroll multiplier: 2.0x
- Custom wheel resolution

#### Quick Start

```bash
cd logiops/

# Install dependencies (Arch Linux)
sudo pacman -S base-devel cmake libevdev libconfig systemd-libs glib2

# Clone and build LogiOps
git clone https://github.com/PixlOne/logiops.git
cd logiops
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install

# Copy configuration
sudo cp ../logid.cfg /etc/logid.cfg

# Validate and start
sudo logid -t  # test configuration
sudo systemctl enable --now logid
```

---

### 3. Node.js Development Setup

**Location:** [`node_started/`](node_started/)  
**Difficulty:** Beginner to Intermediate  
**Time Required:** 10-15 minutes  

Minimal, clean configuration for NVM (Node Version Manager) in Fish shell. No bloated plugins, no unnecessary dependencies—just what you need to get Node.js working reliably.

#### What's Included

- **[NVM Fish Setup Guide](node_started/nvm-fish-readme.md)** - Complete minimal setup instructions
  - Installation requirements
  - Fish shell integration
  - VSCode compatibility
  - Troubleshooting guide
  - Rollback instructions

- **[Minimal config.fish](node_started/config.fish)** - Bare minimum Fish configuration
  - NVM environment setup
  - No fisher or bass required
  - Clean, maintainable approach

- **[NVM Fish Functions](node_started/nvm.fish)** - NVM wrapper and loader functions
  - `nvm` wrapper that syncs bash environment to Fish
  - `nvm-load` function for session initialization
  - PATH synchronization

#### Philosophy

This configuration follows a **minimal, package-manager-friendly** approach:
- No third-party Fish plugin managers
- No bass (bash wrapper) dependency
- Direct integration with pacman-installed NVM
- Clean separation of concerns
- Easy to understand and maintain

#### Quick Start

```bash
cd node_started/

# Install NVM via pacman
sudo pacman -S nvm

# Create Fish config directories
mkdir -p ~/.config/fish/functions

# Copy configurations
cp config.fish ~/.config/fish/config.fish
cp nvm.fish ~/.config/fish/functions/nvm.fish

# Reload shell
exec fish

# Set default Node version (one-time)
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'

# Test
node -v
nvm --version
```

---

### 4. Brother Printer Setup

**Location:** [`brother_dcp-t820dw/`](brother_dcp-t820dw/)  
**Difficulty:** Beginner to Intermediate  
**Time Required:** 15-25 minutes  

Complete setup guide for Brother DCP-T820DW printer and scanner on Arch Linux. Includes network (WiFi), USB configuration, and scanning setup.

#### What's Included

- **[Brother Printer Setup Guide](brother_dcp-t820dw/BROTHER_PRINTER_SETUP_README.md)** - Complete installation and configuration
  - CUPS and Avahi setup
  - AUR driver installation
  - USB and WiFi network printing
  - Scanner setup with SANE
  - Troubleshooting common issues
  - Driver integrity verification

#### Features

🖨️ **Printing:**
- WiFi network printing via IPP
- USB direct printing
- CUPS web interface configuration
- IPP Everywhere support

🔍 **Scanning:**
- SANE integration
- Network scanner support
- Simple Scan GUI
- brscan5 driver configuration

📸 **Photo Management:**
- digiKam recommended for photo organization
- Advanced image editing and cataloging
- RAW format support
- Face detection and tagging

#### Quick Start

```bash
cd brother_dcp-t820dw/

# Install CUPS and dependencies
sudo pacman -S cups cups-pdf avahi nss-mdns system-config-printer

# Enable services
sudo systemctl enable --now cups
sudo systemctl enable --now avahi-daemon

# Install Brother driver (AUR)
paru -S brother-dcpt820dw

# For scanning
sudo pacman -S sane-airscan simple-scan
paru -S brscan5 brscan-skey

# Register scanner
brsaneconfig5 -a name="BrotherDCP" model=DCPT820DW ip=<PRINTER-IP>

# Test printer
lpstat -p
lp /usr/share/cups/data/testprint

# For photo management and organization
sudo pacman -S digikam
```

---

## Project Structure

```
ArchStarterPack/
├── .github/
│   ├── ISSUE_TEMPLATE.md               # Bug report template
│   └── PULL_REQUEST_TEMPLATE.md        # PR template
├── brother_dcp-t820dw/
│   └── BROTHER_PRINTER_SETUP_README.md # Brother printer & scanner guide
├── cachy_os_config/
│   ├── asus_x_507_uf_readme.md         # Main performance & power guide
│   ├── asus_x_507_uf_nvidia_deprecated.md  # External monitor setup
│   ├── diagnostics.sh                   # System diagnostics tool
│   ├── extract.md                      # Diagnostics toolkit documentation
│   ├── optional_extract.md             # Advanced diagnostics
│   ├── GRUB_PARAMETERS.md              # Detailed kernel parameter explanations
│   └── grub                            # GRUB configuration file
├── docs/
│   ├── FAQ.md                          # Frequently asked questions
│   ├── TROUBLESHOOTING.md              # Common issues and solutions
│   ├── GLOSSARY.md                     # Technical terms glossary
│   └── LEARNING_RESOURCES.md           # Curated educational materials
├── logiops/
│   ├── readme.md                       # LogiOps setup guide
│   └── logid.cfg                       # MX Master 3S configuration
├── node_started/
│   ├── nvm-fish-readme.md              # NVM Fish setup guide
│   ├── config.fish                     # Minimal Fish config
│   └── nvm.fish                        # NVM Fish functions
├── check-prerequisites.sh               # System compatibility checker
├── CHANGELOG.md                         # Version history and changes
├── CONTRIBUTING.md                      # Contribution guidelines
├── LICENSE                              # MIT License
└── README.md                           # This file
```

## Quick Start

**Before you begin, verify your system compatibility:**

```bash
git clone https://github.com/cjmaaz/ArchStarterPack.git
cd ArchStarterPack
chmod +x check-prerequisites.sh
./check-prerequisites.sh
```

This will check if your system meets all requirements for the configuration modules.

---

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cjmaaz/ArchStarterPack.git
   cd ArchStarterPack
   ```

2. **Check prerequisites:**
   ```bash
   ./check-prerequisites.sh
   ```

3. **Choose your configuration module:**
   - For system optimization: `cd cachy_os_config/`
   - For mouse configuration: `cd logiops/`
   - For Node.js setup: `cd node_started/`
   - For Brother printer setup: `cd brother_dcp-t820dw/`

4. **Read the documentation:**
   Each module contains detailed README files with step-by-step instructions.

5. **Follow safety guidelines:**
   - Always read the full guide before executing commands
   - Run safety checks where indicated
   - Back up existing configurations
   - Test in a safe environment first

**Quick Diagnostics:**
If you encounter issues, run the diagnostics tool (shows commands and output):
```bash
cd cachy_os_config/
./diagnostics.sh
```

## Troubleshooting & FAQ

For comprehensive troubleshooting guides, common issues, and frequently asked questions, see:
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Solutions to common problems
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Glossary](docs/GLOSSARY.md) - Technical terms explained
- [Learning Resources](docs/LEARNING_RESOURCES.md) - Curated educational materials

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! If you have improvements, additional configurations, or bug fixes:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new configuration'`)
4. Commit your changes with descriptive messages
5. Push to the branch (`git push origin feature/improvement`)
6. Open a Pull Request

**Guidelines:**
- Document all configurations thoroughly
- Include safety checks and warnings
- Test on actual hardware before submitting
- Follow existing documentation style
- Explain the "why" behind configuration choices

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

---

**Repository:** [https://github.com/cjmaaz/ArchStarterPack](https://github.com/cjmaaz/ArchStarterPack)

**Note:** These configurations are tested on specific hardware (ASUS X507UF) and software (CachyOS). While they should work on similar systems, always review and adapt configurations to your specific hardware and requirements.

**Disclaimer:** Use these configurations at your own risk. Always back up your system before making significant changes. The maintainers are not responsible for any system issues that may arise from using these configurations.
