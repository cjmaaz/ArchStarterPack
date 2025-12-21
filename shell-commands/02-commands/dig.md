# dig - DNS Lookup and Troubleshooting

`dig` (Domain Information Groper) is a DNS inspection tool. It’s more verbose than `nslookup`, and it’s the best way to diagnose DNS behavior (records, TTL, which server answered).

---

## 📋 Quick Reference

```bash
dig example.com                       # Query default resolver
dig example.com @192.168.0.109        # Query a specific DNS server (Pi-hole)
dig AAAA example.com @192.168.0.109   # Query an IPv6 record
dig +short example.com @192.168.0.109 # Just the answer IP(s)
dig example.com +trace                # Follow the DNS chain (advanced)
```

---

## How to read the important parts

Key fields you’ll commonly use:

- **SERVER:** which resolver answered (should be Pi-hole when testing Pi-hole)
- **ANSWER SECTION:** the record(s) you asked for
- **TTL:** how long the result can be cached

Example snippet:

```
;; ANSWER SECTION:
example.com.   3600   IN   A   93.184.216.34
```

---

## Beginner Examples (Pi-hole focused)

### Example 1: Confirm Pi-hole answers queries

```bash
dig example.com @192.168.0.109
```

If this works but browsing still shows ads, you likely have bypass (secondary DNS, DoH, IPv6 leakage).

### Example 2: See only the IP (quick verification)

```bash
dig +short example.com @192.168.0.109
```

### Example 3: Check IPv6 path (avoid IPv6 bypass)

```bash
dig AAAA example.com @<pi-hole-ipv6>
```

If this fails but IPv4 works, your IPv6 DNS advertisement (RDNSS/DHCPv6) may not be correct.

### Example 4: Test Unbound directly (local recursion)

If Unbound is listening on `127.0.0.1#5335`:

```bash
dig example.com @127.0.0.1 -p 5335
```

---

## Common troubleshooting interpretations

- **No ANSWER but status NOERROR**

  - Often means the name exists but that record type doesn’t (e.g., no AAAA record).

- **SERVFAIL**

  - Resolver failed upstream or validation. Common when Unbound/DNSSEC has issues.

- **Timeout**
  - Can’t reach the resolver. Check IP/subnet/gateway and firewall.

---

## Learn More

- DNS mental model (recursion, caching, TTL, DoH): [`../../pi-hole/docs/dns.md`](../../pi-hole/docs/dns.md)
- Pi-hole networking fundamentals: [`../../pi-hole/docs/networking-101.md`](../../pi-hole/docs/networking-101.md)
- Unbound setup: [`../../pi-hole/docs/unbound.md`](../../pi-hole/docs/unbound.md)
- `nslookup` (simpler quick checks): [`nslookup.md`](nslookup.md)
