# Minimal fish config for NVM (bare minimum)
set -gx NVM_DIR "$HOME/.nvm"
if type -q nvm-load
    nvm-load
end
