# Storage Management

Disk image formats, snapshots, backups, and storage pools for KVM/QEMU virtual machines.

---

## Disk Image Formats

Understanding disk formats is crucial for VM performance and features.

### qcow2 Explained Deeply

**What is qcow2?**

**qcow2** (QEMU Copy-On-Write version 2) is an advanced disk image format with features like snapshots and compression.

**What is copy-on-write?**
- **Copy-on-write:** Changes written to separate file, original unchanged
- **Base image:** Original disk image (read-only)
- **Overlay:** Changes stored separately
- **Efficient:** Only stores changes, not entire disk

**How snapshots work internally:**
- **Base image:** Original state (read-only)
- **Snapshot layer:** Changes since snapshot
- **Multiple layers:** Can have multiple snapshots
- **Revert:** Discard overlay, return to base

**Why sparse allocation saves space:**
- **Sparse file:** Only allocates space for written data
- **Empty space:** Not allocated on disk
- **Example:** 40GB image with 10GB used = 10GB on disk
- **Efficient:** Saves disk space

**Performance implications:**
- **Slightly slower:** Overhead for copy-on-write
- **More complex:** Multiple layers to read
- **Write amplification:** Writes may trigger multiple operations
- **Still fast:** Overhead usually minimal

**qcow2 (Recommended)**

**What it is:**

- Copy-on-write disk image format
- Supports snapshots and compression
- Default format in virt-manager

**Pros:**

- **Snapshots:** Point-in-time recovery (undo changes)
- **Compression:** Saves disk space (optional)
- **Sparse allocation:** Only uses space for written data
- **Better for learning:** Easy to experiment safely

**Cons:**

- **Slightly slower:** More overhead than raw
- **More complex:** Internal structure more complex
- **Write amplification:** Some writes trigger multiple operations

**When to use:**

- Most desktop VMs (default choice)
- When you need snapshots (experimentation)
- Learning and testing environments
- When disk space matters (sparse allocation)

**Example:**

```bash
# Create qcow2 disk
qemu-img create -f qcow2 vm-disk.qcow2 40G
```

**What this creates:**
- **File:** `vm-disk.qcow2` (40GB virtual size)
- **Actual size:** ~200KB (sparse, empty)
- **Grows:** As data is written

---

### raw Explained Deeply

**What is raw format?**

**raw** is a simple disk image format that stores data directly byte-for-byte.

**What it means:**
- **Direct mapping:** Each byte in file = byte on virtual disk
- **No overhead:** No format-specific structures
- **Simple:** Just raw data, nothing else
- **Fast:** No processing needed

**Why it's faster:**
- **No overhead:** No copy-on-write processing
- **Direct I/O:** Reads/writes go directly to file
- **Simple:** No complex structures to manage
- **Native speed:** Almost as fast as physical disk

**When to use:**
- **Performance-critical:** Need maximum speed
- **No snapshots needed:** Don't need undo capability
- **Production servers:** Maximum performance priority
- **Simple use case:** Don't need advanced features

**Trade-offs:**
- **No snapshots:** Can't undo changes
- **Full allocation:** Uses full size immediately
- **Less flexible:** Fewer features

**raw**

**What it is:**

- Raw disk image (direct byte-for-byte)
- Simple format
- Maximum performance

**Pros:**

- **Fastest performance:** No overhead
- **Simple structure:** Easy to understand
- **Easy to mount:** Can mount directly on host
- **Direct access:** No format processing

**Cons:**

- **No snapshots:** Can't create snapshots
- **Uses full allocated space:** 40GB image = 40GB on disk
- **Less flexible:** Fewer features than qcow2

**When to use:**

- Performance-critical VMs (maximum speed)
- When snapshots aren't needed (production)
- Production servers (performance priority)
- Simple use cases (no advanced features needed)

**Example:**

```bash
# Create raw disk
qemu-img create -f raw vm-disk.raw 40G
```

**What this creates:**
- **File:** `vm-disk.raw` (40GB size)
- **Actual size:** 40GB (fully allocated)
- **No overhead:** Direct byte mapping

---

## Snapshot Types

Snapshots allow you to save VM state and revert to it later. Understanding how they work is crucial.

### How Snapshots Work

**Copy-on-write mechanism:**
- **Base image:** Original disk state (read-only)
- **Snapshot layer:** Changes stored separately
- **Read:** Reads from base + snapshot layers
- **Write:** Writes to snapshot layer only

**Base image + changes:**
- **Base:** Original state (unchanged)
- **Changes:** Modifications since snapshot
- **Combined:** Base + changes = current state
- **Revert:** Discard changes, return to base

**Revert = discard changes:**
- **Revert:** Delete snapshot layer
- **Result:** Return to base image state
- **Loss:** All changes since snapshot lost
- **Use case:** Undo unwanted changes

**Performance impact explained:**
- **Multiple layers:** Must read from multiple files
- **Write amplification:** Writes may trigger multiple operations
- **Disk fragmentation:** Layers can fragment
- **Slower:** More overhead than no snapshots

### Disk-Only Snapshot

**What it is:**

- Captures filesystem state at a point in time
- VM can continue running
- Can revert to snapshot later

**How it works:**
- **Creates overlay:** New layer for changes
- **Base frozen:** Original state preserved
- **Changes tracked:** All writes go to overlay
- **Revert:** Delete overlay, return to base

**Use cases:**

- **Before risky upgrades:** Safe rollback point
- **Before config experiments:** Test safely
- **Learning system internals:** Experiment freely
- **"Undo" functionality:** Revert mistakes

**Create snapshot:**

```bash
virsh snapshot-create-as <vm-name> <snapshot-name> --description "Before upgrade"
```

**What this does:**
- Creates snapshot layer
- Freezes base image
- Tracks changes in overlay
- VM continues running

**List snapshots:**

```bash
virsh snapshot-list <vm-name>
```

**Shows:**
- Snapshot names
- Creation times
- Descriptions
- Current snapshot

**Revert to snapshot:**

```bash
virsh snapshot-revert <vm-name> <snapshot-name>
```

**What this does:**
- Deletes snapshot layer
- Returns to base state
- **Warning:** All changes since snapshot lost
- VM state restored to snapshot time

**Delete snapshot:**

```bash
virsh snapshot-delete <vm-name> <snapshot-name>
```

**What this does:**
- Merges snapshot into base
- Removes snapshot layer
- **Warning:** Can't revert after deletion
- Frees disk space (if merged)

---

### Memory Snapshot (Save State)

**What it is:**

- Captures exact running state (memory + disk)
- VM is paused during snapshot
- Can resume exactly where it left off

**Use cases:**

- Pausing long-running VMs
- Quick state preservation
- Testing scenarios

**Save state:**

```bash
virsh save <vm-name> /path/to/save-file
```

**Restore state:**

```bash
virsh restore /path/to/save-file
```

---

## Snapshot Best Practices

### Why Snapshots Slow Down

**Multiple layers to read:**
- **Base + overlay:** Must read from multiple files
- **More I/O:** More disk operations
- **Slower reads:** More overhead
- **Performance impact:** Noticeable with many snapshots

**Write amplification:**
- **Writes trigger multiple operations:** Base + overlay
- **More disk writes:** Amplified write operations
- **Slower writes:** More overhead
- **Impact:** Worse with many snapshots

**Disk fragmentation:**
- **Layers fragment:** Overlay files fragment
- **Slower access:** Fragmented files slower
- **Performance degradation:** Gets worse over time
- **Impact:** Significant with many snapshots

**When to avoid snapshots:**
- **Performance-critical VMs:** Need maximum speed
- **Heavy I/O workloads:** Database servers, etc.
- **Production servers:** Performance priority
- **Long-running VMs:** Fragmentation accumulates

### Do:

- **Use `qcow2` format:** Required for snapshots (raw doesn't support)
- **Create snapshots before risky changes:** Safe rollback point
- **Delete snapshots after experiments:** Free disk space, improve performance
- **Name snapshots descriptively:** Easy to identify later

### Don't:

- **Chain dozens of snapshots:** Performance impact (too many layers)
- **Keep snapshots on performance-critical VMs:** Slows down VM
- **Use snapshots as long-term backups:** Not reliable backup solution
- **Create snapshots while VM is under heavy I/O:** Can cause issues

---

## Backup Strategies

### Full Backup

**What to backup:**

1. Disk image (`/var/lib/libvirt/images/<vm-name>.qcow2`)
2. XML definition (`/etc/libvirt/qemu/<vm-name>.xml`)

**Backup disk:**

```bash
# While VM is shut down
sudo cp /var/lib/libvirt/images/<vm-name>.qcow2 /backup/location/
```

**Backup XML:**

```bash
virsh dumpxml <vm-name> > /backup/location/<vm-name>.xml
```

**Restore:**

```bash
# Copy disk image back
sudo cp /backup/location/<vm-name>.qcow2 /var/lib/libvirt/images/

# Define VM from XML
virsh define /backup/location/<vm-name>.xml
```

---

### Incremental Backup

**Using qcow2 backing files:**

**Create base image:**

```bash
qemu-img create -f qcow2 base.qcow2 40G
```

**Create VM with backing file:**

```bash
qemu-img create -f qcow2 -b base.qcow2 vm.qcow2
```

**Backup only changes:**

```bash
# Backup only the overlay (changes since base)
cp vm.qcow2 /backup/
```

---

## Storage Pools

### What Are Storage Pools?

Storage pools are libvirt's way of managing VM storage locations. They abstract the underlying storage.

**Default pool:**

- Location: `/var/lib/libvirt/images/`
- Type: Filesystem directory

**List pools:**

```bash
virsh pool-list --all
```

**Pool info:**

```bash
virsh pool-info default
```

---

### Creating Custom Storage Pools

**Create directory pool:**

```bash
# Create directory
sudo mkdir -p /mnt/vm-storage

# Define pool
virsh pool-define-as vm-storage dir - - - - /mnt/vm-storage

# Build and start pool
virsh pool-build vm-storage
virsh pool-start vm-storage
virsh pool-autostart vm-storage
```

**Use custom pool:**

- Select pool when creating VM in virt-manager
- Or specify in VM XML

---

## Disk Performance Considerations

### Host Storage

**SSD:**

- Best performance
- Lower latency
- Recommended for VMs

**HDD:**

- Slower but acceptable
- Use for less critical VMs
- Consider raw format for better performance

**NVMe:**

- Best performance
- Lowest latency
- Ideal for high-performance VMs

---

### Disk Cache Modes

**In virt-manager: Disk → Advanced options**

**Options:**

- **Default:** Host OS manages cache
- **None:** Direct I/O (safest, slowest)
- **Writeback:** Write caching (faster, less safe)
- **Writethrough:** Read cache only (balanced)

**Recommendation:**

- **Default** for most use cases
- **None** for data integrity critical VMs

---

## Migration Between Hosts

### Export VM

**Export disk:**

```bash
# Copy disk image
scp /var/lib/libvirt/images/<vm-name>.qcow2 user@new-host:/path/
```

**Export XML:**

```bash
virsh dumpxml <vm-name> > <vm-name>.xml
scp <vm-name>.xml user@new-host:/path/
```

---

### Import VM

**On new host:**

```bash
# Copy disk image to storage location
sudo cp <vm-name>.qcow2 /var/lib/libvirt/images/

# Define VM from XML
virsh define <vm-name>.xml

# Start VM
virsh start <vm-name>
```

**Note:** May need to adjust paths in XML if storage locations differ.

---

## Disk Space Management

### Check Disk Usage

**VM disk usage:**

```bash
qemu-img info <vm-name>.qcow2
```

**Actual vs allocated:**

- `qcow2` shows "virtual size" (allocated) vs "disk size" (actual)
- `raw` shows only allocated size

---

### Shrink Disk (qcow2)

**Inside VM:**

```bash
# Zero out free space
sudo dd if=/dev/zero of=/tmp/zero bs=1M
sudo rm /tmp/zero
```

**On host:**

```bash
# Shrink qcow2 image
qemu-img convert -O qcow2 <vm-name>.qcow2 <vm-name>-shrunk.qcow2
```

---

## Next Steps

- **Advanced topics:** [`advanced.md`](advanced.md)
- **Troubleshooting:** [`troubleshooting.md`](troubleshooting.md)

---

## Learn More

- **Arch Wiki:** [QEMU Storage](https://wiki.archlinux.org/title/QEMU#Storage)
- **qemu-img manual:** `man qemu-img`
