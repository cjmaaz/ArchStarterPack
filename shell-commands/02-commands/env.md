# env - Environment Variables

Display, set, or run programs in modified environment.

---

## 📋 Quick Reference

```bash
env                                 # List all variables
env | grep PATH                     # Find specific variable
env VAR=value command               # Set for command only
env -i command                      # Clean environment
export VAR=value                    # Set for session
printenv VAR                        # Print specific variable
```

---

## Examples

### View Environment
```bash
# All variables
env

# Sorted
env | sort

# Find variable
env | grep USER
printenv USER
echo $USER
```

### Set Variables
```bash
# For current session
export DATABASE_URL="postgres://localhost/db"

# For single command
env NODE_ENV=production node app.js

# Multiple variables
env VAR1=val1 VAR2=val2 command
```

### Salesforce Examples
```bash
# Set target org
export SFDX_DEFAULTUSERNAME=dev@example.com
sf org display

# Temporary override
env SFDX_DEFAULTUSERNAME=prod@example.com sf project deploy start

# API version
export SF_API_VERSION=60.0
```

### Script Usage
```bash
#!/usr/bin/env bash
# Portable shebang

# Check variable
if [ -z "$DATABASE_URL" ]; then
    echo "DATABASE_URL not set"
    exit 1
fi

# Use variable
echo "Connecting to $DATABASE_URL"
```

---

**Next**: [alias - Command Shortcuts](./alias.md)
