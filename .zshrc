# P10K Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-My-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_COMPDUMP="$HOME/.zcompdump-$ZSH_VERSION"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(copydir git)
source $ZSH/oh-my-zsh.sh

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Aliases
alias pls="sudo !!"
alias emacs="emacs -nw"

alias python="python3"
alias pip="pip3"
alias venv="python -m venv venv"
alias activate="ls venv > /dev/null 2>&1 && source venv/bin/activate"

# Functions
function lowercase() {
    echo $1 | tr "[:upper:]" "[:lower:]"
}

function uppercase() {
    echo $1 | tr "[:lower:]" "[:upper:]"
}

function trim() {
    if [ $# -lt 2 ] || [ $2 -eq 0 ]
    then
        echo $1
    else
        echo "${1:0:-$2}"
    fi
}

# P10K Enable
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
