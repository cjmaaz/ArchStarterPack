# resolvectl - systemd-resolved DNS Status

`resolvectl` shows DNS configuration and status from systemd-resolved. For VM setup, this is used to verify DNS is working correctly inside guest VMs.

---

## 📋 Quick Reference

```bash
resolvectl status              # Show DNS status
resolvectl query <domain>      # Query DNS
resolvectl statistics          # DNS statistics
```

---

## Show DNS Status

**Most common use:**

```bash
resolvectl status
```

**Output:**

```
Global
       Protocols: LLMNR=resolve -mDNS -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
resolv.conf mode: foreign

Link 2 (enp1s0)
    Current Scopes: DNS
         Protocols: +DefaultRoute +LLMNR -mDNS -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 192.168.122.1
       DNS Servers: 192.168.122.1
        DNS Domain: ~.
```

**What to look for:**

- `Current DNS Server: 192.168.122.1` ← DNS server (libvirt dnsmasq)
- `DNS Servers: 192.168.122.1` ← DNS servers list
- Interface name (`enp1s0`) ← Active interface

**If DNS server missing:**

- DHCP not completing
- Check default network on host: `virsh net-list --all`
- Check firewall rules on host

---

## Query DNS

```bash
resolvectl query google.com
```

**Output:**

```
google.com: 142.250.191.46                  -- link: enp1s0
            2607:f8b0:4004:c1b::66          -- link: enp1s0

-- Information acquired via protocol DNS in 12.3ms.
-- Data is authenticated: no; was transformed: no
```

**What it shows:**

- Resolved IP addresses (IPv4 and IPv6)
- Interface used
- Response time
- Authentication status

---

## DNS Statistics

```bash
resolvectl statistics
```

**Output:**

```
DNSSEC supported by current servers: no
Transactions
Current Transactions: 0
  Total Transactions: 1234
Cache
  Current Cache Size: 45
          Cache Hits: 567
        Cache Misses: 667
DNSSEC Verdicts
              Secure: 0
            Insecure: 0
               Bogus: 0
```

**What it shows:**

- DNS transaction statistics
- Cache statistics
- DNSSEC statistics

---

## VM Context

### Verify DNS in Guest VM

**Inside VM:**

```bash
resolvectl status
```

**Expected:**

- Should show DNS server (typically `192.168.122.1`)
- Should show active interface

**If DNS missing:**

- DHCP not completing
- Check host-side networking (see [`../../vm/docs/networking.md`](../../vm/docs/networking.md))

**Test DNS:**

```bash
resolvectl query google.com
ping google.com
```

---

## Troubleshooting

**Problem:** `resolvectl status` shows no DNS server

**Solutions:**

1. Check DHCP: `ip a` (should show IP address)
2. Check host network: `virsh net-list --all` (on host)
3. Check firewall: `ufw status` (on host)
4. Restart NetworkManager: `sudo systemctl restart NetworkManager` (in VM)

**Problem:** DNS queries fail

**Solutions:**

1. Check DNS server: `resolvectl status`
2. Test connectivity: `ping 8.8.8.8`
3. Check firewall rules on host
4. Check default network on host

---

## Related Commands

**Flush DNS cache:**

```bash
sudo resolvectl flush-caches
```

**Reload DNS configuration:**

```bash
sudo resolvectl reload
```

**Show DNS domains:**

```bash
resolvectl domain
```

---

## Learn More

- **VM networking:** [`../../vm/docs/networking.md`](../../vm/docs/networking.md)
- **DNS fundamentals:** [`../../networking/docs/dns.md`](../../networking/docs/dns.md)
- **VM troubleshooting:** [`../../vm/docs/troubleshooting.md`](../../vm/docs/troubleshooting.md)
- **Practice drills:** [`../../vm/practice/networking-drills.md`](../../vm/practice/networking-drills.md)
