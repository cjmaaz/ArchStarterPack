# Intermediate Level Practice - 20 Exercises

Build on fundamentals with command combinations and real-world scenarios.

---

## Exercise 1: Extract and Count Unique IPs
**Task**: From an Apache access log, extract all IP addresses and count how many unique IPs accessed your server

**Sample Input** (access.log):
```
192.168.1.100 - - [05/Dec/2025:10:15:30] "GET /index.html HTTP/1.1" 200
192.168.1.101 - - [05/Dec/2025:10:16:45] "POST /api/data HTTP/1.1" 201
192.168.1.100 - - [05/Dec/2025:10:17:22] "GET /about.html HTTP/1.1" 200
10.0.0.5 - - [05/Dec/2025:10:18:10] "GET /contact HTTP/1.1" 200
```

<details>
<summary>Solution</summary>

```bash
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log | sort | uniq | wc -l
```

**Explanation**:
- `grep -oE` extracts only matching parts with extended regex
- `\b([0-9]{1,3}\.){3}[0-9]{1,3}\b` matches IP addresses
- `sort` arranges alphabetically
- `uniq` removes duplicates
- `wc -l` counts unique IPs

**Alternative (with count per IP)**:
```bash
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log | sort | uniq -c | sort -nr
```

</details>

---

## Exercise 2: Find Top 5 HTTP Error Codes
**Task**: Analyze web server logs and find the top 5 most common HTTP error codes (4xx, 5xx)

**Sample Input** (access.log):
```
GET /page1 HTTP/1.1" 200
GET /page2 HTTP/1.1" 404
POST /api HTTP/1.1" 500
GET /page3 HTTP/1.1" 404
GET /page4 HTTP/1.1" 403
```

<details>
<summary>Solution</summary>

```bash
grep -oE " [45][0-9]{2} " access.log | sort | uniq -c | sort -nr | head -5
```

**Explanation**:
- `grep -oE " [45][0-9]{2} "` matches 4xx and 5xx codes
- `uniq -c` counts occurrences
- `sort -nr` sorts numerically in reverse
- `head -5` shows top 5

**With formatting**:
```bash
grep -oE " [45][0-9]{2} " access.log | sort | uniq -c | sort -nr | head -5 | \
awk '{printf "HTTP %s: %d occurrences\n", $2, $1}'
```

</details>

---

## Exercise 3: Extract Column from CSV
**Task**: From a CSV file with format (Name,Age,City), extract all unique cities sorted alphabetically

**Sample Input** (people.csv):
```
John,30,New York
Alice,25,Boston
Bob,35,New York
Carol,28,Chicago
David,32,Boston
```

<details>
<summary>Solution</summary>

```bash
cut -d',' -f3 people.csv | tail -n +2 | sort | uniq
```

**Explanation**:
- `cut -d',' -f3` extracts 3rd column (City)
- `tail -n +2` skips header row
- `sort | uniq` gets unique sorted values

**Alternative (with awk)**:
```bash
awk -F',' 'NR>1 {print $3}' people.csv | sort -u
```

**Alternative (skip header)**:
```bash
tail -n +2 people.csv | cut -d',' -f3 | sort -u
```

</details>

---

## Exercise 4: Monitor Log File for Errors
**Task**: Create a command that watches a log file in real-time and only shows lines containing "ERROR" or "FATAL"

<details>
<summary>Solution</summary>

```bash
tail -f application.log | grep -E "ERROR|FATAL"
```

**With color highlighting**:
```bash
tail -f application.log | grep --color=always -E "ERROR|FATAL"
```

**With timestamps**:
```bash
tail -f application.log | grep -E "ERROR|FATAL" | while read line; do
    echo "[$(date '+%H:%M:%S')] $line"
done
```

**Explanation**:
- `tail -f` follows file (shows new lines as they're added)
- `grep -E` uses extended regex for OR operator
- `while read` adds custom timestamps

</details>

---

## Exercise 5: Find Large Files
**Task**: Find all files larger than 100MB in /var/log and show their sizes in human-readable format

<details>
<summary>Solution</summary>

```bash
find /var/log -type f -size +100M -exec ls -lh {} \; | awk '{print $9, $5}'
```

**Alternative (cleaner output)**:
```bash
find /var/log -type f -size +100M -exec du -h {} \;
```

**Alternative (sorted by size)**:
```bash
find /var/log -type f -size +100M -exec du -h {} \; | sort -hr
```

**Explanation**:
- `find /var/log` searches in /var/log
- `-type f` only files (not directories)
- `-size +100M` larger than 100 megabytes
- `-exec du -h {}` shows size in human format
- `sort -hr` sorts by size (human-readable, reverse)

</details>

---

## Exercise 6: Process JSON API Response
**Task**: Given a REST API JSON response, extract all user emails and save to a text file

**Sample Input** (api-response.json):
```json
{
  "users": [
    {"id": 1, "name": "Alice", "email": "alice@example.com"},
    {"id": 2, "name": "Bob", "email": "bob@example.com"},
    {"id": 3, "name": "Carol", "email": "carol@example.com"}
  ]
}
```

<details>
<summary>Solution</summary>

```bash
jq -r '.users[].email' api-response.json > emails.txt
```

**Alternative (with curl)**:
```bash
curl -s "https://api.example.com/users" | jq -r '.users[].email' > emails.txt
```

**Alternative (numbered list)**:
```bash
jq -r '.users[] | "\(.id). \(.email)"' api-response.json > emails.txt
```

**Explanation**:
- `jq -r` outputs raw strings (no quotes)
- `.users[]` iterates over users array
- `.email` extracts email field
- `> emails.txt` saves to file

</details>

---

## Exercise 7: Count Errors by Hour
**Task**: From a log file with timestamps, count how many errors occurred in each hour of the day

**Sample Input** (app.log):
```
2025-12-05 08:15:30 ERROR Database connection failed
2025-12-05 08:45:12 ERROR Timeout occurred
2025-12-05 09:10:05 ERROR Invalid input
2025-12-05 09:30:22 INFO Request processed
2025-12-05 10:05:45 ERROR File not found
```

<details>
<summary>Solution</summary>

```bash
grep "ERROR" app.log | awk '{print $2}' | cut -d: -f1 | sort | uniq -c
```

**Explanation**:
- `grep "ERROR"` filters error lines
- `awk '{print $2}'` extracts time column
- `cut -d: -f1` extracts hour (before first colon)
- `sort | uniq -c` counts per hour

**Alternative (with formatting)**:
```bash
grep "ERROR" app.log | awk '{print $2}' | cut -d: -f1 | sort | uniq -c | \
awk '{printf "%s:00 - %d errors\n", $2, $1}'
```

**Output**:
```
08:00 - 2 errors
09:00 - 1 errors
10:00 - 1 errors
```

</details>

---

## Exercise 8: Filter CSV Rows by Condition
**Task**: From a CSV file, extract all rows where the Age column (column 2) is greater than 30

**Sample Input** (users.csv):
```
Name,Age,Department
Alice,25,Engineering
Bob,35,Sales
Carol,42,Marketing
David,28,Engineering
```

<details>
<summary>Solution</summary>

```bash
awk -F',' 'NR==1 || $2>30' users.csv
```

**Explanation**:
- `-F','` sets field separator to comma
- `NR==1` keeps header row
- `||` OR operator
- `$2>30` condition for age column
- Outputs header + matching rows

**Alternative (skip header in output)**:
```bash
awk -F',' 'NR>1 && $2>30' users.csv
```

**Alternative (with column names)**:
```bash
awk -F',' 'NR==1 {print; next} $2>30' users.csv
```

</details>

---

## Exercise 9: Combine Output from Multiple Commands
**Task**: Get the number of processes, logged-in users, and current memory usage in a single formatted report

<details>
<summary>Solution</summary>

```bash
{
    echo "Process Count: $(ps aux | wc -l)"
    echo "Logged-in Users: $(who | wc -l)"
    echo "Memory Usage: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
} | column -t
```

**Alternative (save to file)**:
```bash
cat > system-report.txt <<EOF
System Report - $(date)
=======================
Processes: $(ps aux | wc -l)
Users: $(who | wc -l)
Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')
EOF
```

**Explanation**:
- `{}` groups commands
- `$()` command substitution
- `column -t` formats as table
- Heredoc (`<<EOF`) creates multi-line file

</details>

---

## Exercise 10: Parse Git Log for Statistics
**Task**: Count how many commits each author has made in the repository

<details>
<summary>Solution</summary>

```bash
git log --format="%an" | sort | uniq -c | sort -nr
```

**Explanation**:
- `git log --format="%an"` outputs only author names
- `sort` alphabetically
- `uniq -c` counts occurrences
- `sort -nr` sorts by count (descending)

**Alternative (with percentage)**:
```bash
total=$(git log --oneline | wc -l)
git log --format="%an" | sort | uniq -c | sort -nr | \
awk -v total=$total '{printf "%-20s %4d commits (%5.1f%%)\n", $2" "$3, $1, ($1/total*100)}'
```

**Output**:
```
John Doe            150 commits ( 45.5%)
Jane Smith           95 commits ( 28.8%)
Bob Johnson          85 commits ( 25.7%)
```

</details>

---

## Exercise 11: Extract Failed SSH Attempts
**Task**: From auth.log, find all failed SSH login attempts and list the IP addresses with attempt counts

**Sample Input** (/var/log/auth.log):
```
Dec  5 10:15:30 server sshd[1234]: Failed password for root from 192.168.1.100
Dec  5 10:16:45 server sshd[1235]: Failed password for admin from 192.168.1.101
Dec  5 10:17:22 server sshd[1236]: Failed password for root from 192.168.1.100
```

<details>
<summary>Solution</summary>

```bash
grep "Failed password" /var/log/auth.log | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq -c | sort -nr
```

**Explanation**:
- First `grep` filters failed attempts
- Second `grep -oE` extracts IPs
- `uniq -c` counts per IP
- `sort -nr` shows most attempts first

**Alternative (with alert threshold)**:
```bash
grep "Failed password" /var/log/auth.log | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | \
sort | uniq -c | sort -nr | \
awk '$1 > 10 {printf "⚠️  ALERT: %s attempted %d times\n", $2, $1}'
```

</details>

---

## Exercise 12: Calculate Average from Column
**Task**: Calculate the average value of the 3rd column in a CSV file

**Sample Input** (sales.csv):
```
Product,Date,Amount
Widget,2025-01-15,150.50
Gadget,2025-01-16,200.75
Tool,2025-01-17,175.25
Device,2025-01-18,225.00
```

<details>
<summary>Solution</summary>

```bash
awk -F',' 'NR>1 {sum+=$3; count++} END {print sum/count}' sales.csv
```

**With formatting**:
```bash
awk -F',' 'NR>1 {sum+=$3; count++} END {printf "Average: $%.2f\n", sum/count}' sales.csv
```

**Explanation**:
- `NR>1` skips header
- `sum+=$3` adds column 3 to running total
- `count++` counts rows
- `END` executes after all rows
- `printf "%.2f"` formats to 2 decimal places

**Output**: `Average: $187.88`

</details>

---

## Exercise 13: Find Recently Modified Files
**Task**: Find all .log files modified in the last 24 hours and sort by modification time (newest first)

<details>
<summary>Solution</summary>

```bash
find . -name "*.log" -mtime 0 -type f -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2-
```

**Alternative (with human-readable times)**:
```bash
find . -name "*.log" -mtime 0 -type f -exec ls -lt {} \; | awk '{print $9, $6, $7, $8}'
```

**Simpler alternative**:
```bash
ls -lt *.log | head -10
```

**Explanation**:
- `find . -name "*.log"` finds log files
- `-mtime 0` modified in last 24 hours
- `-printf "%T@ %p\n"` prints timestamp and path
- `sort -nr` sorts by timestamp (newest first)
- `cut -d' ' -f2-` removes timestamp from output

</details>

---

## Exercise 14: Extract JSON Field from API
**Task**: Call a REST API and extract just the "name" field from each object in the results array

**Sample API Response**:
```json
{
  "status": "success",
  "results": [
    {"id": 1, "name": "Product A", "price": 29.99},
    {"id": 2, "name": "Product B", "price": 39.99}
  ]
}
```

<details>
<summary>Solution</summary>

```bash
curl -s "https://api.example.com/products" | jq -r '.results[].name'
```

**Explanation**:
- `curl -s` fetches URL silently
- `jq -r` processes JSON, outputs raw strings
- `.results[]` iterates results array
- `.name` extracts name field

**Alternative (with index numbers)**:
```bash
curl -s "https://api.example.com/products" | \
jq -r '.results[] | "\(.id). \(.name)"'
```

**Output**:
```
Product A
Product B
```

</details>

---

## Exercise 15: Remove Comments from Config
**Task**: Display a configuration file without comments or blank lines

**Sample Input** (config.conf):
```
# Database settings
db.host=localhost
db.port=5432

# Cache settings
cache.enabled=true
# cache.ttl=3600
```

<details>
<summary>Solution</summary>

```bash
grep -v "^#" config.conf | grep -v "^$"
```

**Alternative (single grep)**:
```bash
grep -vE "^#|^$" config.conf
```

**Alternative (with sed)**:
```bash
sed '/^#/d; /^$/d' config.conf
```

**Explanation**:
- First `grep -v "^#"` removes lines starting with #
- Second `grep -v "^$"` removes empty lines
- `^` anchors to start of line
- `$` matches end of line
- `-E` enables extended regex for OR (`|`)

**Output**:
```
db.host=localhost
db.port=5432
cache.enabled=true
```

</details>

---

## Exercise 16: Count Files by Extension
**Task**: In current directory, count how many files exist for each file extension

<details>
<summary>Solution</summary>

```bash
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -nr
```

**Alternative (cleaner)**:
```bash
find . -type f -name "*.*" | awk -F. '{print $NF}' | sort | uniq -c | sort -nr
```

**Explanation**:
- `find . -type f` finds all files
- `sed 's/.*\.//'` or `awk -F. '{print $NF}'` extracts extension
- `sort | uniq -c` counts each extension
- `sort -nr` sorts by count

**Output**:
```
 42 txt
 35 log
 18 conf
 12 csv
```

</details>

---

## Exercise 17: Parallel Processing
**Task**: Count lines in 5 different log files in parallel and display results

**Files**: app1.log, app2.log, app3.log, app4.log, app5.log

<details>
<summary>Solution</summary>

```bash
for file in app{1..5}.log; do
    wc -l "$file" &
done
wait
```

**Alternative (with better formatting)**:
```bash
for file in app{1..5}.log; do
    (wc -l "$file" | awk '{printf "%-15s: %d lines\n", $2, $1}') &
done
wait
```

**Explanation**:
- `app{1..5}.log` expands to app1.log app2.log ... app5.log
- `&` runs each wc command in background (parallel)
- `wait` waits for all background jobs to complete
- `()` subshell for grouping

**Output**:
```
app1.log       : 1523 lines
app2.log       : 2341 lines
app3.log       : 987 lines
app4.log       : 3102 lines
app5.log       : 1654 lines
```

</details>

---

## Exercise 18: Docker Container Log Analysis
**Task**: Get the last 50 lines from all running Docker containers and grep for "error"

<details>
<summary>Solution</summary>

```bash
for container in $(docker ps --format '{{.Names}}'); do
    echo "=== $container ==="
    docker logs --tail 50 "$container" 2>&1 | grep -i "error"
done
```

**Alternative (count errors per container)**:
```bash
for container in $(docker ps --format '{{.Names}}'); do
    count=$(docker logs --tail 100 "$container" 2>&1 | grep -ci "error")
    echo "$container: $count errors"
done | sort -t: -k2 -nr
```

**Explanation**:
- `docker ps --format '{{.Names}}'` lists container names
- `docker logs --tail 50` gets last 50 lines
- `2>&1` captures stderr (where logs often go)
- `grep -i "error"` finds errors case-insensitively

</details>

---

## Exercise 19: Replace Text Across Multiple Files
**Task**: Replace all occurrences of "oldDomain.com" with "newDomain.com" in all .conf files

<details>
<summary>Solution</summary>

```bash
find . -name "*.conf" -type f -exec sed -i 's/oldDomain\.com/newDomain.com/g' {} \;
```

**Alternative (with backup)**:
```bash
find . -name "*.conf" -type f -exec sed -i.bak 's/oldDomain\.com/newDomain.com/g' {} \;
```

**Alternative (preview changes first)**:
```bash
# Preview
find . -name "*.conf" -type f -exec grep "oldDomain.com" {} \; -print

# Then replace
find . -name "*.conf" -type f -exec sed -i 's/oldDomain\.com/newDomain.com/g' {} \;
```

**Explanation**:
- `find . -name "*.conf"` finds all .conf files
- `-exec sed -i` edits files in-place
- `s/oldDomain\.com/newDomain.com/g` substitution pattern
- `\.` escapes the dot
- `g` replaces all occurrences (global)
- `-i.bak` creates backup with .bak extension

</details>

---

## Exercise 10: Parse Docker Compose JSON
**Task**: From docker-compose config, extract all service names and their image versions

**Sample Input** (docker-compose.json):
```json
{
  "services": {
    "web": {"image": "nginx:1.21"},
    "app": {"image": "node:16-alpine"},
    "db": {"image": "postgres:13"}
  }
}
```

<details>
<summary>Solution</summary>

```bash
jq -r '.services | to_entries[] | "\(.key): \(.value.image)"' docker-compose.json
```

**Explanation**:
- `.services` accesses services object
- `to_entries[]` converts to array of key-value pairs
- `\(.key)` is service name
- `\(.value.image)` is image version
- String interpolation with `\()`

**Output**:
```
web: nginx:1.21
app: node:16-alpine
db: postgres:13
```

</details>

---

## Exercise 11: System Resource Monitoring
**Task**: Create a one-liner that shows CPU usage, memory usage, and disk usage on one line

<details>
<summary>Solution</summary>

```bash
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')% | MEM: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2*100}') | DISK: $(df -h / | tail -1 | awk '{print $5}')"
```

**Simpler alternative**:
```bash
printf "CPU: %s | MEM: %s | DISK: %s\n" \
    "$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')" \
    "$(free -h | grep Mem | awk '{print $3 "/" $2}')" \
    "$(df -h / | tail -1 | awk '{print $5}')"
```

**Output**:
```
CPU: 15.3% | MEM: 4.2G/16G | DISK: 45%
```

</details>

---

## Exercise 12: Archive Old Log Files
**Task**: Find all .log files older than 30 days, compress them into dated archives, and delete originals

<details>
<summary>Solution</summary>

```bash
find /var/log -name "*.log" -mtime +30 -type f | \
xargs tar -czf logs_archive_$(date +%Y%m%d).tar.gz && \
find /var/log -name "*.log" -mtime +30 -type f -delete
```

**Safer version (with confirmation)**:
```bash
# List files first
find /var/log -name "*.log" -mtime +30 -type f > old_logs.txt
cat old_logs.txt

# Create archive
tar -czf logs_archive_$(date +%Y%m%d).tar.gz -T old_logs.txt

# Verify archive
tar -tzf logs_archive_$(date +%Y%m%d).tar.gz | head -5

# Delete (after verification)
cat old_logs.txt | xargs rm
```

**Explanation**:
- `-mtime +30` files older than 30 days
- `xargs` builds tar command from find output
- `$(date +%Y%m%d)` creates dated filename
- `&&` only deletes if archive succeeds

</details>

---

## Exercise 13: Parse Nginx Access Log for Top URLs
**Task**: Find the top 10 most requested URLs from Nginx access log

**Sample Input** (access.log):
```
192.168.1.100 - - [05/Dec/2025:10:15:30] "GET /api/users HTTP/1.1" 200
192.168.1.101 - - [05/Dec/2025:10:16:45] "GET /api/products HTTP/1.1" 200
192.168.1.102 - - [05/Dec/2025:10:17:22] "GET /api/users HTTP/1.1" 200
```

<details>
<summary>Solution</summary>

```bash
awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -10
```

**Alternative (with percentage)**:
```bash
total=$(wc -l < access.log)
awk '{print $7}' access.log | sort | uniq -c | sort -nr | head -10 | \
awk -v total=$total '{printf "%5d (%5.1f%%) %s\n", $1, ($1/total*100), $2}'
```

**Explanation**:
- `awk '{print $7}'` extracts URL column (field 7)
- `sort | uniq -c` counts occurrences
- `sort -nr` sorts numerically descending
- `head -10` shows top 10

**Output**:
```
  245 ( 35.2%) /api/users
  180 ( 25.9%) /api/products
  120 ( 17.2%) /
   95 ( 13.7%) /api/orders
   56 (  8.0%) /contact
```

</details>

---

## Exercise 14: Monitor Disk Space Alert
**Task**: Check if any partition is over 80% full and send an alert

<details>
<summary>Solution</summary>

```bash
df -h | awk 'NR>1 {gsub("%",""); if($5>80) print "⚠️  "$6" is "$5"% full"}'
```

**Alternative (with email alert)**:
```bash
#!/bin/bash
THRESHOLD=80
df -h | awk -v threshold=$THRESHOLD '
NR>1 {
    gsub("%","", $5)
    if($5 > threshold) {
        print "ALERT: "$6" is "$5"% full"
    }
}' | while read alert; do
    echo "$alert"
    # Send email: echo "$alert" | mail -s "Disk Alert" admin@example.com
done
```

**Explanation**:
- `df -h` shows disk usage
- `awk 'NR>1'` skips header
- `gsub("%","")` removes % symbol
- `if($5>80)` checks if usage > 80%
- `$6` is mount point, `$5` is usage percentage

</details>

---

## Exercise 15: Process Multiple JSON Files
**Task**: Merge all .json files in a directory into a single JSON array

**Sample Files**:
- user1.json: `{"id":1,"name":"Alice"}`
- user2.json: `{"id":2,"name":"Bob"}`

<details>
<summary>Solution</summary>

```bash
jq -s '.' *.json > merged.json
```

**Alternative (with error handling)**:
```bash
jq -s 'map(select(. != null))' *.json > merged.json
```

**Explanation**:
- `jq -s` slurp mode (read all files into array)
- `'.'` identity (keep as-is)
- `map(select(. != null))` filters out null values
- `> merged.json` saves result

**Output** (merged.json):
```json
[
  {"id":1,"name":"Alice"},
  {"id":2,"name":"Bob"}
]
```

</details>

---

## Exercise 16: Extract and Format Git Commit History
**Task**: Show last 10 commits with format: "Date - Author - Subject" (one line each)

<details>
<summary>Solution</summary>

```bash
git log -10 --pretty=format:"%ad - %an - %s" --date=short
```

**Alternative (with colors)**:
```bash
git log -10 --pretty=format:"%C(yellow)%ad%Creset - %C(blue)%an%Creset - %s" --date=short
```

**Alternative (with grep filter)**:
```bash
git log --pretty=format:"%ad - %an - %s" --date=short | grep "bugfix" | head -10
```

**Explanation**:
- `git log -10` shows last 10 commits
- `--pretty=format:` custom format
- `%ad` author date
- `%an` author name
- `%s` commit subject
- `--date=short` formats date as YYYY-MM-DD

**Output**:
```
2025-12-05 - John Doe - Fix authentication bug
2025-12-04 - Jane Smith - Add new feature
2025-12-03 - Bob Johnson - Update documentation
```

</details>

---

## Exercise 17: Calculate Total File Sizes by Extension
**Task**: For each file extension in current directory, show total size

<details>
<summary>Solution</summary>

```bash
find . -type f -name "*.*" -exec du -b {} \; | \
awk -F/ '{ext=$NF; sub(/.*\./, "", ext); size[$1]; files[ext]+=$1} END {for(e in files) printf "%-10s: %10d bytes\n", e, files[e]}' | \
sort -k2 -nr
```

**Simpler version**:
```bash
for ext in $(find . -type f -name "*.*" | sed 's/.*\.//' | sort -u); do
    total=$(find . -name "*.$ext" -exec du -bc {} + 2>/dev/null | tail -1 | awk '{print $1}')
    printf "%-10s: %10d bytes\n" "$ext" "$total"
done | sort -k2 -nr
```

**Explanation**:
- Finds all files with extensions
- Groups by extension
- Sums file sizes per extension
- Formats output

**Output**:
```
log       :   45823412 bytes
txt       :   12453621 bytes
csv       :    5234156 bytes
```

</details>

---

## Exercise 18: Filter Package.json Scripts
**Task**: Extract all npm script names from package.json and list them

**Sample Input** (package.json):
```json
{
  "scripts": {
    "start": "node server.js",
    "test": "jest",
    "build": "webpack",
    "deploy": "npm run build && deploy.sh"
  }
}
```

<details>
<summary>Solution</summary>

```bash
jq -r '.scripts | keys[]' package.json
```

**Alternative (with command)**:
```bash
jq -r '.scripts | to_entries[] | "\(.key): \(.value)"' package.json
```

**Alternative (formatted table)**:
```bash
jq -r '.scripts | to_entries[] | [.key, .value] | @tsv' package.json | column -t
```

**Explanation**:
- `.scripts` accesses scripts object
- `keys[]` gets all script names
- `to_entries[]` converts to key-value pairs
- `@tsv` formats as tab-separated values
- `column -t` creates aligned columns

**Output (formatted)**:
```
start   node server.js
test    jest
build   webpack
deploy  npm run build && deploy.sh
```

</details>

---

## Exercise 19: Monitor Process Memory Usage
**Task**: List top 10 processes by memory usage with formatted output

<details>
<summary>Solution</summary>

```bash
ps aux | sort -k4 -nr | head -11 | tail -10 | awk '{printf "%-20s %6s%%  %s\n", $11, $4, $2}'
```

**Alternative (with column names)**:
```bash
{
    echo "COMMAND              MEM%    PID"
    ps aux | sort -k4 -nr | head -11 | tail -10 | awk '{printf "%-20s %6s  %s\n", $11, $4, $2}'
} | column -t
```

**Explanation**:
- `ps aux` lists all processes
- `sort -k4 -nr` sorts by column 4 (memory) numerically descending
- `head -11` gets top 11 (including header)
- `tail -10` removes header, keeps top 10
- `awk` formats output

**Output**:
```
COMMAND                MEM%    PID
chrome                 15.3    1234
java                   12.1    5678
docker                  8.5    9012
postgres                6.2    3456
```

</details>

---

## Exercise 20: Create Backup with Rotation
**Task**: Create a backup of a directory, keep only the 5 most recent backups, delete older ones

<details>
<summary>Solution</summary>

```bash
#!/bin/bash
BACKUP_DIR="/backups"
SOURCE_DIR="/data"
BACKUP_NAME="data_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Create backup
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" && \
echo "✓ Backup created: $BACKUP_NAME"

# Keep only 5 most recent, delete rest
ls -t "$BACKUP_DIR"/data_backup_*.tar.gz | tail -n +6 | xargs -r rm && \
echo "✓ Old backups removed"

# List remaining backups
echo "Current backups:"
ls -lh "$BACKUP_DIR"/data_backup_*.tar.gz
```

**Explanation**:
- `$(date +%Y%m%d_%H%M%S)` creates timestamp
- `tar -czf` creates compressed archive
- `ls -t` lists by time (newest first)
- `tail -n +6` gets everything from 6th line onward (old backups)
- `xargs -r rm` deletes if files exist
- `-r` prevents error if no files to delete

**Alternative (with logging)**:
```bash
LOGFILE="backup_$(date +%Y%m%d).log"
{
    echo "[$(date)] Starting backup..."
    tar -czf "$BACKUP_NAME" "$SOURCE_DIR" 2>&1
    echo "[$(date)] Backup complete"
    echo "[$(date)] Cleaning old backups..."
    ls -t "$BACKUP_DIR"/data_backup_*.tar.gz | tail -n +6 | xargs -r rm
    echo "[$(date)] Done"
} | tee -a "$LOGFILE"
```

</details>

---

## Summary

### Key Concepts Covered:
- ✅ Log analysis (Apache, Nginx, system logs)
- ✅ CSV/data processing
- ✅ JSON API parsing (generic REST APIs)
- ✅ Docker operations
- ✅ Git statistics
- ✅ File operations (find, archive, backup)
- ✅ System monitoring (CPU, memory, disk)
- ✅ Parallel processing
- ✅ Text substitution across files
- ✅ Configuration file parsing

### Skills Mastered:
- Complex pipelines (3-5 commands)
- Real-time monitoring
- Data aggregation and reporting
- Error handling in scripts
- Backup and rotation strategies
- Multi-file operations
- JSON processing with jq
- Resource monitoring

---

## Next Steps

Ready for more? Try [Advanced Level Practice](./advanced.md)!

**Estimated time to complete**: 60-90 minutes

---

**Want to review basics?** Go back to [Beginner Level](./beginner.md)
