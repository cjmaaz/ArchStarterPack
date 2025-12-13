#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="paste"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Merge two files side by side" "data/text/" "20" "20 merged lines" "lines" "Use paste file1 file2" "paste data/text/emails.txt data/text/urls.txt | wc -l" "paste merges files horizontally"
run_exercise 2 "Change delimiter to comma" "data/text/" "20" "20 lines" "lines" "Use paste -d','" "paste -d',' data/text/emails.txt data/text/urls.txt | wc -l" "-d sets delimiter"
run_exercise 3 "Merge 3 files" "data/csv/" "26" "26 lines" "lines" "paste 3 files" "paste data/csv/accounts.csv data/csv/contacts.csv data/csv/sales-data.csv | wc -l" "Can merge multiple files"
run_exercise 4 "Serial mode (-s)" "data/text/emails.txt" "1" "1 long line" "lines" "Use paste -s" "paste -s data/text/emails.txt | wc -l" "paste -s merges all lines into one"
run_exercise 5 "Serial with custom delimiter" "data/text/emails.txt" "," "Contains commas" "contains" "paste -s -d','" "paste -s -d',' data/text/emails.txt" "Serial mode with delimiter"
run_exercise 6 "Merge columns from same file" "" "3" "3 columns" "contains" "paste with -" "cut -d',' -f1 data/csv/accounts.csv | paste - - - | head -1" "- reads from stdin"
run_exercise 7 "Transpose rows to columns" "data/text/" "20" "20 in one line" "contains" "paste -s with tabs" "head -3 data/text/emails.txt | paste -s -d'\\t'" "Transpose with serial mode"
run_exercise 8 "Merge with multiple delimiters" "data/csv/" "26" "26 merged" "lines" "paste -d',|'" "paste -d',|' data/csv/accounts.csv data/csv/contacts.csv data/csv/sales-data.csv | wc -l" "Alternates delimiters"
run_exercise 9 "Create CSV from separate columns" "data/csv/" "26" "26 CSV lines" "lines" "Extract cols, paste with comma" "cut -d',' -f1 data/csv/accounts.csv > /tmp/col1.txt && cut -d',' -f2 data/csv/accounts.csv > /tmp/col2.txt && paste -d',' /tmp/col1.txt /tmp/col2.txt | wc -l" "Reconstruct CSV"
run_exercise 10 "Interleave lines from two files" "data/text/" "40" "40 interleaved" "lines" "paste -d'\\n'" "paste -d'\\n' data/text/emails.txt data/text/urls.txt | wc -l" "Newline delimiter interleaves"

show_final_score "$COMMAND"
