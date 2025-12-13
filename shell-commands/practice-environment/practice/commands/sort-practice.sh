#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="sort"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Sort emails.txt alphabetically, show first email" "data/text/emails.txt" "admin" "Starts with admin" "contains" "Use sort and head" "sort data/text/emails.txt | head -1" "sort orders lines alphabetically"
run_exercise 2 "Sort emails in reverse, count lines" "data/text/emails.txt" "20" "20 lines" "lines" "Use sort -r" "sort -r data/text/emails.txt | wc -l" "sort -r reverses order"
run_exercise 3 "Sort accounts by name (field 2), show first" "data/csv/accounts.csv" "Acme" "Starts with Acme" "contains" "Use sort -t',' -k2" "sort -t',' -k2 data/csv/accounts.csv | head -1" "-t sets delimiter, -k selects key"
run_exercise 4 "Sort accounts by revenue (field 4) numerically, highest first" "data/csv/accounts.csv" "24000000" "24M revenue" "contains" "Use sort -t',' -k4 -nr" "sort -t',' -k4 -nr data/csv/accounts.csv | head -1 | cut -d',' -f4" "-n for numeric, -r for reverse"
run_exercise 5 "Count unique industries after sorting" "data/csv/accounts.csv" "4" "4 unique" "numeric" "Cut industry, sort, unique" "cut -d',' -f3 data/csv/accounts.csv | sort -u | wc -l" "sort -u removes duplicates"
run_exercise 6 "Sort server-metrics by CPU (field 3) numerically, get highest" "data/csv/server-metrics.csv" "96" "~96% (accept 94-97)" "numeric" "Sort numeric, reverse, extract value" "tail -n +2 data/csv/server-metrics.csv | sort -t',' -k3 -nr | head -1 | cut -d',' -f3 | cut -d'.' -f1" "Numeric sort on field 3"
run_exercise 7 "Sort IPs from web-access.log, count unique" "data/logs/web-access.log" "25" "25 unique IPs" "numeric" "Extract IPs, sort unique" "awk '{print \$1}' data/logs/web-access.log | sort -u | wc -l" "sort -u for unique sorted list"
run_exercise 8 "Sort by 2nd field then 3rd field" "data/csv/accounts.csv" "25" "25 lines" "lines" "Use sort -t',' -k2,2 -k3,3" "sort -t',' -k2,2 -k3,3 data/csv/accounts.csv | wc -l" "Multiple -k for secondary sort"
run_exercise 9 "Sort case-insensitive, count lines" "data/text/mixed-content.txt" "107" "107 lines" "numeric" "Use sort -f" "sort -f data/text/mixed-content.txt | wc -l" "sort -f ignores case"
run_exercise 10 "Sort by month in dates (complex)" "data/csv/server-metrics.csv" "38" "38 lines" "lines" "Regular sort works for ISO dates" "sort -t',' -k1 data/csv/server-metrics.csv | wc -l" "ISO format sorts correctly"
run_exercise 11 "Find 3rd highest revenue" "data/csv/accounts.csv" "20000000" "~20M" "numeric" "Sort numeric reverse, get 3rd" "tail -n +2 data/csv/accounts.csv | cut -d',' -f4 | sort -nr | sed -n '3p'" "sort -nr then select line 3"
run_exercise 12 "Sort and check if sorted (no output means sorted)" "data/text/urls.txt" "20" "20 lines" "lines" "Use sort -c to check, or just sort" "sort data/text/urls.txt | wc -l" "sort -c checks if sorted"

show_final_score "$COMMAND"
echo "Next: ./uniq-practice.sh"
