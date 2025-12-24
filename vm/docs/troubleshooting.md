# Troubleshooting

Common VM issues, symptoms, root causes, and solutions.

---

## Common Symptoms → Root Causes

| Symptom                      | Root Cause                         | Solution                        |
| ---------------------------- | ---------------------------------- | ------------------------------- |
| "QEMU/KVM not available"     | Virtualization disabled in BIOS    | Enable VT-x/AMD-V in BIOS       |
| "QEMU/KVM not available"     | KVM modules not loaded             | Check `lsmod \| grep kvm`       |
| Permission denied            | User not in libvirt group          | Add user: `usermod -aG libvirt` |
| Permission denied            | Didn't log out after group change  | Log out and log back in         |
| No IP address                | libvirt `default` network inactive | `virsh net-start default`       |
| Ping works, apt fails        | UFW routed traffic blocked         | Allow virbr0 traffic            |
| apt hangs                    | IPv6 broken in NAT                 | Disable IPv6 in VM              |
| Interface mismatch           | Hardcoded interface name           | Discover actual interface name  |
| IP not shown in virt-manager | Guest agent missing                | Install qemu-guest-agent        |
| Black screen                 | Wrong firmware                     | Use UEFI (OVMF)                 |
| Black screen                 | Display model issue                | Try QXL or VNC                  |
| VM feels slow                | Wrong video model                  | Use Virtio-GPU                  |
| VM feels slow                | 3D acceleration enabled            | Disable 3D acceleration         |
| VM feels slow                | Desktop animations                 | Reduce/disable animations       |
| Cursor lag                   | 3D acceleration unstable           | Disable 3D acceleration         |
| Window stutter               | Compositor overloaded              | Disable compositor/animations   |

---

## "QEMU/KVM not available"

### Symptoms

- virt-manager shows "QEMU/KVM not available"
- Cannot create or start VMs

### Root Causes

1. **Virtualization disabled in BIOS**
2. **KVM modules not loaded**

### Solutions

**1. Enable virtualization in BIOS:**

- Reboot into BIOS/UEFI
- Enable **Intel VT-x** or **AMD-V / SVM**
- Save and reboot

**2. Verify KVM modules:**

```bash
lsmod | grep kvm
```

**Expected output:**

```
kvm_intel        (or kvm_amd)
kvm
```

**If modules not loaded:**

```bash
# Check kernel messages
dmesg | grep -i kvm
```

**Learn more:**

- [`../../shell-commands/02-commands/lsmod.md`](../../shell-commands/02-commands/lsmod.md)
- [`../../shell-commands/02-commands/dmesg.md`](../../shell-commands/02-commands/dmesg.md)

---

## Permission Denied Errors

### Symptoms

- "Permission denied" when managing VMs
- Cannot connect to libvirt

### Root Causes

1. **User not in `libvirt` group**
2. **Didn't log out after adding to group**

### Solutions

**1. Add user to libvirt group:**

```bash
sudo usermod -aG libvirt $(whoami)
```

**2. Log out and log back in** (required for group changes)

**3. Verify membership:**

```bash
groups
```

Should show `libvirt` in the list.

**Learn more:**

- [`../../shell-commands/02-commands/usermod.md`](../../shell-commands/02-commands/usermod.md)
- [`../../shell-commands/02-commands/groups.md`](../../shell-commands/02-commands/groups.md)

---

## Network Issues

### No IP Address

**Symptoms:**

- VM has no IP address
- Cannot access internet

**Root cause:** libvirt `default` network inactive

**Solution:**

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

**Verify:**

```bash
sudo virsh net-list --all
```

Should show `default` as `active`.

**Learn more:** [`networking.md`](networking.md)

---

### Ping Works, apt Fails

**Symptoms:**

- `ping google.com` works
- `apt update` times out
- HTTP/HTTPS fails

**Root cause:** UFW blocking routed VM traffic

**Solution:**

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
sudo ufw route allow in on virbr0 out on <HOST_IFACE>
sudo ufw reload
```

**Learn more:**

- [`networking.md`](networking.md)
- [`../../shell-commands/02-commands/ufw.md`](../../shell-commands/02-commands/ufw.md)

---

### apt Hangs

**Symptoms:**

- `apt update` hangs
- Errors mention IPv6 addresses

**Root cause:** IPv6 broken in NAT

**Solution:**

**Disable IPv6 in VM:**

```bash
sudo nano /etc/sysctl.d/99-disable-ipv6.conf
```

Add:

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

Apply:

```bash
sudo sysctl --system
```

**Or APT-only:**

```bash
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```

**Learn more:** [`networking.md`](networking.md)

---

### Interface Mismatch

**Symptoms:**

- NetworkManager profile doesn't work
- Hardcoded interface name fails

**Root cause:** Assumed interface name (e.g., `eth0`) doesn't match actual name

**Solution:**

**Discover actual interface:**

```bash
ip -o link show | awk -F': ' '{print $2}'
```

**Create profile with actual name:**

```bash
sudo nmcli connection add \
  type ethernet \
  ifname <ACTUAL_INTERFACE> \
  con-name kvm-dhcp \
  ipv4.method auto \
  ipv6.method ignore
```

**Learn more:**

- [`networking.md`](networking.md)
- [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)

---

## Performance Issues

### VM Feels Slow Despite Low CPU

**Symptoms:**

- CPU usage is low
- RAM usage is modest
- UI still feels sluggish

**Root causes:**

1. Wrong video model
2. 3D acceleration enabled but unstable
3. Desktop animations

**Solutions:**

**1. Use Virtio-GPU:**

- virt-manager → Video → Model: **Virtio**

**2. Disable 3D acceleration:**

- virt-manager → Video → Uncheck "3D acceleration"

**3. Reduce animations:**

- GNOME: Reduce animations
- KDE: Disable blur, reduce effects
- XFCE: Disable compositor

**Learn more:**

- [`performance.md`](performance.md)
- [`video-display.md`](video-display.md)

---

### Cursor Lag

**Symptoms:**

- Mouse cursor lags behind movement
- UI feels unresponsive

**Root causes:**

1. 3D acceleration enabled but unstable
2. Wrong video model

**Solutions:**

**1. Disable 3D acceleration:**

- virt-manager → Video → Uncheck "3D acceleration"

**2. Try QXL:**

- virt-manager → Video → Model: **QXL**

**Learn more:** [`video-display.md`](video-display.md)

---

### Window Stutter

**Symptoms:**

- Windows stutter when moving
- UI freezes briefly

**Root causes:**

1. Compositor overloaded
2. Desktop animations too heavy
3. Insufficient CPU passthrough

**Solutions:**

**1. Disable compositor/animations:**

- XFCE: Disable compositor
- GNOME/KDE: Reduce animations

**2. Enable host CPU passthrough:**

- virt-manager → CPUs → Copy host CPU configuration

**Learn more:**

- [`performance.md`](performance.md)
- [`video-display.md`](video-display.md)

---

## Boot Issues

### Black Screen

**Symptoms:**

- VM starts but shows black screen
- No boot output

**Root causes:**

1. Wrong firmware (need UEFI/OVMF)
2. Display model issue

**Solutions:**

**1. Use UEFI firmware:**

- virt-manager → Overview → Firmware: **UEFI x86_64: /usr/share/OVMF/OVMF_CODE.fd**

**2. Try different display:**

- virt-manager → Display → Type: **VNC** (temporary debugging)

**Learn more:** [`video-display.md`](video-display.md)

---

### Boot Hangs

**Symptoms:**

- VM starts but hangs during boot
- No error messages

**Root causes:**

1. Insufficient resources
2. Corrupted disk image
3. Firmware mismatch

**Solutions:**

**1. Check resources:**

- Ensure sufficient RAM allocated
- Ensure CPU cores allocated

**2. Check disk:**

```bash
qemu-img check <vm-disk>.qcow2
```

**3. Try different firmware:**

- Switch between UEFI and BIOS

---

## Guest Agent Issues

### IP Not Shown in virt-manager

**Symptoms:**

- VM has IP address (verified inside VM)
- virt-manager shows "N/A" for IP

**Root cause:** Guest agent not installed/running

**Solution:**

**Install guest agent:**

```bash
# Inside VM
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

**Reboot VM.**

**Verify:**

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

**Learn more:** [`performance.md`](performance.md)

---

## Systematic Debugging

### Step 1: Verify Prerequisites

```bash
# CPU virtualization
lscpu | grep -i virtualization

# KVM modules
lsmod | grep kvm

# libvirtd running
systemctl status libvirtd

# User in libvirt group
groups | grep libvirt
```

### Step 2: Check VM State

```bash
# List VMs
virsh list --all

# VM info
virsh dominfo <vm-name>

# VM XML (for advanced debugging)
virsh dumpxml <vm-name>
```

### Step 3: Check Network

```bash
# List networks
virsh net-list --all

# Network info
virsh net-dumpxml default

# Check virbr0
ip a show virbr0
```

### Step 4: Check Logs

```bash
# Kernel messages
dmesg | grep -i kvm
dmesg | grep -i iommu

# libvirt logs
sudo journalctl -u libvirtd
```

---

## Getting Help

### Information to Provide

When asking for help, provide:

1. **Host OS:** Arch Linux / CachyOS / etc.
2. **Guest OS:** Ubuntu / Kali / etc.
3. **Error messages:** Exact output
4. **VM configuration:** CPU, RAM, disk format
5. **Network mode:** NAT / Bridged
6. **Relevant logs:** `dmesg`, `journalctl`

### Useful Commands for Debugging

```bash
# Full VM info
virsh dominfo <vm-name>
virsh dumpxml <vm-name>

# Network info
virsh net-dumpxml default
ip a show virbr0

# System info
lscpu | grep -i virtualization
lsmod | grep kvm
systemctl status libvirtd
```

---

## Next Steps

- **Networking issues:** [`networking.md`](networking.md)
- **Performance issues:** [`performance.md`](performance.md)
- **Display issues:** [`video-display.md`](video-display.md)
- **Practice:** [`../practice/drills.md`](../practice/drills.md)

---

## Learn More

- **Arch Wiki:** [QEMU Troubleshooting](https://wiki.archlinux.org/title/QEMU#Troubleshooting)
- **libvirt FAQ:** [https://libvirt.org/faq.html](https://libvirt.org/faq.html)
