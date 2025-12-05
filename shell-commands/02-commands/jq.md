# jq - JSON Processor

Command-line JSON processor for parsing, filtering, and transforming JSON data.

---

## 📋 Quick Reference

```bash
jq '.' file.json                    # Pretty print
jq '.fieldName' file.json           # Extract field
jq '.[]' file.json                  # Array iteration
jq '.[0]' file.json                 # First element
jq '.field1, .field2' file.json     # Multiple fields
jq '.[] | .name' file.json          # Pipe and extract
jq 'length' file.json               # Array/object length
jq 'keys' file.json                 # Get all keys
jq 'select(.age > 21)' file.json    # Filter
jq 'map(.name)' file.json           # Transform array
```

---

## Installation

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Verify
jq --version
```

---

## Beginner Level

### Example 1: Pretty Print JSON
```bash
# Format JSON nicely
echo '{"name":"John","age":30}' | jq '.'

# Output:
# {
#   "name": "John",
#   "age": 30
# }
```

### Example 2: Extract a Field
```bash
# Get single field value
echo '{"name":"John","age":30}' | jq '.name'

# Output: "John"
```

### Example 3: Remove Quotes from Output
```bash
# Get raw string (no quotes)
echo '{"name":"John"}' | jq -r '.name'

# Output: John
```

### Example 4: Extract from Array
```bash
# Get first element
echo '[{"id":1},{"id":2}]' | jq '.[0]'

# Output: {"id":1}
```

### Example 5: Get Array Length
```bash
# Count array items
echo '[1,2,3,4,5]' | jq 'length'

# Output: 5
```

### Example 6: Extract Multiple Fields
```bash
# Get multiple fields
echo '{"name":"John","age":30,"city":"NYC"}' | jq '.name, .age'

# Output:
# "John"
# 30
```

### Example 7: Iterate Array
```bash
# Process each array element
echo '[{"name":"Alice"},{"name":"Bob"}]' | jq '.[]'

# Output:
# {"name":"Alice"}
# {"name":"Bob"}
```

### Example 8: Extract Field from Each Array Element
```bash
# Get names from array of objects
echo '[{"name":"Alice"},{"name":"Bob"}]' | jq '.[].name'

# Output:
# "Alice"
# "Bob"
```

---

## Intermediate Level

### Example 9: Filter Arrays
```bash
# Select elements matching condition
echo '[{"age":25},{"age":35}]' | jq '.[] | select(.age > 30)'

# Output: {"age":35}
```

### Example 10: Map Over Array
```bash
# Transform each element
echo '[1,2,3]' | jq 'map(. * 2)'

# Output: [2,4,6]
```

### Example 11: Get All Keys
```bash
# Extract object keys
echo '{"name":"John","age":30,"city":"NYC"}' | jq 'keys'

# Output: ["age","city","name"]
```

### Example 12: Nested Field Access
```bash
# Access nested objects
echo '{"user":{"name":"John","address":{"city":"NYC"}}}' | jq '.user.address.city'

# Output: "NYC"
```

### Example 13: Conditional Selection
```bash
# Filter with multiple conditions
echo '[{"name":"Alice","age":25},{"name":"Bob","age":35}]' | \
jq '.[] | select(.age >= 25 and .age < 30)'

# Output: {"name":"Alice","age":25}
```

### Example 14: Create New Object
```bash
# Build custom object
echo '{"firstName":"John","lastName":"Doe"}' | \
jq '{fullName: (.firstName + " " + .lastName)}'

# Output: {"fullName":"John Doe"}
```

### Example 15: Array Slice
```bash
# Get range of elements
echo '[0,1,2,3,4,5]' | jq '.[2:4]'

# Output: [2,3]
```

### Example 16: Sort Array
```bash
# Sort by field
echo '[{"age":30},{"age":25},{"age":35}]' | jq 'sort_by(.age)'

# Output: [{"age":25},{"age":30},{"age":35}]
```

---

## Advanced Level

### Example 17: Group By
```bash
# Group by field value
echo '[{"type":"A","val":1},{"type":"B","val":2},{"type":"A","val":3}]' | \
jq 'group_by(.type)'

# Output: [[{"type":"A","val":1},{"type":"A","val":3}],[{"type":"B","val":2}]]
```

### Example 18: Reduce/Aggregate
```bash
# Sum array values
echo '[1,2,3,4,5]' | jq 'reduce .[] as $item (0; . + $item)'

# Output: 15
```

### Example 19: Flatten Nested Arrays
```bash
# Flatten array
echo '[[1,2],[3,4]]' | jq 'flatten'

# Output: [1,2,3,4]
```

### Example 20: Add Fields to Objects
```bash
# Add calculated field
echo '[{"name":"Alice","price":100},{"name":"Bob","price":200}]' | \
jq '.[] | . + {tax: (.price * 0.1)}'

# Output:
# {"name":"Alice","price":100,"tax":10}
# {"name":"Bob","price":200,"tax":20}
```

### Example 21: Complex Filter
```bash
# Multiple conditions with logic
echo '[{"name":"Alice","age":25,"active":true},{"name":"Bob","age":35,"active":false}]' | \
jq '.[] | select(.age > 20 and .active == true)'

# Output: {"name":"Alice","age":25,"active":true}
```

### Example 22: Path Expressions
```bash
# Get specific paths
echo '{"a":{"b":{"c":1}}}' | jq '.a.b.c'

# With optional operator (won't fail if missing)
echo '{"a":{}}' | jq '.a.b?.c?'  # Output: null
```

### Example 23: Type Checking
```bash
# Check field types
echo '{"name":"John","age":30}' | jq '.age | type'

# Output: "number"
```

### Example 24: String Operations
```bash
# String manipulation
echo '{"name":"john doe"}' | jq '.name | ascii_upcase'

# Output: "JOHN DOE"

# Split string
echo '{"email":"john@example.com"}' | jq '.email | split("@")'

# Output: ["john","example.com"]
```

---

## Expert Level

### Example 25: Custom Functions
```bash
# Define and use functions
echo '[1,2,3,4,5]' | jq 'def double: . * 2; map(double)'

# Output: [2,4,6,8,10]
```

### Example 26: Recursive Descent
```bash
# Search all levels
echo '{"a":{"b":1},"c":{"d":{"b":2}}}' | jq '.. | .b? // empty'

# Output:
# 1
# 2
```

### Example 27: Complex Data Transformation
```bash
# Transform nested structure
echo '{"users":[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]}' | \
jq '{names: [.users[].name], count: (.users | length)}'

# Output: {"names":["Alice","Bob"],"count":2}
```

### Example 28: Multiple File Processing
```bash
# Combine multiple JSON files
jq -s '.[0] + .[1]' file1.json file2.json

# Or merge arrays
jq -s 'add' file1.json file2.json
```

### Example 29: SQL-like Queries
```bash
# Complex filtering and transformation
echo '[{"id":1,"name":"Alice","dept":"Sales","salary":50000},
       {"id":2,"name":"Bob","dept":"IT","salary":60000},
       {"id":3,"name":"Carol","dept":"Sales","salary":55000}]' | \
jq 'group_by(.dept) | map({dept: .[0].dept, avgSalary: (map(.salary) | add / length)})'

# Output: [{"dept":"IT","avgSalary":60000},{"dept":"Sales","avgSalary":52500}]
```

### Example 30: Error Handling
```bash
# Try-catch pattern
echo '{"value":"not a number"}' | \
jq 'try (.value | tonumber) catch "N/A"'

# Output: "N/A"
```

### Example 31: Variables
```bash
# Use variables in jq
echo '{"price":100}' | jq --arg rate "0.1" \
'{price, tax: (.price * ($rate | tonumber))}'

# Output: {"price":100,"tax":10}
```

### Example 32: Streaming Parser
```bash
# Handle large files efficiently
jq -cn --stream 'fromstream(1|truncate_stream([[0]]))'
```

---

## Salesforce-Specific Examples

### Example 33: Parse SF CLI Query Results
```bash
# Extract Account Names from SF query
sf data query --query "SELECT Name, Id FROM Account LIMIT 5" --json | \
jq -r '.result.records[] | .Name'

# Output:
# Acme Corporation
# TechStart Inc
# Global Solutions
```

### Example 34: Extract Record IDs
```bash
# Get all record IDs
sf data query --query "SELECT Id FROM Contact" --json | \
jq -r '.result.records[].Id'

# Output:
# 003xx000004TmiQAAS
# 003xx000004TmiRAAS
```

### Example 35: Format Deployment Results
```bash
# Parse deployment status
sf project deploy start --json | \
jq '{status: .result.status, id: .result.id, componentSuccesses: .result.numberComponentsTotal}'
```

### Example 36: Filter by RecordType
```bash
# Get records of specific type
sf data query --query "SELECT Name, RecordType.Name FROM Account" --json | \
jq '.result.records[] | select(.RecordType.Name == "Customer")'
```

### Example 37: Extract Errors
```bash
# Get deployment errors
sf project deploy start --json | \
jq -r '.result.details.componentFailures[] | "\(.fileName): \(.problem)"'
```

### Example 38: Org List Formatting
```bash
# Format org list nicely
sf org list --json | \
jq -r '.result.scratchOrgs[] | "\(.alias // .username) (\(.expirationDate))"'
```

### Example 39: Test Results Analysis
```bash
# Parse test results
sf apex run test --json | \
jq '{total: .result.summary.testsRan, passed: .result.summary.passing, failed: .result.summary.failing, coverage: .result.summary.testRunCoverage}'
```

### Example 40: Complex Data Extraction
```bash
# Extract and format related records
sf data query --query "SELECT Name, (SELECT LastName FROM Contacts) FROM Account" --json | \
jq '.result.records[] | {account: .Name, contacts: [.Contacts.records[]?.LastName]}'
```

---

## Generic Linux Examples

### Example 41: Parse Package.json (Node.js)
```bash
# Get all dependencies
jq '.dependencies | keys[]' package.json

# Find dependencies with version ^1.0.0
jq '.dependencies | to_entries[] | select(.value | startswith("^1"))' package.json

# Count total dependencies
jq '.dependencies | length' package.json
```

### Example 42: Docker Inspect Output
```bash
# Get container IP address
docker inspect mycontainer | jq -r '.[0].NetworkSettings.IPAddress'

# Get all environment variables
docker inspect mycontainer | jq -r '.[0].Config.Env[]'

# Check if container is running
docker inspect mycontainer | jq -r '.[0].State.Running'
```

### Example 43: AWS CLI JSON Response
```bash
# Get EC2 instance IDs
aws ec2 describe-instances | jq -r '.Reservations[].Instances[].InstanceId'

# Get S3 bucket names
aws s3api list-buckets | jq -r '.Buckets[].Name'

# Filter instances by tag
aws ec2 describe-instances | jq '.Reservations[].Instances[] | select(.Tags[]? | .Key=="Environment" and .Value=="Production")'
```

### Example 44: GitHub API Response
```bash
# Get repository names
curl -s "https://api.github.com/users/USERNAME/repos" | jq -r '.[].name'

# Get repos with >100 stars
curl -s "https://api.github.com/users/USERNAME/repos" | jq '.[] | select(.stargazers_count > 100) | .name'

# Count total repos
curl -s "https://api.github.com/users/USERNAME/repos" | jq 'length'
```

### Example 45: Kubernetes JSON Output
```bash
# Get pod names
kubectl get pods -o json | jq -r '.items[].metadata.name'

# Get pods not in Running state
kubectl get pods -o json | jq -r '.items[] | select(.status.phase != "Running") | .metadata.name'

# Get container images used
kubectl get pods -o json | jq -r '.items[].spec.containers[].image' | sort -u
```

### Example 46: REST API Response Processing
```bash
# Parse API pagination
curl -s "https://api.example.com/data?page=1" | jq '.data[] | {id, name, created_at}'

# Extract nested error messages
curl -s "https://api.example.com/endpoint" | jq -r '.errors[]?.message'

# Build summary report
curl -s "https://api.example.com/stats" | jq '{total: .total_count, active: .active_users, conversion: (.active_users / .total_count * 100)}'
```

### Example 47: System Information JSON
```bash
# Parse npm list output
npm list --json | jq '.dependencies | keys | length'

# Parse composer.json (PHP)
jq '.require | to_entries[] | "\(.key): \(.value)"' composer.json

# Parse pip freeze to JSON
pip list --format=json | jq '.[] | select(.name == "django")'
```

### Example 48: Log Aggregation JSON
```bash
# Parse structured logs (JSON logs)
cat app.log | jq -r 'select(.level == "error") | "\(.timestamp) - \(.message)"'

# Count errors by type
cat app.log | jq -r 'select(.level == "error") | .error_type' | sort | uniq -c

# Extract slow requests (>1 second)
cat access.log | jq 'select(.response_time > 1000) | {path: .request_path, time: .response_time}'
```

---

## Common Patterns & Recipes

### Pattern 1: CSV to JSON
```bash
# Convert CSV to JSON array
csvtool -t ',' -c 1,2 file.csv | \
jq -R -s '[split("\n") | .[] | split(",") | {name: .[0], value: .[1]}]'
```

### Pattern 2: JSON to CSV
```bash
# Convert JSON array to CSV
jq -r '.[] | [.name, .age, .city] | @csv' data.json
```

### Pattern 3: Merge JSON Files
```bash
# Combine multiple JSON objects
jq -s 'reduce .[] as $item ({}; . * $item)' file1.json file2.json
```

### Pattern 4: Validate JSON
```bash
# Check if valid JSON
if jq -e . >/dev/null 2>&1 < file.json; then
    echo "Valid JSON"
else
    echo "Invalid JSON"
fi
```

### Pattern 5: Pretty Print with Colors
```bash
# Colorized output
jq -C '.' file.json | less -R
```

### Pattern 6: Extract Specific Paths
```bash
# Get all values at specific path
jq '[..|select(.name?)] | .[].name' nested.json
```

### Pattern 7: Conditional Field Addition
```bash
# Add field if condition met
jq '.[] | if .age > 18 then . + {adult: true} else . end' data.json
```

### Pattern 8: Deduplicate Array
```bash
# Remove duplicates
jq 'unique_by(.id)' array.json
```

---

## Practice Problems

### Beginner (1-8)

1. Pretty print a JSON file
2. Extract the "name" field
3. Get the first element of an array
4. Count items in an array
5. Extract multiple fields (name and age)
6. Get raw string output (no quotes)
7. Access a nested field (user.address.city)
8. Iterate over array and show all elements

### Intermediate (9-16)

9. Filter array elements where age > 30
10. Map array to double all numbers
11. Get all keys from an object
12. Sort array by age field
13. Create new object with combined fields
14. Select elements with multiple conditions
15. Get array slice [2:5]
16. Check type of a field

### Advanced (17-24)

17. Group array by a field
18. Calculate sum of array values
19. Flatten nested arrays
20. Add calculated field to each object
21. Transform nested structure completely
22. Use string functions (split, upcase)
23. Handle missing fields with optional operator
24. Combine two JSON files

### Expert (25-32)

25. Define and use custom function
26. Implement recursive search
27. Build SQL-like group-by query
28. Parse Salesforce CLI JSON output
29. Extract errors from deployment result
30. Create CSV from JSON array
31. Implement error handling with try-catch
32. Process streaming JSON for large files

### Generic Linux/DevOps (33-48)

33. Parse package.json and list all dependencies
34. Extract Docker container IP addresses
35. Get AWS EC2 instance IDs from describe-instances
36. Parse GitHub API to get repository names
37. Get Kubernetes pods not in Running state
38. Extract error messages from REST API response
39. Parse npm list output and count packages
40. Filter structured JSON logs for errors
41. Get S3 bucket names from AWS CLI
42. Extract container images from kubectl output
43. Parse API response with pagination
44. Build summary report from API stats
45. Count dependencies in composer.json
46. Find slow requests in JSON access logs
47. Extract nested error objects from API
48. Filter GitHub repos by star count

---

## Cheat Sheet

```bash
# Basic
jq '.'                   # Identity (pretty print)
jq '.foo'                # Get field
jq '.foo.bar'            # Nested field
jq '.foo?'               # Optional (won't error if missing)

# Arrays
jq '.[]'                 # Iterate
jq '.[0]'                # Index
jq '.[2:4]'              # Slice
jq '.[-1]'               # Last element

# Filters
jq 'select(.age > 21)'   # Filter
jq 'map(.name)'          # Transform
jq 'sort_by(.age)'       # Sort

# Constructors
jq '{name, age}'         # Build object
jq '[.name, .age]'       # Build array

# Functions
jq 'length'              # Length
jq 'keys'                # Object keys
jq 'type'                # Type check
jq 'unique'              # Dedupe

# String
jq 'split(":")'          # Split
jq 'test("regex")'       # Regex match
jq 'ascii_upcase'        # Uppercase

# Aggregation
jq 'add'                 # Sum
jq 'min'                 # Minimum
jq 'max'                 # Maximum
jq 'group_by(.field)'    # Group

# Output
jq -r                    # Raw (no quotes)
jq -c                    # Compact
jq -S                    # Sort keys
```

---

**Solutions**: [jq Practice Solutions](../04-practice/jq-solutions.md)

**Next**: [xargs - Command Builder](./xargs.md)
