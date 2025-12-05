# column - Format Output in Columns

Format text into aligned columns for better readability.

---

## 📋 Quick Reference

```bash
column -t file.txt                  # Auto-detect columns
column -t -s ',' file.csv           # CSV to table
column -t -s ':' /etc/passwd        # Format with colon delimiter
cat data.txt | column -t            # Format from pipe
column -t -N Name,Age,City data.txt # Named columns
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-t` | Table format |
| `-s CHAR` | Column delimiter |
| `-N NAMES` | Column names |
| `-o CHAR` | Output separator |

---

## Examples

### Basic Formatting
```bash
# Simple table
echo -e "Name Age City\nJohn 30 NYC\nJane 25 LA" | column -t
# Output:
# Name  Age  City
# John  30   NYC
# Jane  25   LA

# CSV to table
column -t -s ',' data.csv

# /etc/passwd formatted
column -t -s ':' /etc/passwd | less
```

### With Headers
```bash
# Named columns
column -t -N "ID,Name,Value" -s ',' data.csv

# Custom output separator
column -t -s ',' -o ' | ' data.csv
```

### Practical Uses
```bash
# Format ps output
ps aux | column -t

# Format du output
du -h */ | column -t

# Create aligned list
cat items.txt prices.txt | paste -d ',' - - | column -t -s ','

# Salesforce org list formatted
sf org list | column -t
```

### Complex Example
```bash
# Generate formatted report
{
    echo "Component,Lines,Files"
    find force-app -name "*.cls" | wc -l | xargs echo "ApexClasses,"
    find force-app -name "*.trigger" | wc -l | xargs echo "Triggers,"
    find force-app -name "*.js" | wc -l | xargs echo "LWC,"
} | column -t -s ','
```

---

**Next**: [zip - Compress Files](./zip.md)
