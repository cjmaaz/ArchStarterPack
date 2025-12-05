# echo - Print Text and Variables

Output text to terminal or files.

---

## 📋 Quick Reference

```bash
echo "Hello World"                 # Print text
echo $USER                         # Print variable
echo "User: $USER"                 # Embed variable in string
echo -n "No newline"               # Suppress newline
echo -e "Line1\nLine2"             # Enable escape sequences
echo "Text" > file.txt             # Write to file
echo "More" >> file.txt            # Append to file
echo $?                            # Print last exit code
echo {1..10}                       # Brace expansion
echo *                             # Glob expansion
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-n` | No trailing newline | `echo -n "text"` |
| `-e` | Enable escape sequences | `echo -e "line1\nline2"` |
| `-E` | Disable escape sequences | `echo -E "raw\ntext"` |

### Escape Sequences (with -e)

| Sequence | Effect | Example |
|----------|--------|---------|
| `\n` | Newline | `echo -e "A\nB"` |
| `\t` | Tab | `echo -e "A\tB"` |
| `\r` | Carriage return | `echo -e "A\rB"` |
| `\b` | Backspace | `echo -e "ABC\b"` |
| `\\` | Backslash | `echo -e "A\\B"` |
| `\c` | Suppress trailing newline | `echo -e "text\c"` |
| `\a` | Alert (bell) | `echo -e "\a"` |

---

## Beginner Level

### Example 1: Basic Text Output
```bash
# Simple print
echo "Hello World"

# Output: Hello World
```

### Example 2: Print Variable
```bash
# Display variable value
NAME="John"
echo $NAME

# Output: John
```

### Example 3: Embed Variable in Text
```bash
# Mix text and variables
USER="Alice"
echo "Welcome, $USER!"

# Output: Welcome, Alice!
```

### Example 4: Multiple Arguments
```bash
# Space-separated arguments
echo one two three

# Output: one two three
```

### Example 5: Write to File
```bash
# Create file with content
echo "Hello World" > greeting.txt

# Overwrites file
```

### Example 6: Append to File
```bash
# Add to existing file
echo "New line" >> greeting.txt

# Preserves existing content
```

### Example 7: Empty Line
```bash
# Print blank line
echo

# Outputs single newline
```

### Example 8: Print Special Variable
```bash
# Last command exit code
ls /nonexistent 2>/dev/null
echo $?

# Output: 2 (error code)
```

---

## Intermediate Level

### Example 9: Suppress Newline
```bash
# No newline at end
echo -n "Enter name: "
read name

# Prompt stays on same line
```

### Example 10: Newline in Text
```bash
# Multi-line output
echo -e "Line 1\nLine 2\nLine 3"

# Output:
# Line 1
# Line 2
# Line 3
```

### Example 11: Tab Character
```bash
# Tab-separated values
echo -e "Name\tAge\tCity"
echo -e "John\t30\tNYC"

# Creates column alignment
```

### Example 12: Brace Expansion
```bash
# Generate sequence
echo {1..10}

# Output: 1 2 3 4 5 6 7 8 9 10
```

### Example 13: Alphabet Range
```bash
# Letter sequence
echo {A..Z}

# Output: A B C D E F G ... Z
```

### Example 14: Pattern Expansion
```bash
# Generate variations
echo file{1,2,3}.txt

# Output: file1.txt file2.txt file3.txt
```

### Example 15: Glob Expansion
```bash
# List matching files
echo *.txt

# Shows all .txt files
```

### Example 16: Command Substitution
```bash
# Embed command output
echo "Today is $(date +%A)"

# Output: Today is Friday
```

---

## Advanced Level

### Example 17: Color Output
```bash
# Red text
echo -e "\033[31mError\033[0m"

# Green text
echo -e "\033[32mSuccess\033[0m"

# \033[31m = red color code
# \033[0m = reset
```

### Example 18: Multiple Escape Sequences
```bash
# Combine escapes
echo -e "Name:\tJohn\nAge:\t30\nCity:\tNYC"

# Formatted output:
# Name:  John
# Age:   30
# City:  NYC
```

### Example 19: Carriage Return Effect
```bash
# Overwrite line
echo -n "Processing..."
sleep 2
echo -e "\rComplete!     "

# Overwrites "Processing..."
```

### Example 20: Alert Bell
```bash
# Sound alert
echo -e "\aAttention!"

# Triggers system beep (if enabled)
```

### Example 21: Backspace Effect
```bash
# Delete characters
echo -e "ABC\b\bXY"

# Output: AXY (overwrote BC)
```

### Example 22: Escape Quote Characters
```bash
# Print quotes
echo "He said \"Hello\""

# Output: He said "Hello"
```

### Example 23: Print Literal Backslash
```bash
# Show backslash
echo "Path: C:\\Users\\John"

# Output: Path: C:\Users\John
```

### Example 24: Here String Alternative
```bash
# Pass to command
echo "content" | grep "con"

# Filters echo output
```

---

## Expert Level

### Example 25: Dynamic Variable Names
```bash
# Indirect variable reference
VAR_NAME="USER"
echo ${!VAR_NAME}

# Prints value of $USER
```

### Example 26: Array Printing
```bash
# Display array elements
COLORS=("red" "green" "blue")
echo "${COLORS[@]}"

# Output: red green blue
```

### Example 27: Multiline String
```bash
# Preserve formatting
echo "Line 1
Line 2
Line 3"

# Maintains line breaks
```

### Example 28: Progress Bar Simulation
```bash
# Simple progress indicator
for i in {1..50}; do
    echo -n "#"
    sleep 0.1
done
echo -e "\nDone!"

# Creates loading bar
```

### Example 29: Conditional Output
```bash
# Output based on condition
[ -f "file.txt" ] && echo "File exists" || echo "File not found"

# One-liner conditional message
```

### Example 30: Format JSON
```bash
# Create JSON structure
echo "{\"name\": \"John\", \"age\": 30}"

# Escaped quotes for JSON
```

### Example 31: Parameter Expansion
```bash
# Default value
echo "User: ${USER:-anonymous}"

# Uses 'anonymous' if USER unset
```

### Example 32: Arithmetic in echo
```bash
# Calculate and print
echo "Result: $((5 * 10))"

# Output: Result: 50
```

---

## Salesforce-Specific Examples

### Example 33: Display Org Info
```bash
# Show current org
ORG=$(sf config get target-org --json | jq -r '.result[0].value')
echo "Current org: $ORG"

# Displays configured org
```

### Example 34: Deployment Message
```bash
# Deployment notification
echo -e "\033[32m✓\033[0m Deployment to $(sf config get target-org --json | jq -r '.result[0].value') successful"

# Green checkmark with org name
```

### Example 35: Create Apex Script
```bash
# Generate Apex code
echo "System.debug('Hello from Apex');" > script.apex
sf apex run --file script.apex

# Quick Apex execution
```

### Example 36: Log Deployment Info
```bash
# Timestamped log entry
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deploying to production" >> deploy.log

# Maintains deployment history
```

### Example 37: Generate SOQL Query
```bash
# Dynamic query construction
OBJECT="Account"
FIELD="Name"
echo "SELECT Id, $FIELD FROM $OBJECT LIMIT 10"

# Output: SELECT Id, Name FROM Account LIMIT 10
```

### Example 38: Test Execution Banner
```bash
# Test run header
echo -e "\n========================================\n  Running Apex Tests\n========================================\n"
sf apex run test --test-level RunLocalTests

# Formatted test execution
```

---

## Generic Real-World Examples

### Example 39: Script Progress Messages
```bash
# Informative script output
echo "Starting backup process..."
backup_data.sh
echo "Backup complete!"
echo "Files backed up: $(ls backup/ | wc -l)"

# User-friendly feedback
```

### Example 40: Create .env File
```bash
# Generate environment config
echo "DB_HOST=localhost" > .env
echo "DB_PORT=5432" >> .env
echo "DB_NAME=myapp" >> .env

# Creates configuration file
```

### Example 41: Log File Entries
```bash
# Structured logging
echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Application started" >> app.log
echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Connection failed" >> app.log

# Timestamped log entries
```

### Example 42: Generate CSV Data
```bash
# Create CSV file
echo "Name,Age,City" > data.csv
echo "John,30,NYC" >> data.csv
echo "Alice,25,LA" >> data.csv

# Simple CSV generation
```

### Example 43: Docker Commands
```bash
# Display container info
echo "Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"

# Formatted Docker output
```

### Example 44: System Information
```bash
# Display system details
echo "Hostname: $(hostname)"
echo "OS: $(uname -s)"
echo "User: $USER"
echo "Shell: $SHELL"

# System info summary
```

---

## Common Patterns & Recipes

### Pattern 1: Colorized Messages
```bash
# Success/Error messaging
success() { echo -e "\033[32m✓ $1\033[0m"; }
error() { echo -e "\033[31m✗ $1\033[0m"; }

success "Operation completed"
error "Something went wrong"
```

### Pattern 2: Debug Mode Output
```bash
# Conditional debug output
DEBUG=true
debug() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $*" >&2
    fi
}

debug "Variable value: $VAR"
```

### Pattern 3: Confirm Prompt
```bash
# User confirmation
echo -n "Are you sure? (y/n): "
read answer
if [ "$answer" = "y" ]; then
    echo "Proceeding..."
else
    echo "Aborted."
fi
```

### Pattern 4: Progress Indicator
```bash
# Show progress
echo -n "Processing"
for i in {1..5}; do
    sleep 1
    echo -n "."
done
echo " Done!"

# Output: Processing..... Done!
```

### Pattern 5: Box Drawing
```bash
# Create text box
MESSAGE="Important Notice"
LENGTH=${#MESSAGE}
echo "+$(printf '%*s' $((LENGTH+2)) | tr ' ' '-')+"
echo "| $MESSAGE |"
echo "+$(printf '%*s' $((LENGTH+2)) | tr ' ' '-')+"
```

---

## Practice Problems

### Beginner (1-8)

1. Print "Hello World" to terminal
2. Print the value of $USER variable
3. Create a file with text using echo
4. Append text to an existing file
5. Print numbers 1 to 5 on separate lines
6. Display current date in echo
7. Print multiple words with spaces
8. Print an empty line

### Intermediate (9-16)

9. Print text without newline
10. Print text with embedded newline
11. Create tab-separated output
12. Generate sequence using brace expansion
13. Print all .txt files using glob
14. Display colored text (green)
15. Print last command exit code
16. Create multi-line output with formatting

### Advanced (17-24)

17. Create colored success/error messages
18. Simulate progress bar with echo
19. Print with carriage return to overwrite
20. Generate JSON string with echo
21. Use conditional echo with &&/||
22. Print array elements
23. Create formatted table output
24. Display variable with default value

### Expert (25-32)

25. Create custom logging function
26. Build dynamic command from echo
27. Generate config file with variables
28. Create interactive prompt
29. Print formatted report with colors
30. Build CSV file programmatically
31. Create menu system with echo
32. Advanced text formatting with boxes

---

**Solutions**: [echo Practice Solutions](../04-practice/echo-solutions.md)

**Next**: [xargs - Command Builder](./xargs.md)
