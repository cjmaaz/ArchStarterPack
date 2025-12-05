# tr - Translate or Delete Characters

Transform, delete, or squeeze characters from input.

---

## 📋 Quick Reference

```bash
tr 'a-z' 'A-Z'                     # Lowercase to uppercase
tr 'A-Z' 'a-z'                     # Uppercase to lowercase
tr -d ' '                          # Delete spaces
tr -d '\n'                         # Delete newlines
tr -s ' '                          # Squeeze multiple spaces to one
tr ' ' '\n'                        # Replace spaces with newlines
tr '\t' ' '                        # Convert tabs to spaces
tr -dc '0-9'                       # Keep only digits
echo "text" | tr 'a-z' 'A-Z'       # Pipe usage
tr -cs 'A-Za-z' '\n'               # Split into words
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-d` | Delete characters | `tr -d 'abc'` |
| `-s` | Squeeze repeats | `tr -s ' '` |
| `-c` | Complement (invert) | `tr -dc '0-9'` |
| `-t` | Truncate set1 | `tr -t 'abc' 'xyz'` |

### Character Classes

| Class | Matches | Example |
|-------|---------|---------|
| `[:alnum:]` | Alphanumeric | `tr -dc '[:alnum:]'` |
| `[:alpha:]` | Letters | `tr -dc '[:alpha:]'` |
| `[:digit:]` | Digits | `tr -dc '[:digit:]'` |
| `[:space:]` | Whitespace | `tr -s '[:space:]'` |
| `[:lower:]` | Lowercase | `tr '[:lower:]' '[:upper:]'` |
| `[:upper:]` | Uppercase | `tr '[:upper:]' '[:lower:]'` |
| `[:punct:]` | Punctuation | `tr -d '[:punct:]'` |

---

## Beginner Level

### Example 1: Convert to Uppercase
```bash
# Lowercase to uppercase
echo "hello world" | tr 'a-z' 'A-Z'

# Output: HELLO WORLD
```

### Example 2: Convert to Lowercase
```bash
# Uppercase to lowercase
echo "HELLO WORLD" | tr 'A-Z' 'a-z'

# Output: hello world
```

### Example 3: Delete Specific Characters
```bash
# Remove all 'a' characters
echo "banana" | tr -d 'a'

# Output: bnn
```

### Example 4: Delete Spaces
```bash
# Remove all spaces
echo "hello world" | tr -d ' '

# Output: helloworld
```

### Example 5: Replace Character
```bash
# Replace spaces with underscores
echo "hello world" | tr ' ' '_'

# Output: hello_world
```

### Example 6: Replace Spaces with Newlines
```bash
# Convert to one word per line
echo "one two three" | tr ' ' '\n'

# Output:
# one
# two
# three
```

### Example 7: Delete Newlines
```bash
# Join lines
tr -d '\n' < file.txt

# Outputs everything on one line
```

### Example 8: Convert Tabs to Spaces
```bash
# Replace tabs with spaces
tr '\t' ' ' < file.txt

# Normalizes whitespace
```

---

## Intermediate Level

### Example 9: Squeeze Repeated Characters
```bash
# Multiple spaces to single space
echo "hello    world" | tr -s ' '

# Output: hello world
```

### Example 10: Squeeze and Replace
```bash
# Squeeze tabs and convert to space
echo "hello\t\tworld" | tr -s '\t' ' '

# Output: hello world
```

### Example 11: Delete Digits
```bash
# Remove all numbers
echo "abc123def456" | tr -d '0-9'

# Output: abcdef
```

### Example 12: Keep Only Digits
```bash
# Delete everything except digits
echo "Price: $1,234.56" | tr -dc '0-9'

# Output: 123456
```

### Example 13: Delete Multiple Character Types
```bash
# Remove digits and punctuation
echo "Hello, 123 World!" | tr -d '[:digit:][:punct:]'

# Output: Hello  World
```

### Example 14: ROT13 Encoding
```bash
# Simple cipher
echo "Hello" | tr 'A-Za-z' 'N-ZA-Mn-za-m'

# Output: Uryyb
# Run again to decode
```

### Example 15: Clean Windows Line Endings
```bash
# Remove carriage returns (CRLF to LF)
tr -d '\r' < windows_file.txt > unix_file.txt

# Converts Windows to Unix format
```

### Example 16: Extract Words
```bash
# Split on non-alphanumeric
tr -cs '[:alnum:]' '\n' < file.txt

# Each word on separate line
```

---

## Advanced Level

### Example 17: Complement with Delete
```bash
# Keep only letters and spaces
echo "Hello, World! 123" | tr -cd 'A-Za-z '

# Output: Hello World
```

### Example 18: Character Mapping
```bash
# Create character translation
echo "12345" | tr '12345' 'abcde'

# Output: abcde
```

### Example 19: Format Phone Number
```bash
# Remove formatting from phone
echo "(555) 123-4567" | tr -d '() -'

# Output: 5551234567
```

### Example 20: Sanitize Filename
```bash
# Replace problematic characters
echo "my file:name*.txt" | tr ' :*' '___'

# Output: my_file_name_.txt
```

### Example 21: Create URL Slug
```bash
# Convert to URL-friendly format
echo "Hello World! How Are You?" | \
tr '[:upper:]' '[:lower:]' | \
tr -cs '[:alnum:]' '-' | \
tr -s '-' | \
sed 's/^-//;s/-$//'

# Output: hello-world-how-are-you
```

### Example 22: Remove Control Characters
```bash
# Delete non-printable characters
tr -cd '[:print:][:space:]' < file.txt

# Keeps only visible characters
```

### Example 23: Count Character Frequency
```bash
# Frequency of each character
echo "hello" | tr -d '\n' | \
fold -w1 | sort | uniq -c

# Output:
#   1 e
#   2 l
#   1 h
#   1 o
```

### Example 24: Binary to Text Cleanup
```bash
# Remove null bytes and control chars
tr -d '\000-\037' < binary.dat > cleaned.txt

# Strips binary characters
```

---

## Expert Level

### Example 25: Complex Text Normalization
```bash
# Comprehensive cleanup
cat input.txt | \
tr -s '[:space:]' ' ' | \
tr '[:upper:]' '[:lower:]' | \
tr -cd '[:alnum:] \n'

# Normalized text output
```

### Example 26: CSV to TSV Conversion
```bash
# Change delimiter
tr ',' '\t' < file.csv > file.tsv

# Converts comma to tab
```

### Example 27: Generate Random String
```bash
# Random alphanumeric string
cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32

# 32-character random string
```

### Example 28: Mask Sensitive Data
```bash
# Replace digits with X
echo "SSN: 123-45-6789" | tr '0-9' 'X'

# Output: SSN: XXX-XX-XXXX
```

### Example 29: Stream Processing
```bash
# Real-time uppercase conversion
tail -f app.log | tr '[:lower:]' '[:upper:]'

# Live case conversion
```

### Example 30: Multiple Transformations Pipeline
```bash
# Complex pipeline
cat file.txt | \
tr '\t' ' ' | \
tr -s ' ' | \
tr '[:upper:]' '[:lower:]' | \
tr -cd '[:alnum:] \n' | \
sort

# Multi-stage transformation
```

### Example 31: Character Set Conversion Helper
```bash
# Prepare for iconv
tr -cd '\11\12\15\40-\176' < input.txt > ascii_only.txt

# Keeps only ASCII printable
```

### Example 32: Performance Optimization
```bash
# tr is faster than sed for simple character operations
time tr 'a-z' 'A-Z' < largefile.txt > /dev/null
time sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' < largefile.txt > /dev/null

# tr typically wins
```

---

## Salesforce-Specific Examples

### Example 33: Clean Salesforce IDs
```bash
# Remove formatting from IDs
echo "001-ABC-123" | tr -d '-'

# Output: 001ABC123
```

### Example 34: Normalize Apex Class Names
```bash
# Convert to lowercase for search
find force-app -name "*.cls" | \
xargs basename | \
tr 'A-Z' 'a-z'

# Lowercase class names
```

### Example 35: Format SOQL Query
```bash
# Clean up query spacing
echo "SELECT  Id,   Name    FROM   Account" | tr -s ' '

# Output: SELECT Id, Name FROM Account
```

### Example 36: Extract Numbers from Debug Log
```bash
# Get numeric values from log
sf apex get log | tr -cs '0-9' '\n' | grep -v '^$'

# All numbers from log
```

### Example 37: Clean Package Names
```bash
# Sanitize package name for filename
echo "My Awesome Package!" | \
tr '[:upper:]' '[:lower:]' | \
tr -cs '[:alnum:]' '-'

# Output: my-awesome-package
```

### Example 38: Format Metadata XML
```bash
# Normalize XML spacing
cat package.xml | tr -s ' ' | tr '\t' ' '

# Consistent whitespace
```

---

## Generic Real-World Examples

### Example 39: Clean Log Files
```bash
# Remove ANSI color codes
cat colored.log | tr -d '\033\[\[0-9;]*m'

# Plain text output
```

### Example 40: Password Generation
```bash
# Generate secure password
cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*' | head -c 16

# 16-char password with symbols
```

### Example 41: Format JSON for grep
```bash
# Make JSON greppable
cat data.json | tr -d '\n' | tr '{' '\n'

# Each object on own line
```

### Example 42: Extract Domains from Email List
```bash
# Get domain parts only
cut -d '@' -f 2 emails.txt | tr '[:upper:]' '[:lower:]' | sort -u

# Unique domains, lowercase
```

### Example 43: Clean Markdown
```bash
# Remove Markdown symbols for plain text
tr -d '*#`_~' < document.md > plain.txt

# Plain text extraction
```

### Example 44: Format SQL for Logging
```bash
# Single line SQL
echo "SELECT *
FROM users
WHERE active = true" | tr -s '[:space:]' ' '

# Output: SELECT * FROM users WHERE active = true
```

---

## Common Patterns & Recipes

### Pattern 1: Complete Text Normalization
```bash
# Normalize text for processing
cat input.txt | \
tr '[:upper:]' '[:lower:]' | \
tr -cs '[:alnum:]' '\n' | \
sort | uniq -c | sort -nr
```

### Pattern 2: Safe Filename Creation
```bash
# Convert any string to safe filename
echo "$USER_INPUT" | \
tr '[:upper:]' '[:lower:]' | \
tr -cs '[:alnum:]' '-' | \
cut -c 1-50

# Safe, limited-length filename
```

### Pattern 3: Extract Numbers from Text
```bash
# Get all numbers from text
cat report.txt | tr -cs '0-9' '\n' | grep -v '^$' | sort -n
```

### Pattern 4: Clean CSV Data
```bash
# Remove quotes and normalize
tr -d '"' < messy.csv | tr -s ' ' | tr '\t' ','
```

### Pattern 5: Count Character Types
```bash
# Statistics on character types
{
    echo "Uppercase: $(tr -cd '[:upper:]' < file.txt | wc -c)"
    echo "Lowercase: $(tr -cd '[:lower:]' < file.txt | wc -c)"
    echo "Digits: $(tr -cd '[:digit:]' < file.txt | wc -c)"
    echo "Spaces: $(tr -cd ' ' < file.txt | wc -c)"
}
```

---

## Practice Problems

### Beginner (1-8)

1. Convert text to uppercase
2. Convert text to lowercase
3. Delete all spaces from text
4. Replace spaces with underscores
5. Delete all digits
6. Convert tabs to spaces
7. Delete newlines (join lines)
8. Replace commas with newlines

### Intermediate (9-16)

9. Squeeze multiple spaces to single space
10. Keep only alphanumeric characters
11. Delete all punctuation
12. Remove Windows line endings (CRLF)
13. Extract words (split on non-alphanumeric)
14. Simple ROT13 cipher
15. Clean phone number formatting
16. Delete control characters

### Advanced (17-24)

17. Keep only letters and spaces (delete rest)
18. Create character translation map
19. Sanitize filename by replacing special chars
20. Create URL-friendly slug
21. Count character frequency
22. Remove null bytes from binary file
23. CSV to TSV conversion
24. Complex multi-stage normalization

### Expert (25-32)

25. Generate random secure password
26. Mask sensitive data (replace digits)
27. Stream processing with tr
28. Performance comparison: tr vs sed
29. Multiple transformations in pipeline
30. Create ASCII-only version of file
31. Complex text cleanup for NLP
32. Real-time log filtering with tr

---

**Solutions**: [tr Practice Solutions](../04-practice/tr-solutions.md)

**Next**: [ps - Process Status](./ps.md)
