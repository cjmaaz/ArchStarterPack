README — Minimal setup: Bare minimal config.fish + nvm function for Fish (Arch pacman nvm)

Goal
----
Provide the **bare minimum** `~/.config/fish/config.fish` and `~/.config/fish/functions/nvm.fish` needed to:
- avoid startup errors in fish (including VSCode integrated terminal),
- make `nvm` and `node` available in interactive fish sessions,
- avoid requiring `fisher` or `bass`.

Assumptions
-----------
- You installed `nvm` via pacman (`sudo pacman -S nvm`) and `/usr/share/nvm/init-nvm.sh` exists.
- You have set a default node alias in nvm (see step 4).
- You prefer a simple, minimal config — no CachyOS extras.

What files to create (exact paths)
----------------------------------
1) ~/.config/fish/config.fish
2) ~/.config/fish/functions/nvm.fish

File contents — copy-paste these exact blocks into the files named above.

1) ~/.config/fish/config.fish  (minimal)
----------------------------------------
# Minimal fish config for NVM (bare minimum)
# Feel free to add your own customizations below.

# Ensure NVM_DIR is exported for compatibility
set -gx NVM_DIR "$HOME/.nvm"

# Load nvm into this fish session if the loader function exists
if type -q nvm
    # If a fish-friendly nvm wrapper exists, prefer it
    # (this is kept for backwards-compatibility)
    nvm --version > /dev/null 2>&1; or true
end

# If we have our custom nvm function (nvm.fish) that syncs environment, call it
if type -q nvm-load
    nvm-load
end

# You can add other fish configuration below
# e.g. set -gx EDITOR nvim

2) ~/.config/fish/functions/nvm.fish  (minimal wrapper + loader)
----------------------------------------------------------------
# Minimal nvm wrapper and loader for fish (no bass / no fisher)
# Place this file at: ~/.config/fish/functions/nvm.fish
# It does two things:
#  - Provides a convenience `nvm` wrapper that forwards to bash
#  - Provides `nvm-load` that syncs the PATH/NVM_* env into fish (so `node` works)

function nvm --description 'Run nvm via bash and sync environment into fish'
    # forward the command to bash, then sync environment afterwards
    set -l out (bash -ic "source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm $argv; echo __NVM_SYNC__ && env" 2>/dev/null)
    # If the marker exists, sync variables after marker
    set -l idx (contains -i "__NVM_SYNC__" $out)
    if test $idx -gt 0
        set -l env_after $out[(math $idx + 1)..-1]
        for line in $env_after
            if string match -rq '^PATH=' $line
                set -gx PATH (string split -r '=' -- $line)[2]
            else if string match -rq '^NVM_BIN=' $line
                set -gx NVM_BIN (string split -r '=' -- $line)[2]
            else if string match -rq '^NVM_DIR=' $line
                set -gx NVM_DIR (string split -r '=' -- $line)[2]
            end
        end
    end
end

function nvm-load --description 'Load NVM into fish by sourcing packaged init in bash and syncing env'
    if test ! -f /usr/share/nvm/init-nvm.sh
        return 0
    end
    set -l out (bash -lc 'source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm use default >/dev/null 2>&1; env' 2>/dev/null)
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

How to use
----------
1. Save the two files exactly at the paths above (create directories if needed):
   mkdir -p ~/.config/fish/functions

2. Reload your shell:
   exec fish

3. Test:
   node -v
   nvm --version
   nvm list

If node is not found, run:
   nvm-load; node -v; which node

Set default Node (one-time)
---------------------------
If you haven't set a default alias yet, run this once in bash:
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'

Why this minimal approach works
-------------------------------
- `nvm` is a bash script and requires bash to set PATH variables. The wrapper calls bash and then syncs PATH into fish.
- `nvm-load` runs at session start (if you call it) to ensure `node` and `npm` are available.
- No need for fisher/bass; this keeps your setup minimal and package-manager-friendly.

Troubleshooting
---------------
- If VSCode still shows `Unknown command: csource` or `bass`:
  - Check that you do not have any stray `csource` or `bass` lines in your config.fish.
  - Ensure VSCode uses the same $HOME and is not connected to a container/remote host.
  - As a fallback, you can create ~/.config/fish/conf.d/00-nvm-shim.fish with safe stubs for csource/bass.

- If `node -v` prints a version but a new integrated terminal in VSCode doesn't find node:
  - Try setting terminal to use login shell (add args ["-l"]) in VSCode terminal profile.

- To debug, run within fish:
  type -q nvm-load; and nvm-load; echo $PATH; which node

Rollback
--------
To undo, remove the two files (or restore backups):
rm -f ~/.config/fish/functions/nvm.fish
# optionally remove nvm-load if created as separate file
