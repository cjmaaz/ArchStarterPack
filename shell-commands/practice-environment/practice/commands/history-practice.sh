#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="history"
TOTAL_EXERCISES=10
init_practice "$COMMAND"$TOTAL_EXERCISES

echo "Note: Simulating history concepts. Real history varies by shell."
run_exercise 1 "Show command history (simulate)" "" "10" ">10 commands" "numeric" "history command" "fc -l 2>/dev/null | wc -l || echo '10'" "history shows commands"
run_exercise 2 "Show last N commands" "" "5" "Last 5" "numeric" "history N" "fc -l -5 2>/dev/null | wc -l || echo '5'" "Limit output"
run_exercise 3 "Search history" "" "echo" "Found echo" "contains" "history | grep" "fc -l 2>/dev/null | grep -i 'echo' | head -1 || echo 'echo command'" "Grep history"
run_exercise 4 "Execute last command" "" "repeat" "!! repeats" "contains" "!! concept" "echo 'repeat'" "!! executes last"
run_exercise 5 "Execute command by number" "" "by_number" "Executes by #" "contains" "!N concept" "echo 'by_number'" "!N runs command N"
run_exercise 6 "Execute last matching command" "" "match" "Executes match" "contains" "!string concept" "echo 'last matching command'" "!string finds command"
run_exercise 7 "Clear history" "" "cleared" "History cleared" "contains" "history -c" "history -c 2>/dev/null; echo 'cleared'" "history -c clears"
run_exercise 8 "Save history" "" "saved" "History saved" "contains" "history -w" "history -w 2>/dev/null; echo 'saved'" "history -w writes"
run_exercise 9 "Delete specific entry" "" "deleted" "Entry removed" "contains" "history -d N" "history -d 1 2>/dev/null; echo 'deleted' || echo 'deleted'" "history -d deletes"
run_exercise 10 "Prevent command from history" "" "no_history" "Not saved" "contains" "Space prefix or HISTCONTROL" "echo 'command with space prefix not saved: no_history'" "Space prevents history"

show_final_score "$COMMAND"
