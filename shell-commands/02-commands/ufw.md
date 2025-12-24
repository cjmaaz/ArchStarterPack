# ufw - Uncomplicated Firewall

`ufw` (Uncomplicated Firewall) is a user-friendly interface for managing netfilter firewall rules. For VM setup, this is used to allow VM traffic through the firewall.

---

## 📋 Quick Reference

```bash
sudo ufw status                  # Show firewall status
sudo ufw status verbose          # Detailed status
sudo ufw allow <rule>            # Allow traffic
sudo ufw deny <rule>             # Deny traffic
sudo ufw reload                  # Reload rules
sudo ufw enable                  # Enable firewall
sudo ufw disable                 # Disable firewall
```

---

## Show Firewall Status

**Basic status:**

```bash
sudo ufw status
```

**Output:**

```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
```

**Verbose status:**

```bash
sudo ufw status verbose
```

**Output:**

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

**What to look for:**

- `Status: active` ← Firewall is enabled
- `Default: deny (routed)` ← This blocks VM traffic!
- Rules for `virbr0` ← Should exist for VM networking

---

## Allow VM Traffic

**For libvirt NAT networking:**

**Step 1: Allow virbr0 traffic**

```bash
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0
```

**Step 2: Allow routed VM traffic**

Replace `<HOST_IFACE>` with your actual interface (`wlan0`, `eth0`, etc.):

```bash
sudo ufw route allow in on virbr0 out on <HOST_IFACE>
```

**Step 3: Reload**

```bash
sudo ufw reload
```

**Verify:**

```bash
sudo ufw status verbose
```

Should show rules for `virbr0`.

---

## Why These Rules Are Safe

**These rules:**

- Do **not** open ports on the host
- Do **not** allow internet → host
- Do **not** allow internet → VM
- Only permit **egress traffic initiated by the VM**

**Why:**

- `virbr0` is a private virtual bridge
- Not routable from the internet
- Only VMs attached to it can see this traffic

---

## Common Rules

**Allow SSH:**

```bash
sudo ufw allow 22/tcp
```

**Allow HTTP/HTTPS:**

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

**Allow from specific IP:**

```bash
sudo ufw allow from 192.168.1.100
```

**Allow to specific port:**

```bash
sudo ufw allow 8080/tcp
```

---

## Enable/Disable Firewall

**Enable firewall:**

```bash
sudo ufw enable
```

**Disable firewall:**

```bash
sudo ufw disable
```

⚠️ **Warning:** Disabling firewall removes all protection. Use only for testing.

---

## Reload Rules

**After making changes:**

```bash
sudo ufw reload
```

**What it does:**

- Reloads firewall rules
- Applies changes without disabling firewall

---

## VM Context

### Fix "Ping Works, apt Fails" Issue

**Symptoms:**

- `ping google.com` works
- `apt update` times out
- HTTP/HTTPS fails

**Root cause:** UFW blocking routed VM traffic

**Solution:**

```bash
# Allow virbr0 traffic
sudo ufw allow in on virbr0
sudo ufw allow out on virbr0

# Allow routed traffic (replace wlan0 with your interface)
sudo ufw route allow in on virbr0 out on wlan0

# Reload
sudo ufw reload
```

**Verify:**

```bash
sudo ufw status verbose
```

**Test in VM:**

```bash
curl http://archive.ubuntu.com
sudo apt update
```

---

## Troubleshooting

**Problem:** VM has no internet despite firewall rules

**Solutions:**

1. Check rules: `sudo ufw status verbose`
2. Verify interface name: `ip a` (check actual interface name)
3. Check default network: `virsh net-list --all` (on host)
4. Reload firewall: `sudo ufw reload`

**Problem:** Firewall blocks everything

**Solutions:**

1. Check default policy: `sudo ufw status verbose`
2. Temporarily disable: `sudo ufw disable` (for testing only)
3. Add specific rules instead of disabling

---

## Learn More

- **VM networking:** [`../../vm/docs/networking.md`](../../vm/docs/networking.md)
- **NAT/Firewalls:** [`../../networking/docs/nat-firewalls.md`](../../networking/docs/nat-firewalls.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/networking-drills.md`](../../vm/practice/networking-drills.md)
