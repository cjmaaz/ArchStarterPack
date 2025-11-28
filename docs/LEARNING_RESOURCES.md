# Learning Resources

**Last Updated:** November 2025

A curated collection of learning materials to help you understand the concepts and technologies used in ArchStarterPack.

---

## Table of Contents

- [Linux Fundamentals](#linux-fundamentals)
- [Arch Linux Specific](#arch-linux-specific)
- [Power Management](#power-management)
- [Graphics & Display](#graphics--display)
- [Hardware & Drivers](#hardware--drivers)
- [Shell Scripting](#shell-scripting)
- [Development Tools](#development-tools)

---

## Linux Fundamentals

### Essential Linux Concepts

**The Linux Command Line**
- [The Linux Command Line Book](http://linuxcommand.org/tlcl.php) - Free comprehensive guide
- [Linux Journey](https://linuxjourney.com/) - Interactive learning platform
- Level: Beginner

**Understanding the Linux Boot Process**
- [Arch Wiki: Boot Process](https://wiki.archlinux.org/title/Arch_boot_process)
- Topics: GRUB, initramfs, kernel parameters
- Level: Intermediate

**Linux File System Hierarchy**
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- Understanding `/etc`, `/sys`, `/proc`, `/dev`
- Level: Beginner to Intermediate

---

## Arch Linux Specific

### Official Resources

**Arch Wiki**
- [https://wiki.archlinux.org/](https://wiki.archlinux.org/)
- **Essential reading!** Best Linux documentation available
- Covers everything from installation to advanced configuration

**Arch Linux Forums**
- [https://bbs.archlinux.org/](https://bbs.archlinux.org/)
- Community support and discussions
- Search before posting

**CachyOS Documentation**
- [CachyOS Wiki](https://wiki.cachyos.org/)
- CachyOS-specific optimizations and features

### Key Arch Wiki Pages for ArchStarterPack

**Package Management**
- [pacman](https://wiki.archlinux.org/title/Pacman)
- [System Maintenance](https://wiki.archlinux.org/title/System_maintenance)

**Boot & Kernel**
- [GRUB](https://wiki.archlinux.org/title/GRUB)
- [Kernel Parameters](https://wiki.archlinux.org/title/Kernel_parameters)
- [mkinitcpio](https://wiki.archlinux.org/title/Mkinitcpio)

**Hardware**
- [Laptop](https://wiki.archlinux.org/title/Laptop) - Essential for laptop users
- [ASUS Laptops](https://wiki.archlinux.org/title/ASUS_Linux)

---

## Power Management

### CPU Frequency Scaling

**Intel P-State Driver**
- [Arch Wiki: CPU Frequency Scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling)
- [Kernel Documentation: Intel P-State](https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html)
- Understanding governors: performance, powersave, schedutil
- Level: Intermediate

**CPU Governors Explained**
- [Red Hat: CPU Performance](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/power_management_guide/cpufreq_governors)
- When to use each governor
- Level: Beginner to Intermediate

### Battery Optimization

**TLP - Power Management**
- [TLP Documentation](https://linrunner.de/tlp/)
- [Arch Wiki: TLP](https://wiki.archlinux.org/title/TLP)
- Understanding TLP configuration
- AC vs Battery profiles
- Level: Intermediate

**thermald - Thermal Management**
- [GitHub: thermald](https://github.com/intel/thermal_daemon)
- [Arch Wiki: thermald](https://wiki.archlinux.org/title/Thermald)
- How thermal management works
- Level: Intermediate

**Power Profiles Daemon**
- [Arch Wiki: power-profiles-daemon](https://wiki.archlinux.org/title/Power_profiles_daemon)
- Alternative to TLP (choose one)
- Level: Beginner

### General Power Management

**Comprehensive Guide**
- [Arch Wiki: Power Management](https://wiki.archlinux.org/title/Power_management)
- Complete overview of Linux power management
- Level: Intermediate to Advanced

**Laptop-Specific Optimizations**
- [Arch Wiki: Laptop/Power](https://wiki.archlinux.org/title/Laptop#Power_management)
- Battery care and longevity tips
- Level: Beginner to Intermediate

---

## Graphics & Display

### Intel Graphics

**Intel HD/UHD Graphics**
- [Arch Wiki: Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics)
- i915 driver configuration
- GuC/HuC firmware loading
- Level: Intermediate

**Intel Graphics Optimization**
- [01.org: Linux Graphics](https://01.org/linuxgraphics)
- Official Intel Linux graphics documentation
- Level: Advanced

### NVIDIA

**NVIDIA Drivers**
- [Arch Wiki: NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- Driver installation and configuration
- Level: Intermediate

**NVIDIA Optimus (Hybrid Graphics)**
- [Arch Wiki: NVIDIA Optimus](https://wiki.archlinux.org/title/NVIDIA_Optimus)
- Understanding hybrid graphics
- Power management strategies
- Level: Intermediate to Advanced

**NVIDIA Official Documentation**
- [NVIDIA Linux Driver README](https://download.nvidia.com/XFree86/Linux-x86_64/latest/README/)
- Comprehensive driver documentation
- Level: Advanced

### Display Servers

**Xorg (X11)**
- [Arch Wiki: Xorg](https://wiki.archlinux.org/title/Xorg)
- Configuration in `/etc/X11/xorg.conf.d/`
- Level: Intermediate

**Wayland**
- [Arch Wiki: Wayland](https://wiki.archlinux.org/title/Wayland)
- Modern display protocol
- NVIDIA support status
- Level: Intermediate

---

## Hardware & Drivers

### Understanding Linux Hardware

**Hardware Detection**
- [Arch Wiki: Monitoring](https://wiki.archlinux.org/title/List_of_applications#System_monitoring)
- Tools: `lspci`, `lsusb`, `lshw`, `inxi`
- Level: Beginner

**ACPI - Power & Thermal Interface**
- [Arch Wiki: ACPI](https://wiki.archlinux.org/title/ACPI)
- Understanding ACPI tables and events
- Level: Intermediate to Advanced

**Kernel Modules**
- [Arch Wiki: Kernel Module](https://wiki.archlinux.org/title/Kernel_module)
- Loading, configuration in `/etc/modprobe.d/`
- Level: Intermediate

### Storage

**NVMe SSDs**
- [Arch Wiki: NVMe](https://wiki.archlinux.org/title/Solid_state_drive/NVMe)
- NVMe-specific optimizations
- Level: Intermediate

**SSD Optimization**
- [Arch Wiki: SSD](https://wiki.archlinux.org/title/Solid_state_drive)
- TRIM, I/O schedulers
- Level: Intermediate

---

## Shell Scripting

### Bash Scripting

**Learning Bash**
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- Level: Beginner to Advanced

**Shell Scripting Best Practices**
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Writing safe and maintainable scripts
- Level: Intermediate

### Fish Shell

**Official Resources**
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- Comprehensive guide to Fish
- Level: Beginner to Intermediate

**Fish vs Bash**
- [Fish Tutorial](https://fishshell.com/docs/current/tutorial.html)
- Understanding Fish syntax differences
- Level: Beginner

---

## Development Tools

### Node.js & NVM

**Node.js Basics**
- [Node.js Documentation](https://nodejs.org/en/docs/)
- Official Node.js guide
- Level: Beginner to Intermediate

**NVM Usage**
- [NVM GitHub](https://github.com/nvm-sh/nvm)
- Managing multiple Node versions
- Level: Beginner

**npm Package Management**
- [npm Documentation](https://docs.npmjs.com/)
- Package installation and management
- Level: Beginner

### Version Control

**Git Essentials**
- [Pro Git Book](https://git-scm.com/book/en/v2) - Free online book
- [Git Official Tutorial](https://git-scm.com/docs/gittutorial)
- Level: Beginner to Advanced

---

## Input Devices & Peripherals

### Logitech Devices

**LogiOps Documentation**
- [LogiOps GitHub](https://github.com/PixlOne/logiops)
- Official documentation and examples
- Level: Intermediate

**HID Devices on Linux**
- [Arch Wiki: Input Devices](https://wiki.archlinux.org/title/Mouse)
- Understanding Linux input subsystem
- Level: Intermediate

---

## Video Tutorials

### YouTube Channels

**Linux Basics**
- [LearnLinuxTV](https://www.youtube.com/@LearnLinuxTV)
- [DistroTube](https://www.youtube.com/@DistroTube)

**Arch Linux**
- [EF - Tech Made Simple](https://www.youtube.com/@ef-techmade-simple)
- [Mental Outlaw](https://www.youtube.com/@MentalOutlaw)

**System Administration**
- [The Linux Foundation](https://www.youtube.com/@LinuxfoundationOrg)
- [Network Chuck](https://www.youtube.com/@NetworkChuck)

---

## Books

### Recommended Reading

**Linux Administration**
- "How Linux Works" by Brian Ward
- "The Linux Command Line" by William Shotts (free online)
- "Linux Bible" by Christopher Negus

**System Programming**
- "The Linux Programming Interface" by Michael Kerrisk
- "Understanding the Linux Kernel" by Daniel P. Bovet

**Shell Scripting**
- "Learning the bash Shell" by Cameron Newham
- "Wicked Cool Shell Scripts" by Dave Taylor

---

## Community Resources

### Forums & Discussion

**Arch Linux**
- [Arch Forums](https://bbs.archlinux.org/)
- [r/archlinux](https://www.reddit.com/r/archlinux/)

**CachyOS**
- [CachyOS Discord](https://discord.gg/cachyos)
- [CachyOS Forum](https://forum.cachyos.org/)

**General Linux**
- [r/linux](https://www.reddit.com/r/linux/)
- [r/linuxquestions](https://www.reddit.com/r/linuxquestions/)
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/)

---

## Specific Topics from ArchStarterPack

### For CachyOS Module

**Must Read:**
1. [Arch Wiki: Power Management](https://wiki.archlinux.org/title/Power_management)
2. [Arch Wiki: TLP](https://wiki.archlinux.org/title/TLP)
3. [Arch Wiki: Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics)
4. [Arch Wiki: NVIDIA Optimus](https://wiki.archlinux.org/title/NVIDIA_Optimus)
5. [Kernel Parameters Documentation](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)

**Nice to Have:**
- [Intel P-State Documentation](https://www.kernel.org/doc/html/latest/admin-guide/pm/intel_pstate.html)
- [TLP Configuration Reference](https://linrunner.de/tlp/settings/)

### For LogiOps Module

**Must Read:**
1. [LogiOps GitHub](https://github.com/PixlOne/logiops)
2. [LogiOps Configuration Examples](https://github.com/PixlOne/logiops/tree/master/examples)

**Nice to Have:**
- [Arch Wiki: Logitech MX Master](https://wiki.archlinux.org/title/Logitech_MX_Master)
- Understanding HID++ protocol

### For Node.js Module

**Must Read:**
1. [Fish Shell Documentation](https://fishshell.com/docs/current/)
2. [NVM GitHub](https://github.com/nvm-sh/nvm)

**Nice to Have:**
- [Fish Shell Tutorial](https://fishshell.com/docs/current/tutorial.html)
- Node.js version management best practices

---

## Learning Paths

### Path 1: Linux Beginner to ArchStarterPack User

1. **Week 1-2:** Linux basics (command line, file system)
2. **Week 3-4:** Package management (pacman), system updates
3. **Week 5-6:** Understanding services (systemd), logs
4. **Week 7-8:** Configuration files, GRUB, kernel parameters
5. **Week 9+:** Apply ArchStarterPack configurations

### Path 2: Optimize Your System

1. Understand current power consumption (tools: `powertop`, `tlp-stat`)
2. Learn about CPU governors and P-States
3. Read TLP documentation
4. Apply CachyOS power optimizations
5. Monitor and tune based on results

### Path 3: Master Your Mouse

1. Read LogiOps documentation
2. Understand CID codes and HID++
3. Apply basic configuration
4. Customize gestures for your workflow
5. Share your configuration!

---

## Tips for Learning

### Best Practices

1. **Read the Arch Wiki first** - It's the gold standard
2. **Test in a VM** - Practice in a safe environment
3. **Take notes** - Document what you learn
4. **Ask questions** - Community is helpful
5. **Contribute back** - Share your knowledge

### When You're Stuck

1. Check [FAQ](FAQ.md) and [TROUBLESHOOTING](TROUBLESHOOTING.md)
2. Search the Arch Wiki
3. Run diagnostic tools
4. Ask in forums with details
5. Read error messages carefully

### Learning by Doing

The best way to learn is to:
1. Read the documentation
2. Understand the concepts
3. Apply the configuration
4. Observe the results
5. Troubleshoot issues
6. Refine your setup

---

## Stay Updated

### Following Linux News

- [Phoronix](https://www.phoronix.com/) - Linux hardware and software news
- [OMG! Ubuntu](https://www.omgubuntu.co.uk/) - Linux news and tutorials
- [It's FOSS](https://itsfoss.com/) - Linux tutorials and news
- [r/linux](https://www.reddit.com/r/linux/) - Linux community

### Security Updates

- Subscribe to Arch security mailing list
- Follow `pacman -Syu` regularly
- Read package update notes

---

## Contributing to This List

Found a great resource? Add it!

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

**Remember:** Learning is a journey. Take your time, practice regularly, and don't be afraid to experiment (with backups!)
