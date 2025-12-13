#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="cat"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Display and count lines in urls.txt" "data/text/urls.txt" "20" "20 lines" "lines" "Use cat and wc" "cat data/text/urls.txt | wc -l" "cat displays file contents"
run_exercise 2 "Concatenate two CSV files, count total lines" "data/csv/" "43" "43 lines" "numeric" "Use cat file1 file2" "cat data/csv/accounts.csv data/csv/contacts.csv | wc -l" "cat combines multiple files"
run_exercise 3 "Show line numbers for first 5 emails" "data/text/emails.txt" "5" "5 numbered lines" "lines" "Use cat -n and head" "cat -n data/text/emails.txt | head -5 | wc -l" "cat -n adds line numbers"
run_exercise 4 "Show non-empty lines with numbers from config" "data/text/config-files.txt" "55" "~55 lines" "numeric" "Use cat -b" "cat -b data/text/config-files.txt | wc -l" "cat -b numbers only non-empty lines"
run_exercise 5 "Display with visible tabs (count lines)" "data/csv/accounts.csv" "26" "26 lines" "lines" "Use cat -T" "cat -T data/csv/accounts.csv | wc -l" "cat -T shows tabs as ^I"
run_exercise 6 "Squeeze multiple blank lines to single" "data/text/mixed-content.txt" "100" "~100 lines" "numeric" "Use cat -s" "cat -s data/text/mixed-content.txt | wc -l" "cat -s squeezes blank lines"
run_exercise 7 "Show line endings (count lines)" "data/text/urls.txt" "20" "20 lines" "lines" "Use cat -E" "cat -E data/text/urls.txt | wc -l" "cat -E shows $ at line ends"
run_exercise 8 "Reverse file content (tac)" "data/text/emails.txt" "admin" "First line now last" "contains" "Use tac command" "tac data/text/emails.txt | tail -1" "tac is cat backwards"
run_exercise 9 "Combine all log files, count" "data/logs/" "258" "~258 lines" "numeric" "cat *.log" "cat data/logs/*.log | wc -l" "Wildcard combines all matching files"
run_exercise 10 "Create file from here doc (count output)" "" "3" "3 lines" "lines" "Use cat << EOF" "cat << 'TESTEOF'
line1
line2
line3
TESTEOF
wc -l" "cat << EOF creates files from input"

show_final_score "$COMMAND"
