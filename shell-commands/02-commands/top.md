# top - Real-Time System Monitor

Display dynamic real-time view of system processes and resource usage.

---

## 📋 Quick Reference

```bash
top                        # Start interactive monitor
top -n 1                   # Run once and exit
top -b                     # Batch mode (non-interactive)
top -p PID                 # Monitor specific process
top -u username            # Monitor user's processes
htop                       # Enhanced version (if installed)
```

---

## Interactive Commands

| Key | Action |
|-----|--------|
| `q` | Quit |
| `k` | Kill process |
| `r` | Renice process |
| `M` | Sort by memory |
| `P` | Sort by CPU |
| `T` | Sort by time |
| `1` | Toggle CPU cores |
| `h` | Help |

---

## Examples

```bash
# Basic monitoring
top

# Batch mode (for scripts)
top -b -n 1 > system_snapshot.txt

# Monitor specific process
top -p $(pgrep java)

# User processes only
top -u john

# Output top 10 CPU consumers
top -b -n 1 | head -17 | tail -10
```

---

**Next**: [df-du - Disk Usage](./df-du.md)
