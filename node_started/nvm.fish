function nvm --description 'Run nvm via bash and sync environment into fish'
    set -l out (bash -ic "source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm $argv; echo __NVM_SYNC__ && env" 2>/dev/null)
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
