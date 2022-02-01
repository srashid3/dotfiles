# PATH
export PATH="$PATH:~/.local/bin"

# Display
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

# Audio
export SDL_AUDIODRIVER=dsp
export LIBGL_ALWAYS_INDIRECT=1

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

alias pip="pip3"
alias venv="python3 -m venv venv"
alias activate="ls venv > /dev/null 2>&1 && source venv/bin/activate"

alias mongo="docker exec -it mongod mongo"
alias mongod="docker run -it -v mongodata:/data/db -p 27017:27017 --name mongod --restart unless-stopped -d mongo:3"

# Functions
function lowercase() {
    echo $1 | tr "[:upper:]" "[:lower:]"
}

function uppercase() {
    echo $1 | tr "[:lower:]" "[:upper:]"
}

function zombies() {
    ps axo stat,ppid,pid,comm | grep -w defunct
}
