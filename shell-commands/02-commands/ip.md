# ip - Show and Configure Networking (Linux)

`ip` is the modern Linux tool for inspecting network state: IP addresses, routes (gateway), interfaces, and more. For Pi-hole setup, it answers the key questions:

- What IP do I have?
- What subnet/prefix am I on?
- What is my gateway?

---

## 📋 Quick Reference

```bash
ip a                   # Show IP addresses (IPv4 + IPv6)
ip -4 a                # IPv4 only
ip -6 a                # IPv6 only
ip r                   # Show routes (includes default gateway)
ip -4 r                # IPv4 routes only
ip link                # Interfaces (UP/DOWN)
```

---

## Beginner Examples (Pi-hole focused)

### Example 1: Find your IP address and subnet prefix

```bash
ip -4 a
```

Look for something like:

```
inet 192.168.0.42/24
```

Interpretation:

- IP = `192.168.0.42`
- Prefix `/24` means the subnet is `192.168.0.0/24` (typical home LAN).

If you don’t know what `/24` means, read:

- [`../../networking/docs/ip-addressing.md`](../../networking/docs/ip-addressing.md)

### Example 2: Find your default gateway (router)

```bash
ip -4 r
```

Look for:

```
default via 192.168.0.1 dev wlan0
```

Interpretation:

- Gateway/router = `192.168.0.1`

### Example 3: Quick “am I on the right LAN?”

If Pi-hole is `192.168.0.109` and your device is `192.168.0.42/24`, you’re on the same LAN and should be able to reach it (unless VLAN/firewall blocks it).

Test reachability:

```bash
ping -c 1 192.168.0.109
```

---

## Notes (DNS on Linux)

DNS settings are not always shown by `ip`. Depending on your distro/stack, check:

- `resolvectl status` (systemd-resolved)
- `cat /etc/resolv.conf`
- NetworkManager: `nmcli dev show`

For “what is DNS and why Pi-hole depends on it,” read:

- [`../../networking/docs/dns.md`](../../networking/docs/dns.md)

---

## Related Commands

- `ping` (reachability): [`ping.md`](ping.md)
- `dig` (DNS detail): [`dig.md`](dig.md)
- `nslookup` (DNS quick check): [`nslookup.md`](nslookup.md)

---

## Legacy note: ifconfig

Some guides use `ifconfig`, but it’s legacy on many distros. If you need it (or you’re on macOS), see:

- [`ifconfig.md`](ifconfig.md)
