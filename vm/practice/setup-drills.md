# Setup Verification Drills

Verify your VM installation and configuration step by step.

---

## Drill 1: Verify CPU Virtualization Support

**Command:**

```bash
lscpu | grep -i virtualization
```

**Expected output:**

- Intel: `VT-x`
- AMD: `AMD-V` or `SVM`

**If nothing appears:**

- Enable virtualization in BIOS/UEFI
- Reboot and try again

**Learn more:** [`../../shell-commands/02-commands/lscpu.md`](../../shell-commands/02-commands/lscpu.md)

---

## Drill 2: Check KVM Modules Loaded

**Command:**

```bash
lsmod | grep kvm
```

**Expected output:**

```
kvm_intel        (or kvm_amd)
kvm
```

**If modules not loaded:**

- Check kernel messages: `dmesg | grep -i kvm`
- Verify virtualization enabled in BIOS

**Learn more:** [`../../shell-commands/02-commands/lsmod.md`](../../shell-commands/02-commands/lsmod.md)

---

## Drill 3: Verify libvirtd Running

**Command:**

```bash
systemctl status libvirtd
```

**Expected output:**

```
● libvirtd.service - Virtualization daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled)
     Active: active (running) since ...
```

**If not running:**

```bash
sudo systemctl enable --now libvirtd
```

**Learn more:** [`../../shell-commands/02-commands/systemctl.md`](../../shell-commands/02-commands/systemctl.md)

---

## Drill 4: Check User in libvirt Group

**Command:**

```bash
groups
```

**Expected:** Should show `libvirt` in the list

**If not in group:**

```bash
sudo usermod -aG libvirt $(whoami)
```

⚠️ **Log out and log back in** after adding to group.

**Verify again:**

```bash
groups | grep libvirt
```

**Learn more:**

- [`../../shell-commands/02-commands/usermod.md`](../../shell-commands/02-commands/usermod.md)
- [`../../shell-commands/02-commands/groups.md`](../../shell-commands/02-commands/groups.md)

---

## Drill 5: List libvirt Networks

**Command:**

```bash
virsh net-list --all
```

**Expected output:**

```
Name      State    Autostart
------------------------------
default   active   yes
```

**If `default` is inactive:**

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

**Learn more:**

- [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)
- [`../docs/networking.md`](../docs/networking.md)

---

## Drill 6: Inspect Default Network

**Command:**

```bash
sudo virsh net-dumpxml default
```

**Expected:** Should show:

- `<forward mode="nat">`
- `<bridge name="virbr0">`
- `<dhcp>` range

**Learn more:** [`../docs/networking.md`](../docs/networking.md)

---

## Drill 7: Check virbr0 Interface

**Command:**

```bash
ip a show virbr0
```

**Expected:** Should show:

- Interface `virbr0` exists
- IP address `192.168.122.1` (or similar)

**If interface doesn't exist:**

- Start default network: `sudo virsh net-start default`

**Learn more:**

- [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)
- [`../docs/networking.md`](../docs/networking.md)

---

## Drill 8: Verify virt-manager Connection

**Command:**

```bash
virt-manager
```

**Expected:**

- virt-manager opens
- Connection shows "QEMU/KVM"
- Status shows "Connected"
- No permission errors

**If connection fails:**

- Check libvirtd: `systemctl status libvirtd`
- Check user group: `groups | grep libvirt`
- Log out and log back in if needed

---

## Verification Checklist

After completing all drills, verify:

- [ ] CPU virtualization support verified
- [ ] KVM modules loaded
- [ ] libvirtd running and enabled
- [ ] User in libvirt group
- [ ] Default network active
- [ ] virbr0 interface exists
- [ ] virt-manager connects successfully

**If all checks pass:** You're ready to create VMs!

**If any check fails:** See [`../docs/troubleshooting.md`](../docs/troubleshooting.md)

---

## Next Steps

- **Ready to create a VM?** → [`../docs/installation-setup.md`](../docs/installation-setup.md)
- **Network issues?** → [`networking-drills.md`](networking-drills.md)
- **Performance issues?** → [`performance-drills.md`](performance-drills.md)
