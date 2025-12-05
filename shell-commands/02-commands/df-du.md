# df/du - Disk Space Analysis

Check filesystem disk space (df) and directory disk usage (du).

---

## 📋 Quick Reference

### df - Filesystem Space
```bash
df                          # All filesystems
df -h                       # Human-readable
df -h /                     # Specific filesystem
df -i                       # Inode information
```

### du - Directory Usage
```bash
du -sh directory/           # Summary, human-readable
du -h --max-depth=1         # First level only
du -sh */ | sort -rh        # Sort by size
du -ch files/* | tail -1    # Total size
```

---

## Examples

### df Examples
```bash
# Readable format
df -h

# Specific mount
df -h /data

# Check inodes
df -i
```

### du Examples
```bash
# Directory size
du -sh /var/log

# Top 10 largest directories
du -sh /* 2>/dev/null | sort -rh | head -10

# Subdirectories only
du -h --max-depth=1 /home | sort -rh

# Total with breakdown
du -ch directory/*
```

### Combined Usage
```bash
# Find large directories when disk is full
df -h  # Check which filesystem is full
cd /full/filesystem
du -sh */ | sort -rh | head -20  # Find culprits
```

---

**Next**: [chmod - Change Permissions](./chmod.md)
