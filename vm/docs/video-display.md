# Video & Display Configuration

How to configure video, display, CPU, memory, and guest integration for smooth UI performance and predictable behavior.

---

## Why VMs Feel Slow Even When CPU & RAM Look Fine

**Key misconception:**

> VM performance problems are usually NOT raw CPU or RAM issues.

**Most UI lag comes from:**

- Software rendering instead of GPU-assisted paths
- Inefficient display models
- Desktop animations overwhelming the virtual GPU
- Guest ↔ host integration gaps
- Excessive context switching

---

## Video Device Models (Critical Choice)

In **Virtual Machine Manager → Video**, you can choose:

- **Virtio-GPU**
- **QXL**

---

### Virtio-GPU (Modern Default)

**Use when:**

- Linux guest (modern kernel)
- Wayland or Xorg
- You want lowest overhead

**Why it works:**

- Paravirtualized GPU
- Minimal emulation
- Designed for modern desktops

**Pros:**

- Faster UI
- Lower CPU overhead
- Better scaling on HiDPI

**Cons:**

- 3D acceleration quality depends on host drivers
- Some desktops misbehave with animations enabled

**Recommendation:**

> Virtio-GPU is the correct default for most modern Linux guests.

---

### QXL (Legacy but Stable)

**Use when:**

- Older desktops
- SPICE-heavy workflows
- Virtio causes glitches

**Why it exists:**

- Designed for SPICE-era remoting
- Very predictable behavior

**Pros:**

- Extremely stable
- Works well with animation-heavy desktops

**Cons:**

- Slower than Virtio
- Higher CPU usage
- Not future-facing

**Recommendation:**

> Use QXL only if Virtio causes visual issues.

---

## 3D Acceleration: Enable Carefully

### What 3D Acceleration Actually Does

- Passes OpenGL calls from guest → host
- Requires:
  - Stable host GPU drivers
  - Mesa alignment between host & guest
- Desktop compositors (KDE, GNOME) rely heavily on it

---

### When to ENABLE 3D Acceleration

Enable **only if**:

- Host GPU drivers are stable
- You need:
  - Wayland
  - GNOME animations
  - KDE compositing
- You see clear UI improvement

---

### When to DISABLE 3D Acceleration

Disable if you observe:

- Cursor lag
- Window stutter
- UI freezes despite low CPU
- Random frame drops

**In many setups:**

> **Disabling 3D + reducing animations gives better real-world smoothness**

---

## Desktop Animations (Huge Impact, Often Ignored)

### Why Animations Hurt VMs

Animations:

- Trigger constant redraws
- Stress the virtual GPU
- Cause compositor stalls

This is amplified in VMs.

### Recommendation (Any Desktop)

- **GNOME:** Reduce animations
- **KDE:** Disable blur, reduce effects
- **XFCE:** Disable compositor if possible

> This single change often fixes "VM feels slow" complaints.

---

## Display Protocols

Display protocols determine how the VM screen is transmitted to your host. Choosing the right protocol affects performance and features.

### SPICE Explained

**What is SPICE?**

**SPICE** (Simple Protocol for Independent Computing Environments) is a remote display protocol designed for virtualization.

**What it does:**

- **Transmits VM display:** Sends screen to host
- **Optimized for virtualization:** Designed for VMs
- **Feature-rich:** Clipboard, audio, USB redirection
- **Efficient:** Optimized protocol

**Why it's better than VNC:**

- **More efficient:** Better compression, less bandwidth
- **Better features:** Clipboard, audio, USB
- **Optimized:** Designed for virtualization
- **Modern:** Built for modern systems

**How it works:**

- **Guest agent:** SPICE agent in VM
- **Host client:** virt-viewer or virt-manager
- **Protocol:** Efficient transmission
- **Features:** Clipboard, audio, USB

**SPICE**

**Default in virt-manager**

**Pros:**

- **Best balance:** Performance and features
- **Good clipboard integration:** Copy/paste works well
- **Better than VNC:** More efficient, more features
- **Optimized:** Designed for virtualization

**Cons:**

- **Requires SPICE client:** Need virt-viewer or virt-manager
- **Less compatible:** Not all clients support SPICE
- **More complex:** More setup than VNC

**When to use:**

- Most desktop VMs (default choice)
- When you want best performance
- When you need clipboard/audio/USB
- Local VM access (same machine)

---

### VNC Explained

**What is VNC?**

**VNC** (Virtual Network Computing) is a remote desktop protocol.

**What it does:**

- **Transmits VM display:** Sends screen to client
- **Simple protocol:** Basic remote desktop
- **Widely supported:** Many clients available
- **Network-friendly:** Works over network easily

**Why it's more compatible:**

- **Many clients:** VNC clients for every platform
- **Standard protocol:** Widely implemented
- **Simple:** Basic protocol, easy to support
- **Universal:** Works everywhere

**Performance trade-offs:**

- **Less efficient:** More bandwidth than SPICE
- **Fewer features:** Basic remote desktop
- **Slower:** More overhead than SPICE
- **Simple:** Less optimized

**VNC**

**Alternative display protocol**

**Pros:**

- **More compatible:** Any VNC client works
- **Works over network easily:** Remote access simple
- **Universal:** Supported everywhere
- **Simple:** Easy to use

**Cons:**

- **Less performant:** Slower than SPICE
- **Weaker clipboard integration:** Basic clipboard
- **Fewer features:** No audio/USB redirection
- **More bandwidth:** Less efficient

**When to use:**

- Remote access needed (over network)
- SPICE causes issues (fallback)
- Temporary debugging (quick access)
- Need universal compatibility

---

## HiDPI Display Handling

### Guest Configuration

**For Wayland (GNOME/KDE):**

- Set scaling factor in guest OS settings
- Usually works automatically with guest agent

**For Xorg:**

- May need manual DPI configuration
- Check `xrandr` output

### Host Configuration

- virt-manager should detect HiDPI automatically
- Adjust display scaling in virt-manager if needed

---

## Troubleshooting Display Issues

### Black Screen

**Causes:**

- Wrong firmware (need UEFI/OVMF)
- Display model mismatch
- Guest not booted properly

**Solutions:**

1. Ensure UEFI firmware (OVMF) is selected
2. Try switching display from SPICE to VNC
3. Check guest boot logs

### Cursor Lag

**Causes:**

- 3D acceleration enabled but unstable
- Desktop animations too heavy
- Wrong video model

**Solutions:**

1. Disable 3D acceleration
2. Reduce desktop animations
3. Try QXL instead of Virtio

### Window Stutter

**Causes:**

- Compositor overloaded
- 3D acceleration issues
- Insufficient CPU passthrough

**Solutions:**

1. Disable compositor (XFCE)
2. Reduce animations (GNOME/KDE)
3. Enable host CPU passthrough
4. Disable 3D acceleration

---

## CPU Configuration (Host Passthrough Matters)

### Enable Host Passthrough

In virt-manager: **CPUs → Configuration**

- Enable: **Copy host CPU configuration (host-passthrough)**

### Why This Matters

**Without passthrough:**

- VM sees generic CPU
- Loses instruction sets
- Slower scheduling

**With passthrough:**

- Native instruction usage
- Better cache behavior
- Lower latency

**Best practice:**

- Allocate fewer vCPUs with passthrough
- Avoid overcommitting cores

---

## Memory Allocation Strategy

### Fixed Memory Allocation

**Why:**

- Ballooning can reclaim memory unexpectedly
- Causes stalls during pressure

**Fixed memory:**

- Predictable performance
- Better desktop responsiveness

**Rule:**

> If host has enough RAM, avoid ballooning for desktop VMs.

---

## qemu-guest-agent (Install It — But Know Why)

### Install

Inside the VM:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

### What It Actually Does

- Reports accurate VM IP & state to host
- Enables clean shutdown/reboot
- Improves time synchronization
- Helps display resizing
- Improves clipboard & integration

### What It Does NOT Do

- It does **not** accelerate graphics
- It does **not** affect networking speed
- It does **not** replace video drivers

### Why It Still Matters

Without it:

- VM manager lacks visibility
- Debugging becomes harder
- Some UI operations lag or desync

---

## Recommended Profiles

### General Linux Desktop VM (Ubuntu, Kali, Arch)

- Video: **Virtio**
- 3D Acceleration: **Test → Disable if unstable**
- Animations: **Reduced or off**
- CPU: **Host passthrough**
- Memory: **Fixed**
- Guest Agent: **Enabled**

---

### Stability-Focused VM

- Video: **QXL**
- 3D Acceleration: **Off**
- Animations: **Off**
- CPU: **Host passthrough**
- Memory: **Fixed**

---

## Key Takeaway

VM performance is dominated by:

- Display model choice
- Animation load
- Compositor behavior
- CPU feature exposure

Not raw CPU usage.

You fix the VM not by "adding resources" but by:

- Aligning the graphics stack
- Reducing unnecessary redraws
- Letting the guest understand the host

---

## Next Steps

- **Performance tuning:** [`performance.md`](performance.md)
- **Troubleshooting:** [`troubleshooting.md`](troubleshooting.md)

---

## Learn More

- **Arch Wiki:** [QEMU Graphics](https://wiki.archlinux.org/title/QEMU#Graphics)
