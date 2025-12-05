# alias - Command Shortcuts

Create shortcuts for frequently used commands.

---

## 📋 Quick Reference

```bash
alias                                   # List all aliases
alias ll='ls -la'                       # Create alias
alias gs='git status'                   # Git shortcut
alias ..='cd ..'                        # Navigation
unalias ll                              # Remove alias
alias rm='rm -i'                        # Make command safer
```

---

## Examples

### Common Aliases
```bash
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# Listing
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Utilities
alias h='history'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
```

### Salesforce Aliases
```bash
# SF CLI shortcuts
alias sfo='sf org'
alias sfod='sf org display'
alias sfol='sf org list'
alias sfd='sf project deploy start'
alias sfr='sf project retrieve start'
alias sft='sf apex run test --test-level RunLocalTests'
alias sfl='sf apex get log'

# Complex commands
alias sfdeploy='sf project deploy start && sf apex run test'
alias sfstatus='sf org display && sf limits api display'
```

### Make Permanent
```bash
# Add to ~/.bashrc or ~/.zshrc
echo "alias ll='ls -lah'" >> ~/.bashrc
source ~/.bashrc

# Or edit directly
nano ~/.bashrc
# Add your aliases
source ~/.bashrc
```

### Functions vs Aliases
```bash
# Alias (simple)
alias greet='echo "Hello"'

# Function (with parameters)
greet() {
    echo "Hello, $1!"
}

# Usage
greet John  # "Hello, John!"
```

---

**Next**: [history - Command History](./history.md)
