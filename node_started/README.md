# Node.js Development Setup (Fish + NVM) — Why This Exists

## What Is Node.js Version Management?

### Definition

**Node.js version management** is the ability to install and switch between different versions of Node.js on the same system.

### Why Version Management Exists

**The problem:** Different projects may require different Node.js versions:

- **Project A:** Needs Node.js 18
- **Project B:** Needs Node.js 20
- **Project C:** Needs Node.js 16
- **Single version:** Can't use different versions simultaneously

**The solution:** Version managers like NVM:

- **Multiple versions:** Install multiple Node.js versions
- **Switch versions:** Change version per project
- **Isolation:** Each project uses its version
- **Flexibility:** Work on different projects easily

**Real-world analogy:**

- **Version management = Multiple toolboxes** (different tools for different projects)
- **Single version = One toolbox** (limited, can't handle all projects)
- **NVM = Toolbox organizer** (manages multiple toolboxes)
- **Result = Work on any project** (right tools for each project)

### What Is NVM?

**Definition:** **NVM (Node Version Manager)** is a tool that allows you to install and manage multiple Node.js versions.

**How NVM works:**

- **Installs versions:** Downloads and installs Node.js versions
- **Manages versions:** Keeps multiple versions available
- **Switches versions:** Changes active Node.js version
- **Isolates projects:** Each project can use different version

## The Fish Shell Problem

### Why This Setup Exists

**If you use **Fish shell** on Arch and install **NVM** (Node Version Manager), you'll run into a classic mismatch:**

**The problem:**

**1. NVM is a bash script that works by modifying environment variables (mainly `PATH`) in your _current shell_.**

**What this means:**

- **NVM is bash script:** Written for bash shell
- **Modifies PATH:** Changes environment variables
- **Current shell:** Only affects shell where command runs
- **Bash-specific:** Designed for bash, not Fish

**How NVM works in bash:**

1. **Run `nvm use 18`:** NVM script executes
2. **Modifies PATH:** Changes PATH environment variable
3. **Bash inherits:** Bash shell gets new PATH
4. **Node available:** `node` command works

**2. Fish cannot be "mutated" by a subprocess. So if you run `nvm use 18` via a bash subprocess, Fish won't automatically inherit the new `PATH`.**

**What this means:**

- **Fish limitation:** Fish shell doesn't inherit environment changes from subprocesses
- **Bash subprocess:** Running NVM in bash doesn't affect Fish
- **PATH unchanged:** Fish's PATH stays the same
- **Node not found:** `node` command doesn't work in Fish

**How it fails in Fish:**

1. **Run `nvm use 18`:** NVM runs in bash subprocess
2. **Modifies PATH:** Changes PATH in bash subprocess
3. **Fish unaffected:** Fish shell doesn't see change
4. **PATH unchanged:** Fish still has old PATH
5. **Node not found:** `node` command doesn't work ❌

**That's why, in Fish, `nvm use <version>` can "succeed" but **`node -v` still shows the old version**.**

**Real-world example:**

**In Fish shell:**

```bash
$ nvm use 18
Now using node v18.17.0
# NVM says it worked ✅

$ node -v
v16.20.0
# But Fish still shows old version ❌
```

**Problem:** NVM changed PATH in bash subprocess, but Fish didn't inherit the change.

**This folder provides a minimal, package-manager-friendly way to make NVM usable in Fish **without** `fisher` or `bass`.**

**What this solution does:**

- **Works with Fish:** Makes NVM work in Fish shell
- **Minimal setup:** Simple, lightweight solution
- **No extra tools:** Doesn't require fisher or bass plugins
- **Package-friendly:** Works with Arch's pacman-installed NVM

---

## What We Do (High Level)

### The Solution Approach

**We split responsibilities into three small pieces:**

**Why split into pieces:**

- **Separation of concerns:** Each piece does one thing
- **Modularity:** Easy to understand and modify
- **Maintainability:** Simple to maintain
- **Flexibility:** Can modify pieces independently

**1. `config.fish`: initializes Fish for NVM and (optionally) auto-loads the default Node version.**

**What it does:**

- **Initialization:** Sets up Fish for NVM
- **Environment:** Exports NVM directory
- **Auto-load:** Loads default Node version on startup
- **Startup:** Runs when Fish shell starts

**Why it's needed:**

- **Setup:** Configures Fish for NVM
- **Convenience:** Auto-loads Node so it's ready
- **Integration:** Makes NVM work with Fish

**2. `nvm.fish`: a tiny `nvm` function that _runs NVM in bash_.**

**What it does:**

- **Wrapper function:** Creates `nvm` command in Fish
- **Bash execution:** Runs NVM commands in bash
- **Command forwarding:** Passes commands to real NVM
- **Compatibility:** Makes NVM commands work in Fish

**Why it's needed:**

- **Command access:** Use `nvm` commands in Fish
- **Bash compatibility:** Runs NVM in bash (where it works)
- **Transparency:** Works like NVM in bash

**3. `nvm-load.fish`: a loader that _syncs the relevant environment back into Fish_ (so `node` is on Fish's `PATH`).**

**What it does:**

- **Environment sync:** Gets PATH from bash/NVM
- **Updates Fish:** Sets PATH in Fish shell
- **Makes Node available:** Puts `node` on Fish's PATH
- **Synchronization:** Keeps Fish in sync with NVM

**Why it's needed:**

- **PATH sync:** Fish needs updated PATH
- **Node availability:** Makes `node` command work
- **Bridge:** Connects NVM (bash) to Fish

**Real-world analogy:**

- **config.fish = Setup crew** (prepares workspace)
- **nvm.fish = Translator** (translates Fish commands to bash)
- **nvm-load.fish = Synchronizer** (syncs results back to Fish)
- **Result = NVM works in Fish** (all pieces work together)

---

## Files and why they exist

### `node_started/config.fish`

This is your Fish startup file (usually `~/.config/fish/config.fish`).

It does two important things:

- **Exports `NVM_DIR`** (needed by NVM tooling).
- **Runs `nvm-load`** (if available) so your Fish session starts with a working `node` on `PATH`.

Notes:

- This repo’s `config.fish` currently sources a CachyOS shared config. If you don’t have it, remove/comment that line and keep the NVM bits.

### `node_started/nvm.fish`

Defines the Fish function `nvm`:

- It forwards your command to bash and runs the real NVM:
  - `bash -ic "source /usr/share/nvm/init-nvm.sh; nvm $argv"`

This makes commands like `nvm list`, `nvm install`, `nvm alias`, etc. available in Fish.

### `node_started/nvm-load.fish`

Defines `nvm-load`, which is the key workaround:

- It runs a bash command that sources NVM, selects the default node (`nvm use default`), then prints the environment (`env`).
- It parses that output and **updates Fish’s environment** (especially `PATH`, plus `NVM_DIR`/`NVM_BIN`).

This is what makes `node`, `npm`, and friends actually work in Fish.

---

## The “Fish problem” in one sentence

**Fish can’t receive environment changes from a child process**, so `nvm use` alone won’t update the current Fish session’s `PATH`.

---

## How to use day-to-day

### Default behavior (recommended)

Use a default Node alias and let `nvm-load` bring it into Fish:

```bash
nvm-load
node -v
```

### Switching versions in Fish (the rule)

When you change versions, **run `nvm-load` after**:

```bash
nvm use 18
nvm-load
node -v
```

---

## Install / setup (quick)

See the detailed guide:

- `node_started/nvm-fish-readme.md`

---

## Troubleshooting checklist

```bash
type -q nvm; and echo "nvm function exists"
type -q nvm-load; and echo "nvm-load function exists"
nvm-load
which node
node -v
```
