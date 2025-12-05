# diff - Compare Files

Compare files line by line and show differences.

---

## 📋 Quick Reference

```bash
diff file1.txt file2.txt            # Basic comparison
diff -u file1.txt file2.txt         # Unified format
diff -y file1.txt file2.txt         # Side-by-side
diff -r dir1/ dir2/                 # Recursive directory
diff -q file1.txt file2.txt         # Brief (just if different)
diff --color file1.txt file2.txt    # Colored output
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-u` | Unified format |
| `-y` | Side-by-side |
| `-r` | Recursive |
| `-q` | Brief |
| `-i` | Ignore case |
| `-w` | Ignore whitespace |
| `--color` | Colored output |

---

## Examples

### Basic Comparison
```bash
# Simple diff
diff old.txt new.txt

# Unified format (patch-style)
diff -u old.txt new.txt

# Side-by-side
diff -y old.txt new.txt
```

### Directory Comparison
```bash
# Compare directories
diff -r dir1/ dir2/

# Only list different files
diff -rq dir1/ dir2/

# Exclude patterns
diff -r --exclude="*.log" dir1/ dir2/
```

### Advanced Usage
```bash
# Create patch
diff -u original.txt modified.txt > changes.patch

# Apply patch
patch original.txt < changes.patch

# Compare command outputs
diff <(sort file1.txt) <(sort file2.txt)

# Ignore whitespace
diff -w file1.txt file2.txt
```

### Salesforce Examples
```bash
# Compare metadata
diff -u old/Account.object-meta.xml new/Account.object-meta.xml

# Compare before/after deployment
diff -r backup/ force-app/

# Check config changes
diff config/prod.json config/dev.json
```

---

**Next**: [wget - Download Files](./wget.md)
