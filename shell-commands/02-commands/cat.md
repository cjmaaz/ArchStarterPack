# cat - Concatenate and Display Files

Display file contents and concatenate multiple files.

---

## 📋 Quick Reference

```bash
cat file.txt                       # Display file contents
cat file1.txt file2.txt            # Display multiple files
cat file1.txt file2.txt > merged.txt  # Concatenate files
cat > newfile.txt                  # Create file from input (Ctrl+D to end)
cat >> file.txt                    # Append input to file
cat -n file.txt                    # Number all lines
cat -b file.txt                    # Number non-empty lines
cat -s file.txt                    # Squeeze multiple blank lines
cat -A file.txt                    # Show all characters (including hidden)
cat -v file.txt                    # Show non-printing characters
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-n` | Number all lines | `cat -n file.txt` |
| `-b` | Number non-empty lines | `cat -b file.txt` |
| `-s` | Squeeze blank lines | `cat -s file.txt` |
| `-A` | Show all characters | `cat -A file.txt` |
| `-E` | Show line endings ($) | `cat -E file.txt` |
| `-T` | Show tabs as ^I | `cat -T file.txt` |
| `-v` | Show non-printing chars | `cat -v file.txt` |
| `-e` | Equivalent to -vE | `cat -e file.txt` |
| `-t` | Equivalent to -vT | `cat -t file.txt` |

---

## Beginner Level

### Example 1: Display File Contents
```bash
# View entire file
cat file.txt

# Most basic usage
# Outputs entire file to terminal
```

### Example 2: Display Multiple Files
```bash
# Show two files in sequence
cat file1.txt file2.txt

# Outputs file1 followed by file2
```

### Example 3: Concatenate Files
```bash
# Merge multiple files into one
cat file1.txt file2.txt file3.txt > combined.txt

# Creates combined.txt with all content
```

### Example 4: Create File from Input
```bash
# Type content directly
cat > newfile.txt
# Type your content
# Press Ctrl+D to finish

# Creates file with your input
```

### Example 5: Append to File
```bash
# Add content to existing file
cat >> logfile.txt
# Type additional content
# Press Ctrl+D to finish

# Appends without overwriting
```

### Example 6: Number All Lines
```bash
# Show with line numbers
cat -n file.txt

# Output:
#      1  First line
#      2  Second line
#      3  Third line
```

### Example 7: Copy File Using cat
```bash
# Copy file.txt to backup.txt
cat file.txt > backup.txt

# Simple file copy method
```

### Example 8: Display Small File Quickly
```bash
# Quick view of short files
cat /etc/hosts

# Better than opening in editor for quick checks
```

---

## Intermediate Level

### Example 9: Number Non-Empty Lines Only
```bash
# Skip blank lines in numbering
cat -b file.txt

# Output:
#      1  First line
#
#      2  Third line (blank skipped)
```

### Example 10: Squeeze Multiple Blank Lines
```bash
# Reduce multiple blanks to single blank
cat -s file.txt

# Cleans up excessive spacing
```

### Example 11: Show Line Endings
```bash
# Display $ at end of each line
cat -E file.txt

# Output:
# Line 1$
# Line 2$
# 
# Line 4$

# Useful for debugging spacing issues
```

### Example 12: Show Tabs
```bash
# Display tabs as ^I
cat -T file.txt

# Reveals tab characters
# Helps identify tab vs space issues
```

### Example 13: Show All Hidden Characters
```bash
# Display everything (tabs, line endings, non-printing)
cat -A file.txt

# Combines -vET
# Ultimate debugging view
```

### Example 14: Combine with grep
```bash
# Filter file contents
cat application.log | grep "ERROR"

# Though `grep "ERROR" application.log` is more efficient
# Useful in complex pipelines
```

### Example 15: Here Document
```bash
# Create multi-line file
cat > config.txt << EOF
Setting1=Value1
Setting2=Value2
Setting3=Value3
EOF

# EOF marks the end
```

### Example 16: Merge with Separator
```bash
# Add separator between files
cat file1.txt <(echo "---") file2.txt

# Clearly divides concatenated content
```

---

## Advanced Level

### Example 17: Create File with Variables
```bash
# Embed variables in file creation
cat > script.sh << EOF
#!/bin/bash
echo "User: $USER"
echo "Date: $(date)"
EOF

# Variables expand during creation
```

### Example 18: Append Multiple Sources
```bash
# Combine multiple inputs
cat file1.txt file2.txt >> destination.txt

# Appends both files
```

### Example 19: Read from stdin and Files
```bash
# Mix stdin with files
echo "Header" | cat - file.txt > output.txt

# - represents stdin
# Prepends stdin to file
```

### Example 20: Process Binary Files Carefully
```bash
# View binary as text (be careful)
cat -v binary.dat

# Shows non-printing characters
# May scramble terminal - use `reset` to fix
```

### Example 21: Combine with Here String
```bash
# Pass string as file input
cat <<< "This is a single line"

# Useful for testing pipelines
```

### Example 22: Reverse Line Order (with tac)
```bash
# Display file in reverse
tac file.txt

# tac is reverse of cat
# Shows last line first
```

### Example 23: Side-by-Side Display (with paste)
```bash
# Show files in columns
paste file1.txt file2.txt | cat

# Displays files side by side
```

### Example 24: Strip Non-Printing Characters
```bash
# Clean binary content
cat -v binaryfile.log | tr -d '\000-\037'

# Removes control characters
```

---

## Expert Level

### Example 25: Create Complex Config Files
```bash
# Generate configuration with logic
cat > application.conf << EOF
# Generated on $(date)
# User: $USER
# Environment: ${ENVIRONMENT:-development}

database.host=${DB_HOST}
database.port=${DB_PORT:-5432}
database.name=${DB_NAME}

app.debug=$([[ $ENV == "dev" ]] && echo "true" || echo "false")
EOF
```

### Example 26: Conditional File Concatenation
```bash
# Merge only if files exist
for file in file1.txt file2.txt file3.txt; do
    [ -f "$file" ] && cat "$file"
done > merged.txt
```

### Example 27: Process While Reading
```bash
# Read and process simultaneously
cat largefile.txt | while IFS= read -r line; do
    # Process each line
    echo "Processing: $line"
done
```

### Example 28: Create Self-Extracting Archive
```bash
# Combine script and data
cat > extract.sh << 'EOF'
#!/bin/bash
sed '1,/^__DATA__$/d' "$0" | tar xz
exit 0
__DATA__
EOF
tar cz files/ | cat extract.sh - > selfextract.sh
```

### Example 29: Multi-Source Pipe Chain
```bash
# Complex pipeline
{
    cat header.txt
    cat data*.txt | sort | uniq
    cat footer.txt
} | cat -n > report.txt
```

### Example 30: Read with Timeout
```bash
# Timeout on stdin
timeout 5 cat > input.txt

# Stops reading after 5 seconds
```

### Example 31: Binary File Concatenation
```bash
# Merge binary files
cat part1.bin part2.bin part3.bin > complete.bin

# Joins binary data properly
# Useful for split archives
```

### Example 32: Stream Processing
```bash
# Continuous stream processing
mkfifo stream
cat stream | process_data.sh &
echo "data" > stream
```

---

## Salesforce-Specific Examples

### Example 33: Combine Apex Classes
```bash
# Merge multiple Apex classes for review
cat force-app/main/default/classes/*.cls > all_classes.txt

# Creates single file for searching
```

### Example 34: Create SOQL Script
```bash
# Generate SOQL queries file
cat > queries.soql << EOF
SELECT Id, Name FROM Account WHERE Industry = 'Technology';
SELECT Id, FirstName, LastName FROM Contact WHERE CreatedDate = TODAY;
SELECT Id, Amount FROM Opportunity WHERE StageName = 'Closed Won';
EOF
```

### Example 35: Merge Debug Logs
```bash
# Combine multiple debug logs
for id in $(sf apex list log --json | jq -r '.[] | .Id'); do
    sf apex get log --log-id "$id"
done | cat > all_logs.txt

# Creates comprehensive log file
```

### Example 36: Display Package.xml
```bash
# Quick view of manifest
cat manifest/package.xml

# Check metadata types being deployed
```

### Example 37: Concatenate Test Results
```bash
# Merge test outputs from multiple runs
cat test_run_1.txt test_run_2.txt test_run_3.txt | grep -E "PASS|FAIL" | sort | uniq -c

# Aggregated test results
```

### Example 38: Create Deployment Script
```bash
# Generate deployment commands
cat > deploy.sh << EOF
#!/bin/bash
echo "Starting deployment..."
sf project deploy start --target-org production
sf apex run test --test-level RunLocalTests
echo "Deployment complete"
EOF
chmod +x deploy.sh
```

---

## Generic Real-World Examples

### Example 39: Quick Log Analysis
```bash
# View and count error types
cat /var/log/syslog | grep ERROR | sort | uniq -c

# Frequency of each error
```

### Example 40: Create Dockerfile
```bash
# Generate Docker configuration
cat > Dockerfile << EOF
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF
```

### Example 41: Merge CSV Files
```bash
# Combine CSV files (skip headers from subsequent files)
cat file1.csv > merged.csv
tail -n +2 file2.csv >> merged.csv
tail -n +2 file3.csv >> merged.csv

# Keeps only first header
```

### Example 42: View Docker Compose
```bash
# Check docker-compose configuration
cat docker-compose.yml

# Quick config review
```

### Example 43: Create Cron Job
```bash
# Generate crontab entry
cat > backup_cron << EOF
# Daily backup at 2 AM
0 2 * * * /usr/local/bin/backup.sh
# Weekly cleanup on Sunday
0 3 * * 0 /usr/local/bin/cleanup.sh
EOF
crontab backup_cron
```

### Example 44: Concatenate Log Rotations
```bash
# View current and rotated logs together
cat app.log.{5..1} app.log > full_history.log

# Chronological full history
```

---

## Common Patterns & Recipes

### Pattern 1: Safe File Viewing
```bash
# Use cat with less for large files
cat largefile.txt | less

# Though `less largefile.txt` is more efficient
# This pattern useful in complex pipelines
```

### Pattern 2: Create Backup with Timestamp
```bash
# Timestamped backup
cat config.txt > "config_backup_$(date +%Y%m%d_%H%M%S).txt"

# Preserves original with dated copy
```

### Pattern 3: Multi-File Search
```bash
# Search across concatenated files
cat *.log | grep -i "error" | sort | uniq -c | sort -nr

# Aggregate search results
```

### Pattern 4: Template Processing
```bash
# Process template file
export NAME="John Doe"
export ROLE="Developer"
cat template.txt | envsubst > personalized.txt

# Substitutes environment variables
```

### Pattern 5: Log Aggregation
```bash
# Merge and timestamp logs
for log in /var/log/app/*.log; do
    echo "=== $log ===" 
    cat "$log"
done > aggregated.log
```

---

## Practice Problems

### Beginner (1-8)

1. Display the contents of a file
2. Concatenate three files into one
3. Create a new file using cat
4. Append text to an existing file
5. Display file with line numbers
6. Copy a file using cat
7. Display multiple files sequentially
8. Create a file with multiple lines of input

### Intermediate (9-16)

9. Number only non-empty lines
10. Squeeze multiple blank lines to one
11. Show line endings with $
12. Display tabs as ^I
13. Show all hidden characters
14. Create file using here document
15. Merge files with separator between them
16. Prepend text to a file

### Advanced (17-24)

17. Create script file with embedded variables
18. Merge files and append to destination
19. Mix stdin with file contents
20. Use cat with process substitution
21. Create config file with conditional logic
22. Concatenate only existing files
23. Create multi-section report file
24. Binary file concatenation

### Expert (25-32)

25. Generate complex configuration dynamically
26. Create self-extracting archive
27. Multi-source conditional concatenation
28. Stream processing with named pipes
29. Timeout-based input reading
30. Create file with inline shell expansion
31. Process and merge in single pipeline
32. Advanced binary file operations

---

**Solutions**: [cat Practice Solutions](../04-practice/cat-solutions.md)

**Next**: [echo - Print Text](./echo.md)
