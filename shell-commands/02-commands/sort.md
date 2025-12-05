# sort - Sort Lines of Text

Sort lines of text files in various ways.

---

## 📋 Quick Reference

```bash
sort file.txt                      # Alphabetical sort
sort -r file.txt                   # Reverse sort
sort -n file.txt                   # Numeric sort
sort -u file.txt                   # Sort and remove duplicates
sort -k 2 file.txt                 # Sort by column 2
sort -t ',' -k 2 file.csv          # Sort CSV by column 2
sort -h file.txt                   # Human-readable numbers (1K, 2M)
sort -M file.txt                   # Sort by month names
sort -R file.txt                   # Random shuffle
sort file1.txt file2.txt           # Merge and sort multiple files
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-r` | Reverse order | `sort -r file.txt` |
| `-n` | Numeric sort | `sort -n numbers.txt` |
| `-u` | Unique (remove duplicates) | `sort -u file.txt` |
| `-k N` | Sort by column N | `sort -k 2 file.txt` |
| `-t CHAR` | Field separator | `sort -t ',' -k 2` |
| `-h` | Human-readable numbers | `sort -h sizes.txt` |
| `-M` | Month names | `sort -M months.txt` |
| `-R` | Random shuffle | `sort -R file.txt` |
| `-f` | Case-insensitive | `sort -f file.txt` |
| `-b` | Ignore leading blanks | `sort -b file.txt` |
| `-o FILE` | Output to file | `sort -o sorted.txt file.txt` |
| `-c` | Check if sorted | `sort -c file.txt` |
| `-m` | Merge sorted files | `sort -m file1.txt file2.txt` |

---

## Beginner Level

### Example 1: Basic Alphabetical Sort
```bash
# Sort lines alphabetically
sort names.txt

# Input:
# Charlie
# Alice
# Bob

# Output:
# Alice
# Bob
# Charlie
```

### Example 2: Reverse Sort
```bash
# Sort in reverse order
sort -r names.txt

# Output:
# Charlie
# Bob
# Alice
```

### Example 3: Numeric Sort
```bash
# Sort numbers correctly
sort -n numbers.txt

# Input:       Regular sort:  Numeric sort (-n):
# 100          10            1
# 20           100           20
# 3            20            100
# 1            3             

# -n treats as numbers, not strings
```

### Example 4: Remove Duplicates While Sorting
```bash
# Sort and keep unique lines
sort -u file.txt

# Combines sort and uniq
```

### Example 5: Case-Insensitive Sort
```bash
# Ignore case when sorting
sort -f words.txt

# 'Apple' and 'apple' treated same
```

### Example 6: Save Sorted Output
```bash
# Output to file
sort file.txt -o sorted.txt

# Can safely use: sort file.txt -o file.txt
```

### Example 7: Sort Multiple Files
```bash
# Merge and sort
sort file1.txt file2.txt

# Combines both files, then sorts
```

### Example 8: Check If File Is Sorted
```bash
# Verify sort order
sort -c file.txt

# Exits with error if not sorted
# Silent if already sorted
```

---

## Intermediate Level

### Example 9: Sort by Specific Column
```bash
# Sort by 3rd column
sort -k 3 data.txt

# Space-separated by default
```

### Example 10: Sort CSV by Column
```bash
# Sort CSV file by column 2
sort -t ',' -k 2 data.csv

# -t sets delimiter
```

### Example 11: Sort by Multiple Columns
```bash
# Sort by column 2, then column 3
sort -k 2,2 -k 3,3 data.txt

# Primary and secondary sort keys
```

### Example 12: Human-Readable Size Sort
```bash
# Sort file sizes (1K, 2M, 3G)
du -h * | sort -h

# Understands K, M, G suffixes
```

### Example 13: Sort by Month
```bash
# Sort dates by month name
sort -M months.txt

# Input:        Output:
# Dec           Jan
# Jan           Feb
# Mar           Mar
# Feb           Dec

# Recognizes month names
```

### Example 14: Reverse Numeric Sort
```bash
# Largest to smallest
sort -nr numbers.txt

# Combines -n and -r
```

### Example 15: Sort and Count Unique
```bash
# Frequency count
sort file.txt | uniq -c | sort -nr

# Most common lines first
```

### Example 16: Stable Sort
```bash
# Maintain original order for equal elements
sort -s -k 2 file.txt

# -s = stable sort
```

---

## Advanced Level

### Example 17: Sort by Column Range
```bash
# Sort by columns 2 through 4
sort -k 2,4 data.txt

# Considers multiple columns as one key
```

### Example 18: Numeric Sort on Specific Column
```bash
# Sort by column 3 numerically
sort -k 3,3n data.txt

# -k 3,3n applies numeric sort to column 3
```

### Example 19: Mixed Column Types
```bash
# Column 1 alphabetically, column 2 numerically
sort -k 1,1 -k 2,2n data.txt

# Different sort types per column
```

### Example 20: Reverse Sort Specific Column
```bash
# Sort column 1 ascending, column 2 descending
sort -k 1,1 -k 2,2nr data.txt

# -r applies only to that key
```

### Example 21: Ignore Leading Whitespace
```bash
# Skip leading spaces when sorting
sort -b data.txt

# Useful for formatted text
```

### Example 22: Sort by Specific Field Position
```bash
# Sort by characters 5-10 of each line
sort -k 1.5,1.10 file.txt

# 1.5 = column 1, character 5
```

### Example 23: Version Number Sort
```bash
# Sort version strings correctly
sort -V versions.txt

# Input:        Output:
# v1.10         v1.2
# v1.2          v1.10
# v2.1          v2.1

# Understands version semantics
```

### Example 24: Parallel Sort (Faster)
```bash
# Use multiple CPU cores
sort --parallel=4 largefile.txt

# Speeds up large file sorting
```

---

## Expert Level

### Example 25: Complex Multi-Key Sort
```bash
# Sort by: status (ascending), date (descending), amount (numeric descending)
sort -k 1,1 -k 2,2r -k 3,3nr data.txt

# Complex business logic sorting
```

### Example 26: Custom Sort Order
```bash
# Define custom collation
LC_COLLATE=C sort file.txt

# ASCII order instead of locale order
```

### Example 27: Sort Large Files with Memory Limit
```bash
# Limit memory usage
sort -S 1G largefile.txt

# -S specifies buffer size
```

### Example 28: Temporary Directory for Sort
```bash
# Use specific directory for temp files
sort -T /fast/tmp largefile.txt

# Useful for large sorts
```

### Example 29: Merge Pre-Sorted Files
```bash
# Efficiently combine sorted files
sort -m sorted1.txt sorted2.txt sorted3.txt

# Faster than regular sort
```

### Example 30: Sort and Split Output
```bash
# Sort and split into multiple files
sort -S 10% bigfile.txt | split -l 10000 - sorted_

# Creates sorted_aa, sorted_ab, etc.
```

### Example 31: Field-Specific Case Sensitivity
```bash
# Case-insensitive column 1, case-sensitive column 2
sort -k 1,1f -k 2,2 data.txt

# -f applies only to specified key
```

### Example 32: Sort with Custom Compression
```bash
# Use specific compression for temp files
sort --compress-program=gzip largefile.txt

# Saves disk space during sort
```

---

## Salesforce-Specific Examples

### Example 33: Sort Apex Classes by Name
```bash
# List Apex classes alphabetically
find force-app -name "*.cls" | sort

# Organized file list
```

### Example 34: Sort SOQL Results
```bash
# Sort query output by Amount
sf data query --query "SELECT Name, Amount FROM Opportunity" --json | \
jq -r '.result.records[] | "\(.Amount)\t\(.Name)"' | \
sort -k 1,1nr

# Highest amounts first
```

### Example 35: Sort Test Results by Coverage
```bash
# Sort classes by code coverage
sf apex get test --code-coverage --json | \
jq -r '.result.coverage.coverage[] | "\(.coveredPercent)\t\(.name)"' | \
sort -k 1,1n

# Lowest coverage first (needs attention)
```

### Example 36: Sort Deployment Components
```bash
# Sort metadata by type then name
cat package.xml | grep "<members>" | sort -u

# Organized package manifest
```

### Example 37: Sort Debug Log Entries
```bash
# Sort log lines by timestamp
sf apex get log | grep "EXECUTE_BEGIN" | sort

# Chronological execution order
```

### Example 38: Sort Errors by Frequency
```bash
# Most common errors first
sf apex get log | grep "ERROR" | sort | uniq -c | sort -nr

# Error frequency report
```

---

## Generic Real-World Examples

### Example 39: Sort Access Log by IP
```bash
# Count requests per IP
awk '{print $1}' access.log | sort | uniq -c | sort -nr

# Top IPs by request count
```

### Example 40: Sort Files by Size
```bash
# Largest files first
ls -lh | sort -k 5 -h -r

# Human-readable size sort
```

### Example 41: Sort CSV by Date
```bash
# Sort by date column (YYYY-MM-DD format)
sort -t ',' -k 3 data.csv

# Dates sort correctly in ISO format
```

### Example 42: Random Sample Selection
```bash
# Randomly pick 10 lines
sort -R file.txt | head -10

# Randomized selection
```

### Example 43: Sort Process List by CPU
```bash
# Sort by CPU usage
ps aux | sort -k 3 -nr | head -10

# Top CPU consumers
```

### Example 44: Sort and Merge Logs
```bash
# Combine and sort log files by timestamp
sort -m -t ' ' -k 1,1 -k 2,2 app.log.* > combined.log

# Chronological merge
```

---

## Common Patterns & Recipes

### Pattern 1: Top N Analysis
```bash
# Find top 10 most common lines
sort file.txt | uniq -c | sort -nr | head -10
```

### Pattern 2: Deduplicate and Sort
```bash
# Remove duplicates and sort
sort -u file.txt -o file.txt

# In-place deduplication
```

### Pattern 3: Sort Multiple File Types
```bash
# Sort different data together
{
    awk -F',' '{print $1}' file.csv
    cut -d$'\t' -f1 file.tsv
} | sort -u
```

### Pattern 4: Complex Log Sorting
```bash
# Sort logs by date and severity
sort -t ' ' -k 1,1 -k 2,2 -k 4,4r application.log

# Date, time, then severity (reverse)
```

### Pattern 5: Performance Monitoring
```bash
# Sort system metrics
ps aux | awk '{print $3"\t"$4"\t"$11}' | sort -k 1,1nr -k 2,2nr

# CPU and memory usage sorted
```

---

## Practice Problems

### Beginner (1-8)

1. Sort a file alphabetically
2. Sort a file in reverse order
3. Sort numbers numerically
4. Remove duplicates while sorting
5. Perform case-insensitive sort
6. Sort and save output to file
7. Check if a file is already sorted
8. Sort multiple files together

### Intermediate (9-16)

9. Sort by 3rd column
10. Sort CSV file by specific column
11. Sort by multiple columns (primary and secondary)
12. Sort file sizes in human-readable format
13. Sort by month names
14. Combine sort and count unique occurrences
15. Reverse numeric sort
16. Sort with stable mode

### Advanced (17-24)

17. Sort by column range
18. Numeric sort on specific column only
19. Mixed sort types (alpha and numeric)
20. Different sort orders per column
21. Sort version numbers correctly
22. Ignore leading whitespace
23. Parallel sort for large files
24. Sort by specific character positions

### Expert (25-32)

25. Complex multi-key sort with mixed orders
26. Custom collation sort
27. Memory-limited sort for huge files
28. Merge multiple pre-sorted files
29. Sort with custom temporary directory
30. Field-specific case sensitivity
31. Sort with custom compression
32. Sort and split into multiple output files

---

**Solutions**: [sort Practice Solutions](../04-practice/sort-solutions.md)

**Next**: [uniq - Filter Duplicate Lines](./uniq.md)
