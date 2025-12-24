# VM Documentation — Reading Order

This directory contains structured learning materials for KVM/QEMU/libvirt virtualization. Follow this reading order for a complete understanding.

---

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] **Hardware virtualization support** (VT-x/AMD-V)
  - Verify: [`../shell-commands/02-commands/lscpu.md`](../../shell-commands/02-commands/lscpu.md)
- [ ] **Basic networking knowledge** (recommended)
  - If unfamiliar: [`../../networking/README.md`](../../networking/README.md)
- [ ] **Arch Linux or Arch-based distribution**
- [ ] **Root/sudo access**

---

## Recommended Reading Order

### 1. Foundations

**Virtualization Basics** → [`virtualization-basics.md`](virtualization-basics.md)

- What is virtualization?
- KVM vs QEMU vs libvirt vs virt-manager
- Hypervisor types
- Guest vs Host concepts
- Hardware virtualization (VT-x, AMD-V, IOMMU)

**Installation & Setup** → [`installation-setup.md`](installation-setup.md)

- Hardware prerequisites
- Package installation
- Service management
- User permissions
- First VM creation

### 2. Core Configuration

**VM Networking** → [`networking.md`](networking.md)

- libvirt NAT networking model
- Host-side verification
- Firewall configuration
- Guest-side network setup
- IPv6 handling
- Links to [`../../networking/docs/`](../../networking/docs/) for foundational concepts

**Performance Tuning** → [`performance.md`](performance.md)

- Why "low CPU" ≠ "fast VM"
- CPU configuration (host-passthrough)
- Memory allocation strategies
- Video device models
- Desktop animations impact
- Guest agent benefits

**Video & Display** → [`video-display.md`](video-display.md)

- Virtio-GPU vs QXL
- 3D acceleration
- Display protocols (SPICE vs VNC)
- Desktop compositor considerations
- HiDPI handling

### 3. Storage & Advanced

**Storage** → [`storage.md`](storage.md)

- Disk image formats (qcow2 vs raw)
- Snapshot types and management
- Backup strategies
- Storage pools
- Disk performance

**Advanced Topics** → [`advanced.md`](advanced.md)

- GPU passthrough (VFIO)
- Bridged networking
- CPU pinning
- Headless VMs
- Automation with virsh
- Migration between hosts

### 4. Troubleshooting

**Troubleshooting** → [`troubleshooting.md`](troubleshooting.md)

- Common symptoms → root causes
- Permission issues
- Network problems
- Performance issues
- Boot failures

---

## Quick Reference

- **New to virtualization?** Start with [`virtualization-basics.md`](virtualization-basics.md)
- **Ready to install?** Follow [`installation-setup.md`](installation-setup.md)
- **VM networking issues?** See [`networking.md`](networking.md)
- **VM feels slow?** Check [`performance.md`](performance.md)
- **Display problems?** See [`video-display.md`](video-display.md)
- **Need advanced features?** Read [`advanced.md`](advanced.md)
- **Something broken?** Check [`troubleshooting.md`](troubleshooting.md)

---

## Practice

After reading the docs, practice with hands-on drills:

- [`../practice/drills.md`](../practice/drills.md) — Index of all practice drills

---

## Cross-References

- **Networking concepts:** [`../../networking/docs/`](../../networking/docs/)
- **Command documentation:** [`../../shell-commands/02-commands/`](../../shell-commands/02-commands/)
- **Glossary:** [`../../docs/GLOSSARY.md`](../../docs/GLOSSARY.md)
