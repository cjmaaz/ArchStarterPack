#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="netstat"
TOTAL_EXERCISES=8
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: Conceptual exercises. Real netstat needs running system."
run_exercise 1 "Simulate: List connections (count lines)" "data/logs/web-access.log" "50" "50 connections" "lines" "netstat -a concept" "awk '{print \$1}' data/logs/web-access.log | wc -l" "netstat -a shows all"
run_exercise 2 "Simulate: TCP connections only" "data/logs/web-access.log" "50" "50 TCP" "lines" "netstat -t concept" "grep -c 'GET\\|POST' data/logs/web-access.log" "netstat -t shows TCP"
run_exercise 3 "Simulate: Listening ports concept" "" "listening" "Shows listeners" "contains" "netstat -l concept" "echo 'listening ports'" "netstat -l shows listening"
run_exercise 4 "Simulate: Numeric addresses" "data/logs/web-access.log" "192.168" "Shows IPs" "contains" "netstat -n concept" "head -1 data/logs/web-access.log | awk '{print \$1}'" "netstat -n numeric"
run_exercise 5 "Simulate: Program names" "data/logs/application.log" "Database" "Shows program" "contains" "netstat -p concept" "grep -o 'Database' data/logs/application.log | head -1" "netstat -p shows programs"
run_exercise 6 "Simulate: Routing table" "" "route" "Routing info" "contains" "netstat -r concept" "echo 'routing table'" "netstat -r shows routes"
run_exercise 7 "Simulate: Statistics" "data/csv/server-metrics.csv" "38" "38 metric lines" "lines" "netstat -s concept" "wc -l < data/csv/server-metrics.csv" "netstat -s shows stats"
run_exercise 8 "Simulate: Count unique IPs" "data/logs/web-access.log" "25" "25 unique" "numeric" "Parse connection IPs" "awk '{print \$1}' data/logs/web-access.log | sort -u | wc -l" "Analyze network connections"

show_final_score "$COMMAND"
