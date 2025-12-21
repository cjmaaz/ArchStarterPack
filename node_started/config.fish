source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

set -gx NVM_DIR "$HOME/.nvm"

if type -q nvm-load
    nvm-load
end
