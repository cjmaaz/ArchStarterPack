# Interactive Demos

## What Are Demos?

These are **guided demonstrations** that show you how commands work by walking you through examples. They are passive learning tools - you press Enter to see each step.

## Demos vs Practice

| Feature           | Demos (This Folder)     | Practice (../practice/) |
| ----------------- | ----------------------- | ----------------------- |
| Learning Style    | Passive (watch & learn) | Active (do & validate)  |
| User Input        | Press Enter to continue | Type commands yourself  |
| Validation        | None                    | Automatic validation    |
| Feedback          | Shows solutions         | Checks your answers     |
| Progress Tracking | No                      | Yes                     |
| Scoring           | No                      | Yes                     |

## When to Use Demos

Use demos when you want to:

- **See how a command works** without typing
- **Quick reference** for command syntax
- **Learn new concepts** before practicing
- **Review examples** for inspiration

## When to Use Practice

Use practice (`../practice/`) when you want to:

- **Test your knowledge** with real exercises
- **Get immediate feedback** on your commands
- **Track your progress** and mastery
- **Build muscle memory** by typing commands

## Available Demos

### Beginner Level

- `beginner/01-grep-basics.sh` - grep pattern matching
- `beginner/02-piping-basics.sh` - Chaining commands
- `beginner/03-json-processing.sh` - jq for JSON
- `beginner/04-file-operations.sh` - cat, head, tail, wc
- `beginner/05-csv-basics.sh` - awk, cut, sort for CSV

### Intermediate Level

- `intermediate/01-log-analysis.sh` - Real log scenarios
- `intermediate/02-salesforce-analysis.sh` - SF debugging
- `intermediate/03-data-transformation.sh` - Format conversion

### Advanced Level

- `advanced/01-complex-pipelines.sh` - Multi-stage processing
- `advanced/02-automation-scripts.sh` - Script building

### Expert Level

- `expert/01-production-scenarios.sh` - Real incidents

## How to Run Demos

```bash
cd demos
./beginner/01-grep-basics.sh
# Press Enter at each prompt to see the next step
```

## Recommended Learning Path

1. **Start with Demos**: Watch 1-2 demos to see how commands work
2. **Switch to Practice**: Test yourself with practice exercises
3. **Return to Demos**: Review when you need examples or inspiration

## Example Workflow

```bash
# 1. Watch a demo to learn
./demos/beginner/01-grep-basics.sh

# 2. Practice what you learned
../practice/commands/grep-practice.sh

# 3. Review demo if stuck
./demos/beginner/01-grep-basics.sh
```

## Next Steps

Ready to practice? Head over to `../practice/` for interactive exercises with validation and scoring!

```bash
cd ../practice
./practice-menu.sh
```
