# Minimal fish config for NVM (bare minimum)
# Last Updated: November 2025
# Purpose: Minimal NVM setup for Fish shell without fisher/bass dependencies
# See: nvm-fish-readme.md for full documentation

# Existing Logic (to load cachyos details in terminal)
source /usr/share/cachyos-fish-config/cachyos-config.fish

# Set NVM directory for compatibility with bash-based NVM
set -gx NVM_DIR "$HOME/.nvm"

# Load NVM into this Fish session using our custom loader
# This syncs the Node.js environment from bash NVM into Fish
if type -q nvm-load
    nvm-load
end

# === Custom Configuration Below ===
# Add your own Fish shell customizations here
# Examples:
# set -gx EDITOR nvim
# set -gx PATH $HOME/.local/bin $PATH
# alias ll='ls -lah'
