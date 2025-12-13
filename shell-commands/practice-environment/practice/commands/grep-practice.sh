#!/usr/bin/env bash

# ============================================
# grep Practice - 15 Interactive Exercises
# ============================================
# Master pattern matching and text searching

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

# Source the practice engine
source "../practice/practice-engine.sh"

COMMAND="grep"
TOTAL_EXERCISES=15

# Initialize practice session
init_practice "$COMMAND" "$TOTAL_EXERCISES"

# ============================================
# BEGINNER EXERCISES (1-5)
# ============================================

# Exercise 1: Count matches
run_exercise 1 \
    "Count lines containing 'ERROR' in application.log" \
    "data/logs/application.log" \
    "47" \
    "47 lines" \
    "numeric" \
    "Use grep -c to count matches" \
    "grep -c \"ERROR\" data/logs/application.log" \
    "The -c flag counts matching lines instead of printing them"

# Exercise 2: Case-insensitive search
run_exercise 2 \
    "Count lines containing 'error' (any case) in application.log" \
    "data/logs/application.log" \
    "47" \
    "47 lines (including ERROR, Error, error)" \
    "numeric" \
    "Use grep -i for case-insensitive matching" \
    "grep -ic \"error\" data/logs/application.log" \
    "The -i flag makes grep ignore case differences"

# Exercise 3: Invert match
run_exercise 3 \
    "Count lines that DON'T contain 'INFO' in application.log" \
    "data/logs/application.log" \
    "100" \
    "100 lines without INFO" \
    "numeric" \
    "Use grep -v to invert the match" \
    "grep -vc \"INFO\" data/logs/application.log" \
    "The -v flag inverts the match, showing non-matching lines"

# Exercise 4: Extract with line numbers
run_exercise 4 \
    "Show the FIRST occurrence of 'ERROR' with its line number" \
    "data/logs/application.log" \
    "15:2025-12-09 08:15:34 ERROR Database connection timeout" \
    "Line number:content format" \
    "contains" \
    "Use grep -n and pipe to head -1" \
    "grep -n \"ERROR\" data/logs/application.log | head -1" \
    "The -n flag adds line numbers. Pipe to head -1 to get first match only"

# Exercise 5: Extract patterns with -o
run_exercise 5 \
    "Extract and count all IP addresses from web-access.log" \
    "data/logs/web-access.log" \
    "50" \
    "50 IP addresses" \
    "numeric" \
    "Use grep -oE with IP regex pattern, then wc -l" \
    "grep -oE \"\\b([0-9]{1,3}\\.){3}[0-9]{1,3}\\b\" data/logs/web-access.log | wc -l" \
    "The -o flag outputs only the matched part, -E enables extended regex"

# ============================================
# INTERMEDIATE EXERCISES (6-10)
# ============================================

# Exercise 6: Context lines
run_exercise 6 \
    "Show 'NullPointerException' with 2 lines of context and count total lines" \
    "data/logs/application.log" \
    "15" \
    "15 lines (includes context)" \
    "numeric" \
    "Use grep -C 2 to get 2 lines before and after" \
    "grep -C 2 \"NullPointerException\" data/logs/application.log | wc -l" \
    "-C N shows N lines before and after each match. With 3 matches, 3*(1+2+2) = 15 lines"

# Exercise 7: Multiple patterns with OR
run_exercise 7 \
    "Count lines containing either 'ERROR' OR 'WARN' in application.log" \
    "data/logs/application.log" \
    "72" \
    "72 lines with ERROR or WARN" \
    "numeric" \
    "Use grep -E with pipe symbol for OR" \
    "grep -Ec \"ERROR|WARN\" data/logs/application.log" \
    "-E enables extended regex where | means OR. Matches lines with either pattern"

# Exercise 8: Recursive search
run_exercise 8 \
    "Count total ERROR lines across ALL log files in data/logs/" \
    "data/logs/" \
    "104" \
    "104 total ERROR lines" \
    "numeric" \
    "Use grep -r to search recursively, -h to hide filenames" \
    "grep -rh \"ERROR\" data/logs/ | wc -l" \
    "-r searches recursively through directories, -h suppresses filenames in output"

# Exercise 9: List files with matches
run_exercise 9 \
    "List only the NAMES of log files containing 'FATAL' (count the files)" \
    "data/logs/" \
    "2" \
    "2 files contain FATAL" \
    "numeric" \
    "Use grep -l to list files, not lines" \
    "grep -l \"FATAL\" data/logs/*.log | wc -l" \
    "-l outputs only filenames of files containing matches, not the matching lines"

# Exercise 10: Word boundaries
run_exercise 10 \
    "Count lines with the word 'user' as a complete word (not 'username' or 'users')" \
    "data/logs/application.log" \
    "8" \
    "8 lines with exactly 'user'" \
    "numeric" \
    "Use grep -w for whole word matching" \
    "grep -wc \"user\" data/logs/application.log" \
    "-w matches whole words only, bounded by non-word characters"

# ============================================
# ADVANCED EXERCISES (11-13)
# ============================================

# Exercise 11: Complex regex - extract emails
run_exercise 11 \
    "Extract and count unique email addresses from application.log" \
    "data/logs/application.log" \
    "12" \
    "12 unique emails" \
    "numeric" \
    "Use grep -oE with email regex, then sort -u" \
    "grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' data/logs/application.log | sort -u | wc -l" \
    "Extract emails with regex, sort -u removes duplicates, wc -l counts"

# Exercise 12: Multiple exclude patterns
run_exercise 12 \
    "Count lines that don't contain 'INFO', 'DEBUG', or 'TRACE'" \
    "data/logs/application.log" \
    "82" \
    "82 lines" \
    "numeric" \
    "Use grep -v multiple times or -E with negative pattern" \
    "grep -v \"INFO\" data/logs/application.log | grep -v \"DEBUG\" | grep -v \"TRACE\" | wc -l" \
    "Chain multiple grep -v commands to exclude multiple patterns"

# Exercise 13: Count per file with context
run_exercise 13 \
    "Show ERROR count for each log file (format: number filename)" \
    "data/logs/" \
    "4" \
    "4 lines of output (one per file)" \
    "lines" \
    "Use grep -c on multiple files" \
    "grep -c \"ERROR\" data/logs/*.log | wc -l" \
    "grep -c on multiple files outputs one line per file in format filename:count"

# ============================================
# EXPERT EXERCISES (14-15)
# ============================================

# Exercise 14: Performance comparison
run_exercise 14 \
    "Count lines in large-dataset.csv where status is 'error'" \
    "data/csv/large-dataset.csv" \
    "1000" \
    "~1000 error lines (accept 900-1100)" \
    "numeric" \
    "Use grep to filter, wc -l to count" \
    "grep -c \"error\" data/csv/large-dataset.csv" \
    "grep is very efficient even on large files. The large dataset has ~10,000 rows with ~10% errors"

# Exercise 15: Production scenario - extract failed logins
run_exercise 15 \
    "From system.log, extract unique IPs that had 'Failed password'" \
    "data/logs/system.log" \
    "1" \
    "1 unique IP" \
    "numeric" \
    "Grep for 'Failed password', extract IPs, get unique count" \
    "grep \"Failed password\" data/logs/system.log | grep -oE '([0-9]{1,3}\\.){3}[0-9]{1,3}' | sort -u | wc -l" \
    "First grep filters lines, second grep -oE extracts IPs, sort -u finds unique, wc -l counts"

# Show final score
show_final_score "$COMMAND"

echo ""
echo "What's next?"
echo "  • Review: ../demos/beginner/01-grep-basics.sh"
echo "  • Reference: ../../02-commands/grep.md"
echo "  • Next command: ./awk-practice.sh"
echo ""
