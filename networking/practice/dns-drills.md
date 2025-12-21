# DNS Drills (Resolver, TTL, Bypass)

Prerequisite reading:
- [`../docs/dns.md`](../docs/dns.md)
- Ports overview: [`../docs/tcp-udp-ports.md`](../docs/tcp-udp-ports.md)

---

## Drill N1: Verify which DNS server answered you

Learn: [`../../shell-commands/02-commands/nslookup.md`](../../shell-commands/02-commands/nslookup.md)

```bash
nslookup example.com
```

Goal:
- The “Server” line should be the resolver you expect (Pi-hole if you’re testing Pi-hole).

---

## Drill N2: Ask a specific resolver directly

```bash
nslookup example.com 192.168.0.109
```

Interpretation:
- Works here but not in N1 → DHCP DNS is wrong or lease not renewed.

---

## Drill N3: Inspect TTL with dig

Learn: [`../../shell-commands/02-commands/dig.md`](../../shell-commands/02-commands/dig.md)

```bash
dig example.com @192.168.0.109
```

Goal:
- Find TTL and understand caching.

---

## Drill N4: Prove bypass (only if you have enforcement rules)

If you later enforce DNS-only-to-Pi-hole, this should fail:

```bash
nslookup example.com 8.8.8.8
```

If it succeeds, outbound DNS is still allowed.
