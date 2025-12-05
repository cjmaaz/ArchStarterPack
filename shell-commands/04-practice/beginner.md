# Beginner Level Practice - 20 Exercises

Master the fundamentals with these hands-on exercises.

---

## Exercise 1: List Files and Count
**Task**: List all files in current directory and count them

**Expected Output**: Total number of files

<details>
<summary>Solution</summary>

```bash
ls | wc -l
```

**Explanation**:
- `ls` lists files
- `|` pipes output to wc
- `wc -l` counts lines

</details>

---

## Exercise 2: Save Directory Listing
**Task**: Save the output of `ls -la` to a file named `listing.txt`

<details>
<summary>Solution</summary>

```bash
ls -la > listing.txt
```

**Explanation**:
- `>` redirects stdout to file
- Overwrites file if it exists

</details>

---

## Exercise 3: Append Date to Log
**Task**: Append the current date and time to a file named `activity.log`

<details>
<summary>Solution</summary>

```bash
date >> activity.log
```

**Explanation**:
- `date` prints current date/time
- `>>` appends to file (doesn't overwrite)

</details>

---

## Exercise 4: Create and Enter Directory
**Task**: Create a directory named `test_folder` and immediately cd into it

**Hint**: Use `&&`

<details>
<summary>Solution</summary>

```bash
mkdir test_folder && cd test_folder
```

**Explanation**:
- `&&` only runs second command if first succeeds
- If mkdir fails, cd won't execute

</details>

---

## Exercise 5: Try Remove with Fallback
**Task**: Try to remove `nonexistent.txt`, show "File not found" message if it doesn't exist

**Hint**: Use `||`

<details>
<summary>Solution</summary>

```bash
rm nonexistent.txt || echo "File not found"
```

**Explanation**:
- `||` runs second command only if first fails
- If rm succeeds, echo doesn't run

</details>

---

## Exercise 6: Find and Count Errors
**Task**: Count how many times "ERROR" appears in `application.log`

**Hint**: Use `grep -c`

<details>
<summary>Solution</summary>

```bash
grep -c "ERROR" application.log
```

**Alternative**:
```bash
grep "ERROR" application.log | wc -l
```

**Explanation**:
- `grep -c` counts matching lines
- Second method pipes matches to wc for counting

</details>

---

## Exercise 7: Case-Insensitive Search
**Task**: Search for "error" in any case (ERROR, Error, error) in `system.log`

<details>
<summary>Solution</summary>

```bash
grep -i "error" system.log
```

**Explanation**:
- `-i` makes search case insensitive
- Matches ERROR, Error, ErRoR, etc.

</details>

---

## Exercise 8: Show Last 20 Lines
**Task**: Display the last 20 lines of `debug.log`

<details>
<summary>Solution</summary>

```bash
tail -20 debug.log
```

**Alternative**:
```bash
tail -n 20 debug.log
```

**Explanation**:
- `tail` shows end of file
- `-20` or `-n 20` specifies number of lines

</details>

---

## Exercise 9: Show First 10 Lines
**Task**: Display the first 10 lines of `config.txt`

<details>
<summary>Solution</summary>

```bash
head -10 config.txt
```

**Explanation**:
- `head` shows beginning of file
- Default is 10 lines if no number specified

</details>

---

## Exercise 10: Filter Out Debug Messages
**Task**: Show all lines from `app.log` that do NOT contain "DEBUG"

**Hint**: Use `grep -v`

<details>
<summary>Solution</summary>

```bash
grep -v "DEBUG" app.log
```

**Explanation**:
- `-v` inverts match (shows non-matching lines)
- Useful for filtering out noise

</details>

---

## Exercise 11: Count Text Files
**Task**: Count how many `.txt` files exist in current directory

<details>
<summary>Solution</summary>

```bash
ls *.txt | wc -l
```

**Alternative**:
```bash
ls *.txt 2>/dev/null | wc -l  # Suppress errors if no matches
```

**Explanation**:
- `*.txt` matches all txt files
- Pipe to wc for counting
- Second version suppresses error if no files found

</details>

---

## Exercise 12: Create Backup File
**Task**: Copy `important.txt` to `important.txt.backup` only if copy succeeds, print "Backup created"

<details>
<summary>Solution</summary>

```bash
cp important.txt important.txt.backup && echo "Backup created"
```

**Explanation**:
- `&&` ensures message only prints if copy succeeds
- Common pattern for confirmation messages

</details>

---

## Exercise 13: Chain Three Commands
**Task**: Create a file named `test.txt`, write "Hello" to it, then display its contents

<details>
<summary>Solution</summary>

```bash
touch test.txt && echo "Hello" > test.txt && cat test.txt
```

**Alternative (using semicolons)**:
```bash
echo "Hello" > test.txt; cat test.txt
```

**Explanation**:
- `&&` chains commands with success checking
- `;` runs commands regardless of success/failure

</details>

---

## Exercise 14: Save Command Output
**Task**: Save the output of `df -h` (disk usage) to `disk_usage.txt`

<details>
<summary>Solution</summary>

```bash
df -h > disk_usage.txt
```

**Explanation**:
- `df -h` shows disk usage in human-readable format
- `>` redirects output to file

</details>

---

## Exercise 15: Find Lines with Numbers
**Task**: Display all lines from `data.txt` that start with a number

**Hint**: Use `grep` with pattern `^[0-9]`

<details>
<summary>Solution</summary>

```bash
grep "^[0-9]" data.txt
```

**Explanation**:
- `^` anchors to start of line
- `[0-9]` matches any digit
- Pattern means "line starting with a digit"

</details>

---

## Exercise 16: Count Unique Lines
**Task**: Count how many unique lines are in `names.txt`

**Hint**: Use `sort | uniq | wc -l`

<details>
<summary>Solution</summary>

```bash
sort names.txt | uniq | wc -l
```

**Alternative**:
```bash
sort -u names.txt | wc -l
```

**Explanation**:
- `sort` arranges lines alphabetically
- `uniq` removes adjacent duplicates (requires sorted input)
- `wc -l` counts the lines
- `sort -u` combines sort and unique

</details>

---

## Exercise 17: Extract Column
**Task**: Extract the first word from each line of `data.txt`

**Hint**: Use `awk '{print $1}'`

<details>
<summary>Solution</summary>

```bash
awk '{print $1}' data.txt
```

**Alternative (with cut)**:
```bash
cut -d' ' -f1 data.txt
```

**Explanation**:
- `awk` processes text by columns
- `$1` represents first column/field
- `cut -d' ' -f1` uses space as delimiter, extracts field 1

</details>

---

## Exercise 18: Combine Two Files
**Task**: Display contents of `file1.txt` followed by `file2.txt`

<details>
<summary>Solution</summary>

```bash
cat file1.txt file2.txt
```

**Alternative (save combined output)**:
```bash
cat file1.txt file2.txt > combined.txt
```

**Explanation**:
- `cat` concatenates and displays files
- Can redirect to new file to save combined output

</details>

---

## Exercise 19: Find Files Modified Today
**Task**: List all `.log` files in current directory modified today

**Hint**: Use `find` with `-mtime 0`

<details>
<summary>Solution</summary>

```bash
find . -name "*.log" -mtime 0
```

**Alternative (using ls and grep)**:
```bash
ls -l *.log | grep "$(date +%b\ %e)"
```

**Explanation**:
- `find . -name "*.log"` finds all log files
- `-mtime 0` means modified in last 24 hours
- Second method uses ls with today's date

</details>

---

## Exercise 20: Create Timestamp File
**Task**: Create a file with current date in filename (format: backup_2025-12-05.txt)

**Hint**: Use command substitution `$(date)`

<details>
<summary>Solution</summary>

```bash
touch backup_$(date +%Y-%m-%d).txt
```

**Alternative (with content)**:
```bash
echo "Backup created" > backup_$(date +%Y-%m-%d).txt
```

**Explanation**:
- `$(date +%Y-%m-%d)` executes date command and uses output
- `+%Y-%m-%d` formats as YYYY-MM-DD
- Creates file like `backup_2025-12-05.txt`

</details>

---

## Summary

### Key Concepts Covered:
- ✅ Piping (`|`)
- ✅ Redirection (`>`, `>>`)
- ✅ Command chaining (`&&`, `||`)
- ✅ Basic grep patterns
- ✅ head/tail for file viewing
- ✅ awk for column extraction
- ✅ Command substitution `$()`

### Skills Mastered:
- Filtering and counting
- File operations
- Basic text processing
- Error handling
- Output redirection

---

## Next Steps

Ready for more? Try [Intermediate Level Practice](./intermediate.md)!

**Estimated time to complete**: 30-45 minutes
