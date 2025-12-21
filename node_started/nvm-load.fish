function nvm-load --description 'Load default nvm node environment into Fish'
    set -l cmd 'source /usr/share/nvm/init-nvm.sh >/dev/null 2>&1; nvm use default >/dev/null 2>&1; env'

    set -l bash_env (bash -c $cmd)

    for line in $bash_env
        if string match -qr '^PATH=' $line
            set -gx PATH (string split '=' $line)[2]
        end
        if string match -qr '^NVM_BIN=' $line
            set -gx NVM_BIN (string split '=' $line)[2]
        end
        if string match -qr '^NVM_DIR=' $line
            set -gx NVM_DIR (string split '=' $line)[2]
        end
    end
end
