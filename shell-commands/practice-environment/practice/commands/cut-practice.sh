#!/usr/bin/env bash
# cut Practice - 12 Interactive Exercises

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"

COMMAND="cut"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

# BEGINNER
run_exercise 1 "Extract 2nd field (Name) from accounts.csv, count lines" "data/csv/accounts.csv" "25" "25 names" "lines" "Use cut -d',' -f2" "cut -d',' -f2 data/csv/accounts.csv | wc -l" "cut -d sets delimiter, -f selects field"

run_exercise 2 "Extract fields 2 and 3 (Name,Industry) from first 3 accounts" "data/csv/accounts.csv" "3" "3 lines" "lines" "Use cut -d',' -f2,3 and head" "cut -d',' -f2,3 data/csv/accounts.csv | head -3 | wc -l" "-f2,3 selects multiple fields"

run_exercise 3 "Extract characters 1-10 from first line of urls.txt" "data/text/urls.txt" "https://ex" "First 10 chars" "contains" "Use cut -c1-10" "head -1 data/text/urls.txt | cut -c1-10" "-c selects character positions"

run_exercise 4 "Count unique values in 3rd field (Industry)" "data/csv/accounts.csv" "4" "4 industries" "numeric" "Extract field 3, sort, unique" "cut -d',' -f3 data/csv/accounts.csv | sort -u | wc -l" "Pipe to sort -u for unique values"

# INTERMEDIATE
run_exercise 5 "Extract all fields except first from accounts.csv header" "data/csv/accounts.csv" "Name" "Starts with Name" "contains" "Use cut with --complement" "head -1 data/csv/accounts.csv | cut -d',' -f2-" "-f2- means from field 2 to end"

run_exercise 6 "Extract 4th field (Revenue) only for Technology accounts" "data/csv/accounts.csv" "8" "8 revenues" "lines" "Filter with grep, then cut" "grep Technology data/csv/accounts.csv | cut -d',' -f4 | wc -l" "Combine grep for filtering with cut"

run_exercise 7 "Extract bytes 1-20 from first log line" "data/logs/application.log" "2025-12-09 08:15:34" "Timestamp" "contains" "Use cut -b1-20" "head -1 data/logs/application.log | cut -b1-20" "-b selects bytes (similar to -c)"

run_exercise 8 "Count unique servers from server-metrics.csv" "data/csv/server-metrics.csv" "4" "4 servers" "numeric" "Extract server field, unique" "cut -d',' -f2 data/csv/server-metrics.csv | sort -u | wc -l" "Field 2 contains server names"

# ADVANCED
run_exercise 9 "Extract domain from URLs (remove http:// and path)" "data/text/urls.txt" "20" "20 domains" "lines" "Use cut with delimiter /" "sed 's|https\\?://||' data/text/urls.txt | cut -d'/' -f1 | wc -l" "Remove protocol first, then cut on /"

run_exercise 10 "Sum revenue (field 4) for first 10 accounts" "data/csv/accounts.csv" "100000000" "~100M" "numeric" "Cut field 4, skip header, sum with awk" "tail -n +2 data/csv/accounts.csv | head -10 | cut -d',' -f4 | awk '{sum+=\$1} END {print sum}'" "Combine cut with awk for calculations"

# EXPERT
run_exercise 11 "Extract email usernames (before @) from emails.txt, count unique" "data/text/emails.txt" "20" "20 unique" "numeric" "Cut on @ delimiter, get first part" "cut -d'@' -f1 data/text/emails.txt | sort -u | wc -l" "@ is delimiter, field 1 is username"

run_exercise 12 "Get average of field 3 (CPU) from server-metrics.csv" "data/csv/server-metrics.csv" "57" "~57% (55-59)" "numeric" "Extract field, skip header, calculate avg" "tail -n +2 data/csv/server-metrics.csv | cut -d',' -f3 | awk '{sum+=\$1; n++} END {print int(sum/n)}'" "Cut extracts field, awk calculates average"

show_final_score "$COMMAND"
echo ""
echo "Next: ./sort-practice.sh"
