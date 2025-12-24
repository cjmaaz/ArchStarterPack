README — Minimal Setup: Fish + NVM (Arch `pacman` NVM) using `nvm.fish` + `nvm-load.fish`

## What Is This Guide?

### Definition

This guide explains how to set up NVM (Node Version Manager) to work with Fish shell on Arch Linux systems.

### Why This Guide Exists

**The problem:** NVM doesn't work natively with Fish shell because:

- **NVM is bash script:** Designed for bash, not Fish
- **Fish incompatibility:** Fish can't inherit environment changes from bash
- **PATH issues:** Node.js not available in Fish after `nvm use`
- **Need workaround:** Requires special setup to work

**The solution:** This guide provides:

- **Fish integration:** Makes NVM work with Fish
- **Minimal setup:** Simple, lightweight solution
- **No plugins:** Doesn't require fisher or bass
- **Arch-friendly:** Works with pacman-installed NVM

## Goal

**Provide the **bare minimum** Fish setup to:**

**1. Make `nvm` available in Fish (by running it via bash)**

**What this means:**

- **`nvm` command works:** Can run `nvm` commands in Fish
- **Via bash:** Commands run in bash (where NVM works)
- **Transparent:** Works like NVM in bash

**2. Ensure `node` is on `PATH` in Fish (by syncing env via `nvm-load`)**

**What this means:**

- **Node available:** `node` command works in Fish
- **PATH sync:** Fish's PATH updated with Node path
- **Via nvm-load:** Uses loader to sync environment

**3. Avoid requiring `fisher` or `bass`**

**What this means:**

- **No plugins:** Doesn't need Fish plugin manager
- **No bass:** Doesn't need bass compatibility layer
- **Standalone:** Works without extra tools

**4. Avoid startup errors (including VSCode integrated terminal)**

**What this means:**

- **Clean startup:** No errors when Fish starts
- **VSCode compatible:** Works in VSCode terminal
- **Reliable:** Consistent behavior

## Assumptions

**What you need before starting:**

**1. You installed `nvm` so `/usr/share/nvm/init-nvm.sh` exists (common on Arch with `pacman`).**

**What this means:**

- **NVM installed:** NVM package installed via pacman
- **Location:** NVM script at `/usr/share/nvm/init-nvm.sh`
- **Arch standard:** Standard Arch NVM installation

**How to verify:**

```bash
ls /usr/share/nvm/init-nvm.sh
# Should show file exists ✅
```

**2. You have (or will set) a default Node alias in `nvm` (recommended).**

**What this means:**

- **Default alias:** NVM has default Node version set
- **Auto-load:** Default version loads automatically
- **Convenience:** Node ready without manual `nvm use`

**How to set default:**

```bash
nvm alias default 18
# Sets Node 18 as default
```

## Install NVM

### Option A (recommended on Arch): pacman

```bash
sudo pacman -S nvm
```

### Option B (manual install/update)

Follow the official guide:

- https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

Example (check latest version in the repo first):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

## What to install (files + paths)

Copy these repo files into your Fish config:

- `node_started/config.fish` → `~/.config/fish/config.fish`
- `node_started/nvm.fish` → `~/.config/fish/functions/nvm.fish`
- `node_started/nvm-load.fish` → `~/.config/fish/functions/nvm-load.fish`

Commands:

```bash
mkdir -p ~/.config/fish/functions
cp node_started/config.fish ~/.config/fish/config.fish
cp node_started/nvm.fish ~/.config/fish/functions/nvm.fish
cp node_started/nvm-load.fish ~/.config/fish/functions/nvm-load.fish
exec fish
```

## Notes About `config.fish`

**What to know:** This repo's `node_started/config.fish` currently sources CachyOS's shared Fish config.

**What this means:**

- **CachyOS config:** References CachyOS-specific Fish configuration
- **May not exist:** If you're not on CachyOS, this line will error
- **Solution:** Remove or comment out that line if you don't have it

**If you don't have it, **remove/comment** that line and keep the NVM bits.**

**How to fix:**

1. **Open config:** `~/.config/fish/config.fish`
2. **Find CachyOS line:** Look for CachyOS-specific source line
3. **Comment out:** Add `#` at start of line
4. **Keep NVM bits:** Keep NVM-related lines
5. **Save:** Save file

**Example:**

```fish
# Comment out if not on CachyOS:
# source /usr/share/fish/vendor_config.fish

# Keep NVM bits:
set -gx NVM_DIR /usr/share/nvm
# ... rest of NVM config
```

**Real-world example:**

**On CachyOS:**

- Keep CachyOS line (works fine) ✅

**Not on CachyOS:**

- Comment out CachyOS line (prevents error) ✅
- Keep NVM configuration (still works) ✅

## Set Default Node (Recommended, One-Time)

**What this does:** Installs latest LTS Node.js and sets it as default.

**Why set default:**

- **Auto-load:** Default version loads automatically
- **Convenience:** Node ready without manual `nvm use`
- **Consistency:** Same Node version every session
- **Ease of use:** No need to remember version

**Set default Node (recommended, one-time):**

```bash
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'
```

**What this command does:**

**Breaking down the command:**

**`bash -ic '...'`:**

- **`bash`:** Run bash shell
- **`-i`:** Interactive shell (loads profile)
- **`-c`:** Execute command
- **`'...'`:** Command to execute

**`source /usr/share/nvm/init-nvm.sh`:**

- **`source`:** Load script into current shell
- **`/usr/share/nvm/init-nvm.sh`:** NVM initialization script
- **Result:** NVM available in bash session ✅

**`nvm install --lts`:**

- **`nvm install`:** Install Node.js version
- **`--lts`:** Install latest LTS (Long Term Support) version
- **Result:** Latest LTS Node.js installed ✅

**`nvm alias default lts/*`:**

- **`nvm alias`:** Create version alias
- **`default`:** Alias name (used as default)
- **`lts/*`:** Points to latest LTS version
- **Result:** Default alias set to LTS ✅

**How it works:**

1. **Starts bash:** Opens bash shell
2. **Loads NVM:** Sources NVM initialization
3. **Installs LTS:** Downloads and installs latest LTS Node.js
4. **Sets default:** Creates default alias pointing to LTS
5. **Ready:** Default Node.js ready for use ✅

**Real-world example:**

**Before setting default:**

- No default Node version
- Must run `nvm use` manually
- Inconvenient ❌

**After setting default:**

- Default Node version set
- Auto-loads on Fish startup
- Convenient ✅

## How to Use

### Understanding Daily Usage

**What you need to know:** How to use NVM in Fish shell on a daily basis.

**Key concepts:**

- **Default loading:** Default Node loads automatically
- **Version switching:** How to change Node versions
- **PATH sync:** Why `nvm-load` is needed
- **Best practices:** Recommended workflow

### Start a Session (Load Default Node into Fish)

**What this does:** Loads default Node.js version into Fish shell.

**Why it's needed:**

- **PATH sync:** Makes Node available in Fish
- **Auto-load:** Happens automatically on startup
- **Manual option:** Can also run manually if needed

**`config.fish` calls `nvm-load` if it exists. You can also run it manually:**

**How it works:**

- **On startup:** `config.fish` runs `nvm-load` automatically
- **Loads default:** Default Node version becomes available
- **PATH updated:** Fish's PATH includes Node.js
- **Ready to use:** `node` command works immediately

```bash
nvm-load
node -v
```

**What these commands do:**

**`nvm-load`:**

- **Syncs environment:** Gets Node PATH from bash/NVM
- **Updates Fish:** Sets PATH in Fish shell
- **Makes Node available:** Puts `node` on Fish's PATH
- **Result:** Node.js available in Fish ✅

**`node -v`:**

- **Shows version:** Displays Node.js version
- **Verifies:** Confirms Node is available
- **Result:** Shows version (e.g., "v18.17.0") ✅

**Real-world example:**

**After Fish startup:**

```bash
$ node -v
v18.17.0
# Node available automatically ✅
```

**If Node not available:**

```bash
$ node -v
fish: Unknown command 'node'
# Need to run nvm-load ❌

$ nvm-load
$ node -v
v18.17.0
# Now works ✅
```

### Important Note About Fish: `nvm use` Behavior (The Limitation)

**What this limitation is:** `nvm use` doesn't automatically update Fish's PATH.

**Why it happens:** Because `nvm` is a bash script, this wrapper runs it in a bash subprocess.

**What this means:**

- **Bash subprocess:** NVM runs in separate bash process
- **PATH change isolated:** PATH change only affects bash subprocess
- **Fish unaffected:** Fish shell doesn't see PATH change
- **Need sync:** Must sync PATH manually

**So:**

**`nvm use <version>` **will not automatically change your current Fish session PATH**.**

**What happens:**

1. **Run `nvm use 18`:** NVM changes PATH in bash subprocess
2. **Bash PATH updated:** Bash subprocess has new PATH
3. **Fish PATH unchanged:** Fish shell still has old PATH
4. **Node not found:** `node` command doesn't work in Fish ❌

**After switching, run `nvm-load` (or open a new shell).**

**Solution:** Sync PATH after switching versions.

**Two options:**

**Option 1: Run `nvm-load`**

- **After `nvm use`:** Run `nvm-load` to sync PATH
- **Updates Fish:** Fish gets new PATH
- **Node available:** `node` command works ✅

**Option 2: Open new shell**

- **New Fish session:** Opens new Fish shell
- **Auto-loads default:** Default version loads automatically
- **Node available:** `node` command works ✅

**Example:**

```bash
nvm use 18
nvm-load
node -v
```

**What this does:**

1. **`nvm use 18`:** Switches to Node 18 in bash/NVM
2. **`nvm-load`:** Syncs PATH to Fish (makes Node 18 available)
3. **`node -v`:** Shows Node version (confirms it's 18) ✅

**Real-world example:**

**Switching versions:**

```bash
$ node -v
v16.20.0
# Currently using Node 16

$ nvm use 18
Now using node v18.17.0
# NVM says switched ✅

$ node -v
v16.20.0
# But Fish still shows Node 16 ❌

$ nvm-load
# Sync PATH

$ node -v
v18.17.0
# Now shows Node 18 ✅
```

**Best practice:** Always run `nvm-load` after `nvm use` in Fish.

## Troubleshooting

- **`node` not found**: run `nvm-load; which node; node -v`
- **VSCode terminal doesn’t see `node`**: ensure VSCode is launching Fish as a login shell, and that `~/.config/fish/config.fish` is being loaded.
- **Check loader exists**: `type -q nvm-load; and echo "ok"`

## Rollback

```bash
rm -f ~/.config/fish/functions/nvm.fish
rm -f ~/.config/fish/functions/nvm-load.fish
```
