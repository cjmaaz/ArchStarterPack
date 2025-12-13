#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."
source "../practice/practice-engine.sh"
COMMAND="comm"
TOTAL_EXERCISES=10
init_practice "$COMMAND" "$TOTAL_EXERCISES"

run_exercise 1 "Compare sorted files (count output)" "" "30" "~30 lines" "lines" "Sort then comm" "sort data/text/emails.txt > /tmp/f1.txt && sort data/text/urls.txt > /tmp/f2.txt && comm /tmp/f1.txt /tmp/f2.txt | wc -l" "comm compares sorted files"
run_exercise 2 "Lines only in first file" "" "20" "20 unique to first" "lines" "Use comm -23" "sort data/text/emails.txt > /tmp/emails-sorted.txt && sort data/text/urls.txt > /tmp/urls-sorted.txt && comm -23 /tmp/emails-sorted.txt /tmp/urls-sorted.txt | wc -l" "comm -23 shows only in file1"
run_exercise 3 "Lines only in second file" "" "20" "20 unique to second" "lines" "Use comm -13" "sort data/text/emails.txt > /tmp/e.txt && sort data/text/urls.txt > /tmp/u.txt && comm -13 /tmp/e.txt /tmp/u.txt | wc -l" "comm -13 shows only in file2"
run_exercise 4 "Lines common to both" "" "0" "0 common" "numeric" "Use comm -12" "sort data/text/emails.txt > /tmp/em.txt && sort data/text/urls.txt > /tmp/ur.txt && comm -12 /tmp/em.txt /tmp/ur.txt | wc -l" "comm -12 shows common lines"
run_exercise 5 "Compare sorted industries" "data/csv/" "0" "0 different" "numeric" "Extract, sort, comm" "cut -d',' -f3 data/csv/accounts.csv | sort > /tmp/ind1.txt && cut -d',' -f3 data/csv/accounts.csv | sort > /tmp/ind2.txt && comm -3 /tmp/ind1.txt /tmp/ind2.txt | wc -l" "comm -3 omits common"
run_exercise 6 "Find accounts not in contacts" "data/csv/" "25" "25 accounts" "lines" "Compare ID fields" "tail -n +2 data/csv/accounts.csv | cut -d',' -f1 | sort > /tmp/acc.txt && tail -n +2 data/csv/contacts.csv | cut -d',' -f1 | sort > /tmp/con.txt && comm -23 /tmp/acc.txt /tmp/con.txt | wc -l" "Set difference operation"
run_exercise 7 "Show all differences" "data/text/" "40" "40 different" "lines" "comm -3 (omit common)" "sort data/text/emails.txt > /tmp/e1.txt && sort data/text/urls.txt > /tmp/u1.txt && comm -3 /tmp/e1.txt /tmp/u1.txt | wc -l" "Symmetric difference"
run_exercise 8 "Compare sorted log errors" "data/logs/" "0" "0 different (same file)" "numeric" "comm on same file" "grep ERROR data/logs/application.log | sort > /tmp/err1.txt && grep ERROR data/logs/application.log | sort > /tmp/err2.txt && comm -3 /tmp/err1.txt /tmp/err2.txt | wc -l" "Identical files show no diff"
run_exercise 9 "Union of two sorted files" "data/text/" "40" "40 total unique" "lines" "Sort -u both, cat, sort -u" "cat data/text/emails.txt data/text/urls.txt | sort -u | wc -l" "Set union with sort -u"
run_exercise 10 "Intersection using comm" "" "0" "0 common (different files)" "numeric" "comm -12 for intersection" "sort data/text/emails.txt > /tmp/f1s.txt && sort data/text/urls.txt > /tmp/f2s.txt && comm -12 /tmp/f1s.txt /tmp/f2s.txt | wc -l" "Set intersection"

show_final_score "$COMMAND"
