NOTES=$HOME/Documents/notes

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

#rvm
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="lol"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/git/bin:/opt/local/bin
# export PS1='%{$fg[yellow]%}%n@bean:%~%{$reset_color%}$(git_prompt_info)%{$fg[yellow]%} %# %{$reset_color%}'

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
sha1pass() { 
    echo "{sha1}$(echo -n ${$1\:?"need a password please"} | openssl dgst -binary -sha1 | openssl enc -base64)"
}
#$1 would be a username.
#$2 num characters (defaults 12) $3 if 1 (default) uses special chars, 0 use alpha
#sha1rand 8 0 -- would return 8 char password of only A-Za-z0-9
function sha1rand() {
  [ "$3" == "0" ] && CHAR="[:alnum:]" || CHAR="[:alnum:][:punct:]"
    sha1random_var=$(cat /dev/urandom | base64 | tr -cd "$CHAR" | head -c ${2:-12})
    if [ -n "$1" ] 
       then
         echo $1-test;
         echo "Password: $sha1random_var";
   else
         echo "TEST Password: $sha1random_var";
   fi
    echo $(sha1pass $sha1random_var)
    echo
    sha1random_var=$(cat /dev/urandom | base64 | tr -cd "$CHAR" | head -c ${2:-12})
    if [ -n "$1" ] 
       then
         echo $1-prod;
         echo "Password: $sha1random_var";
   else
         echo "PROD Password: $sha1random_var";
   fi
    echo $(sha1pass $sha1random_var)
}
