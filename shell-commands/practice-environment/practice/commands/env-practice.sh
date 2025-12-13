#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="env"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "List all environment variables (count)" "" "10" ">10 vars" "numeric" "env command" "env | wc -l" "env lists all variables"
run_exercise 2 "Get specific variable value" "" "USER" "Contains USER or user" "contains" "env | grep" "env | grep -i USER | head -1" "Filter env vars"
run_exercise 3 "Set variable for command" "" "test123" "Shows test123" "contains" "VAR=value command" "TEST_VAR=test123 bash -c 'echo \$TEST_VAR'" "Set env for one command"
run_exercise 4 "Run command with clean environment" "" "1" "1 var" "numeric" "env -i" "env -i TEST=value env | wc -l" "env -i clears environment"
run_exercise 5 "Unset variable" "" "unset" "Var removed" "contains" "env -u" "TEST=value env -u TEST bash -c 'echo \${TEST:-unset}'" "env -u unsets variable"
run_exercise 6 "Show PATH variable" "" "bin" "Contains bin" "contains" "echo \$PATH" "echo \$PATH" "View PATH"
run_exercise 7 "Count environment variables" "" "10" ">10 variables" "numeric" "env | wc -l" "env | wc -l" "Count env vars"
run_exercise 8 "Filter variables by prefix" "" "USER" "USER vars" "contains" "env | grep ^PREFIX" "env | grep -E '^USER|^HOME' | head -1" "Filter by pattern"
run_exercise 9 "Export variable to subshell" "" "exported" "Shows value" "contains" "export VAR=value" "export TEST_EXPORT=exported && bash -c 'echo \$TEST_EXPORT'" "export makes visible"
run_exercise 10 "Simulate config vars from file" "data/text/config-files.txt" "database" "Contains config" "contains" "Parse config file" "grep -E '^[a-z_]+=' data/text/config-files.txt | head -1" "Load env from file"

show_final_score "$COMMAND"
