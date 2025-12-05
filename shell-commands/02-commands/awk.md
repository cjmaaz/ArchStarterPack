# awk - Pattern Scanning and Processing

Powerful text processing language for column-based data manipulation.

---

## 📋 Quick Reference

```bash
awk '{print}' file.txt                    # Print all lines
awk '{print $1}' file.txt                 # Print first column
awk '{print $1, $3}' file.txt             # Print columns 1 and 3
awk -F',' '{print $2}' file.csv           # Use comma as delimiter
awk '$3 > 100' file.txt                   # Filter rows where column 3 > 100
awk 'NR==5' file.txt                      # Print line 5
awk 'NR>=5 && NR<=10' file.txt            # Print lines 5-10
awk '{sum+=$1} END {print sum}' file.txt  # Sum first column
awk 'BEGIN {print "START"} {print} END {print "END"}' file.txt
```

---

## Core Concepts

### Built-in Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `$0` | Entire line | `awk '{print $0}'` |
| `$1, $2, $n` | Column 1, 2, n | `awk '{print $1}'` |
| `NF` | Number of fields | `awk '{print NF}'` |
| `NR` | Line number | `awk '{print NR, $0}'` |
| `FS` | Field separator | `awk 'BEGIN {FS=","}'` |
| `OFS` | Output field separator | `awk 'BEGIN {OFS="|"}'` |
| `RS` | Record separator | `awk 'BEGIN {RS=";"}'` |
| `ORS` | Output record separator | `awk 'BEGIN {ORS="\n\n"}'` |

### Structure

```bash
awk 'BEGIN {actions} pattern {actions} END {actions}' file
```

---

## Beginner Level

### Example 1: Print All Lines
```bash
# Basic print (like cat)
awk '{print}' file.txt

# Equivalent to:
awk '{print $0}' file.txt
```

### Example 2: Print Specific Column
```bash
# Print first column
echo "John Doe 30 Engineer" | awk '{print $1}'

# Output: John
```

### Example 3: Print Multiple Columns
```bash
# Print columns 1 and 3
echo "John Doe 30 Engineer" | awk '{print $1, $3}'

# Output: John 30
# Note: Space between columns
```

### Example 4: Change Field Separator
```bash
# CSV file processing
awk -F',' '{print $2}' data.csv

# -F',' sets comma as delimiter
```

### Example 5: Print with Custom Text
```bash
# Add labels to output
awk '{print "Name:", $1, "Age:", $3}' people.txt

# Output: Name: John Age: 30
```

### Example 6: Print Line Numbers
```bash
# Show line numbers
awk '{print NR, $0}' file.txt

# NR = current line number
```

### Example 7: Print Last Column
```bash
# Access last field
awk '{print $NF}' file.txt

# NF = number of fields
# $NF = last field
```

### Example 8: Print Number of Fields
```bash
# Count columns per line
awk '{print NF}' file.txt

# Useful for validating data format
```

---

## Intermediate Level

### Example 9: Filter by Column Value
```bash
# Show lines where column 3 > 100
awk '$3 > 100' sales.txt

# Implicit: awk '$3 > 100 {print $0}'
```

### Example 10: Multiple Conditions
```bash
# AND condition
awk '$3 > 100 && $4 < 500' data.txt

# OR condition
awk '$2 == "Active" || $2 == "Pending"' status.txt
```

### Example 11: String Matching
```bash
# Lines where column 2 contains "Error"
awk '$2 ~ /Error/' log.txt

# Negation (NOT match)
awk '$2 !~ /Debug/' log.txt
```

### Example 12: Sum a Column
```bash
# Calculate total of column 3
awk '{sum += $3} END {print "Total:", sum}' numbers.txt

# END block runs after all lines processed
```

### Example 13: Average Calculation
```bash
# Calculate average
awk '{sum += $1; count++} END {print "Average:", sum/count}' numbers.txt

# Keeps running sum and count
```

### Example 14: Count Lines
```bash
# Count lines matching pattern
awk '/ERROR/ {count++} END {print count}' log.txt

# Similar to: grep -c ERROR log.txt
```

### Example 15: Print Specific Line Range
```bash
# Print lines 5 to 10
awk 'NR>=5 && NR<=10' file.txt

# NR is line number
```

### Example 16: Change Output Format
```bash
# Convert space-separated to CSV
awk 'BEGIN {OFS=","} {print $1, $2, $3}' data.txt

# OFS = output field separator
```

---

## Advanced Level

### Example 17: BEGIN and END Blocks
```bash
# Add header and footer
awk 'BEGIN {print "=== REPORT ==="} {print $0} END {print "=== END ==="}' data.txt

# BEGIN runs before any line
# END runs after all lines
```

### Example 18: Format Numbers
```bash
# Pretty print with formatting
awk '{printf "%-15s %10.2f\n", $1, $2}' sales.txt

# %-15s = left-aligned string, 15 chars
# %10.2f = number, 2 decimal places
```

### Example 19: Multiple Delimiters
```bash
# Split on comma OR semicolon
awk -F'[,;]' '{print $1, $2}' mixed_delim.txt

# Uses regex for delimiter
```

### Example 20: Arrays in awk
```bash
# Count occurrences
awk '{count[$1]++} END {for (key in count) print key, count[key]}' data.txt

# Creates associative array
```

### Example 21: Find Maximum Value
```bash
# Find max in column 2
awk 'BEGIN {max=0} $2 > max {max=$2} END {print "Max:", max}' numbers.txt

# Tracks maximum value
```

### Example 22: Remove Duplicate Lines
```bash
# Print unique lines only
awk '!seen[$0]++' file.txt

# seen array tracks what we've seen
# !seen[$0]++ is true first time only
```

### Example 23: Column Math Operations
```bash
# Calculate: column3 = column1 + column2
awk '{print $1, $2, $1+$2}' numbers.txt

# Can do +, -, *, /, %, ^
```

### Example 24: Conditional Output
```bash
# Different output based on value
awk '{if ($3 > 100) print $1, "HIGH"; else print $1, "LOW"}' data.txt

# if-else statement
```

---

## Expert Level

### Example 25: Complex Pattern Matching
```bash
# Multi-field pattern
awk '$2 ~ /^[A-Z]/ && $3 > 50 {print $1, $2, $3}' data.txt

# Regex match + numeric condition
```

### Example 26: Multiple Input Files
```bash
# Process multiple files differently
awk 'FNR==1 {print "File:", FILENAME} {print $0}' file1.txt file2.txt

# FNR resets per file
# NR continues across files
```

### Example 27: Join Fields
```bash
# Join all fields with custom delimiter
awk '{for(i=1;i<=NF;i++) printf "%s%s", $i, (i<NF ? " | " : "\n")}' data.txt

# Loop through fields
```

### Example 28: Group By and Aggregate
```bash
# Sum by category (column 1)
awk '{sum[$1] += $2} END {for (cat in sum) print cat, sum[cat]}' sales.txt

# Groups by first column, sums second
```

### Example 29: Multi-Line Records
```bash
# Process records spanning multiple lines
awk 'BEGIN {RS=""; FS="\n"} {print "Record:", NR; for(i=1;i<=NF;i++) print " Line", i":", $i}' multi.txt

# RS="" = paragraph mode
# FS="\n" = field per line
```

### Example 30: Complex Calculations
```bash
# Statistical analysis
awk '{sum+=$1; sumsq+=$1*$1} END {print "Mean:", sum/NR; print "Variance:", sumsq/NR - (sum/NR)^2}' numbers.txt

# Calculates mean and variance
```

### Example 31: Custom Functions
```bash
# Define and use function
awk 'function abs(x) {return x < 0 ? -x : x} {print abs($1)}' numbers.txt

# Custom absolute value function
```

### Example 32: Pattern Range
```bash
# Print between two patterns
awk '/START/,/END/' file.txt

# Prints from START to END inclusive
```

---

## Salesforce-Specific Examples

### Example 33: Parse Apex Log Performance
```bash
# Extract method execution times
awk '/CODE_UNIT_STARTED/ {start=$1} /CODE_UNIT_FINISHED/ {print $1-start, "ms"}' debug.log

# Calculates duration between events
```

### Example 34: Analyze SOQL Query Results
```bash
# Format SOQL query output
sf data query --query "SELECT Name, Amount FROM Opportunity" | awk 'NR>2 {print $1, $2}' | column -t

# Skips header rows, formats output
```

### Example 35: Process Test Results
```bash
# Extract failed test statistics
awk '/Failures/ {fails=$2} /Total/ {total=$2} END {printf "Pass Rate: %.1f%%\n", (total-fails)/total*100}' test_results.txt

# Calculates pass percentage
```

### Example 36: Parse Deployment Errors
```bash
# Extract error messages and line numbers
awk -F: '/ERROR/ {print "File:", $1, "Line:", $2, "Error:", $3}' deploy_result.txt

# Formats deployment errors
```

### Example 37: Analyze Code Coverage
```bash
# Find classes below coverage threshold
sf apex get test --code-coverage --json | awk -F'"' '/"coveredPercent":/ {if ($(NF-1) < 75) print "Low coverage:", prev} {prev=$0}'

# Identifies low coverage classes
```

### Example 38: Process Batch Job Logs
```bash
# Summarize batch processing
awk '/Batch START/ {batches++} /Batch SUCCESS/ {success++} /Batch FAIL/ {fail++} END {print "Total:", batches, "Success:", success, "Failed:", fail}' batch.log

# Batch job statistics
```

---

## Generic Real-World Examples

### Example 39: Apache/Nginx Log Analysis
```bash
# Count requests by HTTP status code
awk '{print $9}' access.log | sort | uniq -c | sort -nr

# $9 typically contains status code
```

### Example 40: Process CSV Files
```bash
# Calculate column statistics
awk -F',' 'NR>1 {sum+=$3; if($3>max) max=$3; if(NR==2 || $3<min) min=$3} END {print "Sum:", sum, "Max:", max, "Min:", min}' sales.csv

# Skip header, find sum, max, min
```

### Example 41: System Resource Monitoring
```bash
# Find high CPU processes
ps aux | awk '$3 > 50 {print $2, $11, $3"%"}'

# $3 is CPU%, $2 is PID, $11 is command
```

### Example 42: Network Connection Analysis
```bash
# Count connections per IP
netstat -an | awk '/ESTABLISHED/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr

# Finds most active IPs
```

### Example 43: Disk Usage Report
```bash
# Format disk usage nicely
df -h | awk 'NR>1 {printf "%-20s %10s %10s %5s\n", $6, $2, $3, $5}'

# Skip header, format columns
```

### Example 44: Generate SQL from CSV
```bash
# Create INSERT statements
awk -F',' 'NR>1 {printf "INSERT INTO users (name, email, age) VALUES ('\''%s'\'', '\''%s'\'', %d);\n", $1, $2, $3}' users.csv

# Converts CSV to SQL
```

---

## Common Patterns & Recipes

### Pattern 1: Data Validation
```bash
#!/bin/bash
# Check CSV has exactly 5 columns
awk -F',' 'NF != 5 {print "Line", NR, "has", NF, "fields (expected 5)"}' data.csv
```

### Pattern 2: Log Aggregation
```bash
# Count error types
awk '/ERROR/ {errors[$3]++} END {for (e in errors) print e, errors[e]}' app.log | sort -k2 -nr
```

### Pattern 3: Data Transformation
```bash
# Convert data format
awk -F',' 'BEGIN {print "Name|Age|City"} NR>1 {print $1"|"$2"|"$3}' input.csv > output.txt
```

### Pattern 4: Report Generation
```bash
# Create formatted report
awk 'BEGIN {
    print "="*50
    print "SALES REPORT"
    print "="*50
} 
{
    total += $2
    printf "%-20s $%10.2f\n", $1, $2
} 
END {
    print "="*50
    printf "%-20s $%10.2f\n", "TOTAL:", total
}' sales.txt
```

### Pattern 5: Multi-Pass Processing
```bash
# First pass: calculate average, Second pass: compare
awk 'NR==FNR {sum+=$1; count++; next} {if ($1 > sum/count) print $0, "ABOVE AVG"}' data.txt data.txt
```

---

## Practice Problems

### Beginner (1-8)

1. Print the third column of a file
2. Print last column of each line
3. Count total number of lines
4. Print lines where first field is "ERROR"
5. Sum all numbers in column 2
6. Print line numbers with content
7. Change delimiter from comma to pipe
8. Print first and last columns only

### Intermediate (9-16)

9. Find average of column 3
10. Print lines where column 2 > 100
11. Count occurrences of each value in column 1
12. Print lines 50-100
13. Remove lines with fewer than 5 fields
14. Calculate column 3 = column 1 + column 2
15. Format output as table with printf
16. Find maximum value in column 2

### Advanced (17-24)

17. Group by column 1, sum column 2
18. Print unique lines (deduplicate)
19. Extract fields matching regex pattern
20. Calculate mean and standard deviation
21. Join multiple input files on key field
22. Convert CSV to JSON format
23. Create frequency histogram
24. Parse and reformat log timestamps

### Expert (25-32)

25. Implement multi-pass algorithm
26. Create custom aggregation function
27. Process multi-line records
28. Build complex report with headers/footers
29. Implement range queries
30. Parse and validate structured data
31. Generate code from template
32. Advanced statistical analysis

---

**Solutions**: [awk Practice Solutions](../04-practice/awk-solutions.md)

**Next**: [tail/head - File Viewing](./tail-head.md)
