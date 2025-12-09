# Shell Commands Practice Environment

**Last Updated:** December 2025

A hands-on learning environment with real files, sample data, and interactive exercises for mastering Unix/Linux shell commands.

---

## 🎯 Purpose

This practice environment provides:

- **Real Data Files**: Logs, JSON, CSV, text files - not toy examples
- **Immediate Practice**: Execute commands right after learning concepts
- **Safe Learning**: Make mistakes without consequences
- **Production-Like Scenarios**: Realistic data formats and patterns
- **Self-Contained**: No external dependencies required

---

## 🚀 Quick Start

### First Time Setup

```bash
# Navigate to practice environment
cd shell-commands/practice-environment

# Run setup (one-time)
./setup.sh

# You're ready to practice!
grep "ERROR" data/logs/application.log
```

### Reset Environment

```bash
# Clean up and start fresh
./reset.sh

# Re-run setup
./setup.sh
```

---

## 📁 Directory Structure

```
practice-environment/
├── data/                    # Sample data files
│   ├── logs/               # Application & web server logs
│   ├── json/               # JSON data (Salesforce, APIs)
│   ├── csv/                # CSV datasets (accounts, sales)
│   ├── text/               # Text files (code, URLs, emails)
│   ├── xml/                # XML files (Salesforce metadata)
│   └── archives/           # Compressed files for tar/zip practice
├── generators/             # Scripts to generate additional data
├── helpers/                # Utility scripts (failing commands, simulators)
├── exercises/              # Interactive practice exercises
│   ├── beginner/
│   ├── intermediate/
│   ├── advanced/
│   └── expert/
└── scenarios/              # Real-world challenge problems
```

---

## 📚 Sample Data Files

### Log Files (`data/logs/`)

**`application.log`** - Generic application logs

- 500+ lines with timestamps
- Mix of INFO, WARN, ERROR, FATAL levels
- Stack traces and error patterns
- IP addresses and user IDs
- **Practice:** grep, tail, awk, sed

**`apex-debug.log`** - Salesforce Apex debug log

- Real Apex log format
- SOQL queries and DML operations
- Governor limits
- Code execution flow
- **Practice:** Salesforce log analysis patterns

**`deployment.log`** - Salesforce deployment output

- Component successes/failures
- Test results and coverage
- Error messages with line numbers
- **Practice:** Deployment debugging

**`web-access.log`** - Apache/Nginx format

- Combined log format
- HTTP status codes (200, 404, 500)
- User agents and IP addresses
- **Practice:** Web server log analysis

### JSON Files (`data/json/`)

**`sf-query-result.json`** - Salesforce CLI output

- Actual `sf data query` format
- Records array with metadata
- **Practice:** jq filtering, extraction

**`api-response.json`** - REST API responses

- Nested JSON structures
- Arrays of objects
- **Practice:** jq transformations

**`deploy-result.json`** - SF deployment result

- Component failures
- Test results
- **Practice:** Error extraction

### CSV Files (`data/csv/`)

**`accounts.csv`** - Salesforce Accounts (100+ rows)

- Id, Name, Industry, Revenue, City
- **Practice:** awk, cut, sort, filter

**`sales-data.csv`** - Sales transactions (1000+ rows)

- Date, Product, Quantity, Price, Region
- **Practice:** Aggregation, grouping

**`large-dataset.csv`** - Performance testing (10K+ rows)

- **Practice:** Efficient processing

### Text Files (`data/text/`)

**`sample-code.cls`** - Apex class files

- Multiple classes and methods
- **Practice:** Pattern matching, extraction

**`urls.txt`** - URL list

- HTTP/HTTPS URLs
- **Practice:** Domain extraction, filtering

**`emails.txt`** - Email addresses

- Various formats
- **Practice:** Regex patterns, validation

---

## 🧪 Usage Examples

### Text Processing

```bash
# Count ERROR lines
grep -c "ERROR" data/logs/application.log

# Extract unique error types
grep "ERROR" data/logs/application.log | \
  awk '{print $4}' | sort | uniq -c | sort -nr

# Find errors with context
grep -C 3 "NullPointerException" data/logs/application.log
```

### JSON Processing

```bash
# Extract all account names
jq -r '.result.records[].Name' data/json/sf-query-result.json

# Filter by field value
jq '.result.records[] | select(.Industry == "Technology")' \
  data/json/sf-query-result.json

# Count records
jq '.result.totalSize' data/json/sf-query-result.json
```

### CSV Processing

```bash
# Show first 10 accounts
head -10 data/csv/accounts.csv

# Extract specific columns
cut -d',' -f2,3,4 data/csv/accounts.csv

# Filter by industry
awk -F',' '$3 == "Technology" {print $2}' data/csv/accounts.csv

# Calculate total revenue
awk -F',' 'NR>1 {sum+=$4} END {print sum}' data/csv/accounts.csv
```

### Piping Patterns

```bash
# Top 10 error types
cat data/logs/application.log | \
  grep "ERROR" | \
  awk '{print $4}' | \
  sort | uniq -c | \
  sort -nr | \
  head -10

# Find IPs with most 404s
grep " 404 " data/logs/web-access.log | \
  awk '{print $1}' | \
  sort | uniq -c | \
  sort -nr
```

---

## 🎓 Learning Paths

### 🌟 Path 1: Interactive Tutorials (Recommended)

**Best for beginners!** Run guided exercises with instant feedback:

```bash
# Week 1: Beginner Exercises (5 tutorials)
./exercises/beginner/01-grep-basics.sh          # 10 min
./exercises/beginner/02-piping-basics.sh         # 10 min
./exercises/beginner/03-json-processing.sh       # 15 min (requires jq)
./exercises/beginner/04-file-operations.sh       # 10 min
./exercises/beginner/05-csv-basics.sh            # 15 min

# Week 2: Intermediate Scenarios (3 tutorials)
./exercises/intermediate/01-log-analysis.sh      # 20 min
./exercises/intermediate/02-salesforce-analysis.sh # 25 min
./exercises/intermediate/03-data-transformation.sh # 20 min

# Week 3: Advanced Challenges (2 tutorials)
./exercises/advanced/01-complex-pipelines.sh     # 30 min
./exercises/advanced/02-automation-scripts.sh    # 30 min

# Week 4: Expert Level (1 tutorial)
./exercises/expert/01-production-scenarios.sh    # 45 min
```

**Why choose this path?**

- ✅ Interactive guidance with hints
- ✅ Step-by-step explanations
- ✅ Instant result verification
- ✅ Real sample data
- ✅ Progressive difficulty

📖 **See full guide:** `cat exercises/README.md`

---

### Path 2: Self-Paced Documentation

**For independent learners who prefer reading:**

1. **Basic Commands**

   ```bash
   cat data/logs/application.log              # View file
   grep "ERROR" data/logs/application.log     # Search
   wc -l data/logs/application.log            # Count lines
   head -20 data/csv/accounts.csv             # First 20 lines
   tail -20 data/csv/accounts.csv             # Last 20 lines
   ```

2. **Practice Files**

   - `data/logs/application.log`
   - `data/csv/accounts.csv`
   - `data/text/urls.txt`

3. **Commands to Master**
   - grep, cat, head, tail, wc

### Path 3: Intermediate (Week 2-3)

1. **Text Processing**

   ```bash
   # Extract and count
   grep "ERROR" data/logs/application.log | wc -l

   # Sort and deduplicate
   cat data/text/emails.txt | sort | uniq

   # Column extraction
   cut -d',' -f2,3 data/csv/accounts.csv
   ```

2. **Practice Files**

   - All log files
   - All CSV files
   - JSON files with jq

3. **Commands to Master**
   - awk, sed, cut, sort, uniq, tr

### Path 4: Advanced (Week 4-5)

1. **Complex Pipelines**

   ```bash
   # Multi-stage processing
   cat data/logs/application.log | \
     grep "ERROR" | \
     sed 's/.*ERROR: //' | \
     sort | uniq -c | \
     sort -nr | \
     head -20
   ```

2. **JSON Processing**

   ```bash
   # Extract and transform
   jq -r '.result.records[] |
     select(.AnnualRevenue > 1000000) |
     "\(.Name): $\(.AnnualRevenue)"' \
     data/json/sf-query-result.json
   ```

3. **Commands to Master**
   - jq, xargs, find, comm, paste

### Path 4: Expert (Week 6+)

1. **Build Automation Scripts**
2. **Real-world scenarios**
3. **Performance optimization**
4. **Complex data transformations**

---

## 🛠️ Helper Scripts

### Generators (`generators/`)

```bash
# Generate additional log files
./generators/generate-logs.sh --lines 5000 --error-rate 10

# Generate JSON test data
./generators/generate-json.sh --records 100

# Generate CSV datasets
./generators/generate-csv.sh --rows 50000
```

### Utilities (`helpers/`)

```bash
# Simulate failing command (for error handling practice)
./helpers/failing-command.sh 1 "Connection timeout"

# Long-running process (for monitoring practice)
./helpers/slow-process.sh

# Create test file structure (for find practice)
./helpers/create-test-files.sh
```

---

## 📝 Practice Exercises

### Beginner Exercises

Located in `exercises/beginner/`:

- `01-grep-basics.sh` - Guided grep tutorial
- `02-pipe-practice.sh` - Basic piping
- `03-file-operations.sh` - cat, head, tail
- Solutions in `solutions/` directory

### Intermediate Exercises

Located in `exercises/intermediate/`:

- `01-log-analysis.sh` - Real log analysis
- `02-data-processing.sh` - CSV/JSON processing
- `03-text-transformation.sh` - sed, awk, tr

### Advanced Exercises

Located in `exercises/advanced/`:

- `01-complex-pipelines.sh` - Multi-stage processing
- `02-performance.sh` - Optimization techniques
- `03-automation.sh` - Script building

### Expert Exercises

Located in `exercises/expert/`:

- `01-real-world.sh` - Production scenarios
- `02-salesforce.sh` - SF CLI automation
- `03-challenges.sh` - Complex problems

---

## 🏆 Real-World Scenarios

### Scenario 1: Deployment Failure

```bash
cd scenarios/deployment-failure
cat README.md  # Read the challenge
# Use skills to debug the deployment
```

### Scenario 2: Log Investigation

```bash
cd scenarios/log-investigation
# Find root cause of production incident
```

### Scenario 3: Data Migration

```bash
cd scenarios/data-migration
# Transform and validate data
```

### Scenario 4: Performance Tuning

```bash
cd scenarios/performance-tuning
# Optimize slow scripts
```

---

## 💡 Tips for Success

1. **Type, Don't Copy-Paste**

   - Build muscle memory
   - Understand what you're doing

2. **Experiment**

   - Try variations
   - Break things (it's safe here!)

3. **Read Error Messages**

   - Errors teach you

4. **Use Man Pages**

   ```bash
   man grep
   man awk
   man jq
   ```

5. **Practice Daily**

   - 15-20 minutes per day
   - Consistency beats intensity

6. **Build Your Own**
   - Create your own exercises
   - Solve real problems

---

## 🔧 Troubleshooting

### Setup Issues

**Problem:** `./setup.sh` fails with permission error

```bash
# Solution: Make executable
chmod +x setup.sh
./setup.sh
```

**Problem:** Data files not generated

```bash
# Solution: Check generators
ls -la generators/
# Ensure they're executable
chmod +x generators/*.sh
```

### Practice Issues

**Problem:** Command not found

```bash
# Check if command is installed
which grep
which jq
which awk

# Install if missing (Arch Linux)
sudo pacman -S grep gawk jq
```

**Problem:** File not found

```bash
# Ensure you're in correct directory
pwd  # Should be in practice-environment/

# Navigate if needed
cd shell-commands/practice-environment
```

---

## 📊 Track Your Progress

### Beginner Checklist

- [ ] Complete 10 grep exercises
- [ ] Master basic piping
- [ ] Use cat, head, tail effectively
- [ ] Count lines with wc
- [ ] Sort and deduplicate with sort/uniq

### Intermediate Checklist

- [ ] Extract columns with awk/cut
- [ ] Transform text with sed
- [ ] Process JSON with jq
- [ ] Build 3-stage pipelines
- [ ] Analyze logs efficiently

### Advanced Checklist

- [ ] Build automation scripts
- [ ] Optimize performance
- [ ] Handle complex JSON
- [ ] Master xargs and find
- [ ] Complete all scenarios

### Expert Checklist

- [ ] Create your own tools
- [ ] Contribute patterns
- [ ] Help others learn
- [ ] Solve production problems

---

## 🤝 Contributing

Found a bug? Want to add more scenarios?

1. Create additional sample data
2. Write new exercises
3. Share your solutions
4. Submit pull requests

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines.

---

## 📚 Additional Resources

- [Main Shell Commands Guide](../README.md)
- [Command Tutorials](../02-commands/)
- [Practice Exercises](../04-practice/)
- [Salesforce Patterns](../05-salesforce/)

---

## ⚠️ Important Notes

- **Safe Environment**: All practice is sandboxed
- **No Internet Required**: Everything is local
- **Reset Anytime**: `./reset.sh` restores clean state
- **Version Control**: Files are in git, safe to experiment

---

**Ready to begin? Run `./setup.sh` and start practicing!** 🚀
