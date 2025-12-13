# Interactive Practice System

Welcome to the **active learning** practice system! This is where you actually TYPE commands, solve problems, and get immediate validation feedback.

## What is This?

This is an **interactive quiz system** where:

1. You read a question
2. You type the command yourself
3. The system executes YOUR command
4. You get immediate feedback (correct/incorrect)
5. Your progress is tracked automatically

## Practice vs Demos

| Feature        | Practice (Here)                    | Demos (../demos/)           |
| -------------- | ---------------------------------- | --------------------------- |
| Learning Style | **Active** - You solve problems    | Passive - Watch & learn     |
| User Action    | **Type commands** yourself         | Press Enter to see examples |
| Validation     | **Automatic** - Checks your answer | None                        |
| Feedback       | **Immediate** - Right/wrong        | Shows solution              |
| Scoring        | **Yes** - Track your score         | No                          |
| Progress       | **Tracked** - Saved per command    | No tracking                 |
| Attempts       | **3 tries** per question           | Unlimited                   |
| Hints          | **Yes** - After incorrect attempts | Always shown                |

## Quick Start

```bash
# Navigate to practice folder
cd practice

# Choose a command to practice
./commands/grep-practice.sh

# Or use the menu
./practice-menu.sh
```

## How It Works

### Step-by-Step Flow

```
1. Question appears:
   "Task: Count lines containing 'ERROR'"
   "Data file: data/logs/application.log"
   "Expected: 47 lines"

2. You type your command:
   Your command: grep -c "ERROR" data/logs/application.log

3. System executes your command

4. System validates output:
   ✓ Correct! Score: 1/15

   OR

   ✗ Incorrect
   Your output: 45
   Expected: 47
   Hint: Use grep -c to count matches
   Try again? (y/n):
```

### Special Commands

While practicing, you can type:

- `skip` or `s` - Skip current question
- `solution` or `sol` - Show solution and explanation
- `Ctrl+C` - Exit practice session

## Available Commands

### High Priority (Complete These First)

| Command | Exercises | Difficulty | Description                          |
| ------- | --------- | ---------- | ------------------------------------ |
| `grep`  | 15        | ⭐⭐       | Pattern matching and searching       |
| `awk`   | 15        | ⭐⭐⭐     | Text processing and field extraction |
| `sed`   | 15        | ⭐⭐⭐     | Stream editing and substitution      |
| `jq`    | 15        | ⭐⭐⭐     | JSON processing and filtering        |
| `cut`   | 12        | ⭐⭐       | Column extraction                    |
| `sort`  | 12        | ⭐⭐       | Sorting lines                        |
| `find`  | 15        | ⭐⭐⭐     | File searching                       |
| `tar`   | 12        | ⭐⭐       | Archive creation/extraction          |
| `curl`  | 15        | ⭐⭐⭐     | HTTP requests                        |

### All 34 Commands

**Text Processing (8):**

- grep, awk, sed, cut, tr, sort, uniq, wc

**File Operations (7):**

- cat, head, tail, find, diff, tee, chmod

**Data Processing (4):**

- jq, column, paste, comm

**Archives (3):**

- tar, gzip, zip

**Network (4):**

- curl, wget, ping, netstat

**System (4):**

- ps, top, df-du, env

**Utilities (4):**

- echo, date, xargs, alias, history

## Difficulty Levels

Each command has exercises at multiple difficulty levels:

### Beginner (3-5 exercises)

- Basic command usage
- Single flags
- Simple patterns
- **Example**: `grep "ERROR" file.log`

### Intermediate (3-5 exercises)

- Multiple flags combined
- Piping with other commands
- Pattern matching
- **Example**: `grep -E "ERROR|WARN" file.log | wc -l`

### Advanced (2-3 exercises)

- Complex pipelines
- Multiple conditions
- Real-world scenarios
- **Example**: `grep -r "TODO" src/ | awk -F':' '{print $1}' | sort -u`

### Expert (2-3 exercises)

- Production scenarios
- Performance optimization
- Edge cases
- **Example**: Multi-step data analysis challenges

## Scoring System

### Per Exercise

- First attempt correct: **1 point**
- You get **3 attempts** per question
- After 3 failed attempts: **Solution shown**, no points

### Final Score

- **90-100%**: ⭐⭐⭐ Master Level
- **75-89%**: ⭐⭐ Advanced Level
- **60-74%**: ⭐ Intermediate Level
- **< 60%**: Keep practicing!

## Progress Tracking

Your progress is automatically saved after each practice session.

### View Progress

```bash
# Interactive menu
./progress.sh

# Quick summary
./progress.sh summary

# Detailed report
./progress.sh show

# Commands needing work
./progress.sh needs

# Mastered commands
./progress.sh mastered

# Export to CSV
./progress.sh export
```

### Progress File Location

- Saved in: `.progress/<username>.json`
- Persists across sessions
- Can be reset: `./progress.sh reset`

## Tips for Success

### 1. Start Simple

Don't jump to expert exercises. Master beginner level first.

```bash
# Good approach
./commands/grep-practice.sh    # Start here
./commands/cut-practice.sh     # Then move up
./commands/awk-practice.sh     # More complex
```

### 2. Use Hints

After an incorrect answer, hints are provided. Read them!

### 3. Check Demos

If stuck, review the corresponding demo:

```bash
# Practice
cd practice
./commands/grep-practice.sh

# Stuck? Check demo
cd ../demos
./beginner/01-grep-basics.sh
```

### 4. Practice Data Files

All exercises use real files from `../data/`:

- `data/logs/*.log` - Application, system, web logs
- `data/json/*.json` - JSON responses and results
- `data/csv/*.csv` - CSV datasets
- `data/text/*.txt` - Text samples

### 5. Read Command Reference

Each command has detailed documentation in `../../02-commands/`:

```bash
cat ../../02-commands/grep.md
```

## Example Session

Here's what a real practice session looks like:

```bash
$ cd practice
$ ./commands/grep-practice.sh

╔════════════════════════════════════════════════════════╗
║                                                        ║
║  grep Practice - Interactive Exercises                 ║
║                                                        ║
╚════════════════════════════════════════════════════════╝

Total Exercises: 15
Instructions: Type your command and press Enter
Scoring: Each correct answer = 1 point

Press Enter to begin...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Question 1 of 15
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task: Count lines containing 'ERROR' in application.log
Data file: data/logs/application.log
Expected: 47 lines

Your command: grep -c "ERROR" data/logs/application.log

✓ Correct!
Score: 1/15

[... continues through all exercises ...]

╔════════════════════════════════════════════════════════╗
║                                                        ║
║              Practice Complete!                        ║
║                                                        ║
╚════════════════════════════════════════════════════════╝

Command: grep
Score: 13 / 15 (87%)

⭐⭐ Great job! Very good understanding!
```

## Troubleshooting

### "timeout: command not found"

Commands execute with a 30-second timeout by default. If `timeout` isn't available on your system, commands run without timeout.

### "Permission denied"

Make sure scripts are executable:

```bash
chmod +x practice-engine.sh progress.sh commands/*.sh
```

### "No such file or directory"

Run exercises from the `practice/` directory:

```bash
cd practice
./commands/grep-practice.sh
```

### "jq: command not found"

Some features require jq:

```bash
# Arch Linux
sudo pacman -S jq

# macOS
brew install jq

# Ubuntu
sudo apt install jq
```

## Advanced Features

### Custom Validation Modes

The practice engine supports multiple validation modes:

- `exact` - Exact string match (default)
- `numeric` - Numeric comparison
- `contains` - Output contains expected text
- `regex` - Regex pattern match
- `lines` - Line count comparison
- `sorted` - Sorted output comparison

### Retry Logic

- 3 attempts per question
- Hints after each failed attempt
- Solution shown after max attempts
- Option to skip questions

### Progress Persistence

- JSON format for easy parsing
- Per-user tracking
- Export to CSV for analysis
- Reset capability

## Learning Paths

### Path 1: Essentials (2-3 hours)

Master the most commonly used commands:

1. grep (15 exercises)
2. cut (12 exercises)
3. sort (12 exercises)
4. find (15 exercises)

### Path 2: Text Processing (4-5 hours)

Deep dive into text manipulation:

1. grep (15 exercises)
2. sed (15 exercises)
3. awk (15 exercises)
4. tr (10 exercises)

### Path 3: Data Processing (3-4 hours)

Work with structured data:

1. jq (15 exercises)
2. cut (12 exercises)
3. column (10 exercises)
4. paste (10 exercises)

### Path 4: Complete Mastery (15-20 hours)

Practice all 34 commands for full proficiency.

## Next Steps

Ready to start? Pick a command and begin practicing!

```bash
# Start with grep (most popular)
./commands/grep-practice.sh

# Or use the menu for all options
./practice-menu.sh

# Check your progress anytime
./progress.sh
```

## Getting Help

- **Stuck on a question?** Type `solution` to see the answer
- **Need examples?** Check `../demos/` folder
- **Want reference?** Read `../../02-commands/<command>.md`
- **See progress?** Run `./progress.sh`

Happy practicing! 🚀
