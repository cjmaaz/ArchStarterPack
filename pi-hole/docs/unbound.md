# Pi-hole + Unbound (Local Recursive DNS)

**Goal:** Run a validating, recursive resolver locally so Pi-hole forwards to your own Unbound instance instead of third-party DNS. This keeps queries on your network and improves privacy.

---

## Prerequisites (recommended)

- Networking basics (IP/subnet/gateway): [`../../networking/docs/ip-addressing.md`](../../networking/docs/ip-addressing.md)
- DNS model (recursion, caching): [`../../networking/docs/dns.md`](../../networking/docs/dns.md)
- DNS tool: [`../../shell-commands/02-commands/dig.md`](../../shell-commands/02-commands/dig.md)

---

## Flow

```mermaid
flowchart LR
    Clients[Clients]
    Router[Router<br/>DHCP]
    PiHole[Pi-hole<br/>DNS + Blocklists]
    Unbound[Unbound<br/>Local Recursive]
    Root[Root/Upstream]

    Clients -->|DHCP DNS = Pi-hole| Router --> PiHole
    PiHole -->|127.0.0.1:5335| Unbound --> Root
```

Key points:

- Pi-hole still enforces blocklists.
- Unbound resolves directly from root servers (or your ISP if you prefer custom forwarders).
- Keep Unbound on the same Pi for simplicity.

---

## Install & Configure (Pi-hole host)

```bash
sudo apt update
sudo apt install -y unbound
```

Create `/etc/unbound/unbound.conf.d/pi-hole.conf`:

```
server:
    verbosity: 0
    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    prefetch: yes
    num-threads: 2
    cache-min-ttl: 60
    cache-max-ttl: 86400
    so-reuseport: yes
    edns-buffer-size: 1232
    harden-glue: yes
    harden-dnssec-stripped: yes
    qname-minimisation: yes
    aggressive-nsec: yes
    hide-identity: yes
    hide-version: yes

    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

Start and enable:

```bash
sudo systemctl enable --now unbound
sudo systemctl status unbound
```

---

## Wire Pi-hole to Unbound

1. In Pi-hole Admin → Settings → DNS:
   - Upstream DNS Servers → **Custom 1 (IPv4):** `127.0.0.1#5335`
   - Disable other upstreams.
2. Apply changes.
3. Test:
   ```bash
   dig google.com @127.0.0.1 -p 5335
   ```
   Expect a valid answer with `SERVFAIL` only when domains are truly failing validation.

---

## Notes & Tips

- Keep router DHCP DNS pointing to Pi-hole (unchanged).
- If you want root priming updates manually: `sudo unbound-anchor -a "/var/lib/unbound/root.key"`.
- For logging, add `verbosity: 1` temporarily; keep at 0 for performance.
- For multi-Pi redundancy, run Unbound on each Pi-hole and keep DHCP pointing at one Pi-hole; use Pi-hole’s conditional forwarding or peer sync if desired.
