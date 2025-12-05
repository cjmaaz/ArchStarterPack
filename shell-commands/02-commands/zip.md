# zip/unzip - Compress and Extract ZIP Archives

Create and extract ZIP format compressed archives.

---

## 📋 Quick Reference

```bash
zip archive.zip files/*              # Create archive
zip -r archive.zip directory/        # Recursive
unzip archive.zip                    # Extract
unzip -l archive.zip                 # List contents
unzip archive.zip -d /dest/          # Extract to directory
zip -u archive.zip newfile.txt       # Update archive
zip -d archive.zip file.txt          # Delete from archive
zip -e secure.zip file.txt           # Encrypt with password
```

---

## Common Options

### zip Options
| Option | Purpose |
|--------|---------|
| `-r` | Recursive (directories) |
| `-u` | Update existing files |
| `-d` | Delete from archive |
| `-e` | Encrypt |
| `-q` | Quiet mode |
| `-v` | Verbose |
| `-[0-9]` | Compression level (0-9) |

### unzip Options
| Option | Purpose |
|--------|---------|
| `-l` | List contents |
| `-d DIR` | Extract to DIR |
| `-q` | Quiet |
| `-o` | Overwrite without prompting |
| `-n` | Never overwrite |

---

## Examples

### Creating Archives
```bash
# Single file
zip archive.zip file.txt

# Multiple files
zip archive.zip file1.txt file2.txt file3.txt

# Entire directory
zip -r project.zip project/

# With exclusions
zip -r archive.zip directory/ -x "*.log" "*.tmp"

# Maximum compression
zip -9 -r archive.zip files/

# Encrypted
zip -e -r secure.zip sensitive/
# Prompts for password
```

### Extracting Archives
```bash
# Extract here
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List contents without extracting
unzip -l archive.zip

# Extract single file
unzip archive.zip file.txt

# Quiet extraction
unzip -q archive.zip
```

### Updating Archives
```bash
# Add new file
zip -u archive.zip newfile.txt

# Delete file from archive
zip -d archive.zip oldfile.txt

# Update changed files
zip -u -r project.zip project/
```

### Practical Uses
```bash
# Backup with date
zip -r backup_$(date +%Y%m%d).zip /data/

# Salesforce metadata backup
zip -r metadata_backup.zip force-app/ manifest/

# Archive logs
find /var/log -name "*.log" -mtime +30 | xargs zip old_logs.zip

# Compare archives
diff <(unzip -l old.zip) <(unzip -l new.zip)
```

---

**Next**: [gzip - GNU Compression](./gzip.md)
