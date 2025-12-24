# systemctl - Control systemd Services

`systemctl` is used to manage systemd services. For VM setup, this is used to start, stop, and enable the `libvirtd` service.

---

## 📋 Quick Reference

```bash
systemctl status <service>     # Check service status
systemctl start <service>      # Start service
systemctl stop <service>       # Stop service
systemctl restart <service>    # Restart service
systemctl enable <service>     # Enable on boot
systemctl disable <service>    # Disable on boot
systemctl enable --now <service> # Enable and start
```

---

## Check Service Status

**Most common use:**

```bash
systemctl status libvirtd
```

**Output:**

```
● libvirtd.service - Virtualization daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled)
     Active: active (running) since Mon 2024-01-15 10:30:00 EST; 1h ago
   Main PID: 1234 (libvirtd)
      Tasks: 15 (limit: 19000)
     Memory: 50.0M
        CPU: 2.5s
     CGroup: /system.slice/libvirtd.service
             └─1234 /usr/sbin/libvirtd
```

**What to look for:**

- `Active: active (running)` ← Service is running
- `enabled` ← Service starts on boot
- Any error messages

---

## Start Service

```bash
sudo systemctl start libvirtd
```

**What it does:**

- Starts the service immediately
- Does not enable on boot (use `enable` for that)

**Verify:**

```bash
systemctl status libvirtd
```

---

## Stop Service

```bash
sudo systemctl stop libvirtd
```

**What it does:**

- Stops the service immediately
- Does not disable on boot (use `disable` for that)

**Verify:**

```bash
systemctl status libvirtd
```

Should show `Active: inactive (dead)`.

---

## Restart Service

```bash
sudo systemctl restart libvirtd
```

**What it does:**

- Stops and starts the service
- Useful after configuration changes

**When to use:**

- After editing service configuration
- If service is misbehaving
- After package updates

---

## Enable Service on Boot

```bash
sudo systemctl enable libvirtd
```

**What it does:**

- Enables service to start on boot
- Does not start immediately (use `start` for that)

**Enable and start:**

```bash
sudo systemctl enable --now libvirtd
```

**This is the recommended way** — enables on boot and starts immediately.

---

## Disable Service on Boot

```bash
sudo systemctl disable libvirtd
```

**What it does:**

- Disables service from starting on boot
- Does not stop immediately (use `stop` for that)

**Disable and stop:**

```bash
sudo systemctl disable --now libvirtd
```

---

## View Service Logs

```bash
sudo journalctl -u libvirtd
```

**What it shows:**

- Service logs
- Error messages
- Debugging information

**Follow logs:**

```bash
sudo journalctl -u libvirtd -f
```

**Last N lines:**

```bash
sudo journalctl -u libvirtd -n 50
```

---

## List Services

**All services:**

```bash
systemctl list-units --type=service
```

**Running services:**

```bash
systemctl list-units --type=service --state=running
```

**Failed services:**

```bash
systemctl list-units --type=service --state=failed
```

---

## VM Context

### Manage libvirtd Service

**Enable and start (required for VMs):**

```bash
sudo systemctl enable --now libvirtd
```

**Check status:**

```bash
systemctl status libvirtd
```

**Restart if needed:**

```bash
sudo systemctl restart libvirtd
```

**View logs:**

```bash
sudo journalctl -u libvirtd
```

---

## Common Patterns

**Check if service is running:**

```bash
systemctl is-active libvirtd
```

**Check if service is enabled:**

```bash
systemctl is-enabled libvirtd
```

**Check if service failed:**

```bash
systemctl is-failed libvirtd
```

---

## Learn More

- **VM installation:** [`../../vm/docs/installation-setup.md`](../../vm/docs/installation-setup.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/setup-drills.md`](../../vm/practice/setup-drills.md)
