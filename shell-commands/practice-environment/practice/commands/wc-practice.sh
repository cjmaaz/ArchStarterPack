#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="wc"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Count lines in accounts.csv" "data/csv/accounts.csv" "26" "26 lines (header + 25)" "numeric" "Use wc -l" "wc -l < data/csv/accounts.csv" "wc -l counts lines"
run_exercise 2 "Count words in first line of urls.txt" "data/text/urls.txt" "1" "1 word" "numeric" "Use wc -w on first line" "head -1 data/text/urls.txt | wc -w" "wc -w counts words"
run_exercise 3 "Count characters in first email" "data/text/emails.txt" "20" "~20 chars (18-22)" "numeric" "Use wc -m" "head -1 data/text/emails.txt | wc -m" "wc -m counts characters"
run_exercise 4 "Count bytes in accounts.csv" "data/csv/accounts.csv" "2486" "2486 bytes" "numeric" "Use wc -c" "wc -c < data/csv/accounts.csv" "wc -c counts bytes"
run_exercise 5 "Count total lines in all log files" "data/logs/" "258" "~258 lines" "numeric" "Use wc -l on multiple files" "cat data/logs/*.log | wc -l" "Combine files then count"
run_exercise 6 "Count ERROR lines" "data/logs/application.log" "47" "47 errors" "numeric" "Grep then wc" "grep -c ERROR data/logs/application.log" "grep -c is shortcut for grep | wc -l"
run_exercise 7 "Find longest line length" "data/csv/accounts.csv" "100" "~100 chars (95-105)" "numeric" "Use wc -L" "wc -L < data/csv/accounts.csv" "wc -L shows longest line"
run_exercise 8 "Count unique lines (dedup first)" "data/text/emails.txt" "20" "20 unique" "numeric" "Sort uniq then count" "sort -u data/text/emails.txt | wc -l" "Unique then count"
run_exercise 9 "Count non-empty lines" "data/text/config-files.txt" "55" "~55 non-empty" "numeric" "Grep non-empty, count" "grep -c '.' data/text/config-files.txt" "grep '.' matches non-empty"
run_exercise 10 "Count CSV fields in header" "data/csv/accounts.csv" "7" "7 fields" "numeric" "Count commas + 1" "head -1 data/csv/accounts.csv | awk -F',' '{print NF}'" "NF is number of fields"

show_final_score "$COMMAND"
