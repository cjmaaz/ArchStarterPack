#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="diff"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Check if two files are identical (exit code)" "data/csv/accounts.csv" "0" "Files differ" "numeric" "Compare file with itself" "diff data/csv/accounts.csv data/csv/accounts.csv; echo \$?" "diff exits 0 if identical"
run_exercise 2 "Count lines of difference" "data/csv/" "17" "~17 different" "lines" "diff two CSVs" "diff data/csv/accounts.csv data/csv/contacts.csv | wc -l" "Shows changed lines"
run_exercise 3 "Show only if files differ (-q)" "data/csv/" "differ" "Files differ message" "contains" "Use diff -q" "diff -q data/csv/accounts.csv data/csv/contacts.csv" "-q shows only if different"
run_exercise 4 "Unified diff format" "data/csv/" "20" "~20 lines" "lines" "Use diff -u" "diff -u data/csv/accounts.csv data/csv/contacts.csv | wc -l" "-u shows unified format"
run_exercise 5 "Context diff" "data/csv/" "25" "~25 lines" "lines" "Use diff -c" "diff -c data/csv/accounts.csv data/csv/contacts.csv | wc -l" "-c shows context"
run_exercise 6 "Side-by-side diff (count lines)" "data/csv/" "26" "~26 lines" "lines" "Use diff -y" "diff -y data/csv/accounts.csv data/csv/contacts.csv | wc -l" "-y shows side by side"
run_exercise 7 "Ignore whitespace" "data/text/" "0" "Same ignoring space" "numeric" "Use diff -w" "diff -w data/text/emails.txt data/text/emails.txt; echo \$?" "-w ignores whitespace"
run_exercise 8 "Ignore case" "data/text/" "0" "Same ignoring case" "numeric" "Use diff -i" "diff -i data/text/emails.txt data/text/emails.txt; echo \$?" "-i ignores case"
run_exercise 9 "Brief output for directories" "" "differ" "Differ or identical" "contains" "diff -q on dirs" "diff -q data/csv data/json || echo 'differ'" "Can compare directories"
run_exercise 10 "Generate patch (count lines)" "data/csv/" "15" "~15 patch lines" "lines" "Use diff for patch" "diff -u data/csv/accounts.csv data/csv/contacts.csv | grep '^[+-]' | wc -l" "Patch shows changes"

show_final_score "$COMMAND"
