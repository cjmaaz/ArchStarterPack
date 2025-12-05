# netstat - Network Statistics

Display network connections, routing tables, and network statistics.

**Note**: On modern systems, `ss` is often preferred over `netstat`.

---

## 📋 Quick Reference

```bash
netstat -an                      # All connections
netstat -tuln                    # Listening ports (TCP/UDP)
netstat -r                       # Routing table
netstat -s                       # Statistics
netstat -p                       # Show process/PID
netstat -i                       # Network interfaces
netstat -c                       # Continuous update
ss -tuln                         # Modern alternative
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-a` | All sockets |
| `-n` | Numeric (no DNS lookup) |
| `-t` | TCP connections |
| `-u` | UDP connections |
| `-l` | Listening ports |
| `-p` | Show process/PID |
| `-r` | Routing table |
| `-s` | Statistics |
| `-c` | Continuous |

---

## Examples

### View Connections
```bash
# All connections
netstat -an

# Listening ports only
netstat -tuln

# With process info (requires root)
sudo netstat -tulnp

# Established connections
netstat -an | grep ESTABLISHED

# Count connections by state
netstat -an | awk '{print $6}' | sort | uniq -c
```

### Find Specific Service
```bash
# Which process on port 8080?
sudo netstat -tulnp | grep :8080

# All connections to port 443
netstat -an | grep :443

# MySQL connections
netstat -an | grep :3306
```

### Network Statistics
```bash
# Protocol statistics
netstat -s

# TCP statistics only
netstat -st

# Interface statistics
netstat -i
```

### Routing Information
```bash
# Routing table
netstat -r

# Or use:
route -n
ip route
```

### Continuous Monitoring
```bash
# Update every 2 seconds
netstat -c

# Combined with watch
watch -n 2 'netstat -an | grep ESTABLISHED | wc -l'
```

### Modern Alternative (ss)
```bash
# Listening TCP ports
ss -tln

# All TCP connections
ss -ta

# Show process info
ss -tlnp

# Faster than netstat
ss -s  # Statistics
```

### Practical Uses
```bash
# Check if port is in use
netstat -tuln | grep :8080

# Count connections per IP
netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr

# Find service on port
sudo lsof -i :8080
# Or
sudo netstat -tulnp | grep :8080

# Monitor specific connection
watch 'netstat -an | grep "192.168.1.100"'
```

---

**Next**: [ping - Network Connectivity Test](./ping.md)
