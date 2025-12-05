# wget - Network Downloader

Download files from the web via HTTP, HTTPS, and FTP.

---

## 📋 Quick Reference

```bash
wget https://example.com/file.zip       # Download file
wget -O custom.zip https://url          # Custom filename
wget -c https://example.com/file.zip    # Resume download
wget -b https://example.com/file.zip    # Background download
wget -r https://example.com/            # Recursive download
wget --limit-rate=200k https://url      # Limit speed
wget -i urls.txt                        # Download from list
wget -q https://url                     # Quiet mode
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-O FILE` | Output to FILE |
| `-c` | Continue/resume |
| `-b` | Background |
| `-q` | Quiet |
| `-r` | Recursive |
| `-np` | No parent directories |
| `--limit-rate` | Limit download speed |
| `-i FILE` | Input file list |
| `-t NUM` | Retry NUM times |

---

## Examples

### Basic Downloads
```bash
# Simple download
wget https://example.com/file.zip

# Custom name
wget -O myfile.zip https://example.com/download

# Resume interrupted
wget -c https://example.com/largefile.iso

# Quiet mode
wget -q https://example.com/file.txt
```

### Advanced Usage
```bash
# Background download
wget -b https://example.com/largefile.zip
tail -f wget-log  # Monitor progress

# From file list
cat > urls.txt << EOF
https://example.com/file1.zip
https://example.com/file2.zip
EOF
wget -i urls.txt

# Limit speed
wget --limit-rate=500k https://example.com/file.zip

# Retry on failure
wget -t 5 https://unreliable-server.com/file.zip
```

### Mirror Websites
```bash
# Download entire site
wget -r -np -k https://example.com/docs/

# -r: recursive
# -np: no parent
# -k: convert links
```

---

**Next**: [env - Environment Variables](./env.md)
