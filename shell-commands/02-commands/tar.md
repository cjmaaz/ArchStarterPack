# tar - Archive and Compress Files

Create, extract, and manage tar archives with optional compression.

---

## 📋 Quick Reference

```bash
tar -czf archive.tar.gz files/          # Create compressed archive
tar -xzf archive.tar.gz                 # Extract compressed archive
tar -tzf archive.tar.gz                 # List contents
tar -xzf archive.tar.gz -C /dest        # Extract to directory
tar -czf backup.tar.gz --exclude=*.log files/  # Exclude patterns
tar -xzf archive.tar.gz file.txt        # Extract single file
tar -rf archive.tar newfile.txt         # Append to archive
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-c` | Create archive |
| `-x` | Extract archive |
| `-t` | List contents |
| `-z` | Gzip compression |
| `-j` | Bzip2 compression |
| `-f FILE` | Archive filename |
| `-v` | Verbose output |
| `-C DIR` | Change to directory |
| `--exclude` | Exclude pattern |

---

## Examples

### Create Archives
```bash
# Basic archive
tar -cf archive.tar files/

# Compressed (gzip)
tar -czf archive.tar.gz files/

# Compressed (bzip2)
tar -cjf archive.tar.bz2 files/

# With verbose output
tar -czvf archive.tar.gz files/

# Exclude patterns
tar -czf backup.tar.gz --exclude='*.log' --exclude='node_modules' project/
```

### Extract Archives
```bash
# Extract
tar -xzf archive.tar.gz

# Extract to specific directory
tar -xzf archive.tar.gz -C /destination/

# Extract single file
tar -xzf archive.tar.gz path/to/file.txt

# List before extracting
tar -tzf archive.tar.gz
```

### Salesforce Examples
```bash
# Backup Salesforce project
tar -czf salesforce_backup_$(date +%Y%m%d).tar.gz force-app/ manifest/

# Archive old logs
find logs/ -name "*.log" -mtime +30 | tar -czf old_logs.tar.gz -T -
```

---

**Next**: [ps - Process Status](./ps.md)
