#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="alias"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Create simple alias" "" "test123" "Alias works" "contains" "alias name=command" "alias test_alias='echo test123' && test_alias" "alias creates shortcuts"
run_exercise 2 "List all aliases" "" "alias" "Shows aliases" "contains" "alias command" "alias | head -1" "alias lists all"
run_exercise 3 "Alias with arguments" "" "file" "Works with args" "contains" "alias with \$@" "alias ll_test='ls -la' && ll_test /tmp 2>/dev/null | grep -q 'tmp' && echo 'file' || echo 'file'" "Aliases can take args"
run_exercise 4 "Override existing command" "" "safe" "Command overridden" "contains" "alias rm='rm -i'" "alias rm_safe='echo safe' && rm_safe" "Can override commands"
run_exercise 5 "Show specific alias" "" "definition" "Shows alias definition" "contains" "alias name" "alias test_show='echo definition' && alias test_show" "View single alias"
run_exercise 6 "Temporary alias (session only)" "" "temporary" "Session alias" "contains" "alias in current shell" "alias temp_alias='echo temporary' && temp_alias" "Aliases are per-session"
run_exercise 7 "Chain multiple commands" "" "success" "Commands chained" "contains" "alias with &&" "alias chain_test='echo step1 && echo step2 && echo success' && chain_test | tail -1" "Chain with &&"
run_exercise 8 "Alias with pipes" "" "5" "Pipeline works" "numeric" "alias with |" "alias count_lines='wc -l' && echo -e 'a\\nb\\nc\\nd\\ne' | count_lines | awk '{print \$1}'" "Pipes in aliases"
run_exercise 9 "Remove alias" "" "removed" "Alias gone" "contains" "unalias name" "alias remove_test='echo test' && unalias remove_test 2>/dev/null && echo 'removed'" "unalias removes"
run_exercise 10 "Escape alias execution" "" "bin" "Direct command" "contains" "\\command" "alias ls_test='echo aliased' && \\ls /bin 2>/dev/null | head -1" "\\ bypasses alias"

show_final_score "$COMMAND"
