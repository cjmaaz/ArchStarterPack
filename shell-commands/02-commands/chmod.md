# chmod - Change File Permissions

Modify file and directory permissions.

---

## 📋 Quick Reference

```bash
chmod 755 file.sh           # rwxr-xr-x
chmod 644 file.txt          # rw-r--r--
chmod +x script.sh          # Add execute
chmod -w file.txt           # Remove write
chmod u+x file              # User execute
chmod g-w file              # Group no write
chmod -R 755 directory/     # Recursive
```

---

## Permission Values

| Number | Permission | Binary |
|--------|------------|--------|
| 4 | Read (r) | 100 |
| 2 | Write (w) | 010 |
| 1 | Execute (x) | 001 |
| 7 | rwx | 111 |
| 6 | rw- | 110 |
| 5 | r-x | 101 |
| 0 | --- | 000 |

---

## Examples

```bash
# Common patterns
chmod 755 script.sh         # Executable script
chmod 644 data.txt          # Regular file
chmod 600 secret.key        # Private file
chmod 777 shared/           # Full access (avoid!)

# Symbolic mode
chmod +x script.sh          # Add execute for all
chmod u+w file.txt          # User write
chmod go-rwx private.txt    # Remove all for group/others

# Recursive
chmod -R 755 website/       # All files and dirs

# Salesforce example
chmod +x deploy.sh
./deploy.sh
```

---

**Next**: [diff - Compare Files](./diff.md)
