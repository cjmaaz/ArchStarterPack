# DHCP Drills (Leases, Reservations, Renewals)

Prerequisite reading:

- [`../docs/dhcp.md`](../docs/dhcp.md)

---

## Drill D1: Identify your DNS server from client config

### Windows

Learn: [`../../shell-commands/02-commands/ipconfig.md`](../../shell-commands/02-commands/ipconfig.md)

```bat
ipconfig /all
```

Goal: find **DNS Servers** and confirm it matches your intended resolver (e.g., Pi-hole IP).

### Linux

Learn: [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md) (IP/gateway). DNS may be in `resolvectl`/`nmcli` depending on system.

---

## Drill D2: Renew a DHCP lease (when DNS changes don’t apply)

This is the most common “why didn’t my change work?” cause: the client is still using an old lease.

### Windows (explicit)

```bat
ipconfig /release
ipconfig /renew
ipconfig /all
```

### Linux/macOS (typical)

- Toggle Wi‑Fi off/on or reconnect.
- Reboot if needed.

Then validate with `nslookup` (DNS drill).

---

## Drill D3: Understand DHCP reservation by MAC

Read:

- MAC/ARP basics: [`../docs/layer2-mac-arp.md`](../docs/layer2-mac-arp.md)

Concept goal:

- DHCP reservation is “MAC → IP”, which is why it survives re-installs.

If you later enforce Pi-hole, a stable IP reservation is critical.
