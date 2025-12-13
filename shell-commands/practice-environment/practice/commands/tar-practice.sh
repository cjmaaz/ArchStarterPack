#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="tar"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "List contents of tar.gz archive" "data/archives/sample-archive.tar.gz" "5" "5 files" "lines" "Use tar -tzf" "tar -tzf data/archives/sample-archive.tar.gz | wc -l" "tar -tzf lists .tar.gz contents"
run_exercise 2 "List contents of tar archive" "data/archives/sample-archive.tar" "5" "5 files" "lines" "Use tar -tf" "tar -tf data/archives/sample-archive.tar | wc -l" "tar -tf lists .tar contents"
run_exercise 3 "Extract and count files" "data/archives/sample-archive.tar.gz" "4" "4 files" "numeric" "Extract to /tmp" "tar -xzf data/archives/sample-archive.tar.gz -C /tmp && find /tmp/temp_sample -type f | wc -l" "tar -xzf extracts .tar.gz"
run_exercise 4 "Create tar archive and verify" "" "3" "3 files" "lines" "tar -cf" "tar -cf /tmp/test.tar data/text/emails.txt data/text/urls.txt data/text/config-files.txt && tar -tf /tmp/test.tar | wc -l" "tar -cf creates archive"
run_exercise 5 "Create compressed tar.gz" "" "exists" "Archive created" "contains" "tar -czf" "tar -czf /tmp/test.tar.gz data/text/*.txt && file /tmp/test.tar.gz" "tar -czf creates compressed archive"
run_exercise 6 "Extract specific file" "data/archives/sample-archive.tar.gz" "file1" "Contains file1" "contains" "Extract one file" "tar -xzf data/archives/sample-archive.tar.gz -C /tmp temp_sample/file1.txt && cat /tmp/temp_sample/file1.txt" "Can extract specific files"
run_exercise 7 "Append to tar archive" "" "4" "4 files" "lines" "Use tar -rf" "tar -cf /tmp/append.tar data/text/emails.txt && tar -rf /tmp/append.tar data/text/urls.txt data/text/config-files.txt && tar -tf /tmp/append.tar | wc -l" "tar -rf appends to archive"
run_exercise 8 "Extract to specific directory" "data/archives/sample-archive.tar" "5" "5 files" "lines" "Use tar -C" "tar -xf data/archives/sample-archive.tar -C /tmp && find /tmp/temp_sample | wc -l" "tar -C extracts to directory"
run_exercise 9 "Verbose extraction (count output)" "data/archives/sample-archive.tar" "5" "5 files listed" "lines" "tar -xvf" "tar -xvf data/archives/sample-archive.tar -C /tmp 2>&1 | wc -l" "tar -v shows progress"
run_exercise 10 "Create archive excluding pattern" "" "2" "2 files (excluding .cls)" "lines" "tar --exclude" "tar -cf /tmp/excl.tar --exclude='*.cls' data/text/*.txt && tar -tf /tmp/excl.tar | wc -l" "--exclude filters files"
run_exercise 11 "Compress with bzip2" "" "bzip2" "Bzip2 format" "contains" "tar -cjf" "tar -cjf /tmp/test.tar.bz2 data/text/emails.txt && file /tmp/test.tar.bz2" "tar -cjf creates bz2"
run_exercise 12 "Archive entire directory" "data/csv/" "5" "5 CSV files" "lines" "tar directory" "tar -czf /tmp/csv.tar.gz -C data csv && tar -tzf /tmp/csv.tar.gz | grep '\\.csv$' | wc -l" "Archive whole directories"

show_final_score "$COMMAND"
