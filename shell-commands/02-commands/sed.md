# sed - Stream Editor

Transform and edit text streams without modifying the original file.

---

## 📋 Quick Reference

```bash
sed 's/old/new/' file.txt           # Replace first occurrence per line
sed 's/old/new/g' file.txt          # Replace all occurrences
sed 's/old/new/gi' file.txt         # Case insensitive replace
sed '5d' file.txt                   # Delete line 5
sed '1,3d' file.txt                 # Delete lines 1-3
sed -n '5p' file.txt                # Print only line 5
sed -i 's/old/new/g' file.txt       # Edit file in-place
sed '/pattern/d' file.txt           # Delete lines matching pattern
sed 's/^/PREFIX/' file.txt          # Add prefix to each line
sed 's/$/SUFFIX/' file.txt          # Add suffix to each line
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `s/pattern/replacement/` | Substitute | `sed 's/foo/bar/'` |
| `g` | Global (all occurrences) | `sed 's/foo/bar/g'` |
| `i` | Case insensitive | `sed 's/foo/bar/gi'` |
| `d` | Delete | `sed '/pattern/d'` |
| `p` | Print | `sed -n '5p'` |
| `-n` | Suppress default output | `sed -n '/pattern/p'` |
| `-i` | In-place edit | `sed -i 's/foo/bar/g'` |
| `-e` | Multiple commands | `sed -e 's/a/b/' -e 's/c/d/'` |
| `-r` or `-E` | Extended regex | `sed -E 's/[0-9]+/NUM/g'` |

---

## Beginner Level

### Example 1: Basic Substitution
```bash
# Replace first occurrence of "error" with "ERROR"
echo "error in line 1, error in line 2" | sed 's/error/ERROR/'

# Output: ERROR in line 1, error in line 2
```

### Example 2: Global Substitution
```bash
# Replace all occurrences
echo "error in line 1, error in line 2" | sed 's/error/ERROR/g'

# Output: ERROR in line 1, ERROR in line 2
```

### Example 3: Case Insensitive Replace
```bash
# Replace regardless of case
echo "Error ERROR error" | sed 's/error/WARNING/gi'

# Output: WARNING WARNING WARNING
```

### Example 4: Delete Specific Line
```bash
# Remove line 3
sed '3d' file.txt

# Original:
# Line 1
# Line 2
# Line 3  <- deleted
# Line 4
```

### Example 5: Delete Line Range
```bash
# Remove lines 2 through 4
sed '2,4d' file.txt

# Keeps line 1, deletes 2-4, keeps 5+
```

### Example 6: Print Specific Line
```bash
# Show only line 10
sed -n '10p' file.txt

# -n suppresses default output
# p prints the specified line
```

### Example 7: Print Line Range
```bash
# Show lines 5 to 15
sed -n '5,15p' file.txt

# Useful for viewing specific sections
```

### Example 8: Delete Empty Lines
```bash
# Remove all blank lines
sed '/^$/d' file.txt

# ^$ matches empty lines
```

---

## Intermediate Level

### Example 9: Add Prefix to Lines
```bash
# Add "LOG: " to each line
sed 's/^/LOG: /' application.log

# Output:
# LOG: First line
# LOG: Second line
```

### Example 10: Add Suffix to Lines
```bash
# Add semicolon to end of each line
sed 's/$/;/' statements.txt

# $ matches end of line
```

### Example 11: Delete Lines Matching Pattern
```bash
# Remove all lines containing "DEBUG"
sed '/DEBUG/d' log.txt

# Useful for filtering logs
```

### Example 12: Delete Lines NOT Matching Pattern
```bash
# Keep only lines with "ERROR"
sed '/ERROR/!d' log.txt

# ! negates the pattern
# Equivalent to: grep "ERROR" log.txt
```

### Example 13: Multiple Substitutions
```bash
# Chain multiple replacements
sed -e 's/foo/bar/g' -e 's/old/new/g' file.txt

# Alternative syntax:
sed 's/foo/bar/g; s/old/new/g' file.txt
```

### Example 14: Replace with Regex Groups
```bash
# Swap first two fields
echo "John Doe" | sed 's/\(.*\) \(.*\)/\2, \1/'

# Output: Doe, John
# \1 = first group, \2 = second group
```

### Example 15: Remove Leading Whitespace
```bash
# Trim spaces from line start
sed 's/^[[:space:]]*//' file.txt

# [[:space:]] matches spaces and tabs
```

### Example 16: Remove Trailing Whitespace
```bash
# Trim spaces from line end
sed 's/[[:space:]]*$//' file.txt

# Common cleanup task
```

---

## Advanced Level

### Example 17: In-Place Editing
```bash
# Modify file directly (macOS)
sed -i '' 's/old/new/g' file.txt

# Linux:
sed -i 's/old/new/g' file.txt

# Creates backup:
sed -i.bak 's/old/new/g' file.txt
```

### Example 18: Replace Only on Specific Lines
```bash
# Replace "foo" with "bar" only on lines 10-20
sed '10,20s/foo/bar/g' file.txt

# Selective substitution
```

### Example 19: Replace on Lines Matching Pattern
```bash
# Replace only on lines containing "ERROR"
sed '/ERROR/s/foo/bar/g' log.txt

# Pattern match then substitute
```

### Example 20: Insert Line Before Match
```bash
# Insert header before first occurrence of "START"
sed '/START/i\--- HEADER LINE ---' file.txt

# i\ = insert before
```

### Example 21: Append Line After Match
```bash
# Add comment after "function"
sed '/function/a\// TODO: Document this function' code.js

# a\ = append after
```

### Example 22: Replace Entire Line
```bash
# Replace lines containing "OLD_VERSION"
sed '/OLD_VERSION/c\NEW_VERSION=2.0.0' config.txt

# c\ = change entire line
```

### Example 23: Number Lines
```bash
# Add line numbers
sed = file.txt | sed 'N;s/\n/\t/'

# First sed adds numbers
# Second joins number with content
```

### Example 24: Extract Email Addresses
```bash
# Find and extract emails
sed -n 's/.*\([a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}\).*/\1/p' contacts.txt

# -n suppresses output
# p prints only matches
```

---

## Expert Level

### Example 25: Multi-Line Pattern Replacement
```bash
# Replace across multiple lines
sed ':a;N;$!ba;s/pattern1\npattern2/replacement/g' file.txt

# :a = label
# N = append next line
# $!ba = if not last line, branch to a
```

### Example 26: Delete from Pattern to End of File
```bash
# Delete from "START_DELETE" to EOF
sed '/START_DELETE/,$d' file.txt

# $ represents last line
```

### Example 27: Print Between Two Patterns
```bash
# Extract content between markers
sed -n '/START/,/END/p' file.txt

# Prints from START to END inclusive
```

### Example 28: Complex Regex with Extended Mode
```bash
# Use extended regex for readability
sed -E 's/([0-9]{3})-([0-9]{3})-([0-9]{4})/(\1) \2-\3/' phones.txt

# Reformats: 555-123-4567 to (555) 123-4567
```

### Example 29: Conditional Replacement
```bash
# Replace only if line also contains another pattern
sed '/keyword/s/old/new/g' file.txt

# Only substitutes on lines with "keyword"
```

### Example 30: Remove HTML Tags
```bash
# Strip HTML tags
sed 's/<[^>]*>//g' page.html

# Removes all <tag> patterns
```

### Example 31: Convert CSV to TSV
```bash
# Replace commas with tabs
sed 's/,/\t/g' data.csv > data.tsv

# \t = tab character
```

### Example 32: Extract and Transform
```bash
# Extract version numbers and format
sed -n 's/.*version: \([0-9.]*\).*/Version \1/p' logs.txt

# Captures and reformats version strings
```

---

## Salesforce-Specific Examples

### Example 33: Clean Apex Log Lines
```bash
# Remove timestamps from Apex logs
sed 's/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\+ //' debug.log

# Cleans: "12:34:56.789 CODE_UNIT_STARTED" 
# Output: "CODE_UNIT_STARTED"
```

### Example 34: Extract SOQL Queries
```bash
# Extract and clean SOQL from logs
sed -n 's/.*SOQL_EXECUTE_BEGIN\[.*\] //p' debug.log | sed 's/Aggregations:.*//'

# Extracts clean SOQL statements
```

### Example 35: Modify Package.xml Versions
```bash
# Update API version in all package.xml files
find . -name "package.xml" -exec sed -i '' 's/<version>[0-9.]*<\/version>/<version>60.0<\/version>/g' {} \;

# Updates API version to 60.0
```

### Example 36: Clean Deployment Output
```bash
# Remove ANSI color codes from SF CLI output
sf project deploy start | sed 's/\x1b\[[0-9;]*m//g' > clean_output.txt

# Strips terminal color codes
```

### Example 37: Format Test Results
```bash
# Extract failed test methods
sed -n '/FAIL/s/.*Test method: \(.*\) --.*/\1/p' test_results.txt

# Lists only failed test method names
```

### Example 38: Convert Sandbox to Production Org
```bash
# Replace sandbox URLs in config
sed 's/\.sandbox\.my\.salesforce\.com/\.my\.salesforce\.com/g' sfdx-project.json

# Updates org URLs
```

---

## Generic Real-World Examples

### Example 39: Log Preprocessing
```bash
# Anonymize IP addresses in logs
sed 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/XXX.XXX.XXX.XXX/g' access.log

# Replaces all IPs with XXX.XXX.XXX.XXX
```

### Example 40: Configuration Updates
```bash
# Update database connection strings
sed -i.bak 's/localhost:3306/prod-db.example.com:3306/g' config/*.properties

# Updates all config files with backup
```

### Example 41: Code Refactoring
```bash
# Rename function calls across files
find . -name "*.js" -exec sed -i '' 's/oldFunctionName/newFunctionName/g' {} \;

# Renames function in all JS files
```

### Example 42: Generate SQL Scripts
```bash
# Convert list to INSERT statements
sed 's/.*/INSERT INTO users (name) VALUES ('\''&'\'');/' names.txt

# Wraps each name in SQL INSERT
```

### Example 43: Format Output for Reports
```bash
# Convert space-separated to CSV
ps aux | sed 's/[[:space:]]\+/,/g' > processes.csv

# Converts ps output to CSV
```

### Example 44: Environment Variable Substitution
```bash
# Replace placeholders with environment variables
sed "s/\${DB_HOST}/$DB_HOST/g" template.conf > production.conf

# Use double quotes for variable expansion
```

---

## Common Patterns & Recipes

### Pattern 1: Clean and Normalize Data
```bash
#!/bin/bash
# Clean CSV file: remove empty lines, trim whitespace, lowercase
sed -e '/^$/d' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]*$//' \
    -e 's/.*/\L&/' \
    input.csv > cleaned.csv
```

### Pattern 2: Extract and Format
```bash
# Extract specific fields from structured logs
sed -n 's/.*\[ERROR\] \([0-9-]*\) \(.*\)/Date: \1 | Error: \2/p' app.log
```

### Pattern 3: Batch File Processing
```bash
# Apply same transformation to multiple files
for file in *.txt; do
    sed -i.bak 's/old/new/g' "$file"
    echo "Processed: $file"
done
```

### Pattern 4: Configuration Template Processing
```bash
# Replace multiple variables in template
sed -e "s/{{APP_NAME}}/$APP_NAME/g" \
    -e "s/{{VERSION}}/$VERSION/g" \
    -e "s/{{ENVIRONMENT}}/$ENVIRONMENT/g" \
    template.yaml > config.yaml
```

### Pattern 5: Log Analysis Pipeline
```bash
# Complex log processing
cat production.log | \
sed '/DEBUG/d' | \
sed -n '/ERROR/p' | \
sed 's/^.*ERROR: //' | \
sort | uniq -c | sort -nr
```

---

## Practice Problems

### Beginner (1-8)

1. Replace "hello" with "goodbye" in greeting.txt
2. Delete line 5 from a file
3. Print only lines 10-20 from a file
4. Remove all empty lines
5. Add "# " prefix to each line
6. Replace all tabs with spaces
7. Delete lines containing "SKIP"
8. Print only lines containing "MATCH"

### Intermediate (9-16)

9. Remove leading spaces from all lines
10. Add line numbers to a file
11. Replace text only on lines 50-100
12. Swap first and last word on each line
13. Remove HTML comments from a file
14. Convert all text to lowercase
15. Delete lines NOT containing "KEEP"
16. Insert blank line after every line

### Advanced (17-24)

17. Replace text in-place with backup
18. Extract email addresses from text
19. Remove ANSI color codes
20. Convert phone numbers to (XXX) XXX-XXXX format
21. Delete from specific pattern to EOF
22. Replace across multiple lines
23. Clean and normalize JSON
24. Extract values from XML tags

### Expert (25-32)

25. Multi-line pattern matching and replacement
26. Conditional replacement based on two patterns
27. Complex regex with capture groups
28. Process files in parallel with sed
29. Generate code from templates
30. Advanced log parsing and transformation
31. Nested pattern extraction
32. Custom delimiter handling

---

**Solutions**: [sed Practice Solutions](../04-practice/sed-solutions.md)

**Next**: [awk - Text Processing](./awk.md)
