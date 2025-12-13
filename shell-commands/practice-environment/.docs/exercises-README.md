# Interactive Exercises Guide

Welcome to the interactive shell commands exercises! This directory contains guided, hands-on tutorials organized by skill level.

## 📚 Exercise Structure

```
exercises/
├── beginner/        # Start here - 5 interactive tutorials
├── intermediate/    # 3 real-world scenarios
├── advanced/        # 2 complex challenges
└── expert/          # 1 production scenario
```

## 🎯 Quick Start

```bash
# Navigate to practice environment
cd shell-commands/practice-environment

# Start with beginner exercises
./exercises/beginner/01-grep-basics.sh
```

## 📖 Exercise Catalog

### Beginner Level (Start Here!)

Perfect for learning the fundamentals. Each exercise is interactive and guides you step-by-step.

| Script                  | Topics Covered           | Duration | Prerequisites |
| ----------------------- | ------------------------ | -------- | ------------- |
| `01-grep-basics.sh`     | grep, patterns, flags    | 10 min   | None          |
| `02-piping-basics.sh`   | pipes, chaining commands | 10 min   | 01            |
| `03-json-processing.sh` | jq, JSON parsing         | 15 min   | jq installed  |
| `04-file-operations.sh` | cat, head, tail, wc      | 10 min   | 01            |
| `05-csv-basics.sh`      | awk, cut, sort, CSV      | 15 min   | 02            |

**Total time: ~60 minutes**

### Intermediate Level

Real-world scenarios using actual log files and data.

| Script                      | Topics Covered              | Duration | Prerequisites |
| --------------------------- | --------------------------- | -------- | ------------- |
| `01-log-analysis.sh`        | Log parsing, error analysis | 20 min   | Beginner      |
| `02-salesforce-analysis.sh` | SF logs, SOQL, deployments  | 25 min   | jq, Beginner  |
| `03-data-transformation.sh` | Format conversion, cleanup  | 20 min   | Beginner      |

**Total time: ~65 minutes**

### Advanced Level

Complex pipelines and automation scripts.

| Script                     | Topics Covered            | Duration | Prerequisites |
| -------------------------- | ------------------------- | -------- | ------------- |
| `01-complex-pipelines.sh`  | Multi-stage processing    | 30 min   | Intermediate  |
| `02-automation-scripts.sh` | Script building, patterns | 30 min   | Intermediate  |

**Total time: ~60 minutes**

### Expert Level

Production scenarios and incident response.

| Script                       | Topics Covered            | Duration | Prerequisites |
| ---------------------------- | ------------------------- | -------- | ------------- |
| `01-production-scenarios.sh` | Real incidents, debugging | 45 min   | All previous  |

**Total time: ~45 minutes**

## 🎓 Learning Paths

### Path 1: Quick Start (1-2 hours)

Perfect for getting practical experience fast.

```bash
./exercises/beginner/01-grep-basics.sh
./exercises/beginner/02-piping-basics.sh
./exercises/beginner/04-file-operations.sh
./exercises/intermediate/01-log-analysis.sh
```

### Path 2: Comprehensive (4-5 hours)

Complete all exercises in order for full mastery.

```bash
# Week 1: Beginner (all 5 exercises)
# Week 2: Intermediate (all 3 exercises)
# Week 3: Advanced (both exercises)
# Week 4: Expert (production scenarios)
```

### Path 3: Salesforce Focus (2-3 hours)

Specialized path for Salesforce developers.

```bash
./exercises/beginner/01-grep-basics.sh
./exercises/beginner/03-json-processing.sh
./exercises/intermediate/02-salesforce-analysis.sh
./exercises/advanced/01-complex-pipelines.sh
```

### Path 4: Data Engineering (2-3 hours)

Focus on data processing and transformation.

```bash
./exercises/beginner/03-json-processing.sh
./exercises/beginner/05-csv-basics.sh
./exercises/intermediate/03-data-transformation.sh
./exercises/advanced/01-complex-pipelines.sh
```

## 🚀 How to Use

### Interactive Mode (Recommended)

Each script guides you through exercises interactively:

```bash
./exercises/beginner/01-grep-basics.sh
# Follow the prompts, try commands, see results
```

### Reference Mode

Read the scripts to see solutions:

```bash
cat exercises/beginner/01-grep-basics.sh
# Study the commands and explanations
```

### Practice Mode

Use scripts as templates for your own practice:

```bash
# Copy a script
cp exercises/beginner/01-grep-basics.sh my-practice.sh
# Modify and experiment
```

## 📊 Progress Tracking

Track your progress:

- [ ] **Beginner Level Complete** (5/5 exercises)

  - [ ] 01-grep-basics.sh
  - [ ] 02-piping-basics.sh
  - [ ] 03-json-processing.sh
  - [ ] 04-file-operations.sh
  - [ ] 05-csv-basics.sh

- [ ] **Intermediate Level Complete** (3/3 exercises)

  - [ ] 01-log-analysis.sh
  - [ ] 02-salesforce-analysis.sh
  - [ ] 03-data-transformation.sh

- [ ] **Advanced Level Complete** (2/2 exercises)

  - [ ] 01-complex-pipelines.sh
  - [ ] 02-automation-scripts.sh

- [ ] **Expert Level Complete** (1/1 exercises)
  - [ ] 01-production-scenarios.sh

## 💡 Tips for Success

1. **Don't skip levels**: Each level builds on previous knowledge
2. **Type commands**: Don't just read - execute them yourself
3. **Experiment**: Modify commands to see what happens
4. **Use the data**: All exercises use files in `../data/`
5. **Take breaks**: 15-minute break after each level
6. **Review**: Go back to earlier exercises to reinforce learning

## 🔧 Troubleshooting

### Script won't run

```bash
chmod +x exercises/beginner/01-grep-basics.sh
```

### jq not found

```bash
# Arch Linux
sudo pacman -S jq

# macOS
brew install jq

# Ubuntu
sudo apt install jq
```

### Sample data missing

```bash
cd ..
./setup.sh
```

### Want to reset environment

```bash
cd ..
./reset.sh
```

## 📝 What You'll Learn

### By completing all exercises, you'll master:

**Text Processing:**

- Pattern matching with grep
- Text transformation with sed
- Advanced parsing with awk
- Data extraction with cut

**Data Processing:**

- JSON parsing with jq
- CSV manipulation
- Format conversion
- Data cleaning

**File Operations:**

- Reading files (cat, head, tail)
- File comparison (diff, comm)
- File searching (find)
- Archive handling (tar, gzip)

**Pipelines:**

- Chaining commands
- Multi-stage processing
- Error handling
- Performance optimization

**Real-World Skills:**

- Log analysis
- Deployment debugging
- Security auditing
- Data migration
- Report generation
- Automation scripting

## 🎯 Next Steps

After completing exercises:

1. **Try Real Scenarios**: Explore `../scenarios/` directory
2. **Read Documentation**: Review `../02-commands/` for reference
3. **Build Projects**: Create your own automation scripts
4. **Practice Daily**: Use these commands in real work

## 📚 Additional Resources

- **Practice Environment README**: `../README.md`
- **Sample Data**: `../data/` directory
- **Helper Scripts**: `../helpers/` directory
- **Real Scenarios**: `../scenarios/` directory
- **Command Reference**: `../../02-commands/` directory
- **Practice Exercises**: `../../04-practice/` directory

## 🆘 Getting Help

1. Read the command reference: `cat ../../02-commands/grep.md`
2. Check command help: `man grep` or `grep --help`
3. Review exercise code: Each script is self-documenting
4. Try simpler examples first, then build up complexity

## 🎉 Completion Certificate

Once you've completed all exercises, you'll have mastered:

- 34+ shell commands
- Multiple data formats (JSON, CSV, logs)
- Real-world scenarios
- Production debugging skills
- Automation patterns

**Start your journey now:**

```bash
./exercises/beginner/01-grep-basics.sh
```

Good luck! 🚀
