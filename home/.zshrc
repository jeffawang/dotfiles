function note() {
    vim $NOTES/$1
}
function __remote_ps1() {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "%{$fg[yellow]%}"
    else
        echo "%{$fg[blue]%}"
    fi
}

function __git_ps1() {
     local PS1_OUTPUT=""
     if [[ -d $(git rev-parse --git-dir 2>/dev/null) ]]; then
        #printf "[ "
        __PS1_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n ${__PS1_GIT_BRANCH/HEAD} ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}%{$fg[green]%}${__PS1_GIT_BRANCH} %{$reset_color%}"
        fi
        PS1_OUTPUT="${PS1_OUTPUT}$(git rev-parse --short HEAD 2>/dev/null) "
        if [[ -n $(git status -s) ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}%{$fg[yellow]%}✗ %{$reset_color%}"
        fi
    fi

    __PS1_SVN_REV=$(svn info 2>/dev/null | awk '/Revision/ {print $NF}')
    if [[ ! -z ${__PS1_SVN_REV} ]]; then
        PS1_OUTPUT="${PS1_OUTPUT}%{$fg[magenta]%}r${__PS1_SVN_REV} %{$reset_color%}"
        if [[ -n $(svn status) ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}%{$fg[yellow]%}✗ %{$reset_color%}"
        fi
    fi
    echo "$PS1_OUTPUT"
}

#export PATH="$HOME/.rbenv/shims:$PATH"
#eval "$(rbenv init -)"

#source ~/.bashrc

# ls aliases
ls --color=auto 2>/dev/null >/dev/null
if [[ $? != 0 ]]; then 
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -Fl'


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

autoload -U select-word-style
select-word-style bash

autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%{$fg[blue]%}%n@$(__remote_ps1)%m%{$fg[blue]%}: %~%{$reset_color%} $(__git_ps1)%{$fg[blue]%}%# %{$reset_color%}'

export EDITOR=vim

export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history

export TERM=xterm-256color
export NOTES=~/Documents/notes
export WORKING=$NOTES/working

