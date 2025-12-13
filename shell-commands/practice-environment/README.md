# Shell Commands Practice Environment

**Complete guide to practicing Unix/Linux shell commands with real data and interactive exercises.**

---

## 🚀 Quick Start (30 seconds)

**Choose your path:**

```
┌─────────────────────────────────────────┐
│  Are you NEW to shell commands?         │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
       YES                     NO
        │                       │
        ▼                       ▼
┌───────────────┐      ┌──────────────────┐
│ Watch Examples│      │ Practice Yourself│
│ cd demos/     │      │ cd practice/     │
└───────────────┘      └──────────────────┘
```

### Path 1: New to Shell Commands

```bash
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
# Press Enter to see each example
```

### Path 2: Know Basics, Want to Practice

```bash
cd shell-commands/practice-environment/practice
./practice-menu.sh
# Select a command → Type commands → Get feedback
```

### Path 3: Want to Use Real Data Files

```bash
cd shell-commands/practice-environment
./setup.sh  # One-time setup
grep "ERROR" data/logs/application.log
```

---

## 📚 Sections

### Section 1: Interactive Practice (`practice/`) ⭐ RECOMMENDED

**What:** Type commands yourself and get immediate validation feedback. System checks your answers automatically.

**When to use:**

- You know basic commands and want to practice
- You want to test your knowledge
- You want to track your progress
- You want immediate feedback on your answers

**How to launch:**

**Option 1: Interactive Menu (Easiest)**

```bash
cd shell-commands/practice-environment/practice
./practice-menu.sh
# Select category → Select command → Start practicing
```

**Option 2: Direct Command Practice**

```bash
cd shell-commands/practice-environment/practice
./commands/grep-practice.sh
# Type commands when prompted
```

**What happens:**

1. System shows you a question (e.g., "Count lines containing 'ERROR'")
2. You type your command
3. System executes it and checks if output matches expected result
4. You get immediate feedback: ✓ Correct or ✗ Try again
5. After 3 wrong attempts, solution is shown
6. Your progress is saved automatically

**Available Commands (35 total, 383 exercises):**

**High Priority (Start Here):**

- `grep-practice.sh` - 15 exercises (pattern matching)
- `awk-practice.sh` - 15 exercises (text processing)
- `sed-practice.sh` - 15 exercises (stream editing)
- `jq-practice.sh` - 15 exercises (JSON processing)
- `find-practice.sh` - 15 exercises (file searching)

**All 35 Commands:**

**Text Processing (8):**

- `grep-practice.sh` - 15 exercises
- `awk-practice.sh` - 15 exercises
- `sed-practice.sh` - 15 exercises
- `cut-practice.sh` - 12 exercises
- `sort-practice.sh` - 12 exercises
- `uniq-practice.sh` - 10 exercises
- `wc-practice.sh` - 10 exercises
- `tr-practice.sh` - 10 exercises

**File Operations (7):**

- `cat-practice.sh` - 10 exercises
- `head-practice.sh` - 10 exercises
- `tail-practice.sh` - 12 exercises
- `find-practice.sh` - 15 exercises
- `diff-practice.sh` - 10 exercises
- `tee-practice.sh` - 10 exercises
- `chmod-practice.sh` - 10 exercises

**Data Processing (4):**

- `jq-practice.sh` - 15 exercises
- `column-practice.sh` - 10 exercises
- `paste-practice.sh` - 10 exercises
- `comm-practice.sh` - 10 exercises

**Archives (3):**

- `tar-practice.sh` - 12 exercises
- `gzip-practice.sh` - 10 exercises
- `zip-practice.sh` - 10 exercises

**Network (4):**

- `curl-practice.sh` - 10 exercises (conceptual)
- `wget-practice.sh` - 10 exercises (conceptual)
- `ping-practice.sh` - 8 exercises (conceptual)
- `netstat-practice.sh` - 8 exercises (conceptual)

**System (4):**

- `ps-practice.sh` - 10 exercises
- `top-practice.sh` - 8 exercises
- `df-du-practice.sh` - 12 exercises
- `env-practice.sh` - 10 exercises

**Utilities (5):**

- `echo-practice.sh` - 10 exercises
- `date-practice.sh` - 12 exercises
- `xargs-practice.sh` - 12 exercises
- `alias-practice.sh` - 10 exercises
- `history-practice.sh` - 10 exercises

**Progress Tracking:**

```bash
cd shell-commands/practice-environment/practice

# Interactive progress menu
./progress.sh

# Quick summary
./progress.sh summary

# Detailed report
./progress.sh show

# Commands needing work
./progress.sh needs

# Mastered commands (90%+)
./progress.sh mastered

# Export to CSV
./progress.sh export
```

**Scoring System:**

- **90-100%**: ⭐⭐⭐ Master Level
- **75-89%**: ⭐⭐ Advanced Level
- **60-74%**: ⭐ Intermediate Level
- **< 60%**: Keep practicing!

**Special Commands While Practicing:**

- Type `skip` or `s` - Skip current question
- Type `solution` or `sol` - Show solution and explanation
- Press `Ctrl+C` - Exit practice session

**Examples:**

```bash
# Practice grep
cd shell-commands/practice-environment/practice
./commands/grep-practice.sh

# Practice awk
./commands/awk-practice.sh

# Use menu for all options
./practice-menu.sh

# Check progress
./progress.sh summary
```

---

### Section 2: Watch Examples (`demos/`)

**What:** Scripts that show you examples. You press Enter to see each step. Passive learning.

**When to use:**

- You're completely new to shell commands
- You want to see how a command works before trying it
- You need a quick reference/reminder
- You want to learn by watching

**How to launch:**

```bash
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
# Press Enter to see each example
```

**Available Demos:**

**Beginner Level:**

- `beginner/01-grep-basics.sh` - grep pattern matching (10 min)
- `beginner/02-piping-basics.sh` - Chaining commands (10 min)
- `beginner/03-json-processing.sh` - jq for JSON (15 min, requires jq)
- `beginner/04-file-operations.sh` - cat, head, tail, wc (10 min)
- `beginner/05-csv-basics.sh` - awk, cut, sort for CSV (15 min)

**Intermediate Level:**

- `intermediate/01-log-analysis.sh` - Real log scenarios (20 min)
- `intermediate/02-salesforce-analysis.sh` - SF debugging (25 min)
- `intermediate/03-data-transformation.sh` - Format conversion (20 min)

**Advanced Level:**

- `advanced/01-complex-pipelines.sh` - Multi-stage processing (30 min)
- `advanced/02-automation-scripts.sh` - Script building (30 min)

**Expert Level:**

- `expert/01-production-scenarios.sh` - Real incidents (45 min)

**Examples:**

```bash
# Watch grep basics
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh

# Watch JSON processing
./03-json-processing.sh

# Watch log analysis
cd ../intermediate
./01-log-analysis.sh
```

---

### Section 3: Use Real Data (`data/`)

**What:** Real data files (logs, JSON, CSV, text) that you can practice commands on.

**When to use:**

- You want to practice commands on real files
- You're following tutorials and need sample data
- You want to experiment without creating your own files
- You need realistic data for testing

**How to setup:**

```bash
cd shell-commands/practice-environment
./setup.sh  # One-time setup (creates sample data)
```

**Available Data Files:**

**Log Files (`data/logs/`):**

- `application.log` - Generic application logs (500+ lines)
- `apex-debug.log` - Salesforce Apex debug log
- `deployment.log` - Salesforce deployment output
- `web-access.log` - Apache/Nginx format access logs
- `system.log` - System logs
- `error-mixed.log` - Mixed error logs

**JSON Files (`data/json/`):**

- `sf-query-result.json` - Salesforce CLI query output
- `api-response.json` - REST API responses
- `deploy-result.json` - SF deployment result
- `nested-complex.json` - Complex nested JSON
- `users.json` - User data

**CSV Files (`data/csv/`):**

- `accounts.csv` - Salesforce Accounts (100+ rows)
- `contacts.csv` - Contacts data
- `sales-data.csv` - Sales transactions (1000+ rows)
- `large-dataset.csv` - Performance testing (10K+ rows)
- `server-metrics.csv` - Server metrics

**Text Files (`data/text/`):**

- `sample-code.cls` - Apex class files
- `urls.txt` - URL list
- `emails.txt` - Email addresses
- `mixed-content.txt` - Mixed text content
- `config-files.txt` - Configuration files

**XML Files (`data/xml/`):**

- `metadata.xml` - Salesforce metadata
- `package.xml` - Package manifest

**Archives (`data/archives/`):**

- `sample-archive.tar` - Tar archive
- `sample-archive.tar.gz` - Compressed tar
- `sample-archive.zip` - ZIP archive
- `sample.log` - Log file
- `sample.log.gz` - Compressed log

**Example Commands:**

```bash
cd shell-commands/practice-environment

# Count ERROR lines
grep -c "ERROR" data/logs/application.log

# Extract account names from JSON
jq -r '.result.records[].Name' data/json/sf-query-result.json

# Show first 10 accounts
head -10 data/csv/accounts.csv

# Extract specific columns
cut -d',' -f2,3,4 data/csv/accounts.csv

# Filter by industry
awk -F',' '$3 == "Technology" {print $2}' data/csv/accounts.csv

# Count total records
jq '.result.totalSize' data/json/sf-query-result.json
```

---

### Section 4: Guided Tutorials (`exercises/`)

**What:** Tutorial scripts that walk you through concepts step-by-step. Currently, most exercises are in `demos/exercises/`.

**When to use:**

- You want structured, guided learning
- You prefer step-by-step explanations
- You want to understand workflows and scenarios

**How to launch:**

```bash
# Exercises are in demos/exercises/ directory
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
# Follow along with the tutorial
```

**Available Exercises:**

Same as demos (see Section 2 above). The `exercises/` folder structure is prepared for future content.

**Examples:**

```bash
# Beginner exercises
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
./02-piping-basics.sh
./03-json-processing.sh

# Intermediate exercises
cd ../intermediate
./01-log-analysis.sh
./02-salesforce-analysis.sh
```

---

### Section 5: Advanced Tools

#### Generators (`generators/`)

**What:** Scripts that generate additional sample data files.

**When to use:**

- You need more data files for practice
- You want to test with larger datasets
- You're creating custom practice scenarios

**How to use:**

```bash
cd shell-commands/practice-environment/generators
./generate-all.sh
# Creates additional data files in data/ directory
```

**Examples:**

```bash
cd shell-commands/practice-environment/generators
./generate-all.sh
# Generates more sample files
```

#### Helpers (`helpers/`)

**What:** Helper scripts for testing and practice scenarios.

**When to use:**

- You're practicing error handling (failing commands)
- You're practicing process monitoring (slow processes)
- You're creating test file structures

**How to use:**

```bash
cd shell-commands/practice-environment/helpers

# Simulate a failing command
./failing-command.sh 1 "Connection timeout"

# Simulate a long-running process (for ps/top practice)
./slow-process.sh

# Create test file structure (for find practice)
./create-test-files.sh
```

**Examples:**

```bash
cd shell-commands/practice-environment/helpers

# Test error handling
./failing-command.sh 1 "Connection timeout"
# Command exits with code 1 and message

# Practice process monitoring
./slow-process.sh &
# Process runs in background, use ps/top to monitor
```

#### Scenarios (`scenarios/`)

**What:** Challenge problems based on real-world scenarios.

**When to use:**

- You've mastered basic commands
- You want to solve realistic problems
- You're preparing for real-world tasks

**How to use:**

```bash
cd shell-commands/practice-environment/scenarios/deployment-failure
cat README.md  # Read the challenge
# Use your skills to solve it
```

**Available Scenarios:**

- `deployment-failure/` - Debug a failed deployment
- `log-investigation/` - Investigate production issues
- `data-migration/` - Transform and validate data
- `performance-tuning/` - Optimize slow scripts

**Examples:**

```bash
cd shell-commands/practice-environment/scenarios/deployment-failure
cat README.md
# Read challenge and solve using shell commands
```

---

## 🎯 Learning Paths

### Path 1: Complete Beginner (Week 1-2)

**Day 1-2: Watch Examples**

```bash
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
./02-piping-basics.sh
./04-file-operations.sh
```

**Day 3-4: Practice Interactively**

```bash
cd shell-commands/practice-environment/practice
./commands/grep-practice.sh
./commands/cut-practice.sh
./commands/sort-practice.sh
```

**Day 5-7: Practice on Real Data**

```bash
cd shell-commands/practice-environment
grep "ERROR" data/logs/application.log
head -20 data/csv/accounts.csv
jq '.result.records[].Name' data/json/sf-query-result.json
```

### Path 2: Intermediate (Week 3-4)

**Practice Core Commands:**

```bash
cd shell-commands/practice-environment/practice
./commands/awk-practice.sh
./commands/sed-practice.sh
./commands/jq-practice.sh
./commands/find-practice.sh
```

**Track Progress:**

```bash
./progress.sh show
```

**Work on Weak Areas:**

```bash
./progress.sh needs
# Practice commands that need work
```

**Watch Advanced Demos:**

```bash
cd ../demos/exercises/intermediate
./01-log-analysis.sh
./02-salesforce-analysis.sh
```

### Path 3: Advanced (Week 5+)

**Master All Commands:**

```bash
cd shell-commands/practice-environment/practice
./practice-menu.sh
# Complete all 35 practice files
```

**Solve Scenarios:**

```bash
cd ../scenarios
# Work through challenge problems
cd deployment-failure
cat README.md
```

**Create Custom Practice:**

```bash
cd ../generators
./generate-all.sh
# Generate your own data
```

**View Mastery:**

```bash
cd ../practice
./progress.sh mastered
```

---

## 📋 Command Reference

**Quick reference: Want to X? → cd here → run this**

| You Want To...                | cd here                        | run this                                 |
| ----------------------------- | ------------------------------ | ---------------------------------------- |
| **See how a command works**   | `demos/exercises/beginner`     | `./01-grep-basics.sh`                    |
| **Practice typing commands**  | `practice`                     | `./practice-menu.sh`                     |
| **Practice specific command** | `practice`                     | `./commands/grep-practice.sh`            |
| **Track your progress**       | `practice`                     | `./progress.sh`                          |
| **Use real data files**       | `.` (root)                     | `grep "ERROR" data/logs/application.log` |
| **Setup data files**          | `.` (root)                     | `./setup.sh`                             |
| **Generate more data**        | `generators`                   | `./generate-all.sh`                      |
| **Test error handling**       | `helpers`                      | `./failing-command.sh`                   |
| **Solve real problems**       | `scenarios/deployment-failure` | `cat README.md`                          |
| **Watch JSON demo**           | `demos/exercises/beginner`     | `./03-json-processing.sh`                |
| **Watch log analysis**        | `demos/exercises/intermediate` | `./01-log-analysis.sh`                   |

---

## 🔧 Setup & Maintenance

### First Time Setup

```bash
cd shell-commands/practice-environment
./setup.sh
# Creates sample data files
```

### Reset Environment

```bash
cd shell-commands/practice-environment
./reset.sh
# Cleans up and resets
./setup.sh
# Re-run setup
```

### Check Setup Status

```bash
cd shell-commands/practice-environment
ls -la .setup_complete
# If file exists, setup is complete
```

---

## ❓ Frequently Asked Questions

### Q: I'm confused. Where do I start?

**A:** If you're new, start with `demos/`. If you know basics, start with `practice/`.

```bash
# New? Watch examples:
cd demos/exercises/beginner && ./01-grep-basics.sh

# Know basics? Practice:
cd practice && ./practice-menu.sh
```

### Q: What's the difference between `demos/` and `practice/`?

**A:**

- `demos/` = You watch (passive learning)
- `practice/` = You type (active learning with validation)

### Q: Do I need to run `setup.sh`?

**A:** Only if you want to use `data/` files. The `practice/` system works without it.

```bash
# If you want to use data files:
./setup.sh

# If you only want interactive practice:
cd practice && ./practice-menu.sh  # No setup needed!
```

### Q: How do I know which commands I've mastered?

**A:** Use the progress tracker:

```bash
cd practice
./progress.sh mastered  # Shows commands with 90%+ score
./progress.sh needs     # Shows commands needing work
```

### Q: Can I practice without the interactive system?

**A:** Yes! Use the `data/` files directly:

```bash
grep "ERROR" data/logs/application.log
jq '.result.records[]' data/json/sf-query-result.json
```

### Q: What are `generators/` and `helpers/` for?

**A:**

- `generators/` = Create more sample data (advanced)
- `helpers/` = Test error handling and process monitoring (advanced)

You can ignore these if you're just starting out.

---

## 📊 Statistics

- **35 Practice Command Files** - One for each documented command
- **383 Total Exercises** - Beginner to expert level
- **11 Demo Scripts** - Guided demonstrations
- **50+ Sample Data Files** - Logs, JSON, CSV, text, XML, archives
- **4 Real-World Scenarios** - Challenge problems

---

## 🎓 Summary: Start Here!

**New to shell commands?**

```bash
cd shell-commands/practice-environment/demos/exercises/beginner
./01-grep-basics.sh
```

**Know basics, want to practice?**

```bash
cd shell-commands/practice-environment/practice
./practice-menu.sh
```

**Want to use real data files?**

```bash
cd shell-commands/practice-environment
./setup.sh
grep "ERROR" data/logs/application.log
```

**That's it!** Everything else is optional and for advanced use.

---

## 📚 Additional Resources

- **Main Shell Commands Guide:** [`../README.md`](../README.md)
- **Command Tutorials:** [`../02-commands/`](../02-commands/)
- **Reading Exercises:** [`../04-practice/`](../04-practice/)

---

**Ready to start? Choose your path above and begin learning!** 🚀
