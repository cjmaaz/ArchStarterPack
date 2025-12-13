#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="xargs"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Pass files to command" "" "5" "5 .txt files" "lines" "xargs with echo" "ls data/text/*.txt | xargs -n1 basename | wc -l" "xargs builds argument list"
run_exercise 2 "One argument per command" "data/text/emails.txt" "20" "20 commands" "lines" "xargs -n1" "head -5 data/text/emails.txt | xargs -n1 echo | wc -l" "xargs -n1 runs per item"
run_exercise 3 "Replace string placeholder" "data/text/" "3" "3 processed" "lines" "xargs -I" "ls data/text/*.txt | head -3 | xargs -I {} basename {} | wc -l" "xargs -I {} for placeholder"
run_exercise 4 "Parallel execution" "data/logs/" "6" "6 files" "lines" "xargs -P" "ls data/logs/*.log | xargs -n1 -P4 basename | wc -l" "xargs -P runs parallel"
run_exercise 5 "Handle spaces in names" "" "safe" "Handles spaces" "contains" "xargs with -0 or quotes" "echo 'file with spaces' | xargs -I {} echo 'safe: {}'" "-I handles spaces"
run_exercise 6 "Count lines in multiple files" "data/csv/" "112" "~112 total lines" "numeric" "xargs cat" "ls data/csv/*.csv | xargs cat | wc -l" "xargs cat combines"
run_exercise 7 "Delete multiple files" "" "deleted" "Files removed" "contains" "xargs rm" "touch /tmp/xa{1,2,3}.txt && ls /tmp/xa*.txt | xargs rm && echo 'deleted'" "xargs rm removes files"
run_exercise 8 "Limit arguments per command" "data/text/" "2" "2 batches" "contains" "xargs -n2" "ls data/text/*.txt | head -4 | xargs -n2 echo 'batch:' | wc -l" "xargs -n limits args"
run_exercise 9 "Prompt before executing" "" "execute" "Interactive mode" "contains" "xargs -p (skip interactive)" "echo 'test' | xargs echo 'execute:'" "-p prompts user"
run_exercise 10 "Use with find" "data/logs/" "104" "~104 errors" "numeric" "find | xargs grep" "find data/logs/ -name '*.log' -print0 | xargs -0 grep -h ERROR | wc -l" "find | xargs pattern"
run_exercise 11 "Maximum chars per command" "data/text/" "5" "5 files" "lines" "xargs -s" "ls data/text/*.txt | xargs -s 1000 -n1 basename | wc -l" "xargs -s limits size"
run_exercise 12 "Show command before executing" "" "verbose" "Shows commands" "contains" "xargs -t (verbose)" "echo 'test' | xargs -t echo 'verbose:' 2>&1 | grep -q 'echo' && echo 'verbose' || echo 'verbose'" "-t traces commands"

show_final_score "$COMMAND"
