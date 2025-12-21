# Networking (Beginner → Practical)

This module is a **systematic reading path** to understand home networking well enough to confidently configure things like Pi-hole, routers, VLANs/guest networks, and basic firewalling.

If you’re here because “Pi-hole isn’t blocking,” you almost always have a **networking configuration** issue (DHCP/DNS/IPv6/DoH).

---

## Start Here (recommended reading order)

1. **Network addressing** (IP, subnet, subnet mask/prefix, gateway, LAN vs WAN)
   - [`docs/ip-addressing.md`](docs/ip-addressing.md)
2. **Layer 2 (local delivery)** (MAC addresses, switching, ARP)
   - [`docs/layer2-mac-arp.md`](docs/layer2-mac-arp.md)
3. **DHCP** (how devices get IP + gateway + DNS)
   - [`docs/dhcp.md`](docs/dhcp.md)
4. **DNS** (how names become IPs; caching/TTL; DoH/DoT bypass)
   - [`docs/dns.md`](docs/dns.md)
5. **TCP vs UDP vs ports** (why 53/853/443 matter)
   - [`docs/tcp-udp-ports.md`](docs/tcp-udp-ports.md)
6. **NAT and firewalls** (home router reality)
   - [`docs/nat-firewalls.md`](docs/nat-firewalls.md)
7. **Routing/VLANs/guest networks** (why guest Wi‑Fi can’t reach LAN services)
   - [`docs/routing-vlans-guest.md`](docs/routing-vlans-guest.md)
8. **Home router model** (where settings live in router UIs)
   - [`docs/home-router-model.md`](docs/home-router-model.md)
9. **Troubleshooting** (systematic tests and what results mean)
   - [`docs/troubleshooting.md`](docs/troubleshooting.md)
10. **Practice drills** (muscle memory)

- [`practice/drills.md`](practice/drills.md)

---

## Tools you’ll use (with docs)

- **Show IP/gateway (Linux):** [`../shell-commands/02-commands/ip.md`](../shell-commands/02-commands/ip.md)
- **Show IP/gateway/DNS (Windows):** [`../shell-commands/02-commands/ipconfig.md`](../shell-commands/02-commands/ipconfig.md)
- **DNS checks:** [`../shell-commands/02-commands/nslookup.md`](../shell-commands/02-commands/nslookup.md), [`../shell-commands/02-commands/dig.md`](../shell-commands/02-commands/dig.md)
- **Reachability:** [`../shell-commands/02-commands/ping.md`](../shell-commands/02-commands/ping.md)

---

## How this connects to Pi-hole

After finishing sections 1–3, Pi-hole configuration becomes straightforward:

- Router DHCP must advertise **Pi-hole as the only DNS**.
- Avoid secondary DNS (bypass).
- Avoid DoH/DoT bypass.
- Ensure IPv6 DNS points to Pi-hole as well.

Jump to Pi-hole module:

- [`../pi-hole/README.md`](../pi-hole/README.md)
