# ping - Test Network Connectivity

Send ICMP ECHO_REQUEST packets to network hosts.

---

## 📋 Quick Reference

```bash
ping hostname                    # Continuous ping
ping -c 4 hostname               # Send 4 packets
ping -i 2 hostname               # 2 second interval
ping -s 1000 hostname            # Packet size 1000 bytes
ping -W 2 hostname               # 2 second timeout
ping -q hostname                 # Quiet (summary only)
ping -f hostname                 # Flood ping (root only)
ping6 hostname                   # IPv6 ping
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-c NUM` | Send NUM packets then stop |
| `-i SEC` | Wait SEC seconds between packets |
| `-s SIZE` | Packet size in bytes |
| `-W SEC` | Timeout in seconds |
| `-q` | Quiet (summary only) |
| `-v` | Verbose |
| `-4` | IPv4 only |
| `-6` | IPv6 only |

---

## Examples

### Basic Usage
```bash
# Continuous ping (Ctrl+C to stop)
ping google.com

# Limited count
ping -c 4 google.com

# One ping
ping -c 1 192.168.1.1
```

### Timing and Intervals
```bash
# Ping every 2 seconds
ping -i 2 google.com

# Wait 5 seconds for response
ping -W 5 slow-server.com

# Fast ping (0.2 second interval)
ping -i 0.2 -c 10 google.com
```

### Packet Size
```bash
# Large packets
ping -s 1000 google.com

# Jumbo frames test
ping -s 8000 server.local

# MTU discovery
ping -M do -s 1472 google.com
```

### Quiet Mode
```bash
# Summary only
ping -q -c 100 google.com

# Output:
# --- google.com ping statistics ---
# 100 packets transmitted, 100 received, 0% packet loss
# rtt min/avg/max/mdev = 10.2/15.5/25.3/3.1 ms
```

### Connectivity Checks
```bash
# Test if host is up
if ping -c 1 -W 2 server.com &> /dev/null; then
    echo "Server is up"
else
    echo "Server is down"
fi

# Check multiple hosts
for host in server1 server2 server3; do
    if ping -c 1 -W 2 $host &> /dev/null; then
        echo "$host: UP"
    else
        echo "$host: DOWN"
    fi
done
```

### Statistics and Monitoring
```bash
# Collect statistics
ping -c 100 -q google.com | tail -2

# Monitor latency over time
ping -i 5 google.com | awk '/time=/ {print strftime("%H:%M:%S"), $0}' | tee ping.log

# Average response time
ping -c 10 -q google.com | awk -F'/' '/^rtt/ {print "Average:", $5, "ms"}'
```

### Network Troubleshooting
```bash
# Test local network
ping -c 4 192.168.1.1  # Gateway

# Test DNS
ping -c 4 8.8.8.8      # Google DNS
ping -c 4 google.com   # If this fails but above works, DNS issue

# Test internet
ping -c 4 1.1.1.1      # Cloudflare DNS

# Path MTU discovery
ping -M do -s 1472 -c 4 google.com  # Should work
ping -M do -s 1473 -c 4 google.com  # May fragment
```

### Continuous Monitoring
```bash
# Log pings with timestamp
ping google.com | while read line; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') $line"
done | tee ping_monitor.log

# Alert on packet loss
ping -c 10 server.com | grep 'packet loss' | \
awk -F'[%,]' '{if ($3 > 0) print "ALERT: Packet loss detected:", $3"%"}'
```

### Salesforce Connectivity
```bash
# Test Salesforce instance reachability
ping -c 4 login.salesforce.com

# Test My Domain
ping -c 4 mycompany.my.salesforce.com

# Quick connectivity check
ping -c 1 -W 2 login.salesforce.com && echo "Salesforce reachable" || echo "Cannot reach Salesforce"
```

### Scripting Examples
```bash
# Health check script
#!/bin/bash
HOSTS=("google.com" "github.com" "salesforce.com")

for host in "${HOSTS[@]}"; do
    if ping -c 1 -W 2 "$host" &> /dev/null; then
        echo "✓ $host is reachable"
    else
        echo "✗ $host is unreachable"
    fi
done

# Response time monitoring
while true; do
    TIME=$(ping -c 1 server.com | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)
    echo "$(date '+%H:%M:%S') Response time: ${TIME}ms"
    sleep 5
done
```

---

**All Phases Complete! Final step: README update**

**Next**: Update [README.md](../README.md)
