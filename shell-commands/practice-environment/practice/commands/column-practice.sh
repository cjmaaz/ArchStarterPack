#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="column"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Format CSV as table" "data/csv/accounts.csv" "26" "26 lines formatted" "lines" "Use column -t -s','" "column -t -s',' < data/csv/accounts.csv | wc -l" "column -t creates table, -s sets separator"
run_exercise 2 "Format space-separated into columns" "data/text/mixed-content.txt" "107" "107 lines" "lines" "Use column without -t" "column < data/text/mixed-content.txt | wc -l" "column formats into columns"
run_exercise 3 "Format with custom output separator" "data/csv/accounts.csv" "26" "26 lines" "lines" "column -t -s',' -o' | '" "column -t -s',' -o' | ' < data/csv/accounts.csv | wc -l" "-o sets output separator"
run_exercise 4 "Fill rows (DEPRECATED but count output)" "data/text/emails.txt" "20" "20 formatted" "lines" "Just use column" "column < data/text/emails.txt | wc -l" "Formats in columns"
run_exercise 5 "Table with headers" "data/csv/accounts.csv" "26" "26 rows" "lines" "column -t" "column -t -s',' < data/csv/accounts.csv | wc -l" "Aligns columns"
run_exercise 6 "Format list into table" "data/text/urls.txt" "20" "20 formatted" "lines" "column -t" "column -t < data/text/urls.txt | wc -l" "Single column table"
run_exercise 7 "Specify table columns" "data/csv/server-metrics.csv" "38" "38 rows" "lines" "column with CSV" "column -t -s',' < data/csv/server-metrics.csv | wc -l" "Format metrics table"
run_exercise 8 "Format key-value pairs" "data/text/config-files.txt" "61" "~61 lines" "lines" "Use column -t" "column -t < data/text/config-files.txt | wc -l" "Aligns config file"
run_exercise 9 "JSON formatted (count)" "data/json/users.json" "64" "64 lines" "lines" "column on JSON" "column < data/json/users.json | wc -l" "Can format any text"
run_exercise 10 "Multi-column file list" "" "25" "~25 files in cols" "lines" "ls | column" "ls data/csv data/json data/logs data/text | column | wc -l" "Format file listings"

show_final_score "$COMMAND"
