# date - Display and Set Date/Time

Display, format, and calculate dates and times.

---

## 📋 Quick Reference

```bash
date                                # Current date/time
date +%Y-%m-%d                      # 2025-12-05
date +%H:%M:%S                      # 14:30:25
date +%s                            # Unix timestamp
date -d "yesterday"                 # Yesterday's date
date -d "+7 days"                   # 7 days from now
date -d "@1234567890"               # Convert timestamp
date +%Y%m%d_%H%M%S                 # 20251205_143025 (filenames)
```

---

## Format Specifiers

| Specifier | Output | Example |
|-----------|--------|---------|
| `%Y` | Year (4 digit) | 2025 |
| `%m` | Month (01-12) | 12 |
| `%d` | Day (01-31) | 05 |
| `%H` | Hour (00-23) | 14 |
| `%M` | Minute (00-59) | 30 |
| `%S` | Second (00-59) | 25 |
| `%s` | Unix timestamp | 1733414425 |
| `%A` | Weekday name | Friday |
| `%B` | Month name | December |

---

## Examples

### Current Date/Time
```bash
# Default format
date

# ISO format
date -I  # or date +%Y-%m-%d

# Custom format
date "+%Y-%m-%d %H:%M:%S"

# Timestamp
date +%s
```

### Date Arithmetic
```bash
# Tomorrow
date -d "tomorrow"

# Yesterday
date -d "yesterday"

# Next week
date -d "+7 days"

# Last month
date -d "last month"

# Specific calculation
date -d "2025-12-05 + 30 days"
```

### Practical Uses
```bash
# Timestamp filenames
backup_$(date +%Y%m%d_%H%M%S).tar.gz

# Log entries
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Process started" >> app.log

# Calculate duration
START=$(date +%s)
# ... do work ...
END=$(date +%s)
DURATION=$((END - START))
echo "Took ${DURATION}s"

# Convert timestamp
date -d @1733414425
```

### Salesforce Examples
```bash
# Deployment timestamp
sf project deploy start | tee deploy_$(date +%Y%m%d_%H%M%S).log

# Date range queries
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
sf data query --query "SELECT Id FROM Account WHERE CreatedDate = $YESTERDAY"
```

---

**Next**: [tee - Duplicate Output](./tee.md)
