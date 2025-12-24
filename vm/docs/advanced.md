# Advanced Topics

GPU passthrough, bridged networking, CPU pinning, headless VMs, automation, and migration.

---

## GPU Passthrough (VFIO)

### What GPU Passthrough Is

GPU passthrough allows a virtual machine to **directly control a physical GPU**, bypassing the host's graphics stack.

**Results:**

- Near-native GPU performance inside the VM
- Required for gaming, CUDA, OpenCL, or graphics-heavy workloads
- Commonly used for Windows or Linux GPU compute VMs

This is done using **VFIO (Virtual Function I/O)**.

---

### Hardware Requirements

GPU passthrough is strict about physics:

- CPU with **IOMMU support**
  - Intel: VT-d
  - AMD: AMD-Vi
- Motherboard firmware must support IOMMU
- Preferably **two GPUs:**
  - One for host
  - One dedicated to VM

Single-GPU passthrough is possible but significantly more complex.

---

### Verify IOMMU Support

```bash
dmesg | grep -i iommu
```

**Expected indicators:**

- `DMAR` (Intel)
- `AMD-Vi` (AMD)

**Learn more:** [`../../shell-commands/02-commands/dmesg.md`](../../shell-commands/02-commands/dmesg.md)

---

### High-Level Steps (Overview Only)

GPU passthrough deserves its _own_ deep dive, but conceptually:

1. Enable IOMMU in BIOS
2. Enable IOMMU in kernel parameters (`intel_iommu=on` or `amd_iommu=on`)
3. Bind target GPU to `vfio-pci`
4. Prevent host drivers from claiming it
5. Attach GPU + audio device to VM
6. Use UEFI (OVMF) firmware in VM

**If any of those steps sound mysterious, that's normal** — GPU passthrough is an **advanced** feature by definition.

---

### When to Use GPU Passthrough

**Good use cases:**

- Machine learning
- GPU compute workloads
- Gaming VMs
- Driver isolation testing

**Bad use cases:**

- Casual distro hopping
- Learning Linux basics
- Lightweight desktop VMs

If your goal is _learning Linux_, GPU passthrough is usually overkill.

---

## Bridged Networking

### What Bridged Networking Is

By default, libvirt uses **NAT networking:**

- VM can access the internet
- VM is hidden behind the host

**Bridged networking** puts the VM on the **same network as the host:**

- VM gets its own IP from the LAN
- Appears as a separate machine on the network
- Useful for servers, labs, and services

---

### When Bridging Makes Sense

**Use bridged networking if:**

- You want SSH access into the VM from other machines
- You're testing servers, DNS, DHCP, Kubernetes, etc.
- You want realistic network behavior

**Stick with NAT if:**

- You're just testing distros
- You want zero configuration
- Security simplicity matters

---

### Conceptual Setup

Bridging involves:

- Creating a bridge interface on the host
- Attaching the physical NIC to the bridge
- Attaching the VM's virtual NIC to the bridge

On modern Arch systems using NetworkManager, this is usually done **via GUI** or `nmcli`.

**Learn more:** [`../../networking/docs/routing-vlans-guest.md`](../../networking/docs/routing-vlans-guest.md)

---

### libvirt Integration

Once a bridge exists:

- virt-manager can attach VM NICs to it
- No VM reinstall required
- Can switch between NAT and bridge per-VM

**In virt-manager:**

- VM → NIC → Network source: **Bridge device** → Select bridge

---

## Snapshots & VM State Management

### Snapshot Types

KVM supports **disk snapshots** and **VM state snapshots**.

- **Disk-only snapshot:** Filesystem state
- **Memory snapshot:** Exact running state (pause & resume)

**Learn more:** [`storage.md`](storage.md)

---

### Snapshot Use Cases

Snapshots are perfect for:

- Risky upgrades
- Config experiments
- Learning system internals
- "Undo" functionality

---

### Best Practices

- Use `qcow2` disks
- Don't chain dozens of snapshots
- Delete snapshots once experiments conclude
- Avoid snapshots on performance-critical VMs

---

### Managing Snapshots

Snapshots can be managed:

- Directly in virt-manager (GUI)
- Via `virsh` (CLI)
- Via XML definitions (advanced)

**Learn more:** [`storage.md`](storage.md)

---

## Headless Virtual Machines

### What "Headless" Means

A headless VM:

- Runs without a graphical console
- Accessed via SSH, serial console, or services
- Ideal for servers and automation

---

### Why Headless VMs Matter

- Lower resource usage
- Closer to real-world servers
- Easier automation
- No GUI overhead

---

### Common Access Methods

- **SSH:** Most common
- **`virsh console`:** Serial console access
- **Port-forwarded services:** Web dashboards, APIs
- **Web dashboards:** Hosted inside VM

---

## Automation with `virsh`

### What `virsh` Is

`virsh` is the **command-line interface** for libvirt.

**It allows:**

- Starting/stopping VMs
- Snapshot control
- Network management
- Automation scripts

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

### Typical Use Cases

- Booting VMs on system startup
- Scripting lab environments
- CI testing
- Infrastructure-as-code experiments

---

### Why Learn virsh?

GUI tools are convenient. CLI tools are **reproducible, scriptable, and debuggable**.

If virt-manager is the cockpit, `virsh` is the flight manual.

---

### Example Scripts

**Start VM on boot:**

```bash
# Enable autostart
virsh autostart <vm-name>
```

**Stop all VMs:**

```bash
for vm in $(virsh list --name); do
    virsh shutdown $vm
done
```

**Create snapshot before upgrade:**

```bash
virsh snapshot-create-as <vm-name> pre-upgrade --description "Before upgrade"
```

---

## CPU Pinning & Performance Tuning

### What CPU Pinning Does

CPU pinning binds VM vCPUs to specific host CPU cores.

**Benefits:**

- Reduced latency
- More predictable performance
- Useful for real-time or compute-heavy workloads

---

### When to Use It

- Database testing
- Real-time workloads
- Latency-sensitive apps
- GPU passthrough VMs

**Avoid premature tuning** — defaults are good for most cases.

---

### How to Pin CPUs

**In virt-manager:**

- CPUs → Topology → CPU pinning
- Select specific cores

**Via virsh:**

```bash
virsh vcpupin <vm-name> <vcpuid> <hostcpuid>
```

---

## Backups & Portability

### VM Backup Strategy

A VM is just:

- A disk image
- An XML definition

**Backing up both allows:**

- Easy restoration
- Migration to another host
- Versioned experimentation

**Learn more:** [`storage.md`](storage.md)

---

### Migration Use Case

You can:

- Copy disk image
- Export XML
- Import VM on another machine
- Resume where you left off

This makes KVM an excellent learning and lab platform.

---

## Final Philosophy

KVM + QEMU + libvirt is not "just a VirtualBox replacement".

It is:

- Infrastructure
- A learning platform
- A gateway to how Linux servers actually work

You can start simple, and _grow into complexity only when needed_.

That scalability — from a single test VM to a full lab — is the real power of this stack.

---

## Next Steps

- **Troubleshooting:** [`troubleshooting.md`](troubleshooting.md)
- **Practice:** [`../practice/virsh-drills.md`](../practice/virsh-drills.md)

---

## Learn More

- **Arch Wiki:** [PCI passthrough](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- **Arch Wiki:** [Network bridges](https://wiki.archlinux.org/title/Network_bridge)
