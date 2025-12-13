#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="uniq"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Remove duplicate adjacent lines from sorted emails" "data/text/emails.txt" "20" "20 unique" "lines" "Sort first, then uniq" "sort data/text/emails.txt | uniq | wc -l" "uniq only removes adjacent duplicates"
run_exercise 2 "Count occurrences with uniq -c, count output lines" "data/text/emails.txt" "20" "20 unique" "lines" "Sort and uniq -c" "sort data/text/emails.txt | uniq -c | wc -l" "uniq -c shows count prefix"
run_exercise 3 "Show only duplicated lines" "data/csv/accounts.csv" "0" "0 duplicates" "numeric" "Use uniq -d after sort" "cut -d',' -f3 data/csv/accounts.csv | sort | uniq -d | wc -l" "uniq -d shows only duplicates"
run_exercise 4 "Show only unique (non-duplicated) industries" "data/csv/accounts.csv" "4" "4 unique" "numeric" "Sort and uniq" "cut -d',' -f3 data/csv/accounts.csv | sort | uniq | wc -l" "Standard unique count"
run_exercise 5 "Count duplicate IPs in web-access.log" "data/logs/web-access.log" "25" "25 with duplicates" "lines" "Extract, sort, uniq -c" "awk '{print \$1}' data/logs/web-access.log | sort | uniq -c | wc -l" "Each unique IP gets count"
run_exercise 6 "Find most common error message" "data/logs/application.log" "Database" "Contains Database" "contains" "Grep errors, sort, uniq -c, sort numeric" "grep ERROR data/logs/application.log | awk '{for(i=4;i<=NF;i++)printf \$i\" \";print\"\"}' | sort | uniq -c | sort -nr | head -1" "Pipeline: filter, count, sort by count"
run_exercise 7 "Show only lines that appear exactly once" "data/text/emails.txt" "20" "20 appear once" "lines" "Use uniq -u" "sort data/text/emails.txt | uniq -u | wc -l" "uniq -u shows unique only"
run_exercise 8 "Ignore case when finding uniques" "data/text/mixed-content.txt" "105" "~105 unique" "numeric" "Use sort -f and uniq -i" "sort -f data/text/mixed-content.txt | uniq -i | wc -l" "uniq -i ignores case"
run_exercise 9 "Get count of most frequent industry" "data/csv/accounts.csv" "8" "8 Technology" "numeric" "Cut, sort, uniq -c, sort -nr, extract count" "cut -d',' -f3 data/csv/accounts.csv | sort | uniq -c | sort -nr | head -1 | awk '{print \$1}'" "Most frequent count"
run_exercise 10 "Count unique HTTP statuses in web-access.log" "data/logs/web-access.log" "3" "3 unique statuses" "numeric" "Extract status, unique count" "awk '{print \$9}' data/logs/web-access.log | sort -u | wc -l" "Field 9 is status code"

show_final_score "$COMMAND"
