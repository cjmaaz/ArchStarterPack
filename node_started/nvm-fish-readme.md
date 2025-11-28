
# README — Full Guide: Fix Fish Shell Startup Errors and Make `node`/`nvm` Work Correctly  
### (Arch Linux / CachyOS — pacman `nvm` — **No fisher / No bass required**)

This document contains:

- ✔ Full reliable setup for **Fish**, **Zsh**, and **Bash**
- ✔ Complete replacement for `bass` (**no plugins needed**)
- ✔ Startup error fixes for `csource` / `bass`
- ✔ Persistently working `node` and `npm` across restarts
- ✔ Debugging steps for every major setup component
- ✔ Safe, copy‑paste‑ready file contents (no risky `cat >` blocks)

---

# 🔧 **0) Backup & Prepare (Safe commands)**

Run these BEFORE creating any files:

```bash
mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions
cp -v ~/.config/fish/config.fish{,.bak} 2>/dev/null || echo "config.fish not found (skipping backup)"
```

This ensures your configuration is backed up and prevents breaking your shell.

---

# 🔧 **1) Fix Fish Startup Errors — Create Shim: `00-nvm-shim.fish`**

**File:** `~/.config/fish/conf.d/00-nvm-shim.fish`  
**Purpose:**  
Fixes startup errors:

- `Unknown command: csource`  
- `Unknown command: bass`  

This shim ensures Fish never breaks on startup again.

Paste this exact file:

```fish
# 00-nvm-shim.fish — prevent "Unknown command: csource/bass" startup errors.
# Loaded early so these commands always exist.

# --- Safe csource fallback ---
if not type -q csource
    function csource --description 'safe csource fallback (sources file if it exists)'
        if test -n "$argv[1]" -a -f "$argv[1]"
            source "$argv[1]"
        end
    end
end

# --- Minimal bass shim (no fisher needed) ---
# Runs bash commands, then syncs environment into fish.
if not type -q bass
    function bass --description 'shim for bass to prevent startup errors and load nvm'
        set -l bash_cmd (string join ' ' $argv)
        bash -lc "$bash_cmd"
        if type -q nvm-load
            nvm-load >/dev/null 2>&1
        end
        return $status
    end
end
```

---

# 🔧 **2) Load Node/NVM Into Fish (bass‑free) — Create Loader: `nvm-load.fish`**

**File:** `~/.config/fish/functions/nvm-load.fish`  
**Purpose:**  
Loads NVM and the selected default Node version into the Fish environment **every time** Fish starts.

Paste:

```fish
# nvm-load.fish — Load NVM + Node into Fish without bass/fisher.
function nvm-load --description 'Load NVM into fish (bash-sourced nvm, sync PATH)'
    if test ! -f /usr/share/nvm/init-nvm.sh
        return 0
    end

    set -l out (bash -lc '
        source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1
        nvm use default >/dev/null 2>&1
        env
    ' 2>/dev/null)

    for line in $out
        if string match -rq '^PATH=' $line
            set -gx PATH (string split -r '=' -- $line)[2]
        else if string match -rq '^NVM_BIN=' $line
            set -gx NVM_BIN (string split -r '=' -- $line)[2]
        else if string match -rq '^NVM_DIR=' $line
            set -gx NVM_DIR (string split -r '=' -- $line)[2]
        end
    end
end
```

---

# 🔧 **3) Update Your Fish Config — Call `nvm-load`**

Open:

`~/.config/fish/config.fish`

Add this block **at the bottom**:

```fish
# Auto-load Node/NVM for fish
if type -q nvm-load
    nvm-load
end
```

This ensures `node` is available on every Fish session.

---

# 🔧 **4) Make Node/NVM Work in Zsh**

Append this to `~/.zshrc`:

```zsh
# nvm (pacman init)
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/share/nvm/init-nvm.sh" ]; then
  . "/usr/share/nvm/init-nvm.sh"
  nvm use default >/dev/null 2>&1 || true
fi
```

---

# 🔧 **5) Make Node/NVM Work in Bash**

Append this to `~/.bashrc`:

```bash
# nvm (pacman init)
export NVM_DIR="$HOME/.nvm"
if [ -s "/usr/share/nvm/init-nvm.sh" ]; then
  . "/usr/share/nvm/init-nvm.sh"
  nvm use default >/dev/null 2>&1 || true
fi
```

---

# 🔧 **6) Set Default Node Version (Run Once)**

Run this in *bash* (important):

```bash
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'
```

This ensures:

- NVM installs LTS  
- `default` points to LTS  
- Fish and Zsh sessions automatically use it  

---

# 🧪 **7) Test Everything**

### Fish test:
```bash
exec fish -c "node -v; which node"
```

### Zsh test:
```bash
exec zsh -c "node -v; which node"
```

### Bash test:
```bash
bash -ic "node -v; which node"
```

Expected:

- `node -v` prints your version  
- `which node` points to:  
  `~/.nvm/versions/node/.../bin/node`

---

# 🩺 **8) Debugging Section (If Something Fails)**

## ❌ Issue: `exec fish` shows errors:  
`Unknown command: csource`  
`Unknown command: bass`

✔ Fix:  
Ensure this file exists:

`~/.config/fish/conf.d/00-nvm-shim.fish`

Run:

```bash
ls ~/.config/fish/conf.d/
```

You should see:

```
00-nvm-shim.fish
```

---

## ❌ Issue: `node -v` works in one session but not after restart

Cause: `nvm-load` not being called.

Check:

```bash
grep nvm-load ~/.config/fish/config.fish
```

If missing, add:

```fish
if type -q nvm-load
    nvm-load
end
```

---

## ❌ Issue: `nvm` works but `node` is missing in Fish

Cause: PATH not carried over.

Check:

```fish
nvm-load; echo $PATH
```

PATH should contain something like:

```
/home/you/.nvm/versions/node/vXX/bin
```

If missing → `nvm-load.fish` is not correct or not saved.

---

## ❌ Issue: Node version wrong

Run:

```bash
bash -ic 'nvm alias'
```

Ensure default is set.

If not:

```bash
bash -ic 'nvm alias default lts/*'
```

---

## ❌ Issue: `nvm` broken in Zsh or Bash

Run:

```bash
grep nvm ~/.zshrc
grep nvm ~/.bashrc
```

Ensure the correct block exists.

---
