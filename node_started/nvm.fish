# NVM wrapper and loader functions for Fish shell
# Last Updated: November 2025
# Purpose: Minimal NVM integration without fisher/bass
# See: nvm-fish-readme.md for documentation

# Function: nvm
# Description: Wrapper that runs nvm commands in bash and syncs environment back to Fish
# Usage: nvm install 18, nvm use 16, nvm list, etc.
function nvm --description 'Run nvm via bash and sync environment into fish'
    # Run the nvm command in bash, then output environment variables
    set -l out (bash -ic "source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm $argv; echo __NVM_SYNC__ && env" 2>/dev/null)
    
    # Find the marker that separates command output from environment variables
    set -l idx (contains -i "__NVM_SYNC__" $out)
    
    # If marker found, sync relevant environment variables into Fish
    if test $idx -gt 0
        set -l env_after $out[(math $idx + 1)..-1]
        for line in $env_after
            # Sync PATH (most important for node/npm availability)
            if string match -rq '^PATH=' $line
                set -gx PATH (string split -r '=' -- $line)[2]
            # Sync NVM_BIN (directory containing node binaries)
            else if string match -rq '^NVM_BIN=' $line
                set -gx NVM_BIN (string split -r '=' -- $line)[2]
            # Sync NVM_DIR (NVM installation directory)
            else if string match -rq '^NVM_DIR=' $line
                set -gx NVM_DIR (string split -r '=' -- $line)[2]
            end
        end
    end
end

# Function: nvm-load
# Description: Load default Node.js version into Fish session at startup
# Usage: Called automatically from config.fish, or manually: nvm-load
function nvm-load --description 'Load NVM into fish by sourcing packaged init in bash and syncing env'
    # Check if NVM is installed via pacman
    if test ! -f /usr/share/nvm/init-nvm.sh
        return 0
    end
    
    # Source NVM in bash, activate default Node version, and capture environment
    set -l out (bash -lc 'source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm use default >/dev/null 2>&1; env' 2>/dev/null)
    
    # Sync environment variables into Fish
    for line in $out
        # Sync PATH
        if string match -rq '^PATH=' $line
            set -gx PATH (string split -r '=' -- $line)[2]
        # Sync NVM_BIN
        else if string match -rq '^NVM_BIN=' $line
            set -gx NVM_BIN (string split -r '=' -- $line)[2]
        # Sync NVM_DIR
        else if string match -rq '^NVM_DIR=' $line
            set -gx NVM_DIR (string split -r '=' -- $line)[2]
        end
    end
end
