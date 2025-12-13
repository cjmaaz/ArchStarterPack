#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="ps"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: Using log data to simulate process listing concepts."
run_exercise 1 "Simulate: List all processes" "data/logs/system.log" "49" "49 log entries" "lines" "ps aux concept" "wc -l < data/logs/system.log" "ps aux shows all"
run_exercise 2 "Simulate: User processes only" "data/logs/system.log" "6" "6 user entries" "numeric" "ps -u concept" "grep -c 'admin' data/logs/system.log" "ps -u shows user procs"
run_exercise 3 "Simulate: Process tree concept" "data/logs/system.log" "hierarchy" "Shows tree" "contains" "ps -ef --forest concept" "echo 'process hierarchy tree'" "ps shows tree"
run_exercise 4 "Simulate: Specific columns" "data/csv/server-metrics.csv" "38" "38 lines" "lines" "ps -o concept" "wc -l < data/csv/server-metrics.csv" "ps -o custom columns"
run_exercise 5 "Simulate: Sort by CPU" "data/csv/server-metrics.csv" "96" "~96% max CPU" "numeric" "Sort by CPU field" "tail -n +2 data/csv/server-metrics.csv | sort -t',' -k3 -nr | head -1 | cut -d',' -f3 | cut -d'.' -f1" "ps --sort=%cpu"
run_exercise 6 "Simulate: Sort by memory" "data/csv/server-metrics.csv" "97" "~97% max mem" "numeric" "Sort by mem field" "tail -n +2 data/csv/server-metrics.csv | sort -t',' -k4 -nr | head -1 | cut -d',' -f4 | cut -d'.' -f1" "ps --sort=%mem"
run_exercise 7 "Simulate: Filter by name" "data/logs/system.log" "3" "3 systemd entries" "numeric" "ps | grep pattern" "grep -c 'systemd' data/logs/system.log" "Filter process list"
run_exercise 8 "Simulate: Show threads" "data/logs/system.log" "49" "All entries" "lines" "ps -T concept" "wc -l < data/logs/system.log" "ps -T shows threads"
run_exercise 9 "Simulate: Custom format" "data/csv/server-metrics.csv" "server" "Shows server" "contains" "ps custom format" "head -2 data/csv/server-metrics.csv | tail -1 | cut -d',' -f2" "ps -o pid,cmd"
run_exercise 10 "Simulate: Count running processes" "data/logs/system.log" "25" "~25 running" "numeric" "Count active" "grep -c 'Started\\|Running' data/logs/system.log" "Count process states"

show_final_score "$COMMAND"
