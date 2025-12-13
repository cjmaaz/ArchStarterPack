#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="gzip"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Compress a file" "" "compressed" "Gzip compressed" "contains" "gzip to compress" "cp data/text/emails.txt /tmp/test-gz.txt && gzip /tmp/test-gz.txt && file /tmp/test-gz.txt.gz" "gzip compresses files"
run_exercise 2 "Decompress .gz file" "data/archives/sample.log.gz" "Application" "Contains text" "contains" "gunzip or gzip -d" "gunzip -c data/archives/sample.log.gz" "gunzip decompresses"
run_exercise 3 "Compress keeping original" "" "2" "2 files (orig + .gz)" "numeric" "Use gzip -k" "cp data/text/emails.txt /tmp/keep.txt && gzip -k /tmp/keep.txt && ls /tmp/keep.txt* | wc -l" "gzip -k keeps original"
run_exercise 4 "Decompress to stdout" "data/archives/sample.log.gz" "3" "3 lines" "lines" "gzip -dc" "gzip -dc data/archives/sample.log.gz | wc -l" "gzip -dc decompresses to stdout"
run_exercise 5 "Compress with best compression" "" "compressed" "Max compression" "contains" "gzip -9" "cp data/text/config-files.txt /tmp/best.txt && gzip -9 /tmp/best.txt && file /tmp/best.txt.gz" "gzip -9 is best compression"
run_exercise 6 "Fast compression" "" "compressed" "Fast compression" "contains" "gzip -1" "cp data/text/urls.txt /tmp/fast.txt && gzip -1 /tmp/fast.txt && file /tmp/fast.txt.gz" "gzip -1 is fastest"
run_exercise 7 "Test compressed file integrity" "data/archives/sample.log.gz" "OK" "Test OK" "contains" "gzip -t" "gzip -t data/archives/sample.log.gz && echo 'OK'" "gzip -t tests integrity"
run_exercise 8 "List compressed file info" "data/archives/sample.log.gz" "sample.log.gz" "Shows info" "contains" "gzip -l" "gzip -l data/archives/sample.log.gz" "gzip -l shows compressed size"
run_exercise 9 "Compress multiple files" "" "3" "3 .gz files" "numeric" "gzip multiple" "cp data/text/*.txt /tmp/ && gzip /tmp/emails.txt /tmp/urls.txt /tmp/config-files.txt && ls /tmp/*.txt.gz 2>/dev/null | wc -l" "Can compress multiple files"
run_exercise 10 "Pipe compression" "data/csv/accounts.csv" "26" "26 compressed lines" "lines" "cat | gzip | gunzip" "cat data/csv/accounts.csv | gzip | gunzip | wc -l" "Can use in pipes"

show_final_score "$COMMAND"
