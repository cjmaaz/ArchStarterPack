# lsmod - List Loaded Kernel Modules

`lsmod` shows which kernel modules are currently loaded. For VM setup, this is used to verify KVM modules are loaded.

---

## 📋 Quick Reference

```bash
lsmod                          # List all loaded modules
lsmod | grep kvm              # Check KVM modules
lsmod | grep <module-name>    # Check specific module
```

---

## Check KVM Modules

**For VM setup, this is the most important check:**

```bash
lsmod | grep kvm
```

**Expected output:**

```
kvm_intel            245760  0
kvm                  901120  1 kvm_intel
```

**Or for AMD:**

```
kvm_amd               245760  0
kvm                   901120  1 kvm_amd
```

**What it shows:**

- `kvm_intel` or `kvm_amd`: CPU-specific KVM module
- `kvm`: Core KVM module
- Numbers show memory usage and dependencies

**If modules not loaded:**

- Virtualization disabled in BIOS
- Enable **Intel VT-x** or **AMD-V** in BIOS/UEFI
- Reboot and check again

---

## List All Modules

```bash
lsmod
```

**Output:**

```
Module                  Size  Used by
kvm_intel            245760  0
kvm                  901120  1 kvm_intel
nvidia              12345678  5
...
```

**Columns:**

- `Module`: Module name
- `Size`: Memory size
- `Used by`: Dependencies (what uses this module)

---

## Check Specific Module

```bash
lsmod | grep <module-name>
```

**Examples:**

```bash
# Check KVM
lsmod | grep kvm

# Check NVIDIA
lsmod | grep nvidia

# Check network modules
lsmod | grep -E "bridge|veth|virbr"
```

---

## Module Dependencies

**Understanding "Used by":**

```bash
lsmod | grep kvm
```

**Output:**

```
kvm_intel            245760  0
kvm                  901120  1 kvm_intel
```

**Interpretation:**

- `kvm_intel` has no dependencies (`0`)
- `kvm` is used by `kvm_intel` (`1 kvm_intel`)

**This means:**

- `kvm_intel` depends on `kvm`
- If you unload `kvm`, `kvm_intel` will also unload

---

## VM Context

### Verify KVM Support

Before creating VMs, verify:

```bash
# Check KVM modules
lsmod | grep kvm

# Check for virtualization errors
dmesg | grep -i kvm
```

**Why this matters:**

- KVM modules must be loaded for virtualization
- If modules not loaded, VMs won't work
- Check kernel messages if modules fail to load

---

## Related Commands

**Load module:**

```bash
sudo modprobe <module-name>
```

**Unload module:**

```bash
sudo modprobe -r <module-name>
```

**Module info:**

```bash
modinfo <module-name>
```

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
