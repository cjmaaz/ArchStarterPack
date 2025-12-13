#!/usr/bin/env bash

# ============================================
# sed Practice - 15 Interactive Exercises
# ============================================
# Master stream editing and text transformation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

source "../practice/practice-engine.sh"

COMMAND="sed"
TOTAL_EXERCISES=15

init_practice "$COMMAND" "$TOTAL_EXERCISES"

# ============================================
# BEGINNER EXERCISES (1-5)
# ============================================

# Exercise 1: Simple substitution
run_exercise 1 \
    "Replace 'ERROR' with 'WARNING' in first line of application.log" \
    "data/logs/application.log" \
    "2025-12-09 08:15:34 WARNING Database connection timeout" \
    "First ERROR replaced with WARNING" \
    "contains" \
    "Use sed 's/ERROR/WARNING/' and pipe to head -1" \
    "grep \"ERROR\" data/logs/application.log | head -1 | sed 's/ERROR/WARNING/'" \
    "sed 's/old/new/' replaces first occurrence on each line"

# Exercise 2: Global substitution
run_exercise 2 \
    "Count lines in urls.txt after replacing all 'http:' with 'https:'" \
    "data/text/urls.txt" \
    "20" \
    "20 lines" \
    "lines" \
    "Use sed 's/http:/https:/g' with /g for global" \
    "sed 's/http:/https:/g' data/text/urls.txt | wc -l" \
    "The /g flag replaces all occurrences on each line, not just first"

# Exercise 3: Delete lines
run_exercise 3 \
    "Delete all INFO lines from application.log, count remaining" \
    "data/logs/application.log" \
    "100" \
    "100 lines remaining" \
    "numeric" \
    "Use sed '/INFO/d' to delete matching lines" \
    "sed '/INFO/d' data/logs/application.log | wc -l" \
    "/pattern/d deletes all lines matching the pattern"

# Exercise 4: Print specific lines
run_exercise 4 \
    "Print only line 10 from accounts.csv" \
    "data/csv/accounts.csv" \
    "ACC-009" \
    "Line starts with ACC-009" \
    "contains" \
    "Use sed -n '10p' to print line 10 only" \
    "sed -n '10p' data/csv/accounts.csv" \
    "-n suppresses normal output, p prints specified line"

# Exercise 5: Line range
run_exercise 5 \
    "Print lines 2-4 from accounts.csv, count them" \
    "data/csv/accounts.csv" \
    "3" \
    "3 lines" \
    "numeric" \
    "Use sed -n '2,4p' for range" \
    "sed -n '2,4p' data/csv/accounts.csv | wc -l" \
    "-n suppresses output, '2,4p' prints lines 2 through 4"

# ============================================
# INTERMEDIATE EXERCISES (6-10)
# ============================================

# Exercise 6: Multiple substitutions
run_exercise 6 \
    "Replace 'ERROR' with 'ERR' AND 'WARNING' with 'WARN', count matches" \
    "data/logs/application.log" \
    "97" \
    "~97 lines with ERR or WARN" \
    "numeric" \
    "Chain sed commands with -e or semicolon" \
    "sed -e 's/ERROR/ERR/g' -e 's/WARNING/WARN/g' data/logs/application.log | grep -E 'ERR|WARN' | wc -l" \
    "Multiple -e options allow multiple edit commands"

# Exercise 7: Delete range
run_exercise 7 \
    "Delete lines 1-5 from accounts.csv, count remaining" \
    "data/csv/accounts.csv" \
    "20" \
    "20 lines remaining" \
    "numeric" \
    "Use sed '1,5d' to delete range" \
    "sed '1,5d' data/csv/accounts.csv | wc -l" \
    "'1,5d' deletes lines 1 through 5"

# Exercise 8: Capture groups
run_exercise 8 \
    "Extract domain from first URL in urls.txt (just the domain, no http:// or path)" \
    "data/text/urls.txt" \
    "example.com" \
    "Just the domain" \
    "contains" \
    "Use sed with capture groups and back-references" \
    "head -1 data/text/urls.txt | sed 's|https\\?://\\([^/]*\\).*|\\1|'" \
    "\\(...\\) captures, \\1 references capture. \\? makes 's' optional"

# Exercise 9: In-place line numbering
run_exercise 9 \
    "Add line numbers to first 3 email addresses (format: '1. email@domain')" \
    "data/text/emails.txt" \
    "3" \
    "3 numbered lines" \
    "lines" \
    "Use sed with = then process output" \
    "head -3 data/text/emails.txt | sed '=' | sed 'N;s/\\n/. /' | wc -l" \
    "sed '=' adds line numbers. N joins lines. s/\\n/. / formats them"

# Exercise 10: Remove empty lines
run_exercise 10 \
    "Remove all empty lines from config-files.txt, count remaining" \
    "data/text/config-files.txt" \
    "55" \
    "~55 non-empty lines" \
    "numeric" \
    "Use sed '/^$/d' to delete empty lines" \
    "sed '/^$/d' data/text/config-files.txt | wc -l" \
    "/^$/ matches empty lines (^ = start, $ = end)"

# ============================================
# ADVANCED EXERCISES (11-13)
# ============================================

# Exercise 11: Complex pattern replacement
run_exercise 11 \
    "Extract just IP addresses from web-access.log line 1 (remove everything else)" \
    "data/logs/web-access.log" \
    "192.168.1" \
    "Starts with 192.168.1" \
    "contains" \
    "Use sed with regex to extract IP" \
    "head -1 data/logs/web-access.log | sed 's/^\\([0-9.]\\+\\).*/\\1/'" \
    "Captures IP at start of line with \\([0-9.]\\+\\), replaces entire line with \\1"

# Exercise 12: Multi-line editing
run_exercise 12 \
    "Replace all newlines with spaces in first 3 emails, count words" \
    "data/text/emails.txt" \
    "3" \
    "3 words (emails)" \
    "numeric" \
    "Use sed with N to join lines, tr to remove newlines" \
    "head -3 data/text/emails.txt | tr '\\n' ' ' | wc -w" \
    "tr '\\n' ' ' is simpler than sed for this case"

# Exercise 13: Conditional replacement
run_exercise 13 \
    "In accounts.csv, replace 'Technology' with 'Tech' only in lines containing 'ACC-001'" \
    "data/csv/accounts.csv" \
    "ACC-001" \
    "Line with ACC-001 and Tech" \
    "contains" \
    "Use sed with address: /pattern/s/old/new/" \
    "sed '/ACC-001/s/Technology/Tech/' data/csv/accounts.csv | grep ACC-001" \
    "/ACC-001/ is address (which lines), s/Technology/Tech/ is command"

# ============================================
# EXPERT EXERCISES (14-15)
# ============================================

# Exercise 14: Complex transformation pipeline
run_exercise 14 \
    "Count lines in application.log after: remove timestamps, delete INFO, remove empty lines" \
    "data/logs/application.log" \
    "82" \
    "~82 lines" \
    "numeric" \
    "Chain multiple sed commands" \
    "sed 's/^[0-9-]\\+ [0-9:]\\+ //' data/logs/application.log | sed '/INFO/d' | sed '/^$/d' | wc -l" \
    "Multiple sed commands can be chained: remove timestamps, delete INFO, remove empty"

# Exercise 15: Extract and transform
run_exercise 15 \
    "From mixed-content.txt, extract all lines starting with 'Name:' and count them" \
    "data/text/mixed-content.txt" \
    "3" \
    "3 Name lines" \
    "numeric" \
    "Use sed -n with pattern and p" \
    "sed -n '/^Name:/p' data/text/mixed-content.txt | wc -l" \
    "-n suppresses output, /^Name:/p prints only matching lines"

show_final_score "$COMMAND"

echo ""
echo "What's next?"
echo "  • Review: ../demos/intermediate/03-data-transformation.sh"
echo "  • Reference: ../../02-commands/sed.md"
echo "  • Next command: ./jq-practice.sh"
echo ""
