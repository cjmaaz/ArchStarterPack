# gzip/gunzip - GNU Compression

Compress and decompress files using gzip compression.

---

## 📋 Quick Reference

```bash
gzip file.txt                    # Compress (creates file.txt.gz)
gzip -k file.txt                 # Keep original
gunzip file.txt.gz               # Decompress
gzip -d file.txt.gz              # Decompress (same as gunzip)
gzip -r directory/               # Recursive
gzip -l file.txt.gz              # List info
gzip -9 file.txt                 # Maximum compression
gzip -1 file.txt                 # Fast compression
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-k` | Keep original file |
| `-d` | Decompress |
| `-r` | Recursive |
| `-l` | List compressed file info |
| `-[1-9]` | Compression level (1=fast, 9=best) |
| `-c` | Write to stdout |
| `-v` | Verbose |

---

## Examples

### Basic Compression
```bash
# Compress file (replaces original)
gzip largefile.txt
# Creates: largefile.txt.gz

# Keep original
gzip -k data.txt
# Creates: data.txt.gz (keeps data.txt)

# Compress multiple files
gzip file1.txt file2.txt file3.txt

# Compress all in directory
gzip *.txt
```

### Decompression
```bash
# Decompress
gunzip file.txt.gz
# Creates: file.txt

# Keep compressed version
gunzip -k file.txt.gz

# Multiple files
gunzip *.gz
```

### Compression Levels
```bash
# Fast (less compression)
gzip -1 file.txt

# Maximum (more time)
gzip -9 file.txt

# Default is -6
gzip file.txt
```

### With Pipes
```bash
# Compress stdout
cat file.txt | gzip > file.txt.gz

# Decompress and view
gunzip -c file.txt.gz | less

# Compress and transfer
tar -c directory/ | gzip | ssh user@server "cat > backup.tar.gz"
```

### Info and Stats
```bash
# View compression info
gzip -l file.txt.gz
# Shows: compressed, uncompressed, ratio, name

# Verbose compression
gzip -v file.txt
# Shows: file.txt: 75.5% -- replaced with file.txt.gz
```

### Recursive Compression
```bash
# Compress all files in directory tree
gzip -r logs/

# Decompress recursively
gunzip -r logs/
```

### Practical Uses
```bash
# Archive and compress
tar -czf archive.tar.gz directory/
# Equivalent to: tar -cf - directory/ | gzip > archive.tar.gz

# Rotate logs
gzip /var/log/application.log.1

# Stream compression
find . -name "*.log" -mtime +7 -exec gzip {} \;

# Compare compressed files
diff <(gunzip -c file1.gz) <(gunzip -c file2.gz)
```

---

**Next**: [netstat - Network Statistics](./netstat.md)
