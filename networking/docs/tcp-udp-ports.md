# TCP vs UDP vs Ports (Enough to Debug Real Networks)

This page makes sense of:

- **Ports** (what they are and why they matter)
- **TCP vs UDP** (the difference in behavior)
- Why Pi-hole “bypass” topics talk about **53**, **853**, and **443**

---

## 0. Prerequisites

- IP/subnet/gateway: [`ip-addressing.md`](ip-addressing.md)

---

## 1. Ports: “which door on the same house”

An IP address tells you **which device**.
A port tells you **which service on that device**.

Analogy:

- IP = building address
- Port = apartment number / door

Example:

- Pi-hole DNS typically listens on **UDP/TCP 53** on the Pi-hole IP.
- Pi-hole admin UI is typically **HTTP 80** or **HTTPS 443** (depending on setup).

---

## 2. TCP vs UDP (plain language)

### UDP (User Datagram Protocol)

- “Send and hope it arrives”
- No built-in connection
- Lower overhead
- Great for small request/response patterns

### TCP (Transmission Control Protocol)

- Connection-oriented (“handshake”)
- Reliable delivery and ordering
- Heavier but robust

---

## 3. Why DNS uses UDP _and_ TCP 53

Most DNS queries use **UDP 53** because it’s fast and lightweight.
DNS can also use **TCP 53** for:

- larger responses
- zone transfers (not typical for home users)
- when UDP responses are truncated

---

## 4. DoT and DoH: why these bypass Pi-hole

### DoT (DNS over TLS)

- DNS encrypted over **TCP 853**
- If a client uses DoT directly to the internet, Pi-hole won’t see the query.

### DoH (DNS over HTTPS)

- DNS encrypted over **TCP 443** (looks like web traffic)
- Harder to block without breaking normal web browsing

Mapping:

- DNS: UDP/TCP **53**
- DoT: TCP **853**
- DoH: TCP **443**

This is why Pi-hole “hardcoded DNS bypass” mitigation often talks about blocking or controlling traffic on those ports.

See: [`nat-firewalls.md`](nat-firewalls.md) and Pi-hole bypass doc: [`../../pi-hole/docs/hardcoded-dns.md`](../../pi-hole/docs/hardcoded-dns.md)

---

## 5. Interpreting common failures

- **Timeout**
  - Packet didn’t get through (routing, firewall, wrong IP, wrong port, VLAN isolation)
- **Connection refused** (TCP)
  - You reached the host, but nothing is listening on that port (service down or different port)

---

## 6. Practical checks (drills)

Learn commands:

- Linux sockets: `ss` (see `../../shell-commands/02-commands/ss.md`)
- Legacy: `netstat` (existing command guide: `../../shell-commands/02-commands/netstat.md`)

Practice:

- [`../practice/ports-drills.md`](../practice/ports-drills.md)
