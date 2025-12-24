# VM Practice Drills

Hands-on exercises to verify your VM setup and build muscle memory with virtualization commands.

---

## Drill Categories

### 1. Setup Verification

[`setup-drills.md`](setup-drills.md)

- Verify CPU virtualization support
- Check KVM modules loaded
- Verify libvirtd running
- Check user permissions
- List libvirt networks

### 2. Networking Troubleshooting

[`networking-drills.md`](networking-drills.md)

- Inspect default network
- Check virbr0 interface
- Verify firewall rules
- Test guest DHCP
- Test connectivity

### 3. Performance Tuning

[`performance-drills.md`](performance-drills.md)

- Check CPU passthrough
- Verify guest agent
- Monitor VM resources
- Test display performance

### 4. virsh Command Practice

[`virsh-drills.md`](virsh-drills.md)

- List VMs
- Start/stop VMs
- Get VM info
- Network management
- Snapshot operations

---

## How to Use These Drills

1. **Read the corresponding doc first** (e.g., read [`../docs/networking.md`](../docs/networking.md) before doing networking drills)
2. **Run each command yourself** — don't just read
3. **Interpret the output** — understand what each result means
4. **Troubleshoot if needed** — if something fails, use [`../docs/troubleshooting.md`](../docs/troubleshooting.md)

---

## Prerequisites

Before starting drills, ensure:

- [ ] KVM/QEMU/libvirt installed (see [`../docs/installation-setup.md`](../docs/installation-setup.md))
- [ ] At least one VM created
- [ ] Basic command-line familiarity

---

## Quick Reference

- **Setup issues?** → [`setup-drills.md`](setup-drills.md)
- **Network issues?** → [`networking-drills.md`](networking-drills.md)
- **Performance issues?** → [`performance-drills.md`](performance-drills.md)
- **Want to master virsh?** → [`virsh-drills.md`](virsh-drills.md)
