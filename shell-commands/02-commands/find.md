# find - Search for Files and Directories

Recursively search directory trees for files and directories matching criteria.

---

## 📋 Quick Reference

```bash
find .                             # List all files/dirs recursively
find . -name "*.txt"              # Find by name pattern
find . -type f                     # Find files only
find . -type d                     # Find directories only
find . -mtime -7                   # Modified in last 7 days
find . -size +100M                 # Larger than 100MB
find . -name "*.log" -delete       # Find and delete
find . -name "*.txt" -exec cat {} \;  # Execute command on results
find . -maxdepth 2 -name "*.js"    # Limit search depth
find . -user john                  # Find by owner
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-name` | Match filename | `find . -name "*.txt"` |
| `-iname` | Case-insensitive name | `find . -iname "*.TXT"` |
| `-type f` | Files only | `find . -type f` |
| `-type d` | Directories only | `find . -type d` |
| `-size +/-N` | By size | `find . -size +1M` |
| `-mtime +/-N` | Modified time (days) | `find . -mtime -7` |
| `-mmin +/-N` | Modified time (minutes) | `find . -mmin -60` |
| `-user NAME` | By owner | `find . -user john` |
| `-perm MODE` | By permissions | `find . -perm 644` |
| `-maxdepth N` | Max directory levels | `find . -maxdepth 2` |
| `-mindepth N` | Min directory levels | `find . -mindepth 1` |
| `-empty` | Empty files/dirs | `find . -empty` |
| `-delete` | Delete matches | `find . -name "*.tmp" -delete` |
| `-exec CMD {} \;` | Execute command | `find . -exec chmod 644 {} \;` |
| `-print0` | Null-terminated output | `find . -print0` |

---

## Beginner Level

### Example 1: List All Files Recursively
```bash
# Show everything
find .

# Lists all files and directories from current location
```

### Example 2: Find by Filename
```bash
# Find specific file
find . -name "config.txt"

# Searches recursively for exact name
```

### Example 3: Find by Pattern
```bash
# Find all .txt files
find . -name "*.txt"

# Wildcard pattern matching
```

### Example 4: Case-Insensitive Search
```bash
# Ignore case
find . -iname "readme.md"

# Matches README.md, readme.MD, etc.
```

### Example 5: Find Only Files
```bash
# Exclude directories
find . -type f

# Shows files only
```

### Example 6: Find Only Directories
```bash
# Directories only
find . -type d

# Lists folder structure
```

### Example 7: Limit Search Depth
```bash
# Search only 2 levels deep
find . -maxdepth 2 -name "*.js"

# Doesn't search subdirectories beyond level 2
```

### Example 8: Skip Current Directory in Output
```bash
# Start from depth 1
find . -mindepth 1 -name "*.txt"

# Excludes "." from results
```

---

## Intermediate Level

### Example 9: Find by Size
```bash
# Files larger than 100MB
find . -type f -size +100M

# Size units: c (bytes), k (KB), M (MB), G (GB)
```

### Example 10: Find by Modified Time
```bash
# Modified in last 7 days
find . -type f -mtime -7

# -7 = within 7 days, +7 = older than 7 days
```

### Example 11: Find Recently Modified (Minutes)
```bash
# Modified in last hour
find . -type f -mmin -60

# -mmin uses minutes instead of days
```

### Example 12: Find Empty Files
```bash
# Empty files and directories
find . -empty

# Useful for cleanup
```

### Example 13: Find by Permissions
```bash
# Files with specific permissions
find . -type f -perm 644

# Exact permission match
```

### Example 14: Find Executable Files
```bash
# Executable by user
find . -type f -perm -u+x

# -perm -mode matches if all bits set
```

### Example 15: Find by Owner
```bash
# Files owned by specific user
find . -user john

# Searches by username
```

### Example 16: Multiple Conditions (AND)
```bash
# .txt files larger than 1MB
find . -name "*.txt" -size +1M

# Both conditions must be true
```

---

## Advanced Level

### Example 17: Multiple Patterns (OR)
```bash
# Find .js OR .ts files
find . -name "*.js" -o -name "*.ts"

# -o means OR
# Use parentheses for complex logic: \( -name "*.js" -o -name "*.ts" \)
```

### Example 18: Exclude Directories
```bash
# Skip node_modules
find . -name "node_modules" -prune -o -name "*.js" -print

# -prune stops descent into directory
```

### Example 19: Find and Execute Command
```bash
# Find and delete .tmp files
find . -name "*.tmp" -exec rm {} \;

# {} is replaced with filename
# \; ends the -exec command
```

### Example 20: Find and Execute with Confirmation
```bash
# Prompt before deleting
find . -name "*.log" -exec rm -i {} \;

# -i prompts for each file
```

### Example 21: Execute with Plus (Batch Mode)
```bash
# More efficient: batch arguments
find . -name "*.txt" -exec cat {} +

# + passes multiple files at once
# {} + instead of {} \;
```

### Example 22: Complex Time Conditions
```bash
# Modified between 7 and 30 days ago
find . -type f -mtime +7 -mtime -30

# Combines time constraints
```

### Example 23: Find and Copy
```bash
# Copy matching files to directory
find . -name "*.conf" -exec cp {} /backup/ \;

# Backs up config files
```

### Example 24: Find with Negation
```bash
# Files NOT matching pattern
find . -type f ! -name "*.txt"

# ! negates the condition
```

---

## Expert Level

### Example 25: Complex Boolean Logic
```bash
# (.js or .ts) AND (modified in last week)
find . \( -name "*.js" -o -name "*.ts" \) -mtime -7

# Parentheses group conditions
```

### Example 26: Find and Archive
```bash
# Create tar of all .conf files
find . -name "*.conf" -print0 | tar -czf configs.tar.gz --null -T -

# -print0 and --null handle spaces in filenames
```

### Example 27: Find with xargs (Safe)
```bash
# Process with xargs (handles spaces)
find . -name "*.txt" -print0 | xargs -0 grep "pattern"

# -print0 with xargs -0 is space-safe
```

### Example 28: Find Duplicate Names
```bash
# Find files with same name
find . -type f -printf '%f\n' | sort | uniq -d

# %f prints just filename without path
```

### Example 29: Find by inode
```bash
# Find file by inode number
find . -inum 12345678

# Useful for finding hard links
```

### Example 30: Size Range Query
```bash
# Files between 1MB and 10MB
find . -type f -size +1M -size -10M

# Both constraints must be met
```

### Example 31: Advanced Time Queries
```bash
# Files accessed but not modified recently
find . -type f -atime -7 -mtime +30

# -atime = access time, -mtime = modification time
```

### Example 32: Execute Complex Shell Commands
```bash
# Rename files with complex logic
find . -name "*.txt" -exec sh -c 'mv "$1" "${1%.txt}.bak"' _ {} \;

# Uses shell for complex operations
# _ is placeholder for $0, {} for $1
```

---

## Salesforce-Specific Examples

### Example 33: Find Apex Classes
```bash
# Find all Apex class files
find force-app -name "*.cls" -type f

# Locates Apex classes in project
```

### Example 34: Find Modified Components
```bash
# Find components modified today
find force-app -name "*.cls" -o -name "*.trigger" -mtime 0

# Shows today's changes
```

### Example 35: Find Large Metadata Files
```bash
# Find metadata files > 5MB
find force-app -type f -size +5M

# Identifies large components
```

### Example 36: Find Test Classes
```bash
# Find test classes by naming convention
find force-app -name "*Test.cls" -o -name "*_Test.cls"

# Locates test files
```

### Example 37: Count Components by Type
```bash
# Count each metadata type
for type in cls trigger lwc; do
    echo "$type: $(find force-app -name "*.$type" | wc -l)"
done

# Component inventory
```

### Example 38: Find Unused LWC Components
```bash
# Find LWC without corresponding JS file
find force-app -name "*.html" -type f -exec sh -c 'test ! -f "${1%.html}.js" && echo "$1"' _ {} \;

# Identifies incomplete components
```

---

## Generic Real-World Examples

### Example 39: Clean Up Old Logs
```bash
# Delete logs older than 30 days
find /var/log -name "*.log" -mtime +30 -delete

# Automated log rotation
```

### Example 40: Find Large Files
```bash
# Top 10 largest files
find . -type f -exec du -h {} + | sort -rh | head -10

# Disk space analysis
```

### Example 41: Find Broken Symlinks
```bash
# Find symlinks pointing to non-existent files
find . -type l ! -exec test -e {} \; -print

# Cleanup broken links
```

### Example 42: Find World-Writable Files
```bash
# Security audit - world-writable files
find . -type f -perm -002

# Potential security issue
```

### Example 43: Find Recently Accessed Files
```bash
# Files accessed in last hour
find . -type f -amin -60

# Track file access
```

### Example 44: Find and Count by Extension
```bash
# Count files by type
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -nr

# File type distribution
```

---

## Common Patterns & Recipes

### Pattern 1: Safe Delete with Backup
```bash
# Backup before deleting
find . -name "*.tmp" -exec sh -c 'cp "$1" /backup/ && rm "$1"' _ {} \;
```

### Pattern 2: Batch File Processing
```bash
# Process matching files in batches
find . -name "*.jpg" -print0 | xargs -0 -P 4 -n 10 process_images.sh
```

### Pattern 3: Directory Size Report
```bash
# Size of each directory
find . -maxdepth 1 -type d -exec du -sh {} \; | sort -rh
```

### Pattern 4: Find and Replace in Files
```bash
# Search and replace across files
find . -name "*.txt" -exec sed -i 's/old/new/g' {} \;
```

### Pattern 5: Comprehensive Cleanup
```bash
# Clean temp files, empty dirs, old logs
find . \( -name "*.tmp" -o -name "*.bak" -o -name "*~" \) -delete
find . -type d -empty -delete
find . -name "*.log" -mtime +30 -delete
```

---

## Practice Problems

### Beginner (1-8)

1. Find all .txt files in current directory tree
2. Find directories only
3. Find files modified in last 24 hours
4. Find files larger than 10MB
5. Find empty files
6. Search for files case-insensitively
7. Limit search to 3 directory levels
8. Find specific file by exact name

### Intermediate (9-16)

9. Find .js OR .ts files
10. Find and delete .tmp files
11. Find files modified between 7-14 days ago
12. Find files with specific permissions (755)
13. Find files by owner
14. Find and copy to backup directory
15. Exclude node_modules from search
16. Find files NOT matching pattern

### Advanced (17-24)

17. Find and execute command with confirmation
18. Find files using complex boolean logic
19. Find and create archive
20. Find files in size range (1MB-10MB)
21. Use find with xargs safely
22. Find and rename files
23. Find broken symlinks
24. Find world-writable files for security audit

### Expert (25-32)

25. Complex multi-condition search with grouping
26. Find duplicate filenames across directories
27. Find by inode number
28. Execute complex shell commands on matches
29. Advanced time queries (access vs modification)
30. Batch processing with parallel execution
31. Find and replace across multiple file types
32. Comprehensive cleanup with multiple patterns

---

**Solutions**: [find Practice Solutions](../04-practice/find-solutions.md)

**Next**: [sort - Sort Lines](./sort.md)
