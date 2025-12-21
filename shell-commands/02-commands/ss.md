# ss - Socket Statistics (Modern netstat)

`ss` shows listening ports and active connections. It’s the modern replacement for `netstat` on many Linux systems.

---

## 📋 Quick Reference

```bash
ss -lntup        # Listening sockets (TCP/UDP), numeric, include process
ss -lnt          # Listening TCP only
ss -lnu          # Listening UDP only
ss -tup          # Active TCP sockets with process
```

---

## Beginner Examples (networking / Pi-hole oriented)

### Example 1: See what ports are listening

```bash
ss -lntup | head
```

Interpretation:

- If a service is “down,” you often won’t see it listening on its port.
- If a port is listening but the client can’t reach it, suspect firewall/VLAN isolation.

### Example 2: Map ports you care about for DNS topics

- DNS: UDP/TCP **53**
- DoT: TCP **853**
- DoH: TCP **443**

Learn the model:

- [`../../networking/docs/tcp-udp-ports.md`](../../networking/docs/tcp-udp-ports.md)
- [`../../networking/docs/nat-firewalls.md`](../../networking/docs/nat-firewalls.md)

---

## Related

- Legacy tool: [`netstat.md`](netstat.md)
