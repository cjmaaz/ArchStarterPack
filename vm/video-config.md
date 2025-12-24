# KVM / QEMU Display, Video & Performance Optimization Guide

*(Host + Guest, OS-agnostic)*

This document explains how to configure **video, display, CPU, memory, and guest integration** for KVM/QEMU virtual machines to achieve **smooth UI performance** and **predictable behavior**, even when system monitors show low CPU and RAM usage.

---

## 1. Why VMs Feel Slow Even When CPU & RAM Look Fine

This is the key misconception:

> **VM performance problems are usually NOT raw CPU or RAM issues.**

Most UI lag comes from:

* Software rendering instead of GPU-assisted paths
* Inefficient display models
* Desktop animations overwhelming the virtual GPU
* Guest ↔ host integration gaps
* Excessive context switching

You observed this exact symptom:

* CPU low
* RAM plenty
* UI still sluggish

The fixes below address *that* layer.

---

## 2. Video Device Models (Critical Choice)

In **Virtual Machine Manager → Video**, you tested:

* **Virtio**
* **QXL**

### 2.1 Virtio-GPU (Modern Default)

**Use when:**

* Linux guest (modern kernel)
* Wayland or Xorg
* You want lowest overhead

**Why it works:**

* Paravirtualized GPU
* Minimal emulation
* Designed for modern desktops

**Pros**

* Faster UI
* Lower CPU overhead
* Better scaling on HiDPI

**Cons**

* 3D acceleration quality depends on host drivers
* Some desktops misbehave with animations enabled

**Recommendation**

> Virtio-GPU is the correct default for most modern Linux guests.

---

### 2.2 QXL (Legacy but Stable)

**Use when:**

* Older desktops
* SPICE-heavy workflows
* Virtio causes glitches

**Why it exists:**

* Designed for SPICE-era remoting
* Very predictable behavior

**Pros**

* Extremely stable
* Works well with animation-heavy desktops

**Cons**

* Slower than Virtio
* Higher CPU usage
* Not future-facing

**Recommendation**

> Use QXL only if Virtio causes visual issues.

---

## 3. 3D Acceleration: Enable Carefully

You tested **3D acceleration toggle**.

### 3.1 What 3D Acceleration Actually Does

* Passes OpenGL calls from guest → host
* Requires:

  * Stable host GPU drivers
  * Mesa alignment between host & guest
* Desktop compositors (KDE, GNOME) rely heavily on it

---

### 3.2 When to ENABLE 3D Acceleration

Enable **only if**:

* Host GPU drivers are stable
* You need:

  * Wayland
  * GNOME animations
  * KDE compositing
* You see clear UI improvement

---

### 3.3 When to DISABLE 3D Acceleration

Disable if you observe:

* Cursor lag
* Window stutter
* UI freezes despite low CPU
* Random frame drops

In many setups:

> **Disabling 3D + reducing animations gives better real-world smoothness**

---

## 4. Desktop Animations (Huge Impact, Often Ignored)

### 4.1 Why Animations Hurt VMs

Animations:

* Trigger constant redraws
* Stress the virtual GPU
* Cause compositor stalls

This is amplified in VMs.

---

### 4.2 What You Did (Correctly)

* Reduced / disabled desktop animations
* Result: noticeably smoother UI

### 4.3 Recommendation (Any Desktop)

* **GNOME**: Reduce animations
* **KDE**: Disable blur, reduce effects
* **XFCE**: Disable compositor if possible

> This single change often fixes “VM feels slow” complaints.

---

## 5. CPU Configuration (Host Passthrough Matters)

You enabled:

* **Copy host CPU configuration (host-passthrough)**

### Why this matters

Without passthrough:

* VM sees generic CPU
* Loses instruction sets
* Slower scheduling

With passthrough:

* Native instruction usage
* Better cache behavior
* Lower latency

**Best practice**

* Allocate fewer vCPUs with passthrough
* Avoid overcommitting cores

---

## 6. Memory Allocation Strategy

Your setup:

* Fixed memory allocation
* No ballooning

### Why this is good

Ballooning:

* Can reclaim memory unexpectedly
* Causes stalls during pressure

Fixed memory:

* Predictable performance
* Better desktop responsiveness

**Rule**

> If host has enough RAM, avoid ballooning for desktop VMs.

---

## 7. qemu-guest-agent (Install It — But Know Why)

You asked whether to install:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

### Short answer

**Yes, install it. You only need this — not alternatives.**

---

### What qemu-guest-agent actually does

It:

* Reports accurate VM IP & state to host
* Enables clean shutdown/reboot
* Improves time synchronization
* Helps display resizing
* Improves clipboard & integration

### What it does NOT do

* It does **not** accelerate graphics
* It does **not** affect networking speed
* It does **not** replace video drivers

### Why it still matters

Without it:

* VM manager lacks visibility
* Debugging becomes harder
* Some UI operations lag or desync

---

## 8. Putting It All Together (Recommended Profiles)

### 8.1 General Linux Desktop VM (Ubuntu, Kali, Arch)

* Video: **Virtio**
* 3D Acceleration: **Test → Disable if unstable**
* Animations: **Reduced or off**
* CPU: **Host passthrough**
* Memory: **Fixed**
* Guest Agent: **Enabled**

---

### 8.2 Stability-Focused VM

* Video: **QXL**
* 3D Acceleration: **Off**
* Animations: **Off**
* CPU: **Host passthrough**
* Memory: **Fixed**

---

## 9. Key Takeaway

VM performance is dominated by:

* Display model choice
* Animation load
* Compositor behavior
* CPU feature exposure

Not raw CPU usage.

You fixed the VM not by “adding resources” but by:

* Aligning the graphics stack
* Reducing unnecessary redraws
* Letting the guest understand the host

That’s the correct mental model.

---

TODO: 

* A **restructured READMEs (network + video + performance)**
* A **VM preset matrix (desktop vs server vs pentest)**
* Or a **checklist-based diagnostic script**
