# arp / Neighbor cache (ARP, `ip neigh`)

This page shows how to view IP→MAC mappings on your system.

- In IPv4 this is commonly called **ARP**.
- In IPv6 the concept exists too (Neighbor Discovery), and `ip neigh` shows both.

---

## 📋 Quick Reference

### Linux (recommended)

```bash
ip neigh
```

### Windows

```bat
arp -a
```

---

## Why this matters

If you’re on the same subnet but can’t reach a device by IP, L2 neighbor resolution can be part of the story.

Learn the concept:
- [`../../networking/docs/layer2-mac-arp.md`](../../networking/docs/layer2-mac-arp.md)

---

## Beginner Examples

### Example 1: List neighbors (Linux)

```bash
ip neigh | head
```

You’ll see lines like:
- `192.168.0.1 dev wlan0 lladdr aa:bb:cc:dd:ee:ff REACHABLE`

### Example 2: List ARP table (Windows)

```bat
arp -a
```

---

## Related

- IP/gateway basics: [`ip.md`](ip.md)
- Layer 2 learning: [`../../networking/docs/layer2-mac-arp.md`](../../networking/docs/layer2-mac-arp.md)
