# Networking Troubleshooting (Beginner, Systematic)

This page is a **decision tree** for common home-network failures (especially when Pi-hole isn’t working).

---

## 0. The 3 questions to always answer

1. **Can I reach the device by IP?** (routing/subnet/firewall problem if no)
2. **Am I using the right DNS server?** (DHCP/DNS problem if no)
3. **Is DNS being bypassed/encrypted?** (DoH/DoT/IPv6 leakage)

---

## 1. Can you reach the target IP?

Use `ping` (reachability):

- [`../../shell-commands/02-commands/ping.md`](../../shell-commands/02-commands/ping.md)

Example:

```bash
ping -c 1 192.168.0.109
```

If this fails:

- Confirm your IP/subnet/gateway:
  - Linux: [`../../shell-commands/02-commands/ip.md`](../../shell-commands/02-commands/ip.md)
  - Windows: [`../../shell-commands/02-commands/ipconfig.md`](../../shell-commands/02-commands/ipconfig.md)
- Confirm you’re on the same LAN (not guest Wi‑Fi).
- If on VLANs, ensure routing/firewall allows LAN → Pi-hole.

Background:

- [`ip-addressing.md`](ip-addressing.md)

---

## 2. Are you using the right DNS server?

Check which DNS answered:

- [`../../shell-commands/02-commands/nslookup.md`](../../shell-commands/02-commands/nslookup.md)

```bash
nslookup example.com
```

If “Server” is not Pi-hole:

- Fix router **LAN DHCP DNS**, not WAN DNS.
- Renew DHCP lease on the client.

Background:

- DHCP: [`dhcp.md`](dhcp.md)
- Router model: [`home-router-model.md`](home-router-model.md)

---

## 3. Are you being bypassed (secondary DNS / DoH / IPv6)?

### Secondary DNS bypass

If DHCP gives a secondary DNS (e.g., `8.8.8.8`), many clients will bypass Pi-hole.

Background:

- DNS: [`dns.md`](dns.md)

### DoH/DoT bypass

If the browser/device uses encrypted DNS, Pi-hole may never see queries.

Background:

- DNS: [`dns.md`](dns.md)

### IPv6 bypass

If IPv6 DNS is advertised incorrectly (RDNSS points to public DNS), clients can bypass Pi-hole on IPv6.

Background:

- DNS: [`dns.md`](dns.md)
- Router model: [`home-router-model.md`](home-router-model.md)

---

## 3.1 Layered checkpoints (L2/L3/L4)

If you’re stuck, classify the failure:

- **Layer 2 (local link)**: can’t resolve IP → MAC (ARP/ND issues)
  - Typical symptom: “same subnet but still unreachable”
  - Learn: [`layer2-mac-arp.md`](layer2-mac-arp.md)
- **Layer 3 (routing/subnet)**: wrong subnet, guest network isolation, missing routes
  - Typical symptom: “can reach router but not Pi-hole” from guest/VLAN
  - Learn: [`routing-vlans-guest.md`](routing-vlans-guest.md)
- **Layer 4 (ports/protocol)**: host reachable, but service blocked / wrong port / firewall
  - Typical symptom: ping works, but DNS times out/refuses
  - Learn: [`tcp-udp-ports.md`](tcp-udp-ports.md), [`nat-firewalls.md`](nat-firewalls.md)

---

## 4. Practice Drills

To build intuition, run the drills:

- [`../practice/drills.md`](../practice/drills.md)

---

## Next

- Home router model (where settings live): [`home-router-model.md`](home-router-model.md)
- Apply this knowledge to Pi-hole: [`../../pi-hole/README.md`](../../pi-hole/README.md)
