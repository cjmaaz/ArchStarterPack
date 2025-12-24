# KVM / QEMU Virtual Machine Performance Optimization Guide

*(Desktop-focused, Host + Guest)*

This document explains **why virtual machines often feel slow despite low CPU/RAM usage** and how to fix that by tuning the **correct layers**: CPU exposure, memory behavior, video models, compositors, and guest integration.

This applies to **Ubuntu, Kali, Arch, Fedora, Debian**, and most Linux desktops running under **KVM/QEMU with virt-manager**.

---

## 1. First Principle: Why “Low CPU” ≠ “Fast VM”

A VM can feel sluggish even when:

* CPU usage is low
* RAM usage is modest
* Disk is fast

This is because **desktop VM performance is dominated by graphics, scheduling, and synchronization**, not raw compute.

Most performance problems come from:

* Inefficient video device models
* Software rendering instead of paravirtualized paths
* Desktop animations overwhelming the virtual GPU
* Missing guest↔host coordination
* CPU feature masking

The fixes below target *those exact causes*.

---

## 2. CPU Configuration (One of the Highest Impact Changes)

### 2.1 Use Host CPU Passthrough

In virt-manager:

**CPUs → Configuration**

* Enable: **Copy host CPU configuration (host-passthrough)**

### Why this matters

Without passthrough:

* Guest sees a generic CPU
* Modern instruction sets are hidden
* Scheduler decisions are worse
* Context switching is more expensive

With passthrough:

* Guest uses native CPU features
* Better cache behavior
* Lower latency for UI threads

### Best Practices

* Do **not** over-allocate vCPUs
* Fewer fast cores > many slow ones
* Leave at least one physical core free for the host

---

## 3. Memory Allocation Strategy (Predictability Over Flexibility)

### 3.1 Fixed Memory Allocation

In virt-manager:

* Set **Allocation = Maximum Allocation**
* Do **not** rely on ballooning for desktop VMs

### Why

Ballooning:

* Can reclaim memory unpredictably
* Causes pauses when memory is reclaimed
* Leads to UI hitching under pressure

Fixed memory:

* Stable latency
* Predictable behavior
* Better desktop responsiveness

Rule of thumb:

> If the host has enough RAM, fixed allocation is always better for interactive desktops.

---

## 4. Video Device Model (The Single Biggest UI Factor)

### 4.1 Virtio-GPU (Modern Default)

**Recommended for most Linux guests**

**Why**

* Paravirtualized
* Minimal emulation overhead
* Designed for modern kernels and compositors

**Pros**

* Better UI responsiveness
* Lower CPU usage
* Scales better on HiDPI displays

**Cons**

* More sensitive to compositor settings
* 3D acceleration quality depends on host drivers

### When to use

* Modern Linux guest
* KDE, GNOME, XFCE, Wayland/Xorg
* General desktop usage

---

### 4.2 QXL (Legacy, Stable Fallback)

**Use only if Virtio causes issues**

**Why**

* Older SPICE-centric model
* Extremely predictable

**Pros**

* Stable rendering
* Fewer surprises

**Cons**

* Higher CPU usage
* Lower performance ceiling
* Not future-facing

### When to use

* Virtio glitches
* Older desktops
* Stability > performance

---

## 5. 3D Acceleration: Not Always a Win

### 5.1 What 3D Acceleration Actually Does

* Forwards OpenGL calls from guest to host
* Relies heavily on:

  * Host GPU drivers
  * Mesa compatibility
  * Compositor behavior

### 5.2 When to Enable It

Enable **only if**:

* Host GPU drivers are stable
* You need:

  * Wayland
  * GNOME/KDE compositing
  * GPU-heavy UI features

### 5.3 When to Disable It (Very Common)

Disable if you see:

* Cursor lag
* Frame drops
* Window stutter
* UI freezes despite low CPU usage

Important observation from this setup:

> Disabling 3D + reducing animations often produces a smoother VM than enabling 3D.

---

## 6. Desktop Animations (Massive Hidden Cost)

### Why animations hurt VMs

Animations:

* Trigger constant redraws
* Stress the virtual GPU
* Increase compositor latency

VMs amplify these costs.

### Recommended Actions

* **GNOME**: Reduce animations
* **KDE**: Disable blur, translucency, heavy effects
* **XFCE**: Disable compositor if possible

This single change frequently transforms VM usability.

---

## 7. Guest Integration: qemu-guest-agent (Install It)

Inside the VM:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

### What it improves

* Clean shutdown/reboot
* Accurate VM state reporting
* Better display resizing
* Time synchronization
* Clipboard and UI coordination

### What it does NOT do

* It does **not** accelerate graphics
* It does **not** affect network throughput
* It does **not** replace GPU drivers

Still, it is essential for a “well-behaved” VM.

---

## 8. Why the VM Felt Slow Before (Root Cause Summary)

The VM was not slow because of:

* CPU limits
* RAM shortage
* Disk speed

It was slow because of:

* Graphics stack inefficiencies
* Desktop animation overhead
* Suboptimal video model behavior
* Missing guest↔host signaling

Once those were fixed:

* UI latency dropped
* Interaction became predictable
* Performance matched expectations

---

## 9. Recommended Performance Profiles

### General Linux Desktop VM

* CPU: Host passthrough
* vCPUs: Moderate (not max)
* Memory: Fixed allocation
* Video: Virtio
* 3D Accel: Test → disable if unstable
* Animations: Reduced or off
* Guest Agent: Enabled

### Stability-First VM

* CPU: Host passthrough
* Memory: Fixed
* Video: QXL
* 3D Accel: Off
* Animations: Off
* Guest Agent: Enabled

---

## 10. Final Mental Model

> VM performance is about **latency consistency**, not raw power.

If the UI feels bad:

* Stop adding CPU
* Stop adding RAM
* Fix the **graphics + compositor + integration layer**

That’s exactly what was done here — and why it worked.

---

TODO:
* A **VM preset matrix** (desktop / server / pentest)
* And a **performance diagnostic checklist**
