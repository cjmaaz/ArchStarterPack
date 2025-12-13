#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="tail"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Show last 5 lines of accounts.csv" "data/csv/accounts.csv" "5" "5 lines" "lines" "Use tail -5" "tail -5 data/csv/accounts.csv | wc -l" "tail -n shows last n lines"
run_exercise 2 "Show last line of accounts.csv" "data/csv/accounts.csv" "ACC-025" "Last account" "contains" "Use tail -1" "tail -1 data/csv/accounts.csv" "tail -1 gets last line"
run_exercise 3 "Skip header (all except first line)" "data/csv/accounts.csv" "25" "25 data rows" "lines" "Use tail -n +2" "tail -n +2 data/csv/accounts.csv | wc -l" "tail -n +2 starts from line 2"
run_exercise 4 "Last 100 bytes of log" "data/logs/application.log" "connection" "Contains text" "contains" "Use tail -c100" "tail -c100 data/logs/application.log" "tail -c shows last n bytes"
run_exercise 5 "Last 3 unique IPs from web log" "data/logs/web-access.log" "3" "3 IPs" "lines" "Extract IPs, unique, tail" "awk '{print \$1}' data/logs/web-access.log | sort -u | tail -3 | wc -l" "Process then get last n"
run_exercise 6 "All except first 5 lines" "data/text/emails.txt" "15" "15 lines" "numeric" "Use tail -n +6" "tail -n +6 data/text/emails.txt | wc -l" "Start from line 6"
run_exercise 7 "Last ERROR from log" "data/logs/application.log" "ERROR" "Contains ERROR" "contains" "Grep then tail -1" "grep ERROR data/logs/application.log | tail -1" "Find then get last"
run_exercise 8 "Middle lines (skip first 10, show next 5)" "data/csv/accounts.csv" "5" "5 lines" "lines" "tail +11 then head -5" "tail -n +11 data/csv/accounts.csv | head -5 | wc -l" "Combine tail and head for middle"
run_exercise 9 "Last 5 accounts sorted by name" "data/csv/accounts.csv" "5" "5 lines" "lines" "Sort then tail" "sort -t',' -k2 data/csv/accounts.csv | tail -5 | wc -l" "Process then extract last n"
run_exercise 10 "Count data rows (skip header)" "data/csv/accounts.csv" "25" "25 rows" "numeric" "tail -n +2 then wc" "tail -n +2 data/csv/accounts.csv | wc -l" "Common pattern for CSV"
run_exercise 11 "Last 10 lines from all logs" "data/logs/" "24" "24 lines (4 files x ~6)" "numeric" "tail on multiple files" "tail -n 2 data/logs/*.log | grep -v '^==' | wc -l" "tail on multiple shows all"
run_exercise 12 "Extract last 3 errors" "data/logs/application.log" "3" "3 errors" "lines" "Grep ERROR, tail -3" "grep ERROR data/logs/application.log | tail -3 | wc -l" "Filter then extract last n"

show_final_score "$COMMAND"
