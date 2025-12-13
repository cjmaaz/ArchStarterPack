#!/usr/bin/env bash

# ============================================
# awk Practice - 15 Interactive Exercises
# ============================================
# Master field processing and text transformation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

source "../practice/practice-engine.sh"

COMMAND="awk"
TOTAL_EXERCISES=15

init_practice "$COMMAND" "$TOTAL_EXERCISES"

# ============================================
# BEGINNER EXERCISES (1-5)
# ============================================

# Exercise 1: Print specific field
run_exercise 1 \
    "Print only the 2nd field (Name) from accounts.csv, first 3 lines" \
    "data/csv/accounts.csv" \
    "3" \
    "3 names" \
    "lines" \
    "Use awk with -F',' to set delimiter, print \$2" \
    "awk -F',' 'NR<=3 {print \$2}' data/csv/accounts.csv | wc -l" \
    "awk -F',' sets comma as delimiter. NR is record number. \$2 is second field"

# Exercise 2: Print multiple fields
run_exercise 2 \
    "Print Name and Industry (fields 2 and 3) from first data row of accounts.csv" \
    "data/csv/accounts.csv" \
    "Acme Corporation,Technology" \
    "Name,Industry" \
    "contains" \
    "Use awk to print \$2 and \$3, skip header with NR>1" \
    "awk -F',' 'NR==2 {print \$2 \",\" \$3}' data/csv/accounts.csv" \
    "NR==2 selects second row (first data row). Print fields separated by comma"

# Exercise 3: Filter by field value
run_exercise 3 \
    "Count accounts in Technology industry" \
    "data/csv/accounts.csv" \
    "8" \
    "8 Technology accounts" \
    "numeric" \
    "Use awk with condition: \$3 == \"Technology\"" \
    "awk -F',' '\$3 == \"Technology\"' data/csv/accounts.csv | wc -l" \
    "awk condition \$3 == \"Technology\" filters rows. Default action prints entire line"

# Exercise 4: Calculate sum
run_exercise 4 \
    "Calculate total annual revenue (sum of field 4, skip header)" \
    "data/csv/accounts.csv" \
    "300000000" \
    "300000000 total" \
    "numeric" \
    "Use awk with BEGIN/END blocks for calculation" \
    "awk -F',' 'NR>1 {sum+=\$4} END {print sum}' data/csv/accounts.csv" \
    "NR>1 skips header. sum+=\$4 accumulates. END prints final sum"

# Exercise 5: Count matches
run_exercise 5 \
    "Count how many ERROR lines are in application.log using awk" \
    "data/logs/application.log" \
    "47" \
    "47 ERROR lines" \
    "numeric" \
    "Use awk with pattern matching and END block" \
    "awk '/ERROR/ {count++} END {print count}' data/logs/application.log" \
    "/ERROR/ is the pattern. count++ increments. END prints total"

# ============================================
# INTERMEDIATE EXERCISES (6-10)
# ============================================

# Exercise 6: Calculate average
run_exercise 6 \
    "Calculate average CPU usage from server-metrics.csv (field 3, skip header)" \
    "data/csv/server-metrics.csv" \
    "57" \
    "~57% average (accept 55-59)" \
    "numeric" \
    "Sum field 3, divide by count in END" \
    "awk -F',' 'NR>1 {sum+=\$3; count++} END {print int(sum/count)}' data/csv/server-metrics.csv" \
    "Track sum and count, divide in END block. int() rounds to integer"

# Exercise 7: Conditional counting
run_exercise 7 \
    "Count accounts with revenue > 10000000" \
    "data/csv/accounts.csv" \
    "12" \
    "12 accounts" \
    "numeric" \
    "Use awk with numeric condition on field 4" \
    "awk -F',' 'NR>1 && \$4 > 10000000 {count++} END {print count}' data/csv/accounts.csv" \
    "NR>1 skips header. \$4 > 10000000 is numeric comparison. count++ for matches"

# Exercise 8: Print with formatting
run_exercise 8 \
    "Count formatted lines: '<Name>: $<Revenue>' from accounts.csv (skip header, first 3 data rows)" \
    "data/csv/accounts.csv" \
    "3" \
    "3 formatted lines" \
    "lines" \
    "Use printf or string concatenation in awk" \
    "awk -F',' 'NR>1 && NR<=4 {print \$2 \": $\" \$4}' data/csv/accounts.csv | wc -l" \
    "NR>1 && NR<=4 selects rows 2-4. Concatenate strings with fields"

# Exercise 9: Group by and count
run_exercise 9 \
    "Count how many different industries exist in accounts.csv (unique count)" \
    "data/csv/accounts.csv" \
    "4" \
    "4 unique industries" \
    "numeric" \
    "Use awk array to track unique values" \
    "awk -F',' 'NR>1 {industries[\$3]=1} END {print length(industries)}' data/csv/accounts.csv" \
    "Array industries[\$3]=1 stores unique keys. length() counts unique keys"

# Exercise 10: Field manipulation
run_exercise 10 \
    "Extract hour from timestamp in server-metrics.csv, count unique hours" \
    "data/csv/server-metrics.csv" \
    "3" \
    "3 unique hours" \
    "numeric" \
    "Use awk to split field 1 and extract hour" \
    "awk -F',' 'NR>1 {split(\$1, arr, \" \"); split(arr[2], time, \":\"); hours[time[1]]=1} END {print length(hours)}' data/csv/server-metrics.csv" \
    "split() extracts hour from timestamp. Array tracks unique hours"

# ============================================
# ADVANCED EXERCISES (11-13)
# ============================================

# Exercise 11: Multi-condition filtering
run_exercise 11 \
    "Count Technology accounts with revenue > 5000000" \
    "data/csv/accounts.csv" \
    "5" \
    "5 accounts" \
    "numeric" \
    "Combine multiple conditions with &&" \
    "awk -F',' 'NR>1 && \$3 == \"Technology\" && \$4 > 5000000' data/csv/accounts.csv | wc -l" \
    "Multiple && conditions must all be true. Checks industry AND revenue"

# Exercise 12: Calculate percentage
run_exercise 12 \
    "Calculate percentage of ERROR lines in application.log (as integer)" \
    "data/logs/application.log" \
    "31" \
    "~31% (accept 30-32)" \
    "numeric" \
    "Count total and errors, calculate percentage in END" \
    "awk '/ERROR/ {errors++} {total++} END {print int(errors*100/total)}' data/logs/application.log" \
    "Two patterns: /ERROR/ counts errors, {} counts all. Calculate percentage in END"

# Exercise 13: Complex aggregation
run_exercise 13 \
    "Sum revenue by industry, count output lines (one per industry)" \
    "data/csv/accounts.csv" \
    "4" \
    "4 industries" \
    "lines" \
    "Use awk associative array to group and sum" \
    "awk -F',' 'NR>1 {revenue[\$3]+=\$4} END {for (i in revenue) print i \": $\" revenue[i]}' data/csv/accounts.csv | wc -l" \
    "revenue[\$3]+=\$4 groups by industry. for loop prints each group"

# ============================================
# EXPERT EXERCISES (14-15)
# ============================================

# Exercise 14: Multi-file processing
run_exercise 14 \
    "Count total 'error' status lines across large-dataset.csv" \
    "data/csv/large-dataset.csv" \
    "1000" \
    "~1000 errors (accept 900-1100)" \
    "numeric" \
    "Use awk to filter by status field" \
    "awk -F',' '\$6 == \"error\"' data/csv/large-dataset.csv | wc -l" \
    "Process 10K+ rows efficiently. \$6 is status field"

# Exercise 15: Complex text transformation
run_exercise 15 \
    "From web-access.log, count unique IPs that got 404 status (field 9)" \
    "data/logs/web-access.log" \
    "12" \
    "12 unique IPs" \
    "numeric" \
    "Filter by status, collect unique IPs in array" \
    "awk '\$9 == 404 {ips[\$1]=1} END {print length(ips)}' data/logs/web-access.log" \
    "\$9 == 404 filters by status code. ips[\$1]=1 stores unique IPs"

show_final_score "$COMMAND"

echo ""
echo "What's next?"
echo "  • Review: ../demos/beginner/05-csv-basics.sh"
echo "  • Reference: ../../02-commands/awk.md"
echo "  • Next command: ./sed-practice.sh"
echo ""
