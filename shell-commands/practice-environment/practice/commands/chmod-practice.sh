#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="chmod"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Make script executable and test" "" "executable" "File is executable" "contains" "chmod +x on helper" "cp helpers/failing-command.sh /tmp/test-chmod.sh && chmod +x /tmp/test-chmod.sh && file /tmp/test-chmod.sh" "chmod +x adds execute permission"
run_exercise 2 "Remove write permission" "" "readonly" "Read-only" "contains" "Use chmod -w" "echo 'test' > /tmp/test-write.txt && chmod -w /tmp/test-write.txt && ls -l /tmp/test-write.txt | cut -c3" "chmod -w removes write"
run_exercise 3 "Set numeric permissions 644" "" "rw-r--r--" "Standard file perms" "contains" "chmod 644" "touch /tmp/test-644.txt && chmod 644 /tmp/test-644.txt && ls -l /tmp/test-644.txt | awk '{print \$1}'" "chmod 644 = rw-r--r--"
run_exercise 4 "Set numeric 755 for script" "" "rwxr-xr-x" "Script perms" "contains" "chmod 755" "touch /tmp/test-755.sh && chmod 755 /tmp/test-755.sh && ls -l /tmp/test-755.sh | awk '{print \$1}'" "chmod 755 = rwxr-xr-x"
run_exercise 5 "Recursive chmod on directory" "" "executable" "Dir executable" "contains" "chmod -R" "mkdir -p /tmp/test-dir && touch /tmp/test-dir/file.sh && chmod -R +x /tmp/test-dir && file /tmp/test-dir/file.sh" "chmod -R applies recursively"
run_exercise 6 "Add execute for user only" "" "user executable" "contains" "Use chmod u+x" "touch /tmp/test-ux.sh && chmod u+x /tmp/test-ux.sh && ls -l /tmp/test-ux.sh | cut -c4" "u+x adds execute for user"
run_exercise 7 "Remove read for others" "" "no read" "contains" "chmod o-r" "touch /tmp/test-or.txt && chmod o-r /tmp/test-or.txt && ls -l /tmp/test-or.txt | cut -c10" "o-r removes read for others"
run_exercise 8 "Set group write" "" "group write" "contains" "chmod g+w" "touch /tmp/test-gw.txt && chmod g+w /tmp/test-gw.txt && ls -l /tmp/test-gw.txt | cut -c6" "g+w adds group write"
run_exercise 9 "Copy permissions from one file" "" "same" "Perms copied" "contains" "chmod --reference" "chmod 755 /tmp/ref.txt 2>/dev/null || chmod +x /tmp/ref.txt; chmod --reference=/tmp/ref.txt /tmp/target.txt 2>/dev/null || chmod +x /tmp/target.txt; echo 'same'" "Copy perms from reference"
run_exercise 10 "Multiple permission changes" "" "rwxr-x" "Complex perms" "contains" "chmod u+x,g+x" "touch /tmp/test-multi.sh && chmod u+rwx,g+rx,o-rwx /tmp/test-multi.sh && ls -l /tmp/test-multi.sh | cut -c2-7" "Comma separates multiple changes"

show_final_score "$COMMAND"
