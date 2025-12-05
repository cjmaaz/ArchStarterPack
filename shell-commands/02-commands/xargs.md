# xargs - Build and Execute Commands

Build command lines from standard input and execute them.

---

## 📋 Quick Reference

```bash
ls | xargs rm                      # Delete files from ls output
find . -name "*.tmp" | xargs rm    # Find and delete
echo file1 file2 | xargs cat       # Process multiple inputs
seq 1 5 | xargs -n 1 echo         # One argument per command
cat urls.txt | xargs -I {} curl {} # Replace string placeholder
ls | xargs -P 4 process            # Parallel execution (4 processes)
find . -name "*.txt" | xargs -0 rm # Handle spaces/special chars
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-n NUM` | Max arguments per command | `xargs -n 2 echo` |
| `-I STRING` | Replace string | `xargs -I {} echo {}` |
| `-0` | Null-terminated input | `find -print0 | xargs -0` |
| `-P NUM` | Parallel processes | `xargs -P 4 command` |
| `-t` | Print command before execution | `xargs -t rm` |
| `-p` | Prompt before execution | `xargs -p rm` |
| `-d DELIM` | Custom delimiter | `xargs -d ',' echo` |
| `-L NUM` | Max lines per command | `xargs -L 1 echo` |
| `-r` | Don't run if input empty | `xargs -r command` |
| `-s NUM` | Max command line length | `xargs -s 2000` |

---

## Beginner Level

### Example 1: Basic Usage
```bash
# Pass filenames to rm
echo "file1.txt file2.txt" | xargs rm

# Deletes both files
```

### Example 2: Find and Delete
```bash
# Delete all .tmp files
find . -name "*.tmp" | xargs rm

# Combines find with rm
```

### Example 3: Count Lines in Multiple Files
```bash
# Word count for all .txt files
ls *.txt | xargs wc -l

# Runs: wc -l file1.txt file2.txt...
```

### Example 4: Echo Multiple Items
```bash
# Print each word
echo "one two three" | xargs -n 1 echo

# Output:
# one
# two
# three
```

### Example 5: Concatenate Files
```bash
# Display multiple files
ls *.txt | xargs cat

# Equivalent to: cat *.txt
```

### Example 6: Create Directories
```bash
# Make multiple directories
echo "dir1 dir2 dir3" | xargs mkdir

# Creates all three
```

### Example 7: Show Command Being Run
```bash
# Verbose mode
ls *.txt | xargs -t rm

# Prints: rm file1.txt file2.txt...
# Then executes
```

### Example 8: Interactive Mode
```bash
# Confirm before execution
ls *.txt | xargs -p rm

# Prompts: rm file1.txt file2.txt ...?
```

---

## Intermediate Level

### Example 9: Custom Replacement String
```bash
# Use placeholder
echo "file1 file2" | xargs -I {} cp {} backup/{}

# Copies each file to backup/
```

### Example 10: Process Files One by One
```bash
# One argument per command
cat filelist.txt | xargs -n 1 process_file.sh

# Runs process_file.sh for each file separately
```

### Example 11: Handle Spaces in Filenames
```bash
# Null-terminated input
find . -name "*.txt" -print0 | xargs -0 cat

# Handles "file name.txt" correctly
```

### Example 12: Multiple Arguments per Call
```bash
# Two arguments per command
echo "a b c d e f" | xargs -n 2 echo

# Output:
# a b
# c d
# e f
```

### Example 13: Parallel Execution
```bash
# Run 4 processes simultaneously
cat urls.txt | xargs -P 4 -I {} curl -O {}

# Downloads 4 files in parallel
```

### Example 14: Process Lines
```bash
# One line per command
cat data.txt | xargs -L 1 process_line.sh

# Processes each line separately
```

### Example 15: Custom Delimiter
```bash
# Comma-separated input
echo "one,two,three" | xargs -d ',' -n 1 echo

# Output:
# one
# two
# three
```

### Example 16: Skip Empty Input
```bash
# Don't run if no input
cat emptyfile.txt | xargs -r echo "Processing:"

# No output if file is empty
```

---

## Advanced Level

### Example 17: Complex Find and Process
```bash
# Find files modified today and archive
find /data -type f -mtime 0 -print0 | xargs -0 -I {} tar -rf backup.tar {}

# Adds each file to archive
```

### Example 18: Batch Processing with Count
```bash
# Process 100 files at a time
find . -name "*.log" | xargs -n 100 zip logs.zip

# Creates zip with batches of 100
```

### Example 19: Conditional Processing
```bash
# Process only if file is readable
find . -type f -readable -print0 | xargs -0 grep "pattern"

# Searches only readable files
```

### Example 20: Rename Files
```bash
# Batch rename
ls *.txt | xargs -I {} mv {} {}.bak

# Adds .bak extension to all .txt files
```

### Example 21: Max Command Line Length
```bash
# Limit command length
find . -name "*.o" | xargs -s 5000 rm

# Ensures command doesn't exceed 5000 chars
```

### Example 22: Multiple Replace Strings
```bash
# Complex transformation
cat files.txt | xargs -I FILE sh -c 'cp FILE backup/FILE && chmod 644 backup/FILE'

# Copy and change permissions
```

### Example 23: Parallel with Progress
```bash
# Show progress in parallel processing
cat tasks.txt | xargs -P 4 -I {} sh -c 'echo "Starting {}"; process "{}"; echo "Done {}"'

# Tracks parallel execution
```

### Example 24: Filter and Process
```bash
# Process specific files
ls -1 | grep "\.txt$" | xargs -I {} sh -c 'wc -l "{}" | cut -d" " -f1' | paste -sd+ | bc

# Sum lines in all .txt files
```

---

## Expert Level

### Example 25: Advanced Parallel Processing
```bash
# Parallel with resource control
find /data -name "*.gz" -print0 | xargs -0 -P $(nproc) -n 1 gunzip

# Decompresses using all CPU cores
```

### Example 26: Error Handling
```bash
# Continue on error
find . -name "*.txt" -print0 | xargs -0 -r sh -c 'cat "$@" || true' sh

# Doesn't stop on errors
```

### Example 27: Complex Pipeline
```bash
# Multi-stage processing
find . -name "*.log" -print0 | \
xargs -0 -P 4 -I {} sh -c 'grep "ERROR" "{}" | sed "s/^/{}:/" ' | \
sort | uniq -c | sort -nr

# Parallel grep, format, and aggregate
```

### Example 28: Dynamic Command Construction
```bash
# Build complex commands
cat servers.txt | xargs -I HOST sh -c 'ssh HOST "df -h | grep /data" | sed "s/^/HOST:/"'

# Runs command on multiple servers
```

### Example 29: Nested xargs
```bash
# Double xargs for matrix operations
cat users.txt | xargs -I USER echo "USER {}" | xargs -I CMD sh -c 'echo "Processing: CMD"'

# Nested processing
```

### Example 30: Memory-Efficient Processing
```bash
# Process large file lists efficiently
find /bigdata -type f -size +1G -print0 | \
xargs -0 -n 1 -P 4 sh -c 'process_large_file "$0" > "/output/$(basename "$0").result"'

# Parallel processing with controlled memory
```

### Example 31: Transaction-Like Processing
```bash
# Backup before modification
find . -name "*.conf" -print0 | \
xargs -0 -I {} sh -c 'cp "{}" "{}.bak" && sed -i "s/old/new/g" "{}" || mv "{}.bak" "{}"'

# Automatic rollback on failure
```

### Example 32: Complex Regex with xargs
```bash
# Extract and process
grep -r "TODO:" --include="*.js" -l | \
xargs -I {} sh -c 'echo "File: {}"; grep -n "TODO:" "{}" | sed "s/^/  Line /"'

# Formats TODO list from code
```

---

## Salesforce-Specific Examples

### Example 33: Deploy Multiple Classes
```bash
# Deploy Apex classes in parallel
find force-app -name "*.cls" -type f | \
xargs -P 3 -I {} sf project deploy start --source-dir {} --target-org dev

# Parallel deployment
```

### Example 34: Retrieve Metadata by Type
```bash
# Retrieve multiple metadata types
echo "ApexClass ApexTrigger LightningComponentBundle" | \
xargs -n 1 -I {} sf project retrieve start --metadata {}

# Sequential retrieval
```

### Example 35: Process Debug Logs
```bash
# Download and analyze logs
sf apex list log --json | jq -r '.[].Id' | \
xargs -I {} sh -c 'sf apex get log --log-id {} | grep ERROR > logs/error_{}.txt'

# Extracts errors from all logs
```

### Example 36: Execute Apex Scripts
```bash
# Run multiple Apex scripts
ls scripts/*.apex | xargs -I {} sh -c 'echo "Running {}"; sf apex run --file {}'

# Executes all Apex scripts
```

### Example 37: Query Multiple Objects
```bash
# SOQL queries in parallel
echo "Account Contact Opportunity" | \
xargs -P 3 -I {} sf data query --query "SELECT COUNT() FROM {}" --json | jq -r '.result.totalSize'

# Parallel record counts
```

### Example 38: Validate Components
```bash
# Check deploy validity
find force-app -name "*.cls" -print0 | \
xargs -0 -P 4 -I {} sf project deploy validate --source-dir {} --json | jq '.result.success'

# Parallel validation
```

---

## Generic Real-World Examples

### Example 39: Batch Image Processing
```bash
# Resize images in parallel
find . -name "*.jpg" -print0 | \
xargs -0 -P 4 -I {} convert {} -resize 800x600 resized/{}

# ImageMagick parallel processing
```

### Example 40: Git Operations
```bash
# Pull multiple repositories
find ~/projects -name ".git" -type d | \
sed 's/\.git$//' | \
xargs -I {} sh -c 'cd "{}" && echo "Pulling {}" && git pull'

# Updates all git repos
```

### Example 41: Log Rotation and Compression
```bash
# Compress old logs
find /var/log -name "*.log" -mtime +7 -print0 | \
xargs -0 -P 2 -I {} sh -c 'gzip "{}" && echo "Compressed {}"'

# Parallel compression
```

### Example 42: Database Backup
```bash
# Backup multiple databases
echo "db1 db2 db3" | \
xargs -P 3 -I {} sh -c 'mysqldump {} > backup/{}$(date +%Y%m%d).sql'

# Parallel database dumps
```

### Example 43: Server Health Checks
```bash
# Check multiple servers
cat servers.txt | \
xargs -P 10 -I {} sh -c 'ping -c 1 {} > /dev/null && echo "{}: UP" || echo "{}: DOWN"'

# Parallel ping checks
```

### Example 44: Clean Build Artifacts
```bash
# Remove build files from multiple projects
find ~/projects -name "node_modules" -type d -print0 | \
xargs -0 -I {} sh -c 'echo "Removing {}" && rm -rf "{}"'

# Cleans build directories
```

---

## Common Patterns & Recipes

### Pattern 1: Safe File Processing
```bash
# Process with backup
find . -name "*.conf" -print0 | \
xargs -0 -I {} sh -c 'cp "{}" "{}.backup" && process_file "{}"'
```

### Pattern 2: Parallel Download
```bash
# Download list of URLs
cat urls.txt | xargs -P 4 -I {} sh -c 'curl -O "{}" && echo "Downloaded {}"'
```

### Pattern 3: Batch File Conversion
```bash
# Convert multiple file formats
find . -name "*.md" -print0 | \
xargs -0 -P 4 -I {} sh -c 'pandoc "{}" -o "{}.pdf"'
```

### Pattern 4: Distributed Task Execution
```bash
# Run tasks across servers
cat tasks.txt | \
xargs -I TASK sh -c 'SERVER=$(get_next_server); ssh $SERVER "run_task TASK"'
```

### Pattern 5: Aggregated Report Generation
```bash
# Process and combine results
find . -name "*.log" -print0 | \
xargs -0 -P 4 grep "ERROR" | \
sort | uniq -c | sort -nr > error_report.txt
```

---

## Practice Problems

### Beginner (1-8)

1. Delete files listed in filelist.txt
2. Count lines in all .txt files using xargs
3. Echo each argument on a separate line
4. Create multiple directories from a list
5. Copy files with verbose output
6. Find and remove temporary files
7. Show command before execution with -t
8. Interactive file deletion with -p

### Intermediate (9-16)

9. Use placeholder to rename files
10. Process files one at a time with -n 1
11. Handle filenames with spaces using -0
12. Download multiple URLs in parallel
13. Process two arguments per command call
14. Use custom delimiter (comma)
15. Skip execution on empty input with -r
16. Execute commands from file line by line

### Advanced (17-24)

17. Find and archive files modified today
18. Batch process files (100 at a time)
19. Rename files with custom pattern
20. Parallel compression of log files
21. Complex pipeline with grep and xargs
22. Multiple replace strings in command
23. Process with progress tracking
24. Filter and process with line count

### Expert (25-32)

25. Parallel processing using all CPU cores
26. Error handling with continue-on-failure
27. Multi-stage pipeline with aggregation
28. Dynamic command construction for remote servers
29. Nested xargs for matrix operations
30. Memory-efficient large file processing
31. Transaction-like processing with rollback
32. Complex extraction and formatting

---

**Solutions**: [xargs Practice Solutions](../04-practice/xargs-solutions.md)

**Next**: [find - Search Files](./find.md)
