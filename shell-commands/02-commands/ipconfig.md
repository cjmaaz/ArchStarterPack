# ipconfig - Show Network Settings (Windows)

`ipconfig` is the Windows command that shows your IP address, gateway, and DNS servers. It’s the fastest way to verify whether Windows is actually using Pi-hole.

---

## 📋 Quick Reference

```bat
ipconfig                 rem Summary (IP + gateway sometimes)
ipconfig /all            rem Full details (includes DNS servers)
ipconfig /release        rem Drop DHCP lease (advanced)
ipconfig /renew          rem Get a new DHCP lease (advanced)
ipconfig /flushdns       rem Clear DNS cache (useful after DNS changes)
```

---

## Beginner Examples (Pi-hole focused)

### Example 1: See which DNS servers Windows is using

```bat
ipconfig /all
```

Find your active adapter (Wi‑Fi/Ethernet) and look for:

- **IPv4 Address**
- **Default Gateway**
- **DNS Servers**

If Pi-hole is authoritative, **DNS Servers** should include your Pi-hole IP (and ideally no public secondary DNS).

### Example 2: Force Windows to pick up new router DHCP DNS

After changing router DHCP DNS to Pi-hole, Windows might keep old settings until lease renewal.

```bat
ipconfig /release
ipconfig /renew
```

Then re-check:

```bat
ipconfig /all
```

### Example 3: Clear Windows DNS cache (when behavior “sticks”)

```bat
ipconfig /flushdns
```

---

## How this connects to Pi-hole

- DHCP hands out the DNS server. If DHCP says DNS = Pi-hole, Windows should use it.
- If Windows shows a public DNS server (e.g., `8.8.8.8`), Pi-hole will be bypassed.

Learn the model:

- IP/subnet/gateway basics: [`../../networking/docs/ip-addressing.md`](../../networking/docs/ip-addressing.md)
- DHCP basics (leases/renewals): [`../../networking/docs/dhcp.md`](../../networking/docs/dhcp.md)
- DNS basics (why no secondary DNS): [`../../networking/docs/dns.md`](../../networking/docs/dns.md)

---

## Related tools

- DNS query check: `nslookup` (Windows has it too): [`nslookup.md`](nslookup.md)
