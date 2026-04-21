function __color() {
    case $1 in
    red)
        echo "\[\033[31m\]" ;;
    green)
        echo "\[\033[32m\]" ;;
    yellow)
        echo "\[\033[33m\]" ;;
    blue)
        echo "\[\033[34m\]" ;;
    *)
        echo "\[\033[0m\]" ;;
    esac
}

function __remote_ps1() {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "$(__color yellow)\h"
    else
        echo "$(__color blue)\h"
    fi
}

function __git_ps1() {
    local PS1_OUTPUT=""
    if [[ -d $(git rev-parse --git-dir 2>/dev/null) ]]; then
        __PS1_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n ${__PS1_GIT_BRANCH/HEAD} ]]; then
            PS1_OUTPUT="${PS1_OUTPUT}$(__color green)${__PS1_GIT_BRANCH}$(__color) "
        fi
        PS1_OUTPUT="${PS1_OUTPUT}$(git rev-parse --short HEAD 2>/dev/null) "
        # if [[ -n $(git status -s 2>/dev/null) ]]; then
        if ! git diff --quiet || ! git diff --cached --quiet; then
            PS1_OUTPUT="${PS1_OUTPUT}$(__color yellow)✗ $(__color)"
        fi
    fi
    echo "$PS1_OUTPUT"

}

function __user_ps1() {
    if [ $EUID = 0 ]; then
        echo "$(__color red)\u$(__color blue)"
    else
        echo "$(__color blue)\u"
    fi
}

function __venv_ps1() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "(venv)"
    fi
}

function __set_prompt_mac() {
    local exit_codes="${PIPESTATUS[@]}"
    local emit_exit_codes=0
    local i
    for i in ${exit_codes}; do
        if [ $i -ne 0 ]; then
            emit_exit_codes=1
            break
        fi
    done
    EXIT_INFO=$([ "$emit_exit_codes" != 0 ] && printf "$(__color red)$exit_codes ")
    PS1="$(__venv_ps1)$(__user_ps1)@$(__remote_ps1)$(__color blue): \w$(__color) $(__git_ps1)${EXIT_INFO}$(__color blue)\$ $(__color)"
}

function __set_prompt_ubuntu() {
    # Default ubuntu prompt
    PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
}

# ls aliases
ls --color=auto >/dev/null 2>&1
if [[ $? != 0 ]]; then
    alias ls="ls -GF"
else
    alias ls="ls --color=auto"
fi
alias ll='ls -l'


case $(uname -s) in
'Darwin')
    PROMPT_COMMAND='__set_prompt_mac'
    PS1="${error} ${PS1}"
    ;;
'Linux')
    __set_prompt_ubuntu
    ;;
esac

HISTSIZE=10000
SAVEHIST=10000

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
alias rtfm=man

# sudo aliases
alias please=sudo
alias fucking=sudo

if which tofu >/dev/null; then
	alias tf=tofu
elif which terraform >/dev/null; then
	alias tf=terraform
fi

export EDITOR=vim
export PAGER=less

SOCK=~/.ssh/ssh_auth_sock
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f $SOCK
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi


# turn off XON/XOFF for C-s forward history search
stty -ixon

if [[ -n "$NVIM" ]]; then
  function nvo() {
    f="$(realpath "$1")"
    if [[ -f "$f" || -d "$f" ]]; then
      echo -e "\033]51;${f}\007"
    fi
  }
fi

function nvr() {
    while true; do
        nvim "$@"
        if [ $? -ne 1 ]; then
            break
        fi
    done
}

function append_paths() {
    local i
    for i in "$@"; do
        [[ -d "$i" ]] && export PATH="$PATH:$i" || true
    done
}

eval "$(/opt/homebrew/bin/brew shellenv)"
export BASH_SILENCE_DEPRECATION_WARNING=1

append_paths "$HOME/bin"

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
append_paths "$PATH:$GOBIN"

for envfile in ~/.cargo/env ~/.orbstack/shell/init.bash; do
	[[ -r "$envfile" ]] && . "$envfile"
done

CODEPATH="$HOME/code"
QCODE="$CODEPATH"

# local file not committed. Can override QCODE
[[ -r ~/.bash/local.sh ]] && . ~/.bash/local.sh

alias qcd="cd $QCODE"
alias dcd="cd $CODEPATH/dotfiles"
alias scd="cd $CODEPATH/scratch"
alias gcd="cd $CODEPATH/github"

# Commented out because it kills the shell with ctrl-c...
# eval "$(direnv hook bash)"
