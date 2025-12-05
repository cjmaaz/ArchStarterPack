# Shell Commands Mastery Guide

Complete guide to Unix/Linux shell commands used in Salesforce development and automation.

---

## 📚 Course Structure

### **Part 1: Fundamentals**
- [Shell Operators & Symbols](./01-basics/operators.md) - `|`, `>`, `>>`, `2>&1`, `&&`, `||`
- [Input/Output Redirection](./01-basics/redirection.md) - stdin, stdout, stderr

### **Part 2: Essential Commands**

**Text Processing:**
- [grep - Search & Filter](./02-commands/grep.md) - Text pattern matching
- [sed - Stream Editor](./02-commands/sed.md) - Text transformation
- [awk - Text Processing](./02-commands/awk.md) - Column-based processing
- [cut - Extract Columns](./02-commands/cut.md) - Extract fields and columns
- [sort - Sort Lines](./02-commands/sort.md) - Sort text lines
- [uniq - Filter Duplicates](./02-commands/uniq.md) - Remove duplicate lines
- [tr - Translate Characters](./02-commands/tr.md) - Transform characters
- [wc - Count Lines/Words](./02-commands/wc.md) - Count lines, words, bytes

**File Operations:**
- [find - Search Files](./02-commands/find.md) - Find files and directories
- [tail/head - File Viewing](./02-commands/tail-head.md) - View file portions
- [cat - Concatenate](./02-commands/cat.md) - Display & combine files
- [diff - Compare Files](./02-commands/diff.md) - Show file differences
- [tee - Duplicate Output](./02-commands/tee.md) - Split output streams

**System & Process:**
- [ps - Process Status](./02-commands/ps.md) - Display running processes
- [top - System Monitor](./02-commands/top.md) - Real-time process monitoring
- [df/du - Disk Usage](./02-commands/df-du.md) - Filesystem and directory space

**Archives & Compression:**
- [tar - Archive Files](./02-commands/tar.md) - Create and extract archives
- [zip/unzip - ZIP Files](./02-commands/zip.md) - ZIP compression
- [gzip/gunzip - Compression](./02-commands/gzip.md) - GNU compression

**Network & Download:**
- [curl - Transfer Data](./02-commands/curl.md) - Download and API calls
- [wget - Download Files](./02-commands/wget.md) - Network downloader
- [ping - Test Connectivity](./02-commands/ping.md) - Network connectivity test
- [netstat - Network Stats](./02-commands/netstat.md) - Network connections

**Advanced Text:**
- [jq - JSON Processor](./02-commands/jq.md) - Parse JSON data
- [comm - Compare Sorted](./02-commands/comm.md) - Compare sorted files
- [paste - Merge Lines](./02-commands/paste.md) - Merge file lines
- [column - Format Columns](./02-commands/column.md) - Columnize output

**Shell Utilities:**
- [echo - Print Text](./02-commands/echo.md) - Output text
- [xargs - Command Builder](./02-commands/xargs.md) - Build commands from input
- [date - Date/Time](./02-commands/date.md) - Display and format dates
- [chmod - Permissions](./02-commands/chmod.md) - Change file permissions
- [env - Environment](./02-commands/env.md) - Environment variables
- [alias - Shortcuts](./02-commands/alias.md) - Command aliases
- [history - Command History](./02-commands/history.md) - Command history management

### **Part 3: Command Combinations**
- [Piping Patterns](./03-combinations/piping.md) - Chain commands with `|`
- [Command Chaining](./03-combinations/chaining.md) - Sequential execution
- [Linux System Patterns](./03-combinations/linux-system-patterns.md) - Generic system administration
- [Advanced Patterns](./03-combinations/advanced-patterns.md) - Complex workflows

### **Part 4: Practice Exercises**
- [Beginner Level](./04-practice/beginner.md) - 20 exercises ✅
- [Intermediate Level](./04-practice/intermediate.md) - 20 exercises ✅
- [Advanced Level](./04-practice/advanced.md) - 20 exercises ✅
- [Expert Level](./04-practice/expert.md) - 20 exercises ✅

### **Part 5: Salesforce-Specific**
- [SF CLI Integration](./05-salesforce/sf-cli-patterns.md) - Salesforce CLI workflows
- [Apex Log Analysis](./05-salesforce/log-analysis.md) - Parse & filter logs
- [Deployment Scripts](./05-salesforce/deployment-scripts.md) - Automation patterns

---

## 🎯 Learning Path

### **Week 1: Basics**
1. Read operators.md
2. Complete beginner practice (1-10)
3. Read grep.md and tail-head.md
4. Complete beginner practice (11-20)

### **Week 2: Core Commands**
1. Read sed.md and awk.md
2. Complete intermediate practice (1-10)
3. Read jq.md and xargs.md
4. Complete intermediate practice (11-20)

### **Week 3: Combinations**
1. Read piping.md and chaining.md
2. Complete advanced practice (1-10)
3. Read advanced-patterns.md
4. Complete advanced practice (11-20)

### **Week 4: Mastery**
1. Complete expert practice (1-20)
2. Read SF CLI integration guides
3. Build your own automation scripts

---

## 🔥 Quick Reference

### Most Common Patterns

**Generic Linux:**
```bash
# Monitor system logs for errors
tail -f /var/log/syslog | grep --color=always -iE "error|fail"

# Find large files
find /var/log -type f -size +100M -exec ls -lh {} \;

# Extract IP addresses from access log
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log | sort | uniq -c

# Parse JSON API response
curl -s "https://api.example.com/users" | jq -r '.users[].name'

# Process CSV data
awk -F',' '$3 > 100 {print $1","$2","$3}' data.csv

# Check Docker container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Salesforce-Specific:**
```bash
# Filter and format Apex logs
sf apex run --file script.apex | grep "ERROR" | tail -10

# Deploy with test validation
sf project deploy start && sf apex run test --test-level RunLocalTests

# Process SOQL query results
sf data query --query "SELECT Id FROM Account" --json | jq '.result.records[]'

# Extract deployment errors
sf project deploy start --json | jq -r '.result.details.componentFailures[]'
```

**Data Processing:**
```bash
# Count occurrences
grep "pattern" file.txt | wc -l

# Extract and sort columns
cat data.csv | awk -F',' '{print $2}' | sort | uniq -c

# Save output and errors
command 2>&1 | tee output.log

# Chain commands conditionally
backup && verify || alert
```

---

## 📖 How to Use This Guide

1. **Read**: Each topic has explanations and examples
2. **Practice**: Try examples in your terminal
3. **Exercise**: Complete practice problems
4. **Review**: Check solutions and explanations

---

## 🛠️ Prerequisites

- Access to a Unix/Linux terminal (macOS, Linux, or WSL on Windows)
- Basic command line familiarity
- Salesforce CLI installed (for SF-specific sections)

---

## 💡 Tips for Success

1. **Type, Don't Copy**: Type commands manually to build muscle memory
2. **Experiment**: Try variations of examples
3. **Read Errors**: Understanding errors is key to learning
4. **Build Incrementally**: Start simple, add complexity
5. **Document**: Keep notes of useful patterns

---

## 🎓 Certification

Complete all 80 practice exercises to earn your "Shell Master" badge! 🏆

Track your progress:
- [ ] Beginner (20/20)
- [ ] Intermediate (20/20)
- [ ] Advanced (20/20)
- [ ] Expert (20/20)

---

**Ready to begin? Start with [Shell Operators](./01-basics/operators.md)!**
