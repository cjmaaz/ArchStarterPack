#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="echo"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Print simple text" "" "Hello World" "Hello World" "contains" "echo text" "echo 'Hello World'" "echo prints text"
run_exercise 2 "Print without newline" "" "test" "No newline" "contains" "echo -n" "echo -n 'test'" "echo -n suppresses newline"
run_exercise 3 "Print with escape sequences" "" "line1" "Two lines" "contains" "echo -e" "echo -e 'line1\\nline2' | head -1" "echo -e interprets escapes"
run_exercise 4 "Print variable value" "" "USER" "Shows USER" "contains" "echo \$VAR" "echo \$USER" "echo expands variables"
run_exercise 5 "Print to file" "" "3" "3 lines" "lines" "echo > file" "echo 'line1' > /tmp/echo-test.txt && echo 'line2' >> /tmp/echo-test.txt && echo 'line3' >> /tmp/echo-test.txt && wc -l < /tmp/echo-test.txt" "Redirect echo output"
run_exercise 6 "Print with tab" "" "word1\tword2" "Tab separated" "contains" "echo -e with \\t" "echo -e 'word1\\tword2'" "\\t for tabs"
run_exercise 7 "Print colored text (count)" "" "text" "Colored output" "contains" "echo with color codes" "echo -e '\\033[32mtext\\033[0m'" "ANSI color codes"
run_exercise 8 "Print multiple arguments" "" "3" "3 words" "numeric" "echo word1 word2 word3" "echo 'word1 word2 word3' | wc -w" "echo joins arguments"
run_exercise 9 "Print arithmetic result" "" "5" "Result is 5" "contains" "echo \$((expr))" "echo \$((2 + 3))" "Arithmetic expansion"
run_exercise 10 "Print command substitution" "data/text/emails.txt" "20" "20 lines" "contains" "echo \$(command)" "echo \$(wc -l < data/text/emails.txt)" "Command substitution"

show_final_score "$COMMAND"
