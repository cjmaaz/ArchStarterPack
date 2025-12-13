#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="top"
TOTAL_EXERCISES=8
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: Simulating top concepts with server metrics."
run_exercise 1 "Simulate: Batch mode output" "data/csv/server-metrics.csv" "38" "38 snapshots" "lines" "top -b concept" "wc -l < data/csv/server-metrics.csv" "top -b batch mode"
run_exercise 2 "Simulate: One iteration" "data/csv/server-metrics.csv" "4" "4 servers" "numeric" "top -n 1 concept" "tail -n +2 data/csv/server-metrics.csv | head -4 | wc -l" "top -n iterations"
run_exercise 3 "Simulate: Sort by CPU" "data/csv/server-metrics.csv" "96" "~96% highest" "numeric" "Sort by CPU%" "tail -n +2 data/csv/server-metrics.csv | sort -t',' -k3 -nr | head -1 | cut -d',' -f3 | cut -d'.' -f1" "top sorts by CPU"
run_exercise 4 "Simulate: Sort by memory" "data/csv/server-metrics.csv" "97" "~97% highest" "numeric" "Sort by MEM%" "tail -n +2 data/csv/server-metrics.csv | sort -t',' -k4 -nr | head -1 | cut -d',' -f4 | cut -d'.' -f1" "top sorts by memory"
run_exercise 5 "Simulate: Filter by user" "data/logs/system.log" "6" "6 admin" "numeric" "top -u concept" "grep -c 'admin' data/logs/system.log" "top -u filters user"
run_exercise 6 "Simulate: Update interval" "" "interval" "Set delay" "contains" "top -d concept" "echo 'update interval 3s'" "top -d sets delay"
run_exercise 7 "Simulate: Show threads" "data/csv/server-metrics.csv" "38" "All threads" "lines" "top -H concept" "wc -l < data/csv/server-metrics.csv" "top -H shows threads"
run_exercise 8 "Simulate: Average CPU usage" "data/csv/server-metrics.csv" "57" "~57% average" "numeric" "Calculate avg CPU" "tail -n +2 data/csv/server-metrics.csv | cut -d',' -f3 | awk '{sum+=\$1; n++} END {print int(sum/n)}'" "Monitor averages"

show_final_score "$COMMAND"
