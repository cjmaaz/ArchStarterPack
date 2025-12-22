# Node.js Development Setup (Fish + NVM) — Why this exists

If you use **Fish shell** on Arch and install **NVM** (Node Version Manager), you’ll run into a classic mismatch:

- **NVM is a bash script** that works by **modifying environment variables** (mainly `PATH`) in your _current shell_.
- **Fish cannot be “mutated” by a subprocess**. So if you run `nvm use 18` via a bash subprocess, Fish won’t automatically inherit the new `PATH`.

That’s why, in Fish, `nvm use <version>` can “succeed” but **`node -v` still shows the old version**.

This folder provides a minimal, package-manager-friendly way to make NVM usable in Fish **without** `fisher` or `bass`.

---

## What we do (high level)

We split responsibilities into three small pieces:

- **`config.fish`**: initializes Fish for NVM and (optionally) auto-loads the default Node version.
- **`nvm.fish`**: a tiny `nvm` function that _runs NVM in bash_.
- **`nvm-load.fish`**: a loader that _syncs the relevant environment back into Fish_ (so `node` is on Fish’s `PATH`).

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
