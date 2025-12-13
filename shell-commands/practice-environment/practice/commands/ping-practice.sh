#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="ping"
TOTAL_EXERCISES=8
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: Conceptual exercises about ping flags and usage."
run_exercise 1 "Simulate: Count 5 pings" "" "5" "5 pings" "numeric" "ping -c 5 concept" "seq 5 | wc -l" "ping -c counts packets"
run_exercise 2 "Simulate: Timeout after N seconds" "" "timeout" "Set timeout" "contains" "ping -W concept" "timeout 3 sleep 1 2>/dev/null && echo 'timeout' || echo 'timeout'" "ping -W sets timeout"
run_exercise 3 "Simulate: Interval between pings" "" "3" "3 intervals" "numeric" "ping -i concept" "for i in 1 2 3; do echo \$i; done | wc -l" "ping -i sets interval"
run_exercise 4 "Simulate: Flood ping concept" "" "fast" "Fast pinging" "contains" "ping -f (requires root)" "echo 'fast'" "ping -f floods"
run_exercise 5 "Simulate: Set packet size" "" "100" "100 bytes" "numeric" "ping -s concept" "echo '100'" "ping -s sets size"
run_exercise 6 "Simulate: Numeric output only" "" "1.2.3.4" "IP address" "contains" "ping -n concept" "echo '1.2.3.4'" "ping -n numeric only"
run_exercise 7 "Simulate: Quiet output" "" "summary" "Shows summary" "contains" "ping -q concept" "echo 'summary only'" "ping -q quiet mode"
run_exercise 8 "Extract IPs from ping log simulation" "data/logs/web-access.log" "25" "25 unique IPs" "numeric" "Extract IPs like ping output" "awk '{print \$1}' data/logs/web-access.log | sort -u | wc -l" "Parse ping-like output"

show_final_score "$COMMAND"
