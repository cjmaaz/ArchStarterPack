#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="wget"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: Conceptual exercises. Real wget needs network."
run_exercise 1 "Simulate: Download file" "data/json/users.json" "64" "64 lines" "lines" "wget concept" "cp data/json/users.json /tmp/wget-out.json && wc -l < /tmp/wget-out.json" "wget downloads files"
run_exercise 2 "Simulate: Quiet mode" "" "quiet" "No output" "contains" "wget -q concept" "cp data/json/users.json /tmp/quiet.json 2>/dev/null && echo 'quiet'" "wget -q is quiet"
run_exercise 3 "Simulate: Continue partial download" "data/archives/sample.log.gz" "67" "67 bytes" "numeric" "wget -c concept" "wc -c < data/archives/sample.log.gz" "wget -c continues downloads"
run_exercise 4 "Simulate: Output to specific file" "data/json/users.json" "64" "64 lines" "lines" "wget -O" "cat data/json/users.json > /tmp/output.json && wc -l < /tmp/output.json" "wget -O specifies output"
run_exercise 5 "Simulate: Download multiple files" "" "3" "3 files" "numeric" "wget with list" "for f in users.json api-response.json deploy-result.json; do cp data/json/\$f /tmp/wget-\$f; done && ls /tmp/wget-*.json | wc -l" "wget -i downloads list"
run_exercise 6 "Simulate: Mirror directory" "data/json/" "5" "5 files" "numeric" "wget --mirror concept" "mkdir -p /tmp/mirror && cp data/json/*.json /tmp/mirror/ && ls /tmp/mirror | wc -l" "wget mirrors sites"
run_exercise 7 "Simulate: Limit download rate" "data/archives/sample-archive.tar" "exists" "File exists" "contains" "wget --limit-rate" "cp data/archives/sample-archive.tar /tmp/limited.tar && file /tmp/limited.tar" "wget --limit-rate throttles"
run_exercise 8 "Simulate: Retry on failure" "data/json/users.json" "success" "Downloaded" "contains" "wget --tries" "cp data/json/users.json /tmp/retry.json && echo 'success'" "wget --tries=N retries"
run_exercise 9 "Simulate: Background download" "data/json/api-response.json" "68" "68 lines" "lines" "wget -b concept" "cat data/json/api-response.json > /tmp/bg.json & wait && wc -l < /tmp/bg.json" "wget -b backgrounds"
run_exercise 10 "Simulate: Timestamp preservation" "data/json/users.json" "preserved" "Timestamp kept" "contains" "wget -N concept" "cp -p data/json/users.json /tmp/timestamp.json && echo 'preserved'" "wget -N preserves timestamps"

show_final_score "$COMMAND"
