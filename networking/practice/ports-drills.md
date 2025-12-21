# Ports Drills (TCP/UDP + “is the service reachable?”)

Prerequisite reading:

- [`../docs/tcp-udp-ports.md`](../docs/tcp-udp-ports.md)

---

## Drill P1: Map common ports you’ll see in Pi-hole topics

Memorize these:

- DNS: UDP/TCP **53**
- DoT: TCP **853**
- DoH: TCP **443**

---

## Drill P2: Check local listening sockets (Linux)

Learn: [`../../shell-commands/02-commands/ss.md`](../../shell-commands/02-commands/ss.md)

```bash
ss -lntup | head
```

Goal:

- Understand what it means for a service to be “listening.”

---

## Drill P3: Interpret common failures

- If **ping works** but DNS times out:
  - port-level filtering may exist (firewall) or you’re on a different VLAN/guest network.
- If a TCP check says **connection refused**:
  - the host is reachable but nothing is listening on that port.

See:

- [`../docs/nat-firewalls.md`](../docs/nat-firewalls.md)
- [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)
