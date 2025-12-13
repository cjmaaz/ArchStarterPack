#!/usr/bin/env bash

# ============================================
# jq Practice - 15 Interactive Exercises
# ============================================
# Master JSON processing and transformation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

source "../practice/practice-engine.sh"

COMMAND="jq"
TOTAL_EXERCISES=15

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    echo "Install jq first:"
    echo "  Arch Linux: sudo pacman -S jq"
    echo "  macOS: brew install jq"
    echo "  Ubuntu: sudo apt install jq"
    exit 1
fi

init_practice "$COMMAND" "$TOTAL_EXERCISES"

# ============================================
# BEGINNER EXERCISES (1-5)
# ============================================

# Exercise 1: Extract single field
run_exercise 1 \
    "Extract the totalSize from sf-query-result.json" \
    "data/json/sf-query-result.json" \
    "25" \
    "25" \
    "numeric" \
    "Use jq '.result.totalSize'" \
    "jq '.result.totalSize' data/json/sf-query-result.json" \
    "Dot notation accesses nested fields"

# Exercise 2: Extract from array
run_exercise 2 \
    "Get the Name of the first account" \
    "data/json/sf-query-result.json" \
    "Acme Corporation" \
    "Acme Corporation" \
    "contains" \
    "Use jq '.result.records[0].Name'" \
    "jq -r '.result.records[0].Name' data/json/sf-query-result.json" \
    "[0] gets first array element. -r outputs raw string without quotes"

# Exercise 3: Array iteration
run_exercise 3 \
    "Count how many account names there are" \
    "data/json/sf-query-result.json" \
    "25" \
    "25 accounts" \
    "numeric" \
    "Use jq '.result.records[].Name' and pipe to wc" \
    "jq -r '.result.records[].Name' data/json/sf-query-result.json | wc -l" \
    "[] without index iterates all array elements"

# Exercise 4: Filter with select
run_exercise 4 \
    "Count accounts where Industry is 'Technology'" \
    "data/json/sf-query-result.json" \
    "8" \
    "8 Technology accounts" \
    "numeric" \
    "Use jq select() to filter" \
    "jq '.result.records[] | select(.Industry == \"Technology\")' data/json/sf-query-result.json | wc -l" \
    "select(condition) filters objects. | pipes output"

# Exercise 5: String formatting
run_exercise 5 \
    "Count formatted lines: '<Name>: <Industry>' for all accounts" \
    "data/json/sf-query-result.json" \
    "25" \
    "25 formatted lines" \
    "lines" \
    "Use jq string interpolation \\(...\\)" \
    "jq -r '.result.records[] | \"\\(.Name): \\(.Industry)\"' data/json/sf-query-result.json | wc -l" \
    "\\(...) in strings interpolates field values"

# ============================================
# INTERMEDIATE EXERCISES (6-10)
# ============================================

# Exercise 6: Numeric filtering
run_exercise 6 \
    "Count accounts with AnnualRevenue > 5000000" \
    "data/json/sf-query-result.json" \
    "15" \
    "15 high-revenue accounts" \
    "numeric" \
    "Use select with numeric comparison" \
    "jq '.result.records[] | select(.AnnualRevenue > 5000000)' data/json/sf-query-result.json | wc -l" \
    "select() can use numeric comparisons: >, <, >=, <="

# Exercise 7: Count with length
run_exercise 7 \
    "Count active users in api-response.json using length" \
    "data/json/api-response.json" \
    "4" \
    "4 active users" \
    "numeric" \
    "Use jq [select] | length pattern" \
    "jq '[.data.users[] | select(.active == true)] | length' data/json/api-response.json" \
    "[...] creates array, | length counts elements"

# Exercise 8: Extract nested field
run_exercise 8 \
    "Get company name from nested-complex.json" \
    "data/json/nested-complex.json" \
    "Acme Corporation" \
    "Acme Corporation" \
    "contains" \
    "Navigate nested structure with dots" \
    "jq -r '.company.name' data/json/nested-complex.json" \
    "Chain dots to navigate: .company.name"

# Exercise 9: Array within nested object
run_exercise 9 \
    "Count departments in nested-complex.json" \
    "data/json/nested-complex.json" \
    "2" \
    "2 departments" \
    "numeric" \
    "Access nested array and count" \
    "jq '.company.departments | length' data/json/nested-complex.json" \
    "Navigate to array then use | length"

# Exercise 10: Multiple conditions
run_exercise 10 \
    "Count Technology accounts with revenue > 4000000" \
    "data/json/sf-query-result.json" \
    "5" \
    "5 accounts" \
    "numeric" \
    "Combine conditions with 'and'" \
    "jq '.result.records[] | select(.Industry == \"Technology\" and .AnnualRevenue > 4000000)' data/json/sf-query-result.json | wc -l" \
    "Use 'and' to combine multiple conditions in select()"

# ============================================
# ADVANCED EXERCISES (11-13)
# ============================================

# Exercise 11: Transform array
run_exercise 11 \
    "Extract all user emails from api-response.json, count them" \
    "data/json/api-response.json" \
    "5" \
    "5 emails" \
    "lines" \
    "Map over array to extract field" \
    "jq -r '.data.users[].email' data/json/api-response.json | wc -l" \
    "[] iterates, .email extracts, -r outputs raw"

# Exercise 12: Group and aggregate
run_exercise 12 \
    "Count how many unique Industries exist" \
    "data/json/sf-query-result.json" \
    "4" \
    "4 unique industries" \
    "numeric" \
    "Extract field, make unique array, count" \
    "jq '[.result.records[].Industry] | unique | length' data/json/sf-query-result.json" \
    "[...] creates array, unique removes duplicates, length counts"

# Exercise 13: Complex filtering
run_exercise 13 \
    "Count users in Engineering department (from nested-complex.json)" \
    "data/json/nested-complex.json" \
    "150" \
    "150 employees" \
    "numeric" \
    "Navigate nested, filter, extract field" \
    "jq '.company.departments[] | select(.name == \"Engineering\") | .employees' data/json/nested-complex.json" \
    "Navigate to departments, select by name, extract employees count"

# ============================================
# EXPERT EXERCISES (14-15)
# ============================================

# Exercise 14: Multi-level aggregation
run_exercise 14 \
    "Sum all team member counts in Engineering department" \
    "data/json/nested-complex.json" \
    "55" \
    "55 total members" \
    "numeric" \
    "Navigate to teams array, sum members field" \
    "jq '[.company.departments[] | select(.name == \"Engineering\") | .teams[].members] | add' data/json/nested-complex.json" \
    "Select department, extract team members, add sums array"

# Exercise 15: Complex transformation
run_exercise 15 \
    "Count Backend team technologies in Engineering" \
    "data/json/nested-complex.json" \
    "4" \
    "4 technologies" \
    "numeric" \
    "Navigate nested, filter team, count array" \
    "jq '.company.departments[] | select(.name == \"Engineering\") | .teams[] | select(.name == \"Backend\") | .technologies | length' data/json/nested-complex.json" \
    "Chain selects to find specific team, get technologies array length"

show_final_score "$COMMAND"

echo ""
echo "What's next?"
echo "  • Review: ../demos/beginner/03-json-processing.sh"
echo "  • Reference: ../../02-commands/jq.md"
echo "  • Continue: Try other commands in ./commands/"
echo ""
