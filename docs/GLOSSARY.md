# Glossary of Terms

**Last Updated:** December 2025

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

### ARP (Address Resolution Protocol)

**Definition:** IPv4 protocol that maps an IP address to a MAC address on the local network
**Context:** Used when a device needs a MAC to send a frame to a local IP
**Used in:** Understanding “same subnet but unreachable” issues
**Learn More:** [Layer 2 (MAC/ARP)](../networking/docs/layer2-mac-arp.md), [`arp` command](../shell-commands/02-commands/arp.md)

### awk

**Definition:** Pattern scanning and text processing language
**Usage:** `awk '{print $1}' file.txt` (print first column)
**Context:** Powerful tool for column-based data processing
**Common Use:** Extract fields, perform calculations, format output
**Example:** `ps aux | awk '{print $1, $11}'` (show user and command)
**Learn More:** [awk Tutorial](../shell-commands/02-commands/awk.md)

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

### CUPS

**Definition:** Common UNIX Printing System
**Context:** Print server and spooler for Linux/UNIX
**Usage:** Manages printers, print queues, and print jobs
**Web Interface:** `http://localhost:631`

---

## D

### digiKam

**Definition:** Professional photo management application for KDE
**Context:** Used for organizing, editing, and managing scanned photos
**Features:** Face detection, tagging, RAW support, non-destructive editing
**Website:** https://www.digikam.org/

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

### DHCP (Dynamic Host Configuration Protocol)

**Definition:** Protocol that automatically assigns network settings to devices (IP, gateway, DNS)
**Context:** Your router typically runs the DHCP server for your LAN
**Used in:** Pi-hole module (router DHCP DNS must point to Pi-hole)
**Learn More:** [DHCP](../networking/docs/dhcp.md), [IP Addressing](../networking/docs/ip-addressing.md)

### DHCP Lease

**Definition:** Time-limited “contract” of assigned network settings from DHCP
**Context:** Devices may keep old DNS until lease renewal
**Used in:** Pi-hole troubleshooting (why DNS changes don’t apply instantly)
**Learn More:** [DHCP](../networking/docs/dhcp.md)

### DNS (Domain Name System)

**Definition:** System that maps names (example.com) to IP addresses (93.184.216.34)
**Context:** Pi-hole blocks ads by filtering DNS lookups
**Used in:** Pi-hole module (clients must use Pi-hole as DNS)
**Learn More:** [DNS](../networking/docs/dns.md)

### DoH (DNS over HTTPS)

**Definition:** Encrypted DNS transported over HTTPS (port 443)
**Context:** Can bypass Pi-hole because queries don’t go to Pi-hole
**Used in:** Pi-hole hardcoded DNS/DoH blocking
**Learn More:** [DNS](../networking/docs/dns.md), [Hardcoded DNS/DoH Blocking](../pi-hole/docs/hardcoded-dns.md)

### DoT (DNS over TLS)

**Definition:** Encrypted DNS transported over TLS (typically port 853)
**Context:** Can bypass Pi-hole unless blocked or policy-disabled
**Used in:** Pi-hole hardcoded DNS/DoH blocking
**Learn More:** [DNS](../networking/docs/dns.md), [Hardcoded DNS/DoH Blocking](../pi-hole/docs/hardcoded-dns.md)

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

### Firewall

**Definition:** Network policy enforcement controlling which traffic is allowed/blocked
**Context:** Home routers typically use stateful firewalls with connection tracking
**Used in:** Forcing DNS to Pi-hole and blocking bypass paths
**Learn More:** [NAT and Firewalls](../networking/docs/nat-firewalls.md)

---

## G

### Governor

**See:** CPU Governor

### Gateway (Default Gateway)

**Definition:** The router IP your device uses to reach non-local networks (the “exit” of your subnet)
**Context:** Commonly `192.168.0.1` in home networks
**Used in:** Networking fundamentals and troubleshooting reachability to Pi-hole
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### Guest Network

**Definition:** A separate Wi‑Fi/LAN segment intended for untrusted devices, usually isolated from the main LAN
**Context:** Can prevent clients from reaching Pi-hole on the main LAN
**Used in:** Pi-hole reachability and DNS timeout troubleshooting
**Learn More:** [Routing/VLANs/Guest Networks](../networking/docs/routing-vlans-guest.md)

### Guest (VM)

**Definition:** The virtual machine running inside a host
**Context:** Thinks it has dedicated hardware but shares host resources
**Used in:** VM module for understanding virtualization concepts
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md)

### Guest Agent (qemu-guest-agent)

**Definition:** Service inside VM that improves host↔guest integration
**Context:** Provides accurate IP reporting, clean shutdown, display resizing, clipboard integration
**Used in:** VM performance and management
**Learn More:** [Performance Tuning](../vm/docs/performance.md)

### grep

**Definition:** Global Regular Expression Print - search text using patterns
**Usage:** `grep "pattern" file.txt`
**Common Options:**

- `-i` - Case insensitive
- `-r` - Recursive search
- `-v` - Invert match (exclude)
- `-n` - Show line numbers
  **Example:** `grep -i "error" log.txt | wc -l` (count errors)
  **Context:** Most commonly used command for filtering and searching text
  **Learn More:** [grep Tutorial](../shell-commands/02-commands/grep.md)

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

### Host (VM)

**Definition:** The physical machine running the hypervisor and virtual machines
**Context:** Manages resources (CPU, RAM, disk, network) for guest VMs
**Used in:** VM module for understanding virtualization concepts
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md)

### Hypervisor

**Definition:** Software layer that manages and runs virtual machines
**Context:** KVM is a Type 1 hypervisor (runs in kernel), QEMU provides Type 2 interface
**Types:** Type 1 (bare metal) vs Type 2 (hosted)
**Used in:** VM module for understanding virtualization architecture
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md)

---

## I

### IP Address

**Definition:** Numeric address of a device on a network
**Context:** IPv4 example `192.168.0.109` (Pi-hole), IPv6 example `fd00::109`
**Used in:** Pi-hole module (router DHCP advertises Pi-hole IP as DNS)
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### IPv4

**Definition:** Internet Protocol version 4 (32-bit addresses like `192.168.0.42`)
**Context:** Most home LANs still primarily use IPv4 for local addressing
**Used in:** Pi-hole DNS configuration and router DHCP settings
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### IPv6

**Definition:** Internet Protocol version 6 (128-bit addresses like `fd00::109`)
**Context:** If IPv6 DNS is advertised incorrectly, clients can bypass Pi-hole
**Used in:** Pi-hole IPv6-safe setup
**Learn More:** [IPv6-Safe Pi-hole](../pi-hole/docs/ipv6.md), [IP Addressing](../networking/docs/ip-addressing.md)

### IPP (Internet Printing Protocol)

**Definition:** Network protocol for printing over IP networks
**Context:** Modern standard for network printing
**Usage:** `ipp://printer.local/ipp/print`
**Advantage:** Driverless printing with IPP Everywhere

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

### IOMMU (Input/Output Memory Management Unit)

**Definition:** Hardware feature that enables device passthrough to VMs
**Context:** Required for GPU passthrough (VFIO)
**Types:** Intel VT-d, AMD-Vi
**Used in:** VM advanced topics (GPU passthrough)
**Learn More:** [Advanced Topics](../vm/docs/advanced.md), [dmesg command](../shell-commands/02-commands/dmesg.md)

---

## J

### jq

**Definition:** Command-line JSON processor
**Usage:** `echo '{"name":"John"}' | jq '.name'` (extract field)
**Context:** Essential for parsing JSON output from APIs and CLI tools
**Common Use:** Parse Salesforce CLI JSON output, API responses
**Example:** `sf org list --json | jq '.result.nonScratchOrgs[].username'`
**Learn More:** [jq Tutorial](../shell-commands/02-commands/jq.md)

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

### KVM (Kernel-based Virtual Machine)

**Definition:** Linux kernel module enabling hardware-assisted virtualization
**Context:** Provides hypervisor functionality using CPU virtualization extensions (VT-x/AMD-V)
**Used in:** VM module for creating and managing virtual machines
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md), [Installation & Setup](../vm/docs/installation-setup.md)

---

## L

### LAN (Local Area Network)

**Definition:** Your local home network (devices behind your router)
**Context:** Pi-hole is deployed on the LAN and must be advertised by LAN DHCP
**Used in:** Pi-hole module and router configuration steps
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### LogiOps

**Definition:** Linux driver for advanced Logitech mouse features
**Context:** Enables button remapping, gestures, SmartShift on Linux
**Repository:** https://github.com/PixlOne/logiops

### LTS (Long Term Support)

**Definition:** Kernel version with extended support/stability
**Context:** `linux-lts` package provides LTS kernel

### libvirt

**Definition:** Management daemon and API for virtual machines, storage, and networks
**Context:** Provides unified interface for managing VMs (abstraction layer)
**Used in:** VM module for VM lifecycle management
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md), [virsh command](../shell-commands/02-commands/virsh.md)

---

## M

### MAC Address (Media Access Control)

**Definition:** Link-layer identifier used for local frame delivery on Ethernet/Wi‑Fi (e.g., `AA:BB:CC:DD:EE:FF`)
**Context:** DHCP reservations typically map MAC → IP
**Used in:** DHCP reservations and LAN troubleshooting
**Learn More:** [Layer 2 (MAC/ARP)](../networking/docs/layer2-mac-arp.md), [DHCP](../networking/docs/dhcp.md)

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

### NAT (Network Address Translation)

**Definition:** Translation of IP addresses/ports, commonly used to let many private LAN devices share one public IP
**Context:** Not the same as firewalling; NAT is translation, firewall is policy
**Used in:** Home router behavior and DNS enforcement patterns
**Learn More:** [NAT and Firewalls](../networking/docs/nat-firewalls.md)

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

### OVMF (Open Virtual Machine Firmware)

**Definition:** UEFI firmware for virtual machines
**Context:** Required for modern guest OSes (Windows 10/11, modern Linux)
**Used in:** VM installation and configuration
**Learn More:** [Installation & Setup](../vm/docs/installation-setup.md)

---

## P

### PAT (Page Attribute Table)

**Definition:** CPU feature for memory cache management
**Context:** `nvidia.NVreg_UsePageAttributeTable=1` improves NVIDIA memory performance

### pacman

**Definition:** Package manager for Arch Linux
**Usage:** `sudo pacman -S package` installs, `pacman -Syu` updates system

### Pipe (|)

**Definition:** Shell operator that connects output of one command to input of another
**Syntax:** `command1 | command2`
**Example:** `grep "ERROR" log.txt | wc -l` (count error lines)
**Context:** Fundamental for command chaining and data processing
**Learn More:** [Piping Patterns](../shell-commands/03-combinations/piping.md)

### Port

**Definition:** Logical endpoint on a host that identifies a service (IP identifies the host; port identifies the service)
**Context:** DNS=53, DoT=853, DoH=443
**Used in:** Understanding firewall rules and bypass paths
**Learn More:** [TCP/UDP/Ports](../networking/docs/tcp-udp-ports.md)

### P-State

**Definition:** Performance state - CPU frequency/voltage combination
**Context:** Intel P-State driver manages modern Intel CPU frequencies

### PWM (Pulse Width Modulation)

**Definition:** Technique to control fan speed
**Context:** ASUS X507UF doesn't expose PWM control (BIOS-managed)

---

## R

### RAW (Image Format)

**Definition:** Unprocessed image data from camera sensor
**Context:** Professional photography format requiring special software
**Supported by:** digiKam, Darktable, RawTherapee
**Advantage:** Maximum editing flexibility

### Redirection

**Definition:** Changing where command input comes from or output goes to
**Types:**

- `>` - Write stdout to file (overwrite)
- `>>` - Append stdout to file
- `<` - Read stdin from file
- `2>` - Redirect stderr to file
- `&>` - Redirect both stdout and stderr
  **Example:** `command > output.txt 2>&1` (save all output)
  **Learn More:** [Redirection Guide](../shell-commands/01-basics/redirection.md)

### Rolling Release

**Definition:** Distribution model with continuous updates (no version numbers)
**Context:** Arch Linux and derivatives use rolling release

### Recursive Resolver

**Definition:** DNS resolver that performs full recursion (root → TLD → authoritative) to answer queries
**Context:** Unbound is a common local recursive resolver used with Pi-hole
**Used in:** Pi-hole + Unbound setup
**Learn More:** [DNS](../networking/docs/dns.md), [Unbound Guide](../pi-hole/docs/unbound.md)

### RDNSS

**Definition:** Recursive DNS Server (IPv6 router advertisement option to announce DNS servers)
**Context:** If your router advertises public IPv6 DNS via RDNSS, IPv6 clients can bypass Pi-hole
**Used in:** Pi-hole IPv6-safe setup
**Learn More:** [IPv6-Safe Pi-hole](../pi-hole/docs/ipv6.md)

---

## S

### SANE

**Definition:** Scanner Access Now Easy
**Context:** Standard API for scanner access on Linux/UNIX
**Usage:** Backend for scanner drivers
**Command:** `scanimage` for command-line scanning

### Shell

**Definition:** Command-line interpreter that executes commands
**Types:** Bash, Zsh, Fish, sh
**Context:** Interface for interacting with the operating system
**Learn More:** [Shell Commands Module](../shell-commands/)

### Shell Operators

**Definition:** Special characters that control command execution and data flow
**Common Operators:**

- `|` (pipe) - Pass output of one command as input to another
- `>` (redirect) - Write output to file (overwrite)
- `>>` (append) - Write output to file (append)
- `&&` (AND) - Execute next command only if previous succeeds
- `||` (OR) - Execute next command only if previous fails
- `2>&1` - Redirect stderr to stdout
- `;` (semicolon) - Execute commands sequentially
  **Learn More:** [Operators Guide](../shell-commands/01-basics/operators.md)

### Stateful Firewall

**Definition:** Firewall that tracks connection state and allows return traffic for established connections
**Context:** Default "allow outbound, block unsolicited inbound" model on home routers
**Used in:** Understanding why outbound DNS bypass works by default
**Learn More:** [NAT and Firewalls](../networking/docs/nat-firewalls.md)

### SPICE

**Definition:** Remote display protocol for virtual machines
**Context:** Default display protocol in virt-manager, better performance than VNC
**Used in:** VM display configuration
**Learn More:** [Video & Display](../vm/docs/video-display.md)

### Snapshot (VM)

**Definition:** Point-in-time recovery point for a virtual machine
**Context:** Allows reverting VM to previous state, requires qcow2 disk format
**Types:** Disk-only snapshot, memory snapshot (save state)
**Used in:** VM storage management and experimentation
**Learn More:** [Storage Management](../vm/docs/storage.md), [virsh command](../shell-commands/02-commands/virsh.md)

### stdin (Standard Input)

**Definition:** Default input stream for programs (file descriptor 0)
**Context:** Data read by a program (typically from keyboard or pipe)
**Usage:** `cat < file.txt` redirects file to stdin

### stdout (Standard Output)

**Definition:** Default output stream for programs (file descriptor 1)
**Context:** Normal program output (typically displayed on screen)
**Usage:** `command > output.txt` redirects stdout to file

### stderr (Standard Error)

**Definition:** Error output stream for programs (file descriptor 2)
**Context:** Error messages and diagnostics
**Usage:** `command 2> errors.txt` redirects stderr to file
**Combined:** `command > output.txt 2>&1` redirects both stdout and stderr

### SmartShift

**Definition:** Logitech scroll wheel technology
**Context:** Automatically switches between ratchet (tactile) and free-spin modes
**Configuration:** `threshold` determines switching speed

### Subnet

**Definition:** A logical group of IP addresses that can communicate locally (e.g., `192.168.0.0/24`)
**Context:** Devices must be in the same subnet (or routed correctly) to reach Pi-hole
**Used in:** Pi-hole networking basics and troubleshooting
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### Subnet Mask

**Definition:** IPv4 representation of a subnet/prefix (common home mask: `255.255.255.0`)
**Context:** Equivalent to CIDR `/24` in typical home networks
**Used in:** Understanding IP ranges and local vs routed traffic
**Learn More:** [IP Addressing](../networking/docs/ip-addressing.md)

### SDDM

**Definition:** Simple Desktop Display Manager - login screen
**Context:** Common display manager on KDE Plasma

### sed

**Definition:** Stream Editor - non-interactive text editor
**Usage:** `sed 's/old/new/g' file.txt` (replace text)
**Context:** Powerful tool for text transformation and substitution
**Common Use:** Find and replace, delete lines, insert text
**Example:** `grep "ERROR" log.txt | sed 's/.*ERROR: //'` (extract error messages)
**Learn More:** [sed Tutorial](../shell-commands/02-commands/sed.md)

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

### TCP (Transmission Control Protocol)

**Definition:** Connection-oriented transport protocol (reliable, ordered delivery)
**Context:** Used by HTTPS (443) and DoT (853)
**Used in:** Understanding ports and “connection refused/timeout” behaviors
**Learn More:** [TCP/UDP/Ports](../networking/docs/tcp-udp-ports.md)

### Turbo Boost

**Definition:** Intel technology to temporarily increase CPU frequency
**Context:** Enabled on AC, disabled on battery for power savings
**Control:** `/sys/devices/system/cpu/intel_pstate/no_turbo`

### TTL (Time To Live)

**Definition:** DNS cache duration (seconds) indicating how long an answer may be cached
**Context:** DNS changes may appear delayed because caches respect TTL
**Used in:** Pi-hole DNS behavior and troubleshooting
**Learn More:** [DNS](../networking/docs/dns.md)

---

## U

### udev

**Definition:** Device manager for Linux kernel
**Context:** Creates device nodes, handles hardware events
**Usage:** Rules in `/etc/udev/rules.d/` configure device behavior

### UDP (User Datagram Protocol)

**Definition:** Connectionless transport protocol (low overhead, no built-in reliability)
**Context:** Many DNS lookups use UDP 53 for speed
**Used in:** DNS behavior and port-level troubleshooting
**Learn More:** [TCP/UDP/Ports](../networking/docs/tcp-udp-ports.md)

---

## V

### VFIO (Virtual Function I/O)

**Definition:** Linux kernel framework for device passthrough to virtual machines
**Context:** Required for GPU passthrough, uses IOMMU
**Used in:** VM advanced topics (GPU passthrough)
**Learn More:** [Advanced Topics](../vm/docs/advanced.md)

### virt-manager

**Definition:** Graphical user interface for libvirt
**Context:** User-friendly GUI for creating and managing VMs, comparable to VirtualBox
**Used in:** VM module for VM management
**Learn More:** [Virtualization Basics](../vm/docs/virtualization-basics.md), [Installation & Setup](../vm/docs/installation-setup.md)

### virsh

**Definition:** Command-line interface for libvirt
**Context:** Scriptable, reproducible VM management tool
**Used in:** VM module for automation and advanced management
**Learn More:** [virsh command](../shell-commands/02-commands/virsh.md), [Advanced Topics](../vm/docs/advanced.md)

### virbr0

**Definition:** libvirt's default virtual bridge for NAT networking
**Context:** Private virtual bridge on host, provides DHCP/DNS to VMs
**Used in:** VM networking configuration
**Learn More:** [VM Networking](../vm/docs/networking.md), [ip command](../shell-commands/02-commands/ip.md)

### Virtio

**Definition:** Paravirtualized device framework for virtual machines
**Context:** Includes Virtio-GPU (video), Virtio-NIC (network), provides better performance than emulated devices
**Used in:** VM performance and networking configuration
**Learn More:** [Performance Tuning](../vm/docs/performance.md), [Video & Display](../vm/docs/video-display.md)

### VNC (Virtual Network Computing)

**Definition:** Remote display protocol for virtual machines
**Context:** Alternative to SPICE, more compatible but less performant
**Used in:** VM display configuration
**Learn More:** [Video & Display](../vm/docs/video-display.md)

### VSync (Vertical Synchronization)

**Definition:** Synchronizes frame rate with monitor refresh rate
**Context:** Eliminates screen tearing
**Configuration:** Set in compositor (picom, KWin)

### VT-x (Intel Virtualization Technology)

**Definition:** Intel's hardware-assisted virtualization extension
**Context:** Required for KVM on Intel CPUs, check with `lscpu | grep -i vmx`
**Used in:** VM installation prerequisites
**Learn More:** [Installation & Setup](../vm/docs/installation-setup.md), [lscpu command](../shell-commands/02-commands/lscpu.md)

### VLAN (Virtual LAN)

**Definition:** Logical separation of networks at Layer 2, often used to segment guest/IoT devices
**Context:** Guest networks are commonly separate VLANs/subnets with isolation rules
**Used in:** Explaining why guest Wi‑Fi can’t reach Pi-hole
**Learn More:** [Routing/VLANs/Guest Networks](../networking/docs/routing-vlans-guest.md)

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

| Acronym | Full Name                                  | Category      |
| ------- | ------------------------------------------ | ------------- |
| AC      | Alternating Current                        | Power         |
| ACPI    | Advanced Configuration and Power Interface | Firmware      |
| BAT     | Battery                                    | Power         |
| BIOS    | Basic Input/Output System                  | Firmware      |
| CID     | Control ID                                 | Input Devices |
| CPU     | Central Processing Unit                    | Hardware      |
| CUPS    | Common UNIX Printing System                | Printing      |
| dGPU    | Discrete GPU                               | Graphics      |
| DKMS    | Dynamic Kernel Module Support              | Drivers       |
| DPI     | Dots Per Inch                              | Input Devices |
| DRM     | Direct Rendering Manager                   | Graphics      |
| eDP     | Embedded DisplayPort                       | Display       |
| GPU     | Graphics Processing Unit                   | Hardware      |
| GRUB    | GRand Unified Bootloader                   | Boot          |
| GuC     | Graphics Micro Controller                  | Graphics      |
| HDMI    | High-Definition Multimedia Interface       | Display       |
| HID     | Human Interface Device                     | Input Devices |
| HuC     | HDCP Micro Controller                      | Graphics      |
| HWP     | Hardware P-States                          | CPU           |
| iGPU    | Integrated GPU                             | Graphics      |
| IPP     | Internet Printing Protocol                 | Printing      |
| KDE     | K Desktop Environment                      | Desktop       |
| KMS     | Kernel Mode Setting                        | Graphics      |
| LTS     | Long Term Support                          | Kernel        |
| NVMe    | Non-Volatile Memory Express                | Storage       |
| NVM     | Node Version Manager                       | Development   |
| OCR     | Optical Character Recognition              | Scanning      |
| PAT     | Page Attribute Table                       | Memory        |
| PDF     | Portable Document Format                   | Documents     |
| PWM     | Pulse Width Modulation                     | Hardware      |
| RAM     | Random Access Memory                       | Hardware      |
| RAW     | (Unprocessed image data)                   | Photography   |
| SANE    | Scanner Access Now Easy                    | Scanning      |
| SSD     | Solid State Drive                          | Storage       |
| TLP     | (No expansion - just TLP)                  | Power         |
| USB     | Universal Serial Bus                       | Hardware      |

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
