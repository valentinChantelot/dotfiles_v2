export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

# Config OMZ
ZSH_THEME="gozilla"
plugins=(
    git 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)
HIST_STAMPS="dd.mm.yyyy"
source $ZSH/oh-my-zsh.sh

# Aliases
alias lt='eza --tree --level=2 --long --icons --git'
alias ls='eza -lh --group-directories-first --icons=auto'

alias pull="git pull"
alias push="git push"
alias all="git add ."
alias com="git commit -m"
alias ck="git checkout"
alias stash="git stash"
alias pop="git stash pop"

# Loading nvm - https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Loading modules from ~/.config/zsh/modules/
if [[ -d "$HOME/.config/zsh/modules" ]]; then
    for module in "$HOME/.config/zsh/modules"/*.zsh; do
        [[ -r "$module" ]] && source "$module"
    done
    unset module
fi