# Installation & Setup

Complete guide for installing KVM/QEMU/libvirt on Arch Linux and creating your first virtual machine.

---

## Hardware Prerequisites

### 1. CPU Virtualization Support

Your CPU **must** support hardware virtualization. This is a fundamental requirement for KVM.

### Why CPU Virtualization Support is Required

**The problem without hardware virtualization:**

- **Software emulation:** CPU instructions must be emulated in software
- **Extremely slow:** 10-100x slower than native performance
- **Not usable:** Too slow for practical use
- **High overhead:** Host CPU spends most time emulating, not running

**The solution with hardware virtualization:**

- **Hardware-assisted:** CPU has special instructions for virtualization
- **Near-native performance:** <5% overhead (vs 1000%+ with emulation)
- **Production-ready:** Suitable for real workloads
- **Efficient:** CPU handles virtualization natively

**Real-world comparison:**

- **Without extensions:** Like running Windows on a calculator (possible but unusable)
- **With extensions:** Like running Windows on a computer (fast and usable)

**What CPU extensions provide:**

- **Virtualization instructions:** Special CPU instructions for VM operations
- **Hardware isolation:** CPU enforces VM isolation at hardware level
- **Efficient switching:** Fast context switching between host and guest
- **Performance:** Near-native execution speed

### What VT-x/AMD-V Actually Do

**Intel VT-x (Virtualization Technology):**

- **What it is:** Intel's CPU extension for hardware virtualization
- **What it adds:** Special CPU instructions for VM operations
- **Performance impact:** Enables near-native VM performance
- **Check:** `lscpu | grep -i vmx` (should show `vmx`)

**AMD-V (AMD Virtualization) / SVM (Secure Virtual Machine):**

- **What it is:** AMD's CPU extension for hardware virtualization
- **What it adds:** Special CPU instructions for VM operations
- **Performance impact:** Enables near-native VM performance
- **Check:** `lscpu | grep -i svm` (should show `svm`)

**Performance comparison:**

- **Without extensions:** Software emulation → 10-100x slower
- **With extensions:** Hardware-assisted → <5% overhead
- **Example:** Task takes 1 second native → 10-100 seconds emulated → 1.05 seconds with extensions

**Why extensions are required:**

- **Efficiency:** Hardware is much faster than software emulation
- **Isolation:** Hardware-level isolation (more secure)
- **Performance:** Production-grade performance
- **Standard:** All modern CPUs have these extensions

**Check support:**

```bash
lscpu | grep -i virtualization
```

**Expected output:**

- Intel: `VT-x` (or `vmx` in flags)
- AMD: `AMD-V` or `SVM` (or `svm` in flags)

**If nothing appears:**

1. Reboot into BIOS/UEFI
2. Enable **Intel VT-x** or **AMD-V / SVM**
3. Save and reboot

### Why BIOS Enablement is Required

**The problem:**

- CPU extensions are **disabled by default** in BIOS/UEFI
- Security measure (prevents some attack vectors)
- Must be explicitly enabled

**Why disabled by default:**

- **Security:** Some attacks use virtualization extensions
- **Compatibility:** Some old software doesn't work with extensions
- **Power:** Extensions use slightly more power
- **Default safe:** Disabled = safer default

**Why enable:**

- **Required for KVM:** KVM needs extensions to work
- **Performance:** Without extensions, VMs are unusably slow
- **Modern use:** All modern systems should enable it

⚠️ **No software workaround exists** — this is a hardware requirement. You cannot use KVM without enabling virtualization in BIOS.

**Learn more:** [`../../shell-commands/02-commands/lscpu.md`](../../shell-commands/02-commands/lscpu.md)

---

### 2. Kernel Support

Arch-based distributions ship with KVM support enabled by default. No custom kernel builds required.

**Verify KVM modules:**

```bash
lsmod | grep kvm
```

**Expected output:**

```
kvm_intel        (or kvm_amd)
kvm
```

**Learn more:** [`../../shell-commands/02-commands/lsmod.md`](../../shell-commands/02-commands/lsmod.md)

---

## Package Installation

### Install the Full Stack

```bash
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libvirt edk2-ovmf
```

### Why Each Package is Needed

**qemu-full:**

- **What:** QEMU emulator with full feature set
- **Why "full":** Includes all QEMU features (vs minimal `qemu` package)
- **What it provides:** VM runtime (CPU, memory, device emulation)
- **Why needed:** Core component - creates and runs VMs
- **Alternative:** `qemu` (minimal, missing features)

**virt-manager:**

- **What:** Graphical user interface for VM management
- **Why GUI:** Easier than command-line for beginners
- **What it provides:** Visual VM creation, management, console
- **Why needed:** User-friendly interface (like VirtualBox GUI)
- **Alternative:** `virsh` (CLI only, more complex)

**virt-viewer:**

- **What:** Lightweight VM console viewer
- **Why separate:** Can view VM display without full virt-manager
- **What it provides:** Display VM screen (SPICE/VNC client)
- **Why needed:** View VM console, remote access
- **Alternative:** Built into virt-manager (but separate tool useful)

**libvirt:**

- **What:** VM management daemon and API
- **Why daemon:** Runs in background, manages VMs continuously
- **What it provides:** VM lifecycle, storage, network management
- **Why needed:** Core management layer (virt-manager/virsh use it)
- **Dependency:** Required by virt-manager and virsh

**dnsmasq:**

- **What:** DHCP and DNS server for virtual networks
- **Why needed:** Provides DHCP/DNS for VM networks (virbr0)
- **What it provides:** IP assignment, DNS resolution for VMs
- **Why needed:** VMs need network configuration (DHCP assigns IPs)
- **Used by:** libvirt default network (virbr0)

**bridge-utils:**

- **What:** Utilities for network bridge management
- **Why needed:** Future-proofing (bridged networking)
- **What it provides:** Bridge management tools
- **Why needed:** Advanced networking (bridged mode)
- **Note:** May be replaced by `ip` command, but still useful

**edk2-ovmf:**

- **What:** UEFI firmware for VMs (Open Virtual Machine Firmware)
- **Why UEFI:** Modern firmware (vs legacy BIOS)
- **What it provides:** UEFI boot support for VMs
- **Why needed:** Required for Windows 10/11, modern Linux distros
- **Alternative:** Legacy BIOS (limited compatibility)

### Package Dependencies Explained

**How packages depend on each other:**

```
libvirt (core)
    ↓
    ├──→ virt-manager (uses libvirt API)
    ├──→ virsh (uses libvirt API)
    └──→ dnsmasq (used by libvirt for networking)

qemu-full (VM runtime)
    ↓
    └──→ Used by libvirt to create/run VMs

virt-manager (GUI)
    ↓
    └──→ Uses libvirt to manage VMs

edk2-ovmf (firmware)
    ↓
    └──→ Used by libvirt/QEMU for UEFI boot
```

**What happens if one is missing:**

- **Missing libvirt:** Can't manage VMs (no daemon)
- **Missing qemu-full:** Can't create/run VMs (no runtime)
- **Missing virt-manager:** Can't use GUI (must use CLI)
- **Missing dnsmasq:** VMs won't get IP addresses (no DHCP)
- **Missing edk2-ovmf:** Can't boot modern OSes (no UEFI)

**Why certain combinations are required:**

- **libvirt + qemu-full:** libvirt needs QEMU to run VMs
- **libvirt + dnsmasq:** libvirt needs DHCP for VM networking
- **virt-manager + libvirt:** GUI needs management daemon
- **qemu-full + edk2-ovmf:** Modern VMs need UEFI firmware

### What These Packages Provide

| Package        | Purpose                             | Critical?             |
| -------------- | ----------------------------------- | --------------------- |
| `qemu-full`    | QEMU with full feature set          | Yes                   |
| `virt-manager` | GUI VM manager                      | No (can use virsh)    |
| `virt-viewer`  | Lightweight VM console              | No (optional)         |
| `libvirt`      | VM management daemon                | Yes                   |
| `dnsmasq`      | Virtual networking (DHCP/DNS)       | Yes (for NAT)         |
| `bridge-utils` | Network bridges (future-proofing)   | No (optional)         |
| `edk2-ovmf`    | UEFI firmware for modern guest OSes | Yes (for modern OSes) |

---

## Enable and Start libvirt

libvirt must be running for any VM to work.

**Enable and start:**

```bash
sudo systemctl enable --now libvirtd
```

**Verify status:**

```bash
systemctl status libvirtd
```

**Expected output:**

```
● libvirtd.service - Virtualization daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled)
     Active: active (running) since ...
```

**Learn more:** [`../../shell-commands/02-commands/systemctl.md`](../../shell-commands/02-commands/systemctl.md)

---

## User Permissions

To manage virtual machines without root access, add your user to the `libvirt` group.

### Why libvirt Group is Needed

**The problem:**

- libvirt daemon runs as **root** (needs privileged access)
- Regular users can't communicate with root daemon
- Without group: Permission denied errors
- With group: User can manage VMs

**Why libvirt daemon runs as root:**

- **Hardware access:** Needs access to virtualization hardware
- **Network management:** Creates/manages virtual networks
- **Storage management:** Manages disk images
- **Security:** Controlled access (only group members)

**What group membership grants:**

- **Permission to communicate** with libvirt daemon
- **Ability to create/manage VMs** (through libvirt)
- **Access to VM management** (start, stop, configure)
- **No root password needed** (for VM operations)

**Without group membership:**

- Permission denied errors
- Can't create VMs
- Can't start/stop VMs
- Must use `sudo` for everything

**With group membership:**

- Can manage VMs normally
- No `sudo` needed (for VM operations)
- Works with virt-manager GUI
- Works with virsh CLI

**Add user to group:**

```bash
sudo usermod -aG libvirt $(whoami)
```

### Why Logout is Required

**The problem:**

- Groups are loaded **at login time**
- Adding to group doesn't affect current session
- Current session still has old group list
- Must logout/login to reload groups

**Why groups load at login:**

- **Security:** Groups loaded once at login (prevents privilege escalation)
- **Efficiency:** Loaded once, not continuously checked
- **Session isolation:** Each session has own group list
- **Standard behavior:** How Linux user management works

**What happens if you don't logout:**

- Group membership not active in current session
- Still get permission denied errors
- virt-manager can't connect
- Must use `sudo` (defeats the purpose)

**Alternative (temporary):**

```bash
newgrp libvirt
```

- **What it does:** Starts new shell with libvirt group active
- **Limitation:** Only affects that shell session
- **Use case:** Quick test without logout
- **Note:** Still need logout for permanent effect

⚠️ **You must log out and log back in** for this to take effect permanently.

**Verify membership:**

```bash
groups
```

Should show `libvirt` in the list.

**If not showing:**

1. Verify command ran: `sudo usermod -aG libvirt $(whoami)`
2. Log out completely (not just close terminal)
3. Log back in
4. Check again: `groups | grep libvirt`

**Learn more:**

- [`../../shell-commands/02-commands/usermod.md`](../../shell-commands/02-commands/usermod.md)
- [`../../shell-commands/02-commands/groups.md`](../../shell-commands/02-commands/groups.md)

---

## Launch virt-manager

**Start the GUI:**

```bash
virt-manager
```

**On first launch, verify:**

- Default connection should be **QEMU/KVM**
- Status should show **Connected**
- No errors about permissions or hypervisor availability

**If virt-manager cannot connect:**

- Check `libvirtd` is running: `systemctl status libvirtd`
- Verify user is in `libvirt` group: `groups`
- Log out and log back in if you just added yourself to the group

---

## Creating Your First Virtual Machine

### Step-by-Step Walkthrough

1. **Click "Create New Virtual Machine"** in virt-manager

2. **Choose installation method:**

   - **Local install media (ISO image)** ← Recommended for beginners

3. **Select ISO file:**

   - Browse to your Linux ISO (Ubuntu, Kali, Arch, etc.)
   - Allow automatic OS detection (or override if needed)

4. **Allocate resources:**

   - **Memory (RAM):** Start with 2-4 GB for most Linux distros
   - **CPU cores:** Start with 2-4 cores (don't over-allocate)

5. **Create virtual disk:**

   - **Size:** 20-40 GB for most Linux distros
   - **Format:** `qcow2` ← Recommended (supports snapshots)

6. **Review and finish:**

   - VM name
   - Network: **NAT (default)** ← Safe for beginners
   - Firmware: **UEFI (OVMF)** ← Better compatibility

7. **Boot and install:**
   - VM will start automatically
   - Follow the guest OS installation process

---

## Recommended Defaults

### Disk Format: `qcow2`

**Why:**

- Supports snapshots
- Copy-on-write (saves disk space)
- Better for learning and experimentation

**Alternative:** `raw` (better performance, no snapshots)

### Firmware: UEFI (OVMF)

**Why:**

- Better compatibility with modern distros
- Required for Windows 10/11
- Required for GPU passthrough

**Alternative:** BIOS (legacy, simpler but less compatible)

### Display: SPICE

**Why:**

- Best balance of performance and features
- Good clipboard integration
- Better than VNC for most use cases

**Alternative:** VNC (more compatible, less performant)

### Network: NAT (default)

**Why:**

- Works out of the box
- Safe (no inbound exposure)
- No extra configuration required

**Alternative:** Bridged networking (see [`advanced.md`](advanced.md))

---

## Storage Locations

Default VM storage paths:

- **Images:** `/var/lib/libvirt/images/`
- **XML configs:** `/etc/libvirt/qemu/`

These are managed automatically by libvirt. Manual editing is rarely needed.

---

## Verification Checklist

After installation, verify:

- [ ] CPU virtualization support: `lscpu | grep -i virtualization`
- [ ] KVM modules loaded: `lsmod | grep kvm`
- [ ] libvirtd running: `systemctl status libvirtd`
- [ ] User in libvirt group: `groups | grep libvirt`
- [ ] virt-manager connects: Launch `virt-manager` and verify connection
- [ ] Default network active: `virsh net-list --all` (should show `default`)

**Practice:** [`../practice/setup-drills.md`](../practice/setup-drills.md)

---

## Troubleshooting Installation

### "QEMU/KVM not available" in virt-manager

**Causes:**

- Virtualization disabled in BIOS
- KVM modules not loaded

**Solutions:**

1. Enable virtualization in BIOS/UEFI
2. Verify modules: `lsmod | grep kvm`
3. Check kernel messages: `dmesg | grep -i kvm`

**Learn more:** [`troubleshooting.md`](troubleshooting.md)

### Permission denied errors

**Causes:**

- User not in `libvirt` group
- Didn't log out after adding to group

**Solutions:**

1. Add user: `sudo usermod -aG libvirt $(whoami)`
2. **Log out and log back in**
3. Verify: `groups | grep libvirt`

### Black screen or boot issues

**Causes:**

- Wrong firmware selected
- Display model issues

**Solutions:**

1. Ensure UEFI firmware (OVMF) is selected
2. Try switching display from SPICE to VNC (temporary debugging)
3. See [`video-display.md`](video-display.md) for display troubleshooting

---

## Uninstall (Clean Removal)

If you ever want to remove everything:

```bash
sudo systemctl disable --now libvirtd
sudo pacman -Rns qemu-full virt-manager virt-viewer dnsmasq bridge-utils libvirt edk2-ovmf
```

**Note:** VM images may remain in `/var/lib/libvirt/images/` — remove manually if desired.

---

## Next Steps

- **VM networking issues?** → [`networking.md`](networking.md)
- **VM feels slow?** → [`performance.md`](performance.md)
- **Display problems?** → [`video-display.md`](video-display.md)
- **Ready for advanced topics?** → [`advanced.md`](advanced.md)

---

## Learn More

- **Arch Wiki:** [KVM Installation](https://wiki.archlinux.org/title/KVM#Installation)
- **Practice drills:** [`../practice/setup-drills.md`](../practice/setup-drills.md)
