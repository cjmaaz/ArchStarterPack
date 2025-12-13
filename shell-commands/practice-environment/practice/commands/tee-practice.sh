#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="tee"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Copy to file and count output" "data/text/emails.txt" "20" "20 lines" "lines" "Use tee to write and display" "cat data/text/emails.txt | tee /tmp/test-tee.txt | wc -l" "tee writes to file and stdout"
run_exercise 2 "Append to file with tee -a" "data/text/emails.txt" "40" "40 lines (20+20)" "lines" "Run twice with -a" "cat data/text/emails.txt | tee /tmp/test-tee2.txt > /dev/null; cat data/text/emails.txt | tee -a /tmp/test-tee2.txt > /dev/null; wc -l < /tmp/test-tee2.txt" "tee -a appends instead of overwriting"
run_exercise 3 "Save ERROR lines and count" "data/logs/application.log" "47" "47 errors" "numeric" "grep | tee | wc" "grep ERROR data/logs/application.log | tee /tmp/errors.txt | wc -l" "Can save intermediate results"
run_exercise 4 "Multiple output files" "data/text/emails.txt" "20" "20 lines" "lines" "tee file1 file2" "cat data/text/emails.txt | tee /tmp/out1.txt /tmp/out2.txt | wc -l" "tee can write to multiple files"
run_exercise 5 "Capture and process" "data/csv/accounts.csv" "25" "25 lines" "lines" "tee for split processing" "tail -n +2 data/csv/accounts.csv | tee /tmp/data.txt | wc -l" "Common pattern: save and process"
run_exercise 6 "Log pipeline output" "data/logs/application.log" "47" "47 errors" "lines" "grep | tee log | process" "grep ERROR data/logs/application.log | tee /tmp/error-log.txt | wc -l" "Save logs while processing"
run_exercise 7 "Tee with sudo simulation (count)" "data/text/emails.txt" "20" "20 lines" "lines" "tee for privileged write" "cat data/text/emails.txt | tee /tmp/priv.txt | wc -l" "tee useful for sudo writes"
run_exercise 8 "Ignore interrupts (tee -i)" "data/text/urls.txt" "20" "20 lines" "lines" "Use tee -i" "cat data/text/urls.txt | tee -i /tmp/urls.txt | wc -l" "tee -i ignores SIGINT"
run_exercise 9 "Save sorted output" "data/text/emails.txt" "20" "20 sorted" "lines" "sort | tee" "sort data/text/emails.txt | tee /tmp/sorted.txt | wc -l" "Save intermediate sort results"
run_exercise 10 "Pipeline with multiple tees" "data/csv/accounts.csv" "25" "25 lines" "lines" "Multiple tee stages" "tail -n +2 data/csv/accounts.csv | tee /tmp/stage1.txt | cut -d',' -f2 | tee /tmp/stage2.txt | wc -l" "Can have multiple tees in pipeline"

show_final_score "$COMMAND"
