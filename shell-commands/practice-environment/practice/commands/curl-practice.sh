#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="curl"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

echo "Note: These are conceptual exercises. Real curl needs network access."
run_exercise 1 "Simulate: Download file (count local file as if downloaded)" "data/json/users.json" "64" "64 lines" "lines" "curl file:// or cat" "cat data/json/users.json | wc -l" "Simulates curl URL"
run_exercise 2 "Simulate: Save output to file" "data/json/users.json" "64" "64 lines saved" "lines" "Use -o flag concept" "cat data/json/users.json > /tmp/curl-out.json && wc -l < /tmp/curl-out.json" "curl -o saves to file"
run_exercise 3 "Simulate: Follow redirects concept (count)" "data/json/api-response.json" "68" "~68 lines" "lines" "curl -L concept" "cat data/json/api-response.json | wc -l" "curl -L follows redirects"
run_exercise 4 "Simulate: Silent mode (no progress)" "" "silent" "Quiet output" "contains" "curl -s concept" "cat data/json/users.json > /dev/null && echo 'silent'" "curl -s silences progress"
run_exercise 5 "Simulate: Include headers concept" "data/json/users.json" "70" "~70 with headers" "lines" "Add headers manually" "echo -e 'HTTP/1.1 200 OK\\nContent-Type: application/json\\n' && cat data/json/users.json | head -5 | wc -l" "curl -i includes headers"
run_exercise 6 "Simulate: POST data concept" "data/json/users.json" "user" "Contains user data" "contains" "Send data concept" "cat data/json/users.json | jq '.data.users[0]'" "curl -d sends POST data"
run_exercise 7 "Simulate: Custom header concept" "data/json/api-response.json" "success" "Success status" "contains" "Header concept" "jq -r '.status' data/json/api-response.json" "curl -H adds headers"
run_exercise 8 "Simulate: Multiple requests (count files)" "" "3" "3 files" "numeric" "Multiple URLs concept" "for f in users.json api-response.json nested-complex.json; do cat data/json/\$f > /tmp/\$f; done && ls /tmp/*.json | head -3 | wc -l" "curl multiple URLs"
run_exercise 9 "Simulate: Auth header concept" "data/json/users.json" "John" "Contains John" "contains" "Authorization concept" "jq -r '.data.users[0].name' data/json/users.json" "curl with auth"
run_exercise 10 "Simulate: JSON parsing pipeline" "data/json/api-response.json" "5" "5 users" "numeric" "curl | jq pattern" "cat data/json/api-response.json | jq '.data.users | length'" "Common curl | jq pattern"

show_final_score "$COMMAND"
