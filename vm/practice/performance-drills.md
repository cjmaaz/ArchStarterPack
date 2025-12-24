# Performance Tuning Verification Drills

Verify your VM performance configuration and identify optimization opportunities.

---

## Prerequisites

- At least one VM created
- Basic understanding of performance tuning (see [`../docs/performance.md`](../docs/performance.md))

---

## Drill 1: Check CPU Passthrough

**Command:**

```bash
virsh dominfo <vm-name> | grep -i cpu
```

**What to look for:**

- CPU model should match host CPU (not generic)
- vCPU count should be reasonable (not maxed out)

**If CPU is generic:**

- Enable host passthrough in virt-manager:
  - CPUs → Configuration → Copy host CPU configuration

**Learn more:**

- [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)
- [`../docs/performance.md`](../docs/performance.md)

---

## Drill 2: Verify Guest Agent

**Command:**

```bash
virsh qemu-agent-command <vm-name> '{"execute":"guest-info"}'
```

**Expected:** Should return guest agent information

**If command fails:**

- Guest agent not installed/running
- Install inside VM:
  ```bash
  sudo apt install -y qemu-guest-agent
  sudo systemctl enable --now qemu-guest-agent
  ```
- Reboot VM

**Learn more:** [`../docs/performance.md`](../docs/performance.md)

---

## Drill 3: Monitor VM Resources

**Command:**

```bash
virsh dominfo <vm-name>
```

**What to check:**

- CPU time
- Memory usage
- State (running/paused/shut off)

**Command:**

```bash
virsh domstats <vm-name>
```

**What to check:**

- Detailed resource statistics
- CPU usage percentage
- Memory usage

**Learn more:** [`../../shell-commands/02-commands/virsh.md`](../../shell-commands/02-commands/virsh.md)

---

## Drill 4: Check Video Model

**In virt-manager:**

- VM → Video → Model

**What to verify:**

- Model should be **Virtio** (for modern Linux guests)
- Or **QXL** (if Virtio causes issues)

**If wrong model:**

- Change in virt-manager
- Restart VM

**Learn more:** [`../docs/video-display.md`](../docs/video-display.md)

---

## Drill 5: Check 3D Acceleration

**In virt-manager:**

- VM → Video → 3D acceleration

**What to verify:**

- Should be **disabled** if experiencing lag/stutter
- Can be **enabled** if host GPU drivers are stable

**If experiencing issues:**

- Disable 3D acceleration
- Restart VM
- Test UI responsiveness

**Learn more:** [`../docs/video-display.md`](../docs/video-display.md)

---

## Drill 6: Test Display Performance

**Inside VM:**

**Step 1: Move windows around**

- Observe cursor lag
- Observe window stutter

**Step 2: Resize windows**

- Check responsiveness
- Check for lag

**Step 3: Open/close applications**

- Check animation smoothness
- Check responsiveness

**If experiencing lag:**

- Disable 3D acceleration
- Reduce desktop animations
- Try QXL instead of Virtio

**Learn more:**

- [`../docs/performance.md`](../docs/performance.md)
- [`../docs/video-display.md`](../docs/video-display.md)

---

## Drill 7: Check Memory Allocation

**In virt-manager:**

- VM → Memory

**What to verify:**

- Allocation = Maximum Allocation (fixed memory)
- Not using ballooning for desktop VMs

**If using ballooning:**

- Set Allocation = Maximum Allocation
- Restart VM

**Learn more:** [`../docs/performance.md`](../docs/performance.md)

---

## Drill 8: Monitor Host Resources

**Command:**

```bash
top
```

**What to check:**

- CPU usage (should have headroom)
- Memory usage (should have headroom)
- Load average

**If host overloaded:**

- Reduce VM resources
- Close unnecessary VMs
- Optimize host system

**Learn more:** [`../../shell-commands/02-commands/top.md`](../../shell-commands/02-commands/top.md)

---

## Performance Profile Checklist

After completing drills, verify your VM matches a recommended profile:

### General Linux Desktop VM

- [ ] CPU: Host passthrough enabled
- [ ] vCPUs: Moderate (not maxed out)
- [ ] Memory: Fixed allocation
- [ ] Video: Virtio
- [ ] 3D Accel: Disabled (or tested and stable)
- [ ] Animations: Reduced or off
- [ ] Guest Agent: Enabled

### Stability-First VM

- [ ] CPU: Host passthrough enabled
- [ ] Memory: Fixed allocation
- [ ] Video: QXL
- [ ] 3D Accel: Off
- [ ] Animations: Off
- [ ] Guest Agent: Enabled

---

## Next Steps

- **Display issues?** → [`../docs/video-display.md`](../docs/video-display.md)
- **Want to master virsh?** → [`virsh-drills.md`](virsh-drills.md)
- **Troubleshooting?** → [`../docs/troubleshooting.md`](../docs/troubleshooting.md)
