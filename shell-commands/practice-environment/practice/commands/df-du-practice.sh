#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="df-du"
TOTAL_EXERCISES=12
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Show disk space (df)" "" "Filesystem" "Shows filesystems" "contains" "df command" "df | head -1" "df shows disk space"
run_exercise 2 "Human readable format (df -h)" "" "G" "Shows GB/MB" "contains" "df -h" "df -h | head -2 | tail -1" "df -h for human format"
run_exercise 3 "Show specific filesystem" "" "/" "Root filesystem" "contains" "df /" "df / | tail -1" "df on specific mount"
run_exercise 4 "Show inodes (df -i)" "" "Inodes" "Shows inodes" "contains" "df -i" "df -i | head -1" "df -i shows inode usage"
run_exercise 5 "Directory size (du)" "data/" "1" "~1-2M" "contains" "du -sh" "du -sh data/ | awk '{print \$1}'" "du shows directory size"
run_exercise 6 "Subdirectory sizes" "data/" "6" "6 subdirectories" "lines" "du data/*" "du -sh data/*/ | wc -l" "du on subdirectories"
run_exercise 7 "Sort by size" "data/" "data" "Sorted list" "contains" "du | sort -n" "du -sh data/* | sort -h | tail -1" "Sort by size"
run_exercise 8 "Total size only (du -s)" "data/" "total" "Summary only" "contains" "du -s" "du -sh data/ | awk '{print \$1}'" "du -s summarizes"
run_exercise 9 "Exclude files (du --exclude)" "data/" "size" "Filtered size" "contains" "du --exclude pattern" "du -sh --exclude='*.log' data/ 2>/dev/null | awk '{print \$1}' || du -sh data/ | awk '{print \$1}'" "--exclude filters"
run_exercise 10 "Show all files (du -a)" "data/logs/" "6" "6 log files" "numeric" "du -a | grep" "du -a data/logs/ | grep '\\.log$' | wc -l" "du -a shows all files"
run_exercise 11 "Maximum depth (du --max-depth)" "data/" "6" "6 top-level" "lines" "du --max-depth=1" "du -d 1 data/ 2>/dev/null | wc -l || du --max-depth=1 data/ | wc -l" "Limit depth"
run_exercise 12 "Find largest files" "data/" "large" "Finds largest" "contains" "du | sort | tail" "du -ah data/ | sort -h | tail -1" "Find large files"

show_final_score "$COMMAND"
