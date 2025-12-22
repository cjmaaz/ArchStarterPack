README — Minimal setup: Fish + NVM (Arch `pacman` NVM) using `nvm.fish` + `nvm-load.fish`

## Goal

Provide the **bare minimum** Fish setup to:

- make `nvm` available in Fish (by running it via bash),
- ensure `node` is on `PATH` in Fish (by syncing env via `nvm-load`),
- avoid requiring `fisher` or `bass`,
- avoid startup errors (including VSCode integrated terminal).

## Assumptions

- You installed `nvm` so `/usr/share/nvm/init-nvm.sh` exists (common on Arch with `pacman`).
- You have (or will set) a default Node alias in `nvm` (recommended).

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

## Notes about `config.fish`

- This repo’s `node_started/config.fish` currently sources CachyOS’s shared Fish config. If you don’t have it, **remove/comment** that line and keep the NVM bits.

## Set default Node (recommended, one-time)

```bash
bash -ic 'source /usr/share/nvm/init-nvm.sh && nvm install --lts && nvm alias default lts/*'
```

## How to use

### Start a session (load default Node into Fish)

`config.fish` calls `nvm-load` if it exists. You can also run it manually:

```bash
nvm-load
node -v
```

### Important note about Fish: `nvm use` behavior (the limitation)

Because `nvm` is a bash script, this wrapper runs it in a bash subprocess. So:

- `nvm use <version>` **will not automatically change your current Fish session PATH**.
- After switching, run `nvm-load` (or open a new shell).

Example:

```bash
nvm use 18
nvm-load
node -v
```

## Troubleshooting

- **`node` not found**: run `nvm-load; which node; node -v`
- **VSCode terminal doesn’t see `node`**: ensure VSCode is launching Fish as a login shell, and that `~/.config/fish/config.fish` is being loaded.
- **Check loader exists**: `type -q nvm-load; and echo "ok"`

## Rollback

```bash
rm -f ~/.config/fish/functions/nvm.fish
rm -f ~/.config/fish/functions/nvm-load.fish
```
