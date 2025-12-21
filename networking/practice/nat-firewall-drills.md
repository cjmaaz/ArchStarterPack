# NAT/Firewall Drills (Enforcement Thinking)

Prerequisite reading:

- [`../docs/nat-firewalls.md`](../docs/nat-firewalls.md)
- [`../docs/tcp-udp-ports.md`](../docs/tcp-udp-ports.md)

---

## Drill F1: Understand the enforcement goal (mental model)

Goal:

- Clients can send DNS to **Pi-hole**
- Clients cannot send DNS to **public resolvers**

```mermaid
flowchart LR
    Client[Client]
    Pi[Pi-hole]
    Public[PublicDNS]
    FW[Firewall]

    Client -->|Allow 53| Pi
    Client -->|Block 53/853| Public
    Client -->|DoH 443 (hard)| Public
    FW -.-> Client
```

---

## Drill F2: Prove bypass is possible (before enforcement)

On a client:

```bash
nslookup example.com 8.8.8.8
```

If this succeeds, your network allows bypass (normal default).

---

## Drill F3: Prove bypass is blocked (after enforcement)

After you add firewall rules, the same command should fail:

```bash
nslookup example.com 8.8.8.8
```

If it still succeeds:

- outbound DNS is still allowed (rule not applied to that client segment)
- you may be testing from a different VLAN/guest network

See: [`../docs/routing-vlans-guest.md`](../docs/routing-vlans-guest.md)

---

## Drill F4: DoH reality check

DoH uses TCP 443 and looks like normal HTTPS.

If you block all DoH endpoints broadly, you may break legitimate browsing.

Preferred approach:

- disable DoH at the client/browser policy layer (where possible)
- use DNS firewalling for 53/853 first

See: Pi-hole bypass guide: [`../../pi-hole/docs/hardcoded-dns.md`](../../pi-hole/docs/hardcoded-dns.md)
