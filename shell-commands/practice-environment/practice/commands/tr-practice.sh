#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="tr"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Convert first email to uppercase" "data/text/emails.txt" "ADMIN@" "Starts with ADMIN@" "contains" "Use tr '[:lower:]' '[:upper:]'" "head -1 data/text/emails.txt | tr '[:lower:]' '[:upper:]'" "tr translates characters"
run_exercise 2 "Replace all commas with pipes in header" "data/csv/accounts.csv" "|" "Contains pipes" "contains" "Use tr ',' '|'" "head -1 data/csv/accounts.csv | tr ',' '|'" "tr replaces one char set with another"
run_exercise 3 "Delete all digits from first URL" "data/text/urls.txt" "https://example.com" "No digits" "contains" "Use tr -d '[:digit:]'" "head -1 data/text/urls.txt | tr -d '0-9'" "tr -d deletes characters"
run_exercise 4 "Squeeze multiple spaces to single space" "data/text/mixed-content.txt" "107" "107 lines" "lines" "Use tr -s ' '" "tr -s ' ' < data/text/mixed-content.txt | wc -l" "tr -s squeezes repeats"
run_exercise 5 "Count words after replacing newlines with spaces" "data/text/emails.txt" "20" "20 words" "numeric" "Use tr '\\n' ' ' then wc -w" "tr '\\n' ' ' < data/text/emails.txt | wc -w" "Replace newlines to join lines"
run_exercise 6 "Remove all non-alphanumeric from first line" "data/text/urls.txt" "httpsexamplecom" "Only alphanum" "contains" "Use tr -cd '[:alnum:]'" "head -1 data/text/urls.txt | tr -cd '[:alnum:]'" "tr -c complements (keeps instead of deletes)"
run_exercise 7 "Replace all vowels with asterisk" "data/text/emails.txt" "20" "20 lines" "lines" "Use tr 'aeiouAEIOU' '*'" "tr 'aeiouAEIOU' '*' < data/text/emails.txt | wc -l" "Can replace multiple chars with one"
run_exercise 8 "Delete all punctuation from config header" "data/text/config-files.txt" "Application" "First word" "contains" "Use tr -d '[:punct:]'" "head -1 data/text/config-files.txt | tr -d '[:punct:]'" "[:punct:] is all punctuation"
run_exercise 9 "Convert Windows line endings (count lines)" "data/text/emails.txt" "20" "20 lines" "lines" "Use tr -d '\\r'" "tr -d '\\r' < data/text/emails.txt | wc -l" "Removes carriage returns"
run_exercise 10 "ROT13 cipher on first email" "data/text/emails.txt" "nqzva" "Starts with nqzva" "contains" "Use tr with shifted alphabet" "head -1 data/text/emails.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'" "ROT13: shift 13 letters"

show_final_score "$COMMAND"
