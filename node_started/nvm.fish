# functions/nvm.fish
function nvm --description "Run nvm via bash"
    bash -ic "source /usr/share/nvm/init-nvm.sh; nvm $argv"
end
