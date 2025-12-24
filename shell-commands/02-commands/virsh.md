# virsh - libvirt Command-Line Interface

`virsh` is the command-line interface for libvirt, the virtualization management daemon. It allows you to manage virtual machines, networks, storage, and more from the command line.

**Why learn virsh?** GUI tools are convenient, but CLI tools are reproducible, scriptable, and debuggable. If virt-manager is the cockpit, `virsh` is the flight manual.

---

## 📋 Quick Reference

```bash
virsh list --all              # List all VMs
virsh start <vm-name>         # Start VM
virsh shutdown <vm-name>      # Graceful shutdown
virsh destroy <vm-name>       # Force stop
virsh dominfo <vm-name>       # VM information
virsh dumpxml <vm-name>       # VM XML configuration
virsh net-list --all         # List networks
virsh net-dumpxml default     # Network configuration
virsh snapshot-list <vm-name> # List snapshots
virsh snapshot-create-as <vm-name> <snap-name> # Create snapshot
```

---

## VM Management

### List VMs

```bash
virsh list --all
```

**Output:**

```
Id   Name      State
---------------------
1    ubuntu    running
-    kali      shut off
```

**What it shows:**

- `Id`: VM ID (only for running VMs)
- `Name`: VM name
- `State`: running, paused, shut off

**Without `--all`:** Shows only running VMs.

---

### Start VM

```bash
virsh start <vm-name>
```

**Example:**

```bash
virsh start ubuntu
```

**What it does:**

- Starts a shut-off VM
- Returns immediately (VM boots in background)

**Verify:**

```bash
virsh list
```

---

### Stop VM (Graceful Shutdown)

```bash
virsh shutdown <vm-name>
```

**Example:**

```bash
virsh shutdown ubuntu
```

**What it does:**

- Sends shutdown signal to guest OS
- Guest OS shuts down gracefully
- Requires guest agent for reliable shutdown

**Force stop (if VM frozen):**

```bash
virsh destroy <vm-name>
```

⚠️ **Warning:** `destroy` is like unplugging power — use only if VM is frozen.

---

### VM Information

**Basic info:**

```bash
virsh dominfo <vm-name>
```

**Output:**

```
Id:             1
Name:           ubuntu
UUID:           12345678-1234-1234-1234-123456789abc
OS Type:        hvm
State:          running
CPU(s):         4
CPU time:       1234.5s
Max memory:     8388608 KiB
Used memory:    4194304 KiB
```

**Full XML configuration:**

```bash
virsh dumpxml <vm-name>
```

**What it shows:**

- Complete VM configuration
- Useful for debugging
- Can be saved and used to recreate VM

**Example use:**

```bash
# Export VM configuration
virsh dumpxml ubuntu > ubuntu.xml

# Edit if needed
nano ubuntu.xml

# Define VM from XML (on another host)
virsh define ubuntu.xml
```

---

## Network Management

### List Networks

```bash
virsh net-list --all
```

**Output:**

```
Name      State    Autostart
------------------------------
default   active   yes
```

**What it shows:**

- `Name`: Network name
- `State`: active or inactive
- `Autostart`: Starts automatically on boot

---

### Network Information

**Basic info:**

```bash
virsh net-info default
```

**Full XML:**

```bash
virsh net-dumpxml default
```

**Output:**

```xml
<network>
  <name>default</name>
  <forward mode="nat"/>
  <bridge name="virbr0" stp="on" delay="0"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
```

**What to look for:**

- `<forward mode="nat">` ← NAT mode
- `<bridge name="virbr0">` ← Bridge name
- `<dhcp>` range ← DHCP range

---

### Start/Stop Network

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

**Disable autostart:**

```bash
sudo virsh net-autostart --disable default
```

---

## Snapshot Management

### List Snapshots

```bash
virsh snapshot-list <vm-name>
```

**Output:**

```
Name         Creation Time             State
------------------------------------------------------------
pre-upgrade  2024-01-15 10:30:00 -0500  disk
```

**What it shows:**

- Snapshot name
- Creation time
- State (disk or disk+memory)

---

### Create Snapshot

```bash
virsh snapshot-create-as <vm-name> <snapshot-name> --description "Before upgrade"
```

**Example:**

```bash
virsh snapshot-create-as ubuntu pre-upgrade --description "Before upgrading packages"
```

**What it does:**

- Creates disk snapshot (point-in-time recovery)
- VM can continue running
- Requires `qcow2` disk format

**Verify:**

```bash
virsh snapshot-list ubuntu
```

---

### Revert to Snapshot

```bash
virsh snapshot-revert <vm-name> <snapshot-name>
```

**Example:**

```bash
virsh snapshot-revert ubuntu pre-upgrade
```

⚠️ **Warning:** This will discard all changes since snapshot.

---

### Delete Snapshot

```bash
virsh snapshot-delete <vm-name> <snapshot-name>
```

**Example:**

```bash
virsh snapshot-delete ubuntu pre-upgrade
```

**What it does:**

- Deletes snapshot
- Frees disk space
- Cannot be undone

---

## Guest Agent Commands

### Guest Information

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

**What it shows:**

- Guest agent version
- Supported commands
- Requires guest agent installed in VM

**If command fails:**

- Guest agent not installed/running
- Install in VM: `sudo apt install -y qemu-guest-agent`

---

### Shutdown via Agent

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-shutdown"}'
```

**Why use this:**

- More reliable than `virsh shutdown`
- Works even if guest OS is unresponsive to signals

---

## VM Autostart

**Enable autostart:**

```bash
virsh autostart <vm-name>
```

**Disable autostart:**

```bash
virsh autostart --disable <vm-name>
```

**What it does:**

- VM starts automatically on host boot
- Useful for server VMs
- Not recommended for desktop VMs

**Verify:**

```bash
virsh dominfo <vm-name> | grep -i autostart
```

---

## VM Statistics

**Get stats:**

```bash
virsh domstats <vm-name>
```

**Output:**

```
Domain: 'ubuntu'
  state.state=1
  state.reason=5
  cpu.time=1234567890
  cpu.user=123456789
  cpu.system=123456789
  balloon.current=4194304
  balloon.maximum=8388608
  ...
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

## VM Console Access

**Connect to console:**

```bash
virsh console <vm-name>
```

**To exit:** Press `Ctrl+]`

**What it does:**

- Provides serial console access
- Useful for headless VMs
- Requires guest OS to have console enabled

**Note:** May need to configure guest OS for console access.

---

## Common Use Cases

### Backup VM

```bash
# Export VM configuration
virsh dumpxml ubuntu > ubuntu.xml

# Copy disk image
sudo cp /var/lib/libvirt/images/ubuntu.qcow2 /backup/location/
```

### Restore VM

```bash
# Copy disk image back
sudo cp /backup/location/ubuntu.qcow2 /var/lib/libvirt/images/

# Define VM from XML
virsh define ubuntu.xml
```

### Start All VMs on Boot

```bash
for vm in $(virsh list --name --all); do
    virsh autostart $vm
done
```

### Stop All Running VMs

```bash
for vm in $(virsh list --name); do
    virsh shutdown $vm
done
```

---

## VM Context Examples

### Check if VM Networking is Working

```bash
# List networks
virsh net-list --all

# Check default network
virsh net-dumpxml default | grep -i nat

# Check VM network interface
virsh dumpxml <vm-name> | grep -i interface
```

### Verify Guest Agent

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

### Monitor VM Performance

```bash
# Get VM stats
virsh domstats <vm-name>

# Get VM info
virsh dominfo <vm-name>
```

---

## Learn More

- **VM networking:** [`../../vm/docs/networking.md`](../../vm/docs/networking.md)
- **VM performance:** [`../../vm/docs/performance.md`](../../vm/docs/performance.md)
- **VM storage:** [`../../vm/docs/storage.md`](../../vm/docs/storage.md)
- **VM advanced:** [`../../vm/docs/advanced.md`](../../vm/docs/advanced.md)
- **Practice drills:** [`../../vm/practice/virsh-drills.md`](../../vm/practice/virsh-drills.md)
- **Arch Wiki:** [libvirt](https://wiki.archlinux.org/title/Libvirt)
