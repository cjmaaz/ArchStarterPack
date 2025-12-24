# Virtualization with KVM + QEMU + libvirt

This module is a **systematic learning path** to understand and use KVM/QEMU/libvirt virtualization on Arch Linux. Learn how to create, configure, and manage virtual machines for learning, testing, and production use.

If you're here because "my VM has no internet" or "my VM feels slow," you likely have a **networking** or **performance configuration** issue.

---

## Start Here (recommended reading order)

Follow the structured path in [`docs/README.md`](docs/README.md) for a complete learning journey, or jump to specific topics:

1. **Virtualization basics** (what is KVM/QEMU/libvirt?)
   - [`docs/virtualization-basics.md`](docs/virtualization-basics.md)
2. **Installation & setup** (hardware check, packages, permissions, first VM)
   - [`docs/installation-setup.md`](docs/installation-setup.md)
3. **VM networking** (NAT, bridges, DHCP, firewall)
   - [`docs/networking.md`](docs/networking.md)
4. **Performance tuning** (CPU, memory, graphics, guest agent)
   - [`docs/performance.md`](docs/performance.md)
5. **Video & display** (Virtio vs QXL, 3D acceleration, SPICE vs VNC)
   - [`docs/video-display.md`](docs/video-display.md)
6. **Storage** (disk formats, snapshots, backups)
   - [`docs/storage.md`](docs/storage.md)
7. **Advanced topics** (GPU passthrough, bridged networking, automation)
   - [`docs/advanced.md`](docs/advanced.md)
8. **Troubleshooting** (common issues and solutions)
   - [`docs/troubleshooting.md`](docs/troubleshooting.md)
9. **Practice drills** (hands-on verification)
   - [`practice/drills.md`](practice/drills.md)

---

## Prerequisites

Before starting, ensure you have:

- **Hardware virtualization support** (VT-x for Intel, AMD-V for AMD)
  - Check: [`../shell-commands/02-commands/lscpu.md`](../shell-commands/02-commands/lscpu.md)
- **Basic networking knowledge** (recommended but not required)
  - If unfamiliar with NAT, DHCP, DNS: [`../networking/README.md`](../networking/README.md)
- **Arch Linux or Arch-based distribution** (CachyOS, Manjaro, EndeavourOS, etc.)
- **Root/sudo access** (for installation and service management)

---

## Quick Start

1. **Verify hardware support:**

   ```bash
   lscpu | grep -i virtualization
   ```

   Should show `VT-x` (Intel) or `AMD-V` (AMD). If not, enable in BIOS.

2. **Install packages:**

   ```bash
   sudo pacman -S qemu-full virt-manager virt-viewer dnsmasq bridge-utils libvirt edk2-ovmf
   ```

3. **Enable libvirt:**

   ```bash
   sudo systemctl enable --now libvirtd
   ```

4. **Add user to libvirt group:**

   ```bash
   sudo usermod -aG libvirt $(whoami)
   ```

   ⚠️ **Log out and log back in** for this to take effect.

5. **Launch virt-manager:**
   ```bash
   virt-manager
   ```

For detailed explanations and troubleshooting, see [`docs/installation-setup.md`](docs/installation-setup.md).

---

## Tools you'll use (with docs)

- **VM management:** [`../shell-commands/02-commands/virsh.md`](../shell-commands/02-commands/virsh.md)
- **CPU info:** [`../shell-commands/02-commands/lscpu.md`](../shell-commands/02-commands/lscpu.md)
- **Kernel modules:** [`../shell-commands/02-commands/lsmod.md`](../shell-commands/02-commands/lsmod.md)
- **System logs:** [`../shell-commands/02-commands/dmesg.md`](../shell-commands/02-commands/dmesg.md)
- **Service management:** [`../shell-commands/02-commands/systemctl.md`](../shell-commands/02-commands/systemctl.md)
- **User management:** [`../shell-commands/02-commands/usermod.md`](../shell-commands/02-commands/usermod.md), [`../shell-commands/02-commands/groups.md`](../shell-commands/02-commands/groups.md)
- **Network config:** [`../shell-commands/02-commands/nmcli.md`](../shell-commands/02-commands/nmcli.md), [`../shell-commands/02-commands/resolvectl.md`](../shell-commands/02-commands/resolvectl.md)
- **Firewall:** [`../shell-commands/02-commands/ufw.md`](../shell-commands/02-commands/ufw.md)
- **Network inspection:** [`../shell-commands/02-commands/ip.md`](../shell-commands/02-commands/ip.md), [`../shell-commands/02-commands/ping.md`](../shell-commands/02-commands/ping.md)

---

## How this connects to other modules

- **Networking module:** Understanding NAT, bridges, DHCP, and DNS helps troubleshoot VM networking issues. See [`../networking/README.md`](../networking/README.md).
- **System optimization:** Host performance tuning affects VM performance. See [`../system-optimization/README.md`](../system-optimization/README.md).
- **Pi-hole:** VMs can use Pi-hole for DNS filtering. See [`../pi-hole/README.md`](../pi-hole/README.md).

---

## Key Concepts (Quick Glossary)

- **KVM (Kernel-based Virtual Machine):** Linux kernel module enabling hardware-assisted virtualization
- **QEMU:** Userspace emulator/virtualizer that provides the VM runtime
- **libvirt:** Management daemon and API for VMs, storage, and networks
- **virt-manager:** Graphical UI for libvirt (like VirtualBox's GUI)
- **virsh:** Command-line interface for libvirt
- **Guest:** The virtual machine running inside the host
- **Host:** The physical machine running the hypervisor
- **NAT:** Network Address Translation (default VM networking mode)
- **virbr0:** libvirt's default virtual bridge for NAT networking
- **qcow2:** Copy-on-write disk image format (supports snapshots)
- **Guest Agent:** Service inside VM for better host↔guest integration

For full definitions, see [`../docs/GLOSSARY.md`](../docs/GLOSSARY.md).

---

## Why KVM/QEMU instead of VirtualBox?

On Arch-based systems:

- **KVM is part of the kernel** → fewer breakages with kernel updates
- **Better performance** → hardware-assisted virtualization
- **More stable** → same stack used in production servers and cloud infrastructure
- **More powerful** → advanced features like GPU passthrough, live migration

---

## Next Steps

1. **New to virtualization?** Start with [`docs/virtualization-basics.md`](docs/virtualization-basics.md)
2. **Ready to install?** Follow [`docs/installation-setup.md`](docs/installation-setup.md)
3. **VM networking issues?** See [`docs/networking.md`](docs/networking.md)
4. **VM feels slow?** Check [`docs/performance.md`](docs/performance.md)
5. **Want hands-on practice?** Try [`practice/drills.md`](practice/drills.md)
