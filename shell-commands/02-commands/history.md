# history - Command History

View and manage shell command history.

---

## 📋 Quick Reference

```bash
history                             # Show all history
history 20                          # Last 20 commands
history | grep keyword              # Search history
!n                                  # Execute command n
!!                                  # Repeat last command
!keyword                            # Last command starting with keyword
Ctrl+R                              # Reverse search
history -c                          # Clear history
```

---

## Examples

### View History
```bash
# All commands
history

# Last 20
history 20

# Search
history | grep deploy

# With timestamps (if enabled)
HISTTIMEFORMAT="%Y-%m-%d %T " history
```

### Execute from History
```bash
# By number
!123

# Last command
!!

# Last starting with 'sf'
!sf

# Last argument
!$

# All arguments from last command
!*
```

### History Control
```bash
# Clear history
history -c

# Delete specific entry
history -d 123

# Save immediately
history -a

# Reload history
history -r
```

### Configuration
```bash
# In ~/.bashrc or ~/.zshrc

# Size settings
export HISTSIZE=10000           # In memory
export HISTFILESIZE=20000       # In file

# Timestamps
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Avoid duplicates
export HISTCONTROL=ignoreboth

# Ignore specific commands
export HISTIGNORE="ls:cd:pwd:exit"

# Append instead of overwrite
shopt -s histappend
```

### Useful Patterns
```bash
# Find most used commands
history | awk '{print $2}' | sort | uniq -c | sort -nr | head -20

# Recent deployments
history | grep "sf project deploy"

# Execute with modification
^old^new  # Replace old with new in last command

# Rerun with sudo
sudo !!
```

### Salesforce Examples
```bash
# Recent SF commands
history | grep "^sf "

# Last deployment
!sfd  # If you have alias sfd='sf project deploy start'

# Repeat test command
history | grep "apex run test"
!123  # Execute that specific test
```

---

**Phase 6 Complete! Moving to Phase 7...**

**Next**: [comm - Compare Sorted Files](./comm.md)
