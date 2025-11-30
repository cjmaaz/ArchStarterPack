# Contributing to ArchStarterPack

Thank you for considering contributing to ArchStarterPack! This document provides guidelines and instructions for contributing.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Contribution Guidelines](#contribution-guidelines)
- [Pull Request Process](#pull-request-process)
- [Style Guide](#style-guide)
- [Testing](#testing)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

### Expected Behavior

- Be respectful and inclusive
- Be patient with beginners
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment, trolling, or insulting comments
- Personal or political attacks
- Publishing others' private information
- Any conduct that would be inappropriate in a professional setting

---

## How Can I Contribute?

### Reporting Bugs

**Before submitting a bug report:**
- Check the [FAQ](docs/FAQ.md) and [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- Search existing [GitHub Issues](https://github.com/cjmaaz/ArchStarterPack/issues)
- Run the diagnostics script: `./cachy_os_config/diagnostics.sh`

**When submitting a bug report, include:**
- Clear, descriptive title
- Step-by-step reproduction steps
- Expected vs. actual behavior
- System information (output of `./check-prerequisites.sh`)
- Relevant log files or error messages
- Screenshots if applicable

### Suggesting Enhancements

**Before suggesting an enhancement:**
- Check if it's already been suggested
- Ensure it aligns with the project's goals

**When suggesting an enhancement, include:**
- Clear use case and benefits
- Proposed implementation
- Any potential drawbacks
- Examples from other projects

### Adding Hardware Support

Want to add configurations for your hardware?

**Include:**
- Hardware specifications (CPU, GPU, laptop model)
- Distribution and kernel version tested
- Complete configuration files
- Step-by-step setup guide
- Safety checks and rollback instructions
- Expected results and benchmarks

### Improving Documentation

Documentation improvements are always welcome!

**Areas to improve:**
- Clarifying existing guides
- Adding examples
- Fixing typos and grammar
- Translating to other languages
- Adding troubleshooting steps
- Creating visual guides or diagrams

### Adding New Modules

Want to add a new configuration module?

**Requirements:**
- Must be relevant to Arch-based systems
- Should follow existing documentation structure
- Must include safety checks and rollback instructions
- Should be tested on real hardware
- Must include comprehensive documentation

---

## Getting Started

### Development Setup

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/ArchStarterPack.git
   cd ArchStarterPack
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # OR
   git checkout -b fix/your-bug-fix
   ```

4. **Make your changes**
   - Follow the style guide
   - Test thoroughly
   - Update documentation

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill out the PR template

---

## Contribution Guidelines

### Documentation Standards

**All documentation must include:**
- Last Updated date
- Tested On information (distribution, kernel, hardware)
- Difficulty level (Beginner/Intermediate/Advanced)
- Time estimate
- Clear prerequisites
- Safety warnings where appropriate
- Rollback/recovery instructions

**Markdown formatting:**
- Use proper headings hierarchy (H1 → H2 → H3)
- Include code blocks with language specification
- Use tables for comparisons
- Add links to related documentation
- Use warning/note boxes for important information

**Example:**
```markdown
# Guide Title

**Last Updated:** November 2025  
**Tested On:** CachyOS, Linux Kernel 6.x, ASUS X507UF  
**Difficulty:** Intermediate  
**Time Required:** 30-45 minutes

## Prerequisites
- Item 1
- Item 2

## ⚠️ Safety Warning
Always back up before proceeding.

## Instructions
...
```

### Configuration File Standards

**All configuration files must include:**
- Header comments explaining purpose
- Inline comments for non-obvious settings
- Examples of alternatives (commented out)
- Link to detailed documentation
- Last Updated date

**Example:**
```bash
# /etc/tlp.d/01-custom.conf
# Last Updated: November 2025
# Purpose: Automatic AC/battery power management
# See: cachy_os_config/asus_x_507_uf_readme.md

# Performance on AC power
CPU_SCALING_GOVERNOR_ON_AC=performance  # Maximum frequency

# Power saving on battery
CPU_SCALING_GOVERNOR_ON_BAT=schedutil   # Dynamic scaling

# Alternative options (uncomment to use):
# CPU_SCALING_GOVERNOR_ON_BAT=powersave  # Minimum frequency
```

### Script Standards

**All scripts must:**
- Include shebang (`#!/usr/bin/env bash`)
- Have descriptive header comments
- Include error handling (`set -e`)
- Provide helpful output messages
- Check prerequisites before running
- Be well-commented
- Handle edge cases gracefully

**Example:**
```bash
#!/usr/bin/env bash

# ============================================
# Script Name
# ============================================
# Last Updated: November 2025
# Purpose: Brief description
# Usage: ./script.sh [arguments]

set -e  # Exit on error

# Check prerequisites
if ! command -v required-tool &> /dev/null; then
    echo "Error: required-tool not found"
    exit 1
fi

# Main logic
...
```

---

## Pull Request Process

### Before Submitting

- [ ] Code follows project style guidelines
- [ ] Documentation is updated
- [ ] Changes are tested on real hardware
- [ ] Commit messages are clear and descriptive
- [ ] No merge conflicts with main branch
- [ ] Added entry to CHANGELOG.md (if applicable)

### PR Template

When opening a PR, include:

**Description:**
Clear description of changes

**Type of Change:**
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Hardware support addition
- [ ] Other (describe)

**Testing:**
- Hardware tested on
- Distribution and kernel version
- Test results

**Checklist:**
- [ ] Follows style guidelines
- [ ] Documentation updated
- [ ] Tested on hardware
- [ ] No breaking changes (or documented)

### Review Process

1. Maintainer reviews PR
2. Feedback provided (if needed)
3. Contributor makes requested changes
4. PR approved and merged

**Timeline:**
- First review: Within 7 days
- Follow-up reviews: Within 3-5 days
- Merge: After approval

---

## Style Guide

### Markdown

- Use ATX-style headers (`#` not underlines)
- One sentence per line (for easier diffs)
- Use fenced code blocks with language: ` ```bash `
- Use relative links for internal files
- Use proper list formatting (consistent bullets)

### Shell Scripts

- Use `bash` not `sh`
- Indent with 4 spaces (no tabs)
- Use descriptive variable names (`CONFIG_FILE` not `cf`)
- Quote variables: `"$VAR"` not `$VAR`
- Use `$( )` for command substitution, not backticks

### Configuration Files

- Comment every non-obvious line
- Group related settings
- Use descriptive setting names
- Include examples of alternatives
- Reference documentation

---

## Testing

### Before Submitting

**Test on real hardware:**
- Verify configurations work as documented
- Test rollback procedures
- Check for conflicts with other modules
- Verify scripts run without errors

**Documentation testing:**
- Follow your own guide from scratch
- Verify all commands work
- Check that links aren't broken
- Ensure code blocks are correct

**Safety testing:**
- Verify backups are created
- Test rollback procedures
- Ensure no permanent damage is possible
- Check that warnings are clear

### Test Environments

Preferred testing:
- Clean Arch/CachyOS installation
- Up-to-date system packages
- Default desktop environment
- No previous custom configurations

---

## Questions?

- Check the [FAQ](docs/FAQ.md)
- Open a [Discussion](https://github.com/cjmaaz/ArchStarterPack/discussions)
- Ask in [Issues](https://github.com/cjmaaz/ArchStarterPack/issues)

---

## Recognition

Contributors will be:
- Listed in project credits
- Mentioned in CHANGELOG
- Recognized in release notes

Thank you for contributing to ArchStarterPack! 🚀
