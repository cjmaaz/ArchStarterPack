#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="date"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Show current date" "" "202" "Shows year 202x" "contains" "date command" "date" "date shows current date/time"
run_exercise 2 "Format as YYYY-MM-DD" "" "2025" "ISO format" "contains" "date +%Y-%m-%d" "date '+%Y-%m-%d'" "+FORMAT sets output"
run_exercise 3 "Show only year" "" "2025" "Current year" "contains" "date +%Y" "date '+%Y'" "%Y is year"
run_exercise 4 "Show only month" "" "12" "Month number" "contains" "date +%m" "date '+%m'" "%m is month"
run_exercise 5 "Show day of week" "" "day" "Weekday name" "contains" "date +%A" "date '+%A'" "%A is weekday"
run_exercise 6 "Show Unix timestamp" "" "17" "Epoch time" "contains" "date +%s" "date '+%s'" "%s is Unix timestamp"
run_exercise 7 "Show time only (HH:MM:SS)" "" ":" "Time format" "contains" "date +%H:%M:%S" "date '+%H:%M:%S'" "%H %M %S for time"
run_exercise 8 "Format as 'Month DD, YYYY'" "" "2025" "Full format" "contains" "date +%B %d, %Y" "date '+%B %d, %Y'" "Custom format string"
run_exercise 9 "Show yesterday's date" "" "202" "Date shown" "contains" "date -d yesterday" "date -d 'yesterday' 2>/dev/null || date -v-1d 2>/dev/null || date" "-d for date arithmetic"
run_exercise 10 "Show date 7 days ago" "" "202" "Past date" "contains" "date -d '7 days ago'" "date -d '7 days ago' 2>/dev/null || date -v-7d 2>/dev/null || date" "Relative dates"
run_exercise 11 "Parse specific date" "" "2025" "Parsed date" "contains" "date -d 'date string'" "date -d '2025-01-01' 2>/dev/null || date -j -f '%Y-%m-%d' '2025-01-01' 2>/dev/null || date" "Parse date strings"
run_exercise 12 "ISO 8601 format" "" "T" "ISO format with T" "contains" "date -Iseconds" "date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S'" "ISO 8601 standard"

show_final_score "$COMMAND"
