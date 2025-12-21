# nslookup - Query DNS (Beginner-Friendly)

`nslookup` asks a DNS server a question and shows you the answer. It’s one of the fastest ways to confirm whether your device is **actually using Pi-hole**.

---

## 📋 Quick Reference

```bash
nslookup example.com                    # Use default DNS configured on your device
nslookup example.com 192.168.0.109      # Ask a specific DNS server (Pi-hole IP)
nslookup doubleclick.net 192.168.0.109  # Test a commonly blocked domain (example)
```

---

## What problem does this solve?

When Pi-hole “is installed but not blocking,” the most common issue is: **clients are not using Pi-hole DNS**.

`nslookup` answers the key question:

> “Which DNS server answered me?”

---

## How to read the output

Typical output looks like:

```
Server:         192.168.0.109
Address:        192.168.0.109#53

Non-authoritative answer:
Name:   example.com
Address: 93.184.216.34
```

Interpretation:

- **Server** should be your Pi-hole IP if Pi-hole is authoritative.
- If “Server” is `8.8.8.8` / `1.1.1.1` / ISP DNS, Pi-hole is being bypassed.

---

## Beginner Examples (Pi-hole focused)

### Example 1: Confirm your device’s configured DNS

```bash
nslookup example.com
```

- If **Server = Pi-hole**, good.
- If not, fix router DHCP DNS settings (see Pi-hole docs).

### Example 2: Ask Pi-hole directly (bypass your device config)

```bash
nslookup example.com 192.168.0.109
```

If this works but Example 1 doesn’t:

- Pi-hole is reachable, but your device isn’t using it by default → DHCP/DNS config problem.

### Example 3: Test blocking

```bash
nslookup doubleclick.net 192.168.0.109
```

Expected outcomes vary by your Pi-hole blocklists, but you often see:

- `0.0.0.0` (blocked), or
- your Pi-hole IP / sinkhole address.

### Example 4: Prove bypass (should fail after firewall rules)

```bash
nslookup example.com 8.8.8.8
```

If you have configured “block outbound DNS except Pi-hole,” this should fail.

---

## Common Errors

- **connection timed out; no servers could be reached**

  - You can’t reach the DNS server (wrong IP, network/VLAN issue, firewall).
  - First check reachability: `ping <dns-ip>` (see `ping.md`).

- **SERVFAIL**
  - The resolver failed to answer (could be upstream outage, DNSSEC issues, or Unbound misconfig).
  - If using Unbound, test Unbound directly (see `dig.md` or the Unbound doc).

---

## Learn More (linked concepts)

- Pi-hole learning hub: [`../../pi-hole/docs/learning.md`](../../pi-hole/docs/learning.md)
- Networking fundamentals (IP/subnet/gateway): [`../../pi-hole/docs/networking-101.md`](../../pi-hole/docs/networking-101.md)
- DNS deep dive (recursion, caching, DoH): [`../../pi-hole/docs/dns.md`](../../pi-hole/docs/dns.md)
- `dig` (more powerful DNS tool): [`dig.md`](dig.md)
