# ifconfig - Legacy Interface Display (Linux/macOS)

`ifconfig` shows network interface configuration (IP addresses, interface status). On many modern Linux distros it’s considered **legacy** in favor of `ip`, but it’s still common in older guides and on macOS.

---

## 📋 Quick Reference

```bash
ifconfig                     # Show all interfaces
ifconfig en0                 # Show a specific interface (macOS Wi‑Fi often en0)
ifconfig | grep "inet "      # Quick IPv4 scan (legacy pattern)
```

---

## Beginner Examples (Pi-hole focused)

### Example 1: Find your IP address (IPv4)

```bash
ifconfig | grep "inet "
```

You’ll see lines like:

```
inet 192.168.0.42 netmask 0xffffff00 broadcast 192.168.0.255
```

Interpretation:

- IP = `192.168.0.42`
- netmask `0xffffff00` corresponds to `255.255.255.0` (same idea as `/24`)

If subnet masks are new to you, read:

- [`../../pi-hole/docs/networking-101.md`](../../pi-hole/docs/networking-101.md)

### Example 2: Prefer the modern tool on Linux

If you’re on Linux, use:

```bash
ip -4 a
ip -4 r
```

Guide: [`ip.md`](ip.md)

---

## Why this matters for Pi-hole

You need to know:

- Your Pi-hole IP (e.g., `192.168.0.109`)
- Your router/gateway (e.g., `192.168.0.1`)
- Whether clients are on the same subnet

Those are the foundations for setting DHCP DNS correctly.

---

## Related

- Modern networking tool (Linux): [`ip.md`](ip.md)
- DNS testing: [`nslookup.md`](nslookup.md), [`dig.md`](dig.md)
