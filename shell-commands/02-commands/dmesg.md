# dmesg - Display Kernel Ring Buffer

`dmesg` displays kernel ring buffer messages, including hardware detection, driver loading, and error messages. For VM setup, this is used to check for virtualization-related messages.

---

## 📋 Quick Reference

```bash
dmesg                          # All kernel messages
dmesg | grep -i kvm            # KVM-related messages
dmesg | grep -i iommu          # IOMMU messages (for GPU passthrough)
dmesg | grep -i error          # Error messages
dmesg | tail -n 50            # Last 50 messages
dmesg -w                       # Watch new messages (follow mode)
```

---

## Check KVM Messages

**For VM setup:**

```bash
dmesg | grep -i kvm
```

**Expected output:**

```
[    0.123456] kvm: Nested Virtualization enabled
[    0.234567] kvm: support for 'kvm_intel' acceleration
```

**What to look for:**

- KVM support enabled
- Acceleration support (kvm_intel/kvm_amd)
- Any error messages

**If errors appear:**

- Check BIOS virtualization settings
- Check CPU compatibility

---

## Check IOMMU Messages

**For GPU passthrough:**

```bash
dmesg | grep -i iommu
```

**Expected output:**

```
[    0.123456] DMAR: IOMMU enabled
[    0.234567] AMD-Vi: IOMMU enabled
```

**What to look for:**

- `DMAR` (Intel VT-d)
- `AMD-Vi` (AMD IOMMU)
- IOMMU enabled confirmation

**If nothing appears:**

- IOMMU disabled in BIOS
- IOMMU not enabled in kernel parameters

---

## Filter Error Messages

```bash
dmesg | grep -i error
```

**What it shows:**

- Kernel errors
- Driver errors
- Hardware errors

**Useful for:**

- Troubleshooting VM issues
- Identifying hardware problems
- Debugging driver issues

---

## Last N Messages

```bash
dmesg | tail -n 50
```

**What it shows:**

- Last 50 kernel messages
- Most recent events
- Useful for recent issues

---

## Watch Mode

```bash
dmesg -w
```

**What it does:**

- Follows new kernel messages
- Like `tail -f` for kernel log
- Press `Ctrl+C` to exit

**Useful for:**

- Real-time debugging
- Watching for errors
- Monitoring hardware events

---

## Clear Messages

**Note:** `dmesg` shows messages since last boot. To see only new messages:

```bash
# Clear ring buffer (requires root)
sudo dmesg -C

# Then watch for new messages
dmesg -w
```

⚠️ **Warning:** Clearing dmesg removes all messages — use only if needed.

---

## Common Filters

**KVM-related:**

```bash
dmesg | grep -i kvm
```

**IOMMU-related:**

```bash
dmesg | grep -i iommu
```

**Errors:**

```bash
dmesg | grep -i error
```

**Warnings:**

```bash
dmesg | grep -i warn
```

**Virtualization:**

```bash
dmesg | grep -i -E "kvm|iommu|virtualization"
```

---

## VM Context

### Verify Virtualization Support

```bash
# Check KVM messages
dmesg | grep -i kvm

# Check IOMMU (for GPU passthrough)
dmesg | grep -i iommu

# Check for errors
dmesg | grep -i error
```

### Troubleshooting VM Issues

```bash
# Check for VM-related errors
dmesg | grep -i -E "kvm|qemu|libvirt"

# Check recent messages
dmesg | tail -n 100
```

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **VM advanced (GPU passthrough):** [`../../vm/docs/advanced.md`](../../vm/docs/advanced.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
