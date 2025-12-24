# virsh Command Practice

Master the `virsh` command-line interface for VM management.

---

## Prerequisites

- At least one VM created
- Basic understanding of virsh (see [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md))

---

## Drill 1: List VMs

**Command:**

```bash
virsh list --all
```

**Expected output:**

```
Id   Name      State
---------------------
1    ubuntu    running
-    kali      shut off
```

**What to learn:**

- `--all` shows all VMs (running and shut off)
- Without `--all`, shows only running VMs
- Id shows VM ID (only for running VMs)

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

## Drill 2: Start/Stop VMs

**Start VM:**

```bash
virsh start <vm-name>
```

**Stop VM (graceful shutdown):**

```bash
virsh shutdown <vm-name>
```

**Force stop VM:**

```bash
virsh destroy <vm-name>
```

**What to learn:**

- `start` starts a shut-off VM
- `shutdown` sends shutdown signal (graceful)
- `destroy` force stops (like unplugging power)

**Best practice:** Use `shutdown` for normal stops, `destroy` only if VM is frozen.

---

## Drill 3: Get VM Info

**Basic info:**

```bash
virsh dominfo <vm-name>
```

**What it shows:**

- VM name, UUID
- CPU info
- Memory info
- State

**Full XML:**

```bash
virsh dumpxml <vm-name>
```

**What it shows:**

- Complete VM configuration
- Useful for debugging
- Can be used to recreate VM

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

## Drill 4: Network Management

**List networks:**

```bash
virsh net-list --all
```

**Network info:**

```bash
virsh net-info default
```

**Network XML:**

```bash
virsh net-dumpxml default
```

**Start network:**

```bash
sudo virsh net-start default
```

**Stop network:**

```bash
sudo virsh net-destroy default
```

**Autostart network:**

```bash
sudo virsh net-autostart default
```

**What to learn:**

- Network management commands
- `net-autostart` enables network on boot
- `net-dumpxml` shows network configuration

**Learn more:**

- [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)
- [`../docs/networking.md`](../docs/networking.md)

---

## Drill 5: Snapshot Operations

**List snapshots:**

```bash
virsh snapshot-list <vm-name>
```

**Create snapshot:**

```bash
virsh snapshot-create-as <vm-name> <snapshot-name> --description "Before upgrade"
```

**Snapshot info:**

```bash
virsh snapshot-info <vm-name> <snapshot-name>
```

**Revert to snapshot:**

```bash
virsh snapshot-revert <vm-name> <snapshot-name>
```

**Delete snapshot:**

```bash
virsh snapshot-delete <vm-name> <snapshot-name>
```

**What to learn:**

- Snapshots require `qcow2` disk format
- Snapshots are point-in-time recovery points
- Delete snapshots after experiments conclude

**Learn more:**

- [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)
- [`../docs/storage.md`](../docs/storage.md)

---

## Drill 6: VM Console Access

**Connect to console:**

```bash
virsh console <vm-name>
```

**To exit:** Press `Ctrl+]`

**What to learn:**

- Console access for headless VMs
- Requires guest OS to have console enabled
- Useful for debugging boot issues

**Note:** May need to configure guest OS for console access.

---

## Drill 7: VM Autostart

**Enable autostart:**

```bash
virsh autostart <vm-name>
```

**Disable autostart:**

```bash
virsh autostart --disable <vm-name>
```

**What to learn:**

- Autostart makes VM start on host boot
- Useful for server VMs
- Not recommended for desktop VMs

---

## Drill 8: Guest Agent Commands

**Guest info:**

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

**Shutdown via agent:**

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-shutdown"}'
```

**What to learn:**

- Requires guest agent installed in VM
- More reliable than `virsh shutdown`
- Can get detailed guest information

**Learn more:** [`../docs/performance.md`](../docs/performance.md)

---

## Drill 9: VM Statistics

**Get stats:**

```bash
virsh domstats <vm-name>
```

**What it shows:**

- CPU usage
- Memory usage
- Disk I/O
- Network I/O

**Useful for:**

- Performance monitoring
- Resource planning
- Troubleshooting

---

## Drill 10: Create VM from XML

**Export VM:**

```bash
virsh dumpxml <vm-name> > <vm-name>.xml
```

**Edit XML (if needed):**

```bash
nano <vm-name>.xml
```

**Define VM from XML:**

```bash
virsh define <vm-name>.xml
```

**What to learn:**

- XML is the native VM format
- Can modify VM configuration via XML
- Useful for advanced configurations

**Warning:** Be careful editing XML — syntax errors can break VM.

---

## Verification Checklist

After completing drills, you should be able to:

- [ ] List all VMs (running and shut off)
- [ ] Start and stop VMs gracefully
- [ ] Get VM information and configuration
- [ ] Manage libvirt networks
- [ ] Create and manage snapshots
- [ ] Access VM console
- [ ] Enable VM autostart
- [ ] Use guest agent commands
- [ ] Monitor VM statistics
- [ ] Export/import VM XML

---

## Next Steps

- **Advanced topics:** [`../docs/advanced.md`](../docs/advanced.md)
- **Automation:** See [`../docs/advanced.md`](../docs/advanced.md) for scripting examples
- **Troubleshooting:** [`../docs/troubleshooting.md`](../docs/troubleshooting.md)

---

## Learn More

- **Full virsh reference:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)
- **Arch Wiki:** [libvirt](https://wiki.archlinux.org/title/Libvirt)
