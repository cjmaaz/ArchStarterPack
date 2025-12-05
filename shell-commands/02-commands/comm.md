# comm - Compare Sorted Files Line by Line

Compare two sorted files and show lines unique to each or common to both.

---

## 📋 Quick Reference

```bash
comm file1.txt file2.txt            # Three-column output
comm -12 file1.txt file2.txt        # Only common lines
comm -13 file1.txt file2.txt        # Only in file2
comm -23 file1.txt file2.txt        # Only in file1
comm -3 file1.txt file2.txt         # Lines NOT in both
```

---

## Output Columns

1. **Column 1**: Lines only in file1
2. **Column 2**: Lines only in file2
3. **Column 3**: Lines in both files

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-1` | Suppress column 1 (unique to file1) |
| `-2` | Suppress column 2 (unique to file2) |
| `-3` | Suppress column 3 (common lines) |
| `-12` | Show only common lines |
| `-13` | Show only lines in file2 |
| `-23` | Show only lines in file1 |

---

## Examples

### Basic Comparison
```bash
# Files must be sorted!
sort file1.txt > sorted1.txt
sort file2.txt > sorted2.txt
comm sorted1.txt sorted2.txt
```

### Common Operations
```bash
# Common lines only
comm -12 <(sort file1.txt) <(sort file2.txt)

# Lines only in file1
comm -23 <(sort file1.txt) <(sort file2.txt)

# Lines only in file2
comm -13 <(sort file1.txt) <(sort file2.txt)

# Lines in either file (union)
comm -3 <(sort file1.txt) <(sort file2.txt)
```

### Practical Uses
```bash
# Find common users between servers
comm -12 <(ssh server1 "cut -d: -f1 /etc/passwd | sort") \
         <(ssh server2 "cut -d: -f1 /etc/passwd | sort")

# Find differences in package lists
comm -3 <(dpkg -l | awk '{print $2}' | sort) \
        <(cat package_list.txt | sort)

# Compare two deployments
comm -12 <(find deploy1/ -type f | sort) \
         <(find deploy2/ -type f | sort)
```

---

**Next**: [paste - Merge Lines](./paste.md)
