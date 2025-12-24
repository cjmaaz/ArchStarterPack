# KVM + QEMU + virt-manager

### Arch Linux Virtualization Starter Guide

This document describes how to set up **KVM + QEMU + virt-manager** on an Arch-based Linux system (including CachyOS) for running other Linux distributions in virtual machines.

This setup is:

* 100% free and open-source
* Native to the Linux kernel
* Faster and more stable than VirtualBox on rolling-release systems
* Suitable for learning, testing, and long-term use

---

## What This Stack Is (Conceptual Overview)

Before installing anything, it helps to know what each piece does:

* **KVM (Kernel-based Virtual Machine)**
  A Linux kernel module that enables hardware-assisted virtualization.
  This is the core technology — if KVM works, everything else builds on top.

* **QEMU**
  A userspace emulator and virtualizer. When paired with KVM, it provides near-native performance.

* **libvirt**
  A daemon and API that manages virtual machines, storage, and networks.

* **virt-manager**
  A graphical user interface for libvirt. Comparable to VirtualBox’s GUI, but more powerful and more Linux-native.

Think of it as:

> Kernel (KVM) → Engine (QEMU) → Control Plane (libvirt) → Dashboard (virt-manager)

---

## Prerequisites

### 1. Hardware Virtualization Support

Your CPU **must** support virtualization.

Check with:

```bash
lscpu | grep -i virtualization
```

Expected output:

* `VT-x` → Intel CPUs
* `AMD-V` → AMD CPUs

If nothing appears:

* Reboot into BIOS/UEFI
* Enable **Intel VT-x** or **SVM / AMD-V**
* Save and reboot

No software workaround exists for this.

---

### 2. Kernel Support

Arch-based distributions ship with KVM support enabled by default.
No custom kernel builds are required.

---

## Installation (pacman)

Install the full virtualization stack:

```bash
sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libvirt edk2-ovmf
```

### What these packages provide

* `qemu-full` → QEMU with full feature set
* `virt-manager` → GUI VM manager
* `virt-viewer` → Lightweight VM console
* `libvirt` → VM management daemon
* `dnsmasq` → Virtual networking
* `bridge-utils` → Network bridges (future-proofing)
* `edk2-ovmf` → UEFI firmware for modern guest OSes

---

## Enable and Start libvirt

libvirt must be running for any VM to work.

```bash
sudo systemctl enable --now libvirtd
```

Verify status:

```bash
systemctl status libvirtd
```

You should see `active (running)`.

---

## User Permissions (Important)

To manage virtual machines without root access, add your user to the `libvirt` group:

```bash
sudo usermod -aG libvirt $(whoami)
```

⚠️ **You must log out and log back in** for this to take effect.

Skipping this step leads to confusing permission errors later.

---

## Launching virt-manager

Start the GUI:

```bash
virt-manager
```

On first launch:

* Default connection should be **QEMU/KVM**
* Status should show **Connected**
* No errors about permissions or hypervisor availability

If virt-manager opens but cannot connect, permissions or libvirtd status is usually the cause.

---

## Creating Your First Virtual Machine

1. Click **Create New Virtual Machine**
2. Choose **Local install media (ISO image)**
3. Select a Linux ISO file
4. Allow automatic OS detection (or override if needed)
5. Allocate:

   * Memory (RAM)
   * CPU cores
6. Create virtual disk (qcow2 recommended)
7. Finish and boot

That’s it. You are now running a Linux distro inside Linux.

---

## Recommended Defaults (Sane Choices)

* **Disk format**: `qcow2`
  Supports snapshots and compression

* **Firmware**: UEFI (OVMF)
  Better compatibility with modern distros

* **Display**: SPICE
  Best balance of performance and features

* **Network**: NAT (default)
  Works out of the box, safe for beginners

---

## Networking Notes

By default, libvirt creates a NATed virtual network:

* Guests can access the internet
* Host is protected
* No extra configuration required

Advanced setups (bridged networking, VLANs, etc.) can be added later without reinstalling anything.

---

## Storage Location

Default VM storage paths:

* Images: `/var/lib/libvirt/images/`
* XML configs: `/etc/libvirt/qemu/`

These are managed automatically by libvirt.
Manual editing is rarely needed.

---

## Troubleshooting

### virt-manager shows “QEMU/KVM not available”

* Ensure virtualization is enabled in BIOS
* Verify KVM modules are loaded:

  ```bash
  lsmod | grep kvm
  ```

### Permission denied errors

* Confirm user is in `libvirt` group:

  ```bash
  groups
  ```
* Log out and log back in

### Black screen or boot issues

* Ensure UEFI firmware (OVMF) is selected
* Try switching display from SPICE to VNC (temporary debugging)

---

## Why This Instead of VirtualBox?

On Arch-based systems:

* Kernel updates are frequent
* VirtualBox kernel modules can break
* KVM is part of the kernel itself

This means:

* Fewer breakages
* Better performance
* Less maintenance over time

This is the same stack used on:

* Linux servers
* CI systems
* Cloud infrastructure
* Professional virtualization environments

---

## Uninstall (Clean Removal)

If you ever want to remove everything:

```bash
sudo systemctl disable --now libvirtd
sudo pacman -Rns qemu-full virt-manager virt-viewer dnsmasq bridge-utils libvirt edk2-ovmf
```

VM images may remain in `/var/lib/libvirt/images/` if created manually — remove if desired.

---

## Final Notes

This setup is ideal for:

* Learning Linux distributions
* Testing configs safely
* Running experimental environments
* Long-term, stable virtualization on Arch

Once configured, it rarely needs attention — which is exactly what good infrastructure should do.
