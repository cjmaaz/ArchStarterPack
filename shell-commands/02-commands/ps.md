# ps - Process Status

Display information about running processes.

---

## 📋 Quick Reference

```bash
ps                              # Processes in current shell
ps aux                          # All processes
ps -ef                          # Full format listing
ps -p PID                       # Specific process
ps aux | grep process_name      # Find specific process
ps -u username                  # Processes by user
ps --sort=-%cpu | head          # Top CPU consumers
ps --sort=-%mem | head          # Top memory consumers
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `a` | All users' processes |
| `u` | User-oriented format |
| `x` | Include processes without TTY |
| `-e` | All processes |
| `-f` | Full format |
| `-p PID` | Specific process |
| `--sort` | Sort by column |

---

## Examples

### Basic Usage
```bash
# All processes
ps aux

# Find process
ps aux | grep java

# By user
ps -u john

# Process tree
pstree
```

### Sorting and Filtering
```bash
# Top CPU
ps aux --sort=-%cpu | head -10

# Top memory
ps aux --sort=-%mem | head -10

# Custom format
ps -eo pid,user,%cpu,%mem,cmd | sort -k3 -nr | head
```

### Monitoring
```bash
# Watch processes
watch -n 1 'ps aux --sort=-%cpu | head -20'

# Count by user
ps aux | awk '{print $1}' | sort | uniq -c
```

---

**Next**: [date - Date and Time](./date.md)
