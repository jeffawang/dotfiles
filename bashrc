function __remote_ps1() {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "\[\033[33m\]\h"
    else
        echo "\[\033[34m\]\h"
    fi
}
function __git_ps1() {
    local PS1_OUTPUT=""
    if [[ -d $(git rev-parse --git-dir 2>/dev/null) ]]; then
        __PS1_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n ${__PS1_GIT_BRANCH/HEAD} ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}\[\033[32m\]${__PS1_GIT_BRANCH}\[\033[0m\] "
        fi
        PS1_OUTPUT="${PS1_OUTPUT}$(git rev-parse --short HEAD 2>/dev/null) "
        if [[ -n $(git status -s 2>/dev/null) ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}\[\033[33m\]✗ \[\033[0m\]"
        fi
    fi
    echo "$PS1_OUTPUT"

}
function __venv_ps1() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "(venv)"
    fi
}
function __set_prompt() {
    EXIT_INFO=$(test $? == 0 && printf "\[\033[34m\]" || printf "\[\033[31m\]$? ")
    PS1="$(__venv_ps1)\[\033[34m\]\u@$(__remote_ps1)\[\033[34m\]: \w\[\033[0m\] $(__git_ps1)${EXIT_INFO}\[\033[34m\]\$ \[\033[0m\]"
}

ls --color=auto >/dev/null 2>&1
if [[ $? != 0 ]]; then
    alias ls="ls -GF"
else
    alias ls="ls --color=auto"
fi


PROMPT_COMMAND='__set_prompt'
PS1="${error} ${PS1}"

# misc aliases
alias ll='ls -l'

# git aliases
alias gco='git checkout'
alias gst='git status'
alias grhh='git reset --hard HEAD'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gl='git log'

# sudo aliases
alias please=sudo
alias fucking=sudo

HISTSIZE=10000
SAVEHIST=10000

export EDITOR=vim
export PAGER=less

SOCK=~/.ssh/ssh_auth_sock
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f $SOCK
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

