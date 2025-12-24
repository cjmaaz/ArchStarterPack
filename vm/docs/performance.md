# Performance Tuning

Why virtual machines often feel slow despite low CPU/RAM usage, and how to fix it by tuning the correct layers: CPU exposure, memory behavior, video models, compositors, and guest integration.

---

## First Principle: Why "Low CPU" ≠ "Fast VM"

A VM can feel sluggish even when:

- CPU usage is low
- RAM usage is modest
- Disk is fast

**Why?** Desktop VM performance is dominated by **graphics, scheduling, and synchronization**, not raw compute.

### The Real Problem

**Common misconception:**

- "VM is slow = need more CPU/RAM"
- "CPU usage is low = VM should be fast"
- "More resources = better performance"

**Reality:**

- **Graphics stack inefficiency:** Biggest bottleneck
- **Desktop animation overhead:** Major performance killer
- **Missing guest integration:** Poor coordination
- **CPU feature masking:** Slower instructions
- **Video model choice:** Critical for performance

**Why graphics matter more than CPU:**

- **Desktop VMs are graphics-heavy:** UI rendering is expensive
- **Animations multiply overhead:** Every frame must be rendered
- **Graphics stack choice critical:** Wrong choice = laggy UI
- **CPU can be idle:** But graphics bottleneck causes lag

**Real-World Analogy:**

- **Fast CPU but slow graphics = Laggy UI**
- Like powerful engine but bad transmission
- Graphics bottleneck affects everything
- UI lag makes entire VM feel slow

**Most performance problems come from:**

- **Inefficient video device models:** Wrong GPU emulation
- **Software rendering:** Instead of paravirtualized paths
- **Desktop animations:** Overwhelming the virtual GPU
- **Missing guest↔host coordination:** Poor integration
- **CPU feature masking:** Generic CPU instead of host CPU

---

## CPU Configuration (High Impact)

### Use Host CPU Passthrough

In virt-manager: **CPUs → Configuration**

- Enable: **Copy host CPU configuration (host-passthrough)**

### Why Host Passthrough Matters

**Without passthrough (generic CPU):**

- **Guest sees generic CPU:** Doesn't know real CPU features
- **Modern instruction sets hidden:** Can't use advanced instructions
- **Scheduler decisions worse:** Generic CPU = generic scheduling
- **Context switching expensive:** More overhead switching between VMs
- **Slower execution:** Generic CPU = slower than native

**Example:**

- Host CPU: Intel Core i7 (has AVX, AVX2, SSE4.2)
- Guest sees: Generic x86_64 CPU (no advanced instructions)
- Result: Can't use AVX instructions (slower)

**With passthrough (host CPU):**

- **Guest uses native CPU features:** Sees real CPU
- **Better cache behavior:** CPU cache works optimally
- **Lower latency:** UI threads get better scheduling
- **Faster execution:** Can use all CPU instructions
- **Near-native performance:** Almost as fast as host

**Example:**

- Host CPU: Intel Core i7 (has AVX, AVX2, SSE4.2)
- Guest sees: Intel Core i7 (all features available)
- Result: Can use AVX instructions (faster)

**Performance impact:**

- **Without passthrough:** 10-20% slower
- **With passthrough:** <5% overhead
- **UI responsiveness:** Much better with passthrough

### Why Not Over-Allocate vCPUs

**Common mistake:**

- "More vCPUs = faster VM"
- Allocate all CPU cores to VM
- Leave no cores for host

**Reality:**

- **More vCPUs ≠ faster VM:** Context switching overhead
- **Context switching expensive:** More vCPUs = more switching
- **Fewer fast cores > many slow ones:** Quality over quantity
- **Host needs cores:** Host OS needs CPU too

**Why context switching hurts:**

- **More vCPUs:** More threads to schedule
- **More switching:** CPU spends time switching between threads
- **Less efficient:** Each thread gets less CPU time
- **Worse performance:** Too many vCPUs = slower

**Best practice:**

- **Allocate moderately:** 2-4 vCPUs for desktop VM
- **Leave cores for host:** At least 1-2 cores free
- **Quality over quantity:** Fewer fast cores better

**Example:**

- Host: 8 cores
- **Bad:** VM gets 8 vCPUs (host starved)
- **Good:** VM gets 4 vCPUs (host has 4 cores)

### Best Practices

- Do **not** over-allocate vCPUs
- Fewer fast cores > many slow ones
- Leave at least one physical core free for the host

**Verify:**

```bash
virsh dominfo <vm-name> | grep -i cpu
```

**Practice:** [`../practice/performance-drills.md`](../practice/performance-drills.md)

---

## Memory Allocation Strategy

### Fixed Memory Allocation

In virt-manager:

- Set **Allocation = Maximum Allocation**
- Do **not** rely on ballooning for desktop VMs

### Why

**Ballooning:**

- Can reclaim memory unpredictably
- Causes pauses when memory is reclaimed
- Leads to UI hitching under pressure

**Fixed memory:**

- Stable latency
- Predictable behavior
- Better desktop responsiveness

**Rule of thumb:**

> If the host has enough RAM, fixed allocation is always better for interactive desktops.

---

## Video Device Model (The Single Biggest UI Factor)

The video device model is **the most important factor** for VM UI performance. Choosing the wrong model can make a fast VM feel slow.

### Virtio-GPU Explained

**What is Virtio-GPU?**

**Virtio-GPU** is a **paravirtualized** graphics device designed for modern virtualization.

**What is paravirtualization?**

- **Paravirtualization:** Guest knows it's virtualized
- **Cooperation:** Guest and host work together
- **Efficient:** Less emulation, more direct communication
- **Fast:** Near-native performance

**How it works:**

- **Guest communicates directly** with host graphics stack
- **Minimal emulation:** Host handles graphics natively
- **Efficient:** No full GPU emulation overhead
- **Modern:** Designed for modern kernels/compositors

**Why it's faster:**

- **Less emulation:** Direct communication vs full emulation
- **Host GPU used:** Host GPU does actual rendering
- **Efficient protocol:** Optimized for virtualization
- **Modern design:** Built for modern systems

**Virtio-GPU (Modern Default)**

**Recommended for most Linux guests**

**Why:**

- **Paravirtualized:** Efficient guest↔host communication
- **Minimal emulation overhead:** Direct graphics path
- **Designed for modern kernels:** Works with latest Linux
- **Compositor-friendly:** Works well with modern compositors

**Pros:**

- **Better UI responsiveness:** Faster rendering
- **Lower CPU usage:** Less CPU for graphics
- **Scales better on HiDPI:** Handles high-DPI displays well
- **Modern:** Future-proof design

**Cons:**

- **More sensitive to compositor settings:** Compositor affects performance
- **3D acceleration quality depends on host drivers:** Host GPU matters
- **May have glitches:** Some desktops have issues

**When to use:**

- Modern Linux guest (recent kernel)
- KDE, GNOME, XFCE, Wayland/Xorg
- General desktop usage
- When you want best performance

---

### QXL Explained

**What is QXL?**

**QXL** is a **legacy graphics device** designed for SPICE remote desktop.

**Why it exists:**

- **Legacy support:** Older virtualization systems
- **SPICE-centric:** Designed for SPICE protocol
- **Predictable:** Very stable behavior
- **Compatible:** Works with older systems

**How it differs from Virtio:**

- **Full emulation:** Emulates graphics hardware
- **More overhead:** More CPU for graphics
- **SPICE-focused:** Optimized for SPICE
- **Legacy:** Older architecture

**QXL (Legacy, Stable Fallback)**

**Use only if Virtio causes issues**

**Why:**

- **Older SPICE-centric model:** Designed for SPICE
- **Extremely predictable:** Very stable behavior
- **Legacy support:** Works with older systems

**Pros:**

- **Stable rendering:** Very reliable
- **Fewer surprises:** Predictable behavior
- **Compatible:** Works with older desktops
- **Reliable:** Less likely to have glitches

**Cons:**

- **Higher CPU usage:** More CPU for graphics
- **Lower performance ceiling:** Not as fast as Virtio
- **Not future-facing:** Legacy technology
- **Slower:** More overhead than Virtio

**When to use:**

- Virtio glitches (visual problems)
- Older desktops (legacy support)
- Stability > performance (reliability priority)
- SPICE-heavy workflows

**Learn more:** [`video-display.md`](video-display.md)

---

## 3D Acceleration: Not Always a Win

### What 3D Acceleration Actually Does

- Forwards OpenGL calls from guest to host
- Relies heavily on:
  - Host GPU drivers
  - Mesa compatibility
  - Compositor behavior

### When to Enable It

Enable **only if**:

- Host GPU drivers are stable
- You need:
  - Wayland
  - GNOME/KDE compositing
  - GPU-heavy UI features

### When to Disable It (Very Common)

Disable if you see:

- Cursor lag
- Frame drops
- Window stutter
- UI freezes despite low CPU usage

**Important observation:**

> Disabling 3D + reducing animations often produces a smoother VM than enabling 3D.

**Learn more:** [`video-display.md`](video-display.md)

---

## Desktop Animations (Massive Hidden Cost)

### Why Animations Hurt VMs

Animations:

- Trigger constant redraws
- Stress the virtual GPU
- Increase compositor latency

VMs amplify these costs.

### Recommended Actions

- **GNOME:** Reduce animations
- **KDE:** Disable blur, translucency, heavy effects
- **XFCE:** Disable compositor if possible

**This single change frequently transforms VM usability.**

---

## Guest Integration: qemu-guest-agent

### Install It

Inside the VM:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable --now qemu-guest-agent
```

**Reboot once.**

### What It Improves

- Clean shutdown/reboot
- Accurate VM state reporting
- Better display resizing
- Time synchronization
- Clipboard and UI coordination

### What It Does NOT Do

- It does **not** accelerate graphics
- It does **not** affect network throughput
- It does **not** replace GPU drivers

Still, it is essential for a "well-behaved" VM.

**Verify:**

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

---

## Why the VM Felt Slow Before (Root Cause Summary)

The VM was not slow because of:

- CPU limits
- RAM shortage
- Disk speed

It was slow because of:

- Graphics stack inefficiencies
- Desktop animation overhead
- Suboptimal video model behavior
- Missing guest↔host signaling

Once those were fixed:

- UI latency dropped
- Interaction became predictable
- Performance matched expectations

---

## Recommended Performance Profiles

### General Linux Desktop VM

- CPU: Host passthrough
- vCPUs: Moderate (not max)
- Memory: Fixed allocation
- Video: Virtio
- 3D Accel: Test → disable if unstable
- Animations: Reduced or off
- Guest Agent: Enabled

### Stability-First VM

- CPU: Host passthrough
- Memory: Fixed
- Video: QXL
- 3D Accel: Off
- Animations: Off
- Guest Agent: Enabled

---

## Final Mental Model

> VM performance is about **latency consistency**, not raw power.

If the UI feels bad:

- Stop adding CPU
- Stop adding RAM
- Fix the **graphics + compositor + integration layer**

---

## Next Steps

- **Display problems?** → [`video-display.md`](video-display.md)
- **Storage performance?** → [`storage.md`](storage.md)
- **Troubleshooting?** → [`troubleshooting.md`](troubleshooting.md)

---

## Practice

- [`../practice/performance-drills.md`](../practice/performance-drills.md)
