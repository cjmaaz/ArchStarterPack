# lscpu - Display CPU Information

`lscpu` displays information about the CPU architecture, including virtualization support flags.

---

## 📋 Quick Reference

```bash
lscpu                          # All CPU information
lscpu | grep -i virtualization # Check virtualization support
lscpu -p                       # Parseable format
```

---

## Check Virtualization Support

**For VM setup, this is the most important check:**

```bash
lscpu | grep -i virtualization
```

**Expected output:**

- **Intel:** `VT-x`
- **AMD:** `AMD-V` or `SVM`

**If nothing appears:**

- Virtualization disabled in BIOS
- Enable **Intel VT-x** or **AMD-V / SVM** in BIOS/UEFI
- Reboot and check again

---

## Full CPU Information

```bash
lscpu
```

**Output:**

```
Architecture:            x86_64
CPU op-mode(s):          32-bit, 64-bit
Address sizes:           39 bits physical, 48 bits virtual
CPU(s):                  8
On-line CPU(s) list:     0-7
Thread(s) per core:      2
Core(s) per socket:      4
Socket(s):               1
Vendor ID:               GenuineIntel
CPU family:               6
Model:                    142
Model name:               Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
Stepping:                 10
CPU MHz:                  1800.000
CPU max MHz:              3400.0000
CPU min MHz:              400.0000
BogoMIPS:                 3600.00
Virtualization:           VT-x
L1d cache:                32K
L1i cache:                32K
L2 cache:                 256K
L3 cache:                 6144K
```

**What it shows:**

- CPU architecture
- Number of cores/threads
- CPU model and speed
- **Virtualization support** (VT-x/AMD-V)
- Cache sizes

---

## Parseable Format

```bash
lscpu -p
```

**Output:**

```
# The following is the parsable format, which can be fed to other
# programs. Each different item in every column has an unique ID
# starting from zero.
# CPU,Core,Socket,Node,,L1d,L1i,L2,L3
0,0,0,0,,0,0,0,0
1,1,0,0,,1,1,1,0
...
```

**Useful for:**

- Scripting
- Parsing CPU topology
- CPU pinning configuration

---

## VM Context

### Verify Host CPU Capabilities

Before creating VMs, verify:

```bash
# Check virtualization support
lscpu | grep -i virtualization

# Check CPU cores available
lscpu | grep "^CPU(s):"

# Check CPU model
lscpu | grep "Model name"
```

**Why this matters:**

- Virtualization support required for KVM
- CPU cores determine how many vCPUs you can allocate
- CPU model affects performance

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **VM performance:** [`../../vm/docs/performance.md`](../../vm/docs/performance.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
