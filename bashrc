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
        if [[ -n $(git status -s 2>/dev/null) ]]; then
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


function viw() {
    vim `which $1`
}

function vd() {
    [ "$1" ] && cd *$1*
}

function repeat() {
    if [ "$1" -eq "$1" ]; then
        while [ -n "$2" ]; do
            eval "$2"
            sleep $1
        done
    fi
}

pssh() {
    # Only supports -l and -A ssh options!
    TEMP=`getopt -o ":l:A" -- "$@"`

    local OPTIND o ssh_cmd ssh_count P_PATH

    ssh_cmd="ssh"

    eval set -- "$TEMP"
    while true; do
        case "$1" in
            -- ) shift; break ;;
            * )
                ssh_cmd="${ssh_cmd} $1"
                shift
                ;;
        esac
    done

    ssh_count=$(wc -w <<< "$@")

    tmux new-window "${ssh_cmd} $1"
    tmux rename-window "pssh (${ssh_count})"
    shift
    while [ $# -gt 0 ]; do
        tmux split-window "${ssh_cmd} $1"
        tmux select-layout tiled > /dev/null
        shift
    done
    tmux select-layout tiled > /dev/null
    tmux set-window-option synchronize-panes on > /dev/null
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

function venv() {
    [ -d ./venv ] || virtualenv venv
    . ./venv/bin/activate
    if [[ -n "$1" ]]; then
       pip install -r $1
    fi
}

# sudo aliases
alias please=sudo
alias fucking=sudo

alias tf=terraform

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


function append_paths() {
    local i
    for i in "$@"; do
        [[ -d "$i" ]] && export PATH="$PATH:$i" || true
    done
}

CODEPATH="$HOME/code"
alias qcd="cd $CODEPATH"
export RBENV_ROOT="$HOME/.rbenv"
export PYENV_ROOT="$HOME/.pyenv"

if [ -z "$PATH_EXPANDED" ]; then
    append_paths $CODEPATH/puppet-tools $HOME/go
    append_paths $PYENV_ROOT/bin $RBENV_ROOT/bin $HOME/bin
    export PATH_EXPANDED=1
fi

eval "$(which pyenv > /dev/null 2>&1 && pyenv init -)"
eval "$(which rbenv > /dev/null 2>&1 && rbenv init -)"

function ssh-ec2() {
    aws ec2 describe-instances --instance-id $1 --query Reservations[].Instances[].PrivateIpAddress --output=text
}

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

function note {
    local notepath
    notepath=$HOME/files/notes/scratch
    if [ "${#}" == 0 ]; then
        [ -f $notepath ] && cat $notepath
    elif [ "${*}" == "-a" ]; then
        cat $notepath.* $notepath
    elif [ "${*}" == "-e" ]; then
        vim $notepath
    elif [ "${*}" == "-1" ]; then
        tail -r $notepath | sed -n -e '1,/^--- /p' | tail -r
    elif [ "${*}" == "-r" ]; then
        mv $notepath $notepath.$(date +'%Y-%m-%d-%H%M%S')
        touch $notepath
    elif [ "${*}" == "-l" ]; then
        basename -a $notepath*
    elif [ "${*}" == "-" ]; then
        echo "--- $(date) ---" >> $notepath
        cat >> $notepath
        echo >> $notepath
    else
        echo "--- $(date) ---" >> $notepath
        echo "${*}" >> $notepath
        echo >> $notepath
    fi
}

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home
append_paths $JAVA_HOME/bin

if uname -a | grep -q Microsoft; then
    export LS_COLORS='ow=01;36;40'
    export DOCKER_HOST=tcp://0.0.0.0:2375
fi
