# tee - Duplicate Output Streams

Read from stdin and write to stdout AND file(s) simultaneously.

---

## 📋 Quick Reference

```bash
command | tee output.txt                # Display and save
command | tee -a output.txt             # Display and append
command | tee file1.txt file2.txt       # Multiple files
command 2>&1 | tee log.txt              # Capture stderr too
command | tee >(process1) >(process2)   # Process substitution
```

---

## Common Options

| Option | Purpose |
|--------|---------|
| `-a` | Append to file |
| `-i` | Ignore interrupt signals |

---

## Examples

### Basic Usage
```bash
# Save and display
ls -la | tee listing.txt

# Append mode
date | tee -a activity.log

# Multiple files
echo "data" | tee file1.txt file2.txt file3.txt
```

### With Error Output
```bash
# Capture both stdout and stderr
command 2>&1 | tee output.log

# Deployment with logging
sf project deploy start 2>&1 | tee deploy.log
```

### Advanced Patterns
```bash
# Split output to multiple processes
command | tee >(grep "ERROR" > errors.txt) >(grep "WARN" > warnings.txt) > all.txt

# Pipeline with logging
cat data.txt | \
  process1 | tee intermediate.log | \
  process2 | tee final.log
```

### Salesforce Examples
```bash
# Log deployment
sf project deploy start 2>&1 | tee deployment_$(date +%Y%m%d_%H%M%S).log

# Test results
sf apex run test --test-level RunLocalTests | tee test_results.txt

# Real-time monitoring with logging
tail -f application.log | tee -a monitoring.log | grep "ERROR"
```

### Script Integration
```bash
#!/bin/bash
# Log script output
exec > >(tee -a script.log)
exec 2>&1

echo "Script started"
# ... commands ...
echo "Script completed"

# Everything logged to script.log and displayed
```

---

**Next**: [comm - Compare Sorted Files](./comm.md)
