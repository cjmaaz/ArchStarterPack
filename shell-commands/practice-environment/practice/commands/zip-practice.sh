#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="zip"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "List zip contents" "data/archives/sample-archive.zip" "5" "5 files" "lines" "Use unzip -l" "unzip -l data/archives/sample-archive.zip | grep -E '\\.(txt|sh)$' | wc -l" "unzip -l lists contents"
run_exercise 2 "Create zip archive" "" "3" "3 files" "lines" "zip command" "zip -q /tmp/test.zip data/text/emails.txt data/text/urls.txt data/text/config-files.txt && unzip -l /tmp/test.zip | grep '\\.txt$' | wc -l" "zip creates archives"
run_exercise 3 "Extract zip archive" "data/archives/sample-archive.zip" "4" "4 files extracted" "numeric" "unzip command" "unzip -q -o data/archives/sample-archive.zip -d /tmp && find /tmp/temp_sample -type f 2>/dev/null | wc -l" "unzip extracts"
run_exercise 4 "Add files to existing zip" "" "5" "5 files total" "lines" "zip -u to update" "cp data/archives/sample-archive.zip /tmp/add.zip && zip -q /tmp/add.zip data/text/emails.txt && unzip -l /tmp/add.zip | grep -E '\\.(txt|sh)$' | wc -l" "zip adds files"
run_exercise 5 "Create zip recursively" "" "5" "5 CSV files" "lines" "zip -r" "zip -q -r /tmp/csv.zip data/csv && unzip -l /tmp/csv.zip | grep '\\.csv$' | wc -l" "zip -r includes subdirectories"
run_exercise 6 "Test zip integrity" "data/archives/sample-archive.zip" "OK" "Test passed" "contains" "unzip -t" "unzip -t data/archives/sample-archive.zip 2>&1 | grep -q 'OK' && echo 'OK'" "unzip -t tests"
run_exercise 7 "Extract specific file" "data/archives/sample-archive.zip" "file1" "Contains file1" "contains" "unzip filename" "unzip -q -o data/archives/sample-archive.zip 'temp_sample/file1.txt' -d /tmp && cat /tmp/temp_sample/file1.txt" "Extract specific files"
run_exercise 8 "Create encrypted zip" "" "zip" "Encrypted" "contains" "zip -e (skip, no password)" "zip -q -P testpass /tmp/enc.zip data/text/emails.txt && file /tmp/enc.zip" "zip -e encrypts"
run_exercise 9 "Exclude files from zip" "" "2" "2 files (excluding .cls)" "lines" "zip -x pattern" "zip -q -r /tmp/excl.zip data/text -x '*.cls' && unzip -l /tmp/excl.zip | grep '\\.txt$' | wc -l" "zip -x excludes patterns"
run_exercise 10 "Compress with best ratio" "" "zip" "Max compression" "contains" "zip -9" "zip -q -9 /tmp/best.zip data/text/config-files.txt && file /tmp/best.zip" "zip -9 best compression"

show_final_score "$COMMAND"
