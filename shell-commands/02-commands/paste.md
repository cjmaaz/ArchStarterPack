# paste - Merge Lines of Files

Merge lines from multiple files side-by-side.

---

## 📋 Quick Reference

```bash
paste file1.txt file2.txt               # Tab-separated merge
paste -d ',' file1.txt file2.txt        # CSV merge
paste -s file.txt                       # Serial (single line)
paste -d '\n' file1.txt file2.txt       # Alternate lines
paste - - < file.txt                    # Pair lines
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-d DELIM` | Use DELIM instead of tab |
| `-s` | Serial (one file at a time) |

---

## Examples

### Basic Merging
```bash
# Side-by-side with tab
paste names.txt ages.txt
# Output: John    30
#         Jane    25

# Custom delimiter
paste -d ',' names.txt ages.txt
# Output: John,30
#         Jane,25

# Three files
paste names.txt ages.txt cities.txt
```

### Serial Mode
```bash
# All lines on one line
paste -s file.txt
# Output: line1  line2  line3  line4

# Custom delimiter
paste -s -d ',' file.txt
# Output: line1,line2,line3,line4
```

### Advanced Patterns
```bash
# Pair adjacent lines
paste - - < file.txt
# Line1  Line2
# Line3  Line4

# Triplets
paste - - - < file.txt

# Calculate sum
paste -d '+' numbers.txt | bc

# Create CSV from columns
paste -d ',' col1.txt col2.txt col3.txt > data.csv
```

### Practical Uses
```bash
# Create numbered list
paste <(seq 1 10) file.txt

# Combine with cut
cut -d ',' -f 1 file1.csv > col1.txt
cut -d ',' -f 2 file2.csv > col2.txt
paste -d ',' col1.txt col2.txt > combined.csv

# Statistics
paste <(cat file.txt | wc -l) <(cat file.txt | wc -w)
# Output: 100  450 (100 lines, 450 words)
```

---

**Next**: [column - Format as Columns](./column.md)
