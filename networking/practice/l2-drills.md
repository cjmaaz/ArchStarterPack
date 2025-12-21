# Layer 2 Drills (MAC, ARP, “Why can’t I reach it?”)

Prerequisite reading:

- [`../docs/layer2-mac-arp.md`](../docs/layer2-mac-arp.md)

---

## Drill L2-1: View your neighbor/ARP cache

Linux:

```bash
ip neigh
```

Windows:

```bat
arp -a
```

Goal:

- See that your system maintains IP → MAC mappings for local devices.

Learn: [`../../shell-commands/02-commands/arp.md`](../../shell-commands/02-commands/arp.md)

---

## Drill L2-2: Clear and rebuild neighbor info (safe)

This is optional and system-dependent. If you don’t know what you’re doing, skip it.

Instead, do a “rebuild” by pinging a local IP:

```bash
ping -c 1 192.168.0.1
```

Then re-check:

```bash
ip neigh | head
```

Interpretation:

- If you cannot ARP/ND for a local IP, L2 connectivity is broken (Wi‑Fi isolation, VLAN rules, wrong SSID, etc.).
