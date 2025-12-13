#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="head"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Show first 5 lines of accounts.csv" "data/csv/accounts.csv" "5" "5 lines" "lines" "Use head -5" "head -5 data/csv/accounts.csv | wc -l" "head -n shows first n lines"
run_exercise 2 "Show first line (header) of accounts.csv" "data/csv/accounts.csv" "Id" "Starts with Id" "contains" "Use head -1" "head -1 data/csv/accounts.csv" "head -1 gets first line"
run_exercise 3 "Show first 100 bytes of application.log" "data/logs/application.log" "2025-12-09" "Contains date" "contains" "Use head -c100" "head -c100 data/logs/application.log" "head -c shows first n bytes"
run_exercise 4 "Show first 3 emails" "data/text/emails.txt" "3" "3 emails" "lines" "Use head -n 3" "head -n 3 data/text/emails.txt | wc -l" "head -n explicit line count"
run_exercise 5 "First line from multiple files, count" "data/logs/" "6" "6 first lines" "lines" "head -n 1 on multiple files" "head -n 1 data/logs/*.log | grep -v '^==' | wc -l" "head shows headers for multiple files"
run_exercise 6 "Get first URL from urls.txt" "data/text/urls.txt" "https://" "Starts with https" "contains" "Use head -1" "head -1 data/text/urls.txt" "First line extraction"
run_exercise 7 "All but last 5 lines (use head)" "data/text/emails.txt" "15" "15 lines" "numeric" "Use head -n -5" "head -n -5 data/text/emails.txt | wc -l" "Negative n shows all but last n"
run_exercise 8 "First 10 lines after header" "data/csv/accounts.csv" "10" "10 data lines" "lines" "Skip header, then head" "tail -n +2 data/csv/accounts.csv | head -10 | wc -l" "Combine tail and head"
run_exercise 9 "First ERROR from log" "data/logs/application.log" "ERROR" "Contains ERROR" "contains" "Grep then head -1" "grep ERROR data/logs/application.log | head -1" "Find then extract first"
run_exercise 10 "First 3 unique industries" "data/csv/accounts.csv" "3" "3 industries" "lines" "Cut, sort -u, head" "cut -d',' -f3 data/csv/accounts.csv | sort -u | head -3 | wc -l" "Process then get first n"

show_final_score "$COMMAND"
