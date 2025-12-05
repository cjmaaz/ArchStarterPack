# cut - Extract Columns and Fields

Extract specific columns or fields from files or output.

---

## 📋 Quick Reference

```bash
cut -f 1 file.txt                  # Extract field 1 (tab-delimited)
cut -f 1,3 file.txt                # Extract fields 1 and 3
cut -f 1-3 file.txt                # Extract fields 1 through 3
cut -d ',' -f 2 file.csv           # Extract field 2 from CSV
cut -c 1-10 file.txt               # Extract characters 1-10
cut -c 5 file.txt                  # Extract 5th character
cut -d ':' -f 1 /etc/passwd        # Extract usernames
echo "a:b:c" | cut -d ':' -f 2     # Extract 'b'
cut -f 2- file.txt                 # Extract from field 2 to end
cut -f -3 file.txt                 # Extract fields 1 through 3
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-f LIST` | Select fields | `cut -f 1,3` |
| `-d CHAR` | Field delimiter | `cut -d ',' -f 2` |
| `-c LIST` | Select characters | `cut -c 1-10` |
| `-b LIST` | Select bytes | `cut -b 1-50` |
| `--complement` | Invert selection | `cut --complement -f 3` |
| `-s` | Suppress lines with no delimiter | `cut -s -d ',' -f 2` |
| `--output-delimiter` | Change output delimiter | `cut -f 1,2 --output-delimiter=','` |

### Field/Character Selection Syntax

| Syntax | Meaning | Example |
|--------|---------|---------|
| `N` | Field/char N | `cut -f 2` |
| `N-M` | Range N to M | `cut -f 2-5` |
| `N-` | From N to end | `cut -f 3-` |
| `-M` | From 1 to M | `cut -f -4` |
| `N,M` | Multiple selections | `cut -f 1,3,5` |

---

## Beginner Level

### Example 1: Extract First Field
```bash
# Extract first column (tab-delimited)
cut -f 1 data.txt

# Input:
# John    30    NYC
# Alice   25    LA

# Output:
# John
# Alice
```

### Example 2: Extract Specific Column from CSV
```bash
# Extract column 2 from CSV
cut -d ',' -f 2 data.csv

# Input:
# John,Engineer,50000
# Alice,Designer,45000

# Output:
# Engineer
# Designer
```

### Example 3: Extract Multiple Fields
```bash
# Extract fields 1 and 3
cut -f 1,3 data.txt

# Input:
# John    30    NYC
# Alice   25    LA

# Output:
# John    NYC
# Alice   LA
```

### Example 4: Extract Character Range
```bash
# Extract characters 1-5
cut -c 1-5 file.txt

# Input:
# HelloWorld
# GoodbyeCruelWorld

# Output:
# Hello
# Goodb
```

### Example 5: Extract Single Character
```bash
# Extract 3rd character
cut -c 3 file.txt

# Input:
# abcdef
# 123456

# Output:
# c
# 3
```

### Example 6: Extract from /etc/passwd
```bash
# Extract usernames
cut -d ':' -f 1 /etc/passwd

# Shows all system usernames
```

### Example 7: Extract IP from Output
```bash
# Get IP address only
ifconfig | grep "inet " | cut -d ' ' -f 2

# Extracts IP addresses
```

### Example 8: Extract Extension from Filenames
```bash
# Get file extensions
ls | cut -d '.' -f 2

# Shows extensions only
```

---

## Intermediate Level

### Example 9: Extract Field Range
```bash
# Extract fields 2 through 4
cut -f 2-4 data.txt

# Gets continuous range of columns
```

### Example 10: Extract from Field to End
```bash
# From field 3 to end
cut -f 3- data.txt

# Everything from column 3 onwards
```

### Example 11: Extract Up to Field
```bash
# Fields 1 through 3
cut -f -3 data.txt

# First three fields
```

### Example 12: Custom Delimiter
```bash
# Use pipe as delimiter
cut -d '|' -f 2 data.txt

# Input:
# John|Engineer|NYC
# Output:
# Engineer
```

### Example 13: Change Output Delimiter
```bash
# Convert tab to comma
cut -f 1,2 --output-delimiter=',' data.txt

# Input (tab-separated):
# John    30
# Output (comma-separated):
# John,30
```

### Example 14: Suppress Lines Without Delimiter
```bash
# Skip lines that don't contain delimiter
cut -s -d ',' -f 2 data.txt

# Ignores lines without commas
```

### Example 15: Extract from Multiple Files
```bash
# Process multiple files
cut -d ',' -f 1 file1.csv file2.csv

# Combines output from both
```

### Example 16: Extract Specific Characters
```bash
# Characters 1-3 and 7-10
cut -c 1-3,7-10 file.txt

# Non-continuous character ranges
```

---

## Advanced Level

### Example 17: Complement Selection (Exclude Fields)
```bash
# All fields except field 3
cut --complement -f 3 data.txt

# Removes column 3, keeps rest
```

### Example 18: Complex CSV Processing
```bash
# Extract name and salary from CSV
cut -d ',' -f 1,3 employees.csv | column -t -s ','

# Formatted table output
```

### Example 19: Extract Date Components
```bash
# Extract year from date (YYYY-MM-DD)
echo "2025-12-05" | cut -d '-' -f 1

# Output: 2025
```

### Example 20: Process Log Files
```bash
# Extract timestamp from logs
cut -c 1-19 application.log

# Gets first 19 characters (timestamp)
```

### Example 21: Multi-Step Extraction
```bash
# Extract domain from email
echo "user@example.com" | cut -d '@' -f 2

# Output: example.com
```

### Example 22: Extract URL Components
```bash
# Extract domain from URL
echo "https://www.example.com/path" | cut -d '/' -f 3

# Output: www.example.com
```

### Example 23: Process Columnar Data
```bash
# Extract fixed-width columns
cut -c 1-20,21-40,41-60 report.txt

# Handles fixed-width formats
```

### Example 24: Byte-Based Extraction
```bash
# Extract specific bytes
cut -b 1-100 binary.dat

# Useful for binary files
```

---

## Expert Level

### Example 25: Dynamic Field Selection
```bash
# Extract fields based on variable
FIELDS="1,3,5"
cut -d ',' -f $FIELDS data.csv

# Programmatic field selection
```

### Example 26: Process Multiple Delimiters
```bash
# Handle multiple delimiter types
tr ' \t' ',' < data.txt | cut -d ',' -f 2

# Normalize then extract
```

### Example 27: Extract and Transform
```bash
# Extract and convert to uppercase
cut -d ',' -f 1 data.csv | tr '[:lower:]' '[:upper:]'

# Pipeline transformation
```

### Example 28: Complex Log Parsing
```bash
# Extract specific log fields
cut -d '[' -f 2 log.txt | cut -d ']' -f 1

# Nested extraction
```

### Example 29: CSV with Quoted Fields (Limitations)
```bash
# Basic handling (cut has limitations with quotes)
sed 's/"//g' data.csv | cut -d ',' -f 2

# Remove quotes first
# Note: For complex CSV, use awk or csvkit
```

### Example 30: Extract Multiple Patterns
```bash
# Extract different fields from different lines
awk '/pattern1/ {print $1} /pattern2/ {print $3}' file.txt

# More flexible than cut for conditional extraction
```

### Example 31: Performance Optimization
```bash
# Cut is faster than awk for simple extraction
time cut -f 1 hugefile.txt > /dev/null
time awk '{print $1}' hugefile.txt > /dev/null

# cut typically faster for basic tasks
```

### Example 32: Stream Processing
```bash
# Real-time log monitoring
tail -f application.log | cut -c 20-50

# Extract specific columns from live stream
```

---

## Salesforce-Specific Examples

### Example 33: Extract Apex Class Names
```bash
# Get class names from find output
find force-app -name "*.cls" | cut -d '/' -f 5 | cut -d '.' -f 1

# Extracts just the class name
```

### Example 34: Parse SOQL Results
```bash
# Extract specific field from query output
sf data query --query "SELECT Name FROM Account" | \
grep -v "^---" | cut -c 1-50

# Gets first 50 chars (field width)
```

### Example 35: Extract Org Usernames
```bash
# Get usernames from org list
sf org list | grep -v "^===\|^ALIAS" | cut -d ' ' -f 1

# Extracts first column (alias)
```

### Example 36: Parse Debug Log Timestamps
```bash
# Extract time from log
sf apex get log | cut -c 1-12

# Gets timestamp portion
```

### Example 37: Extract Error Codes
```bash
# Get error codes from deployment
sf project deploy start --json | \
jq -r '.result.details.componentFailures[]' | \
cut -d ':' -f 1

# Extracts error code
```

### Example 38: Parse Package.xml
```bash
# Extract metadata types
grep "<name>" manifest/package.xml | cut -d '>' -f 2 | cut -d '<' -f 1

# Gets metadata type names
```

---

## Generic Real-World Examples

### Example 39: Extract IP Addresses from Logs
```bash
# Get IPs from access log
cut -d ' ' -f 1 /var/log/apache2/access.log | sort | uniq

# Unique IP addresses
```

### Example 40: Extract Usernames from System
```bash
# Get all usernames and shells
cut -d ':' -f 1,7 /etc/passwd

# Shows user and their shell
```

### Example 41: Parse CSV Sales Data
```bash
# Extract product names and prices
cut -d ',' -f 2,4 sales.csv | column -t -s ','

# Formatted product-price list
```

### Example 42: Extract Git Commit Hashes
```bash
# Get commit IDs
git log --oneline | cut -d ' ' -f 1

# First 7 characters of each commit
```

### Example 43: Parse Date-Time
```bash
# Extract date from timestamp
echo "2025-12-05 14:30:25" | cut -d ' ' -f 1

# Output: 2025-12-05
```

### Example 44: Extract Filename from Path
```bash
# Get filename only
echo "/path/to/file.txt" | rev | cut -d '/' -f 1 | rev

# Output: file.txt
# Or use: basename "/path/to/file.txt"
```

---

## Common Patterns & Recipes

### Pattern 1: Extract and Sort
```bash
# Get unique values from column 2
cut -d ',' -f 2 data.csv | sort -u

# Distinct values in column
```

### Pattern 2: Multi-Column Extraction with Labels
```bash
# Create labeled output
cut -d ',' -f 1,3 data.csv | \
awk -F',' '{print "Name:", $1, "Salary:", $2}'

# Formatted extraction
```

### Pattern 3: Conditional Field Extraction
```bash
# Extract field 2 only from lines with pattern
grep "ERROR" log.txt | cut -d ' ' -f 2

# Filtered extraction
```

### Pattern 4: Convert Between Formats
```bash
# Tab to CSV
cut -f 1,2,3 data.tsv --output-delimiter=',' > data.csv

# Format conversion
```

### Pattern 5: Column Statistics
```bash
# Sum column 3
cut -d ',' -f 3 data.csv | paste -sd+ | bc

# Calculate total
```

---

## Practice Problems

### Beginner (1-8)

1. Extract first field from tab-delimited file
2. Extract second column from CSV
3. Extract fields 1 and 3
4. Extract characters 1-10
5. Extract single character (position 5)
6. Extract usernames from /etc/passwd
7. Extract file extensions from ls output
8. Extract first field with colon delimiter

### Intermediate (9-16)

9. Extract field range (2-5)
10. Extract from field 3 to end
11. Extract first 3 fields
12. Use custom delimiter (pipe |)
13. Change output delimiter from tab to comma
14. Suppress lines without delimiter
15. Extract non-continuous characters (1-3,7-10)
16. Process multiple files

### Advanced (17-24)

17. Use complement to exclude specific field
18. Extract and format with column
19. Extract components from date string
20. Parse log timestamps
21. Extract domain from email address
22. Extract URL components
23. Extract fixed-width column ranges
24. Byte-based extraction from binary file

### Expert (25-32)

25. Dynamic field selection with variable
26. Handle multiple delimiter types with tr
27. Extract and transform (uppercase)
28. Nested extraction for complex formats
29. Handle CSV with quoted fields
30. Stream processing from tail -f
31. Performance comparison with awk
32. Complex multi-step log parsing

---

**Solutions**: [cut Practice Solutions](../04-practice/cut-solutions.md)

**Next**: [wc - Word Count](./wc.md)
