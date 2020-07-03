# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1024
HISTFILESIZE=2048

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set prompt
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    SESSION_TYPE=remote/ssh
else
    case $(ps -o comm= -p $PPID) in
        sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    esac
fi

PS1=''

if [[ "$SESSION_TYPE" == remote/* ]]; then
    # Only include user and host information if this session is connected remotely (e.g. over SSH)
    PS1='\[\033[01;38;5;34m\]\u\[\033[01;38;5;220m\]@\[\033[01;38;5;34m\]\h '
fi

PS1="$PS1"'\[\033[01;38;5;33m\]\w\[\033[01;38;5;220m\]$(__git_ps1) \[\033[01;38;5;36m\]\$\[\033[00m\] '

# enable color support of ls
if [ -n "$(which dircolors)" ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export EDITOR=vim

# Pass through Ctrl-S
bind -r '\C-s'
stty -ixon

# Shared utility scripts
export COMMON_SCRIPTS_DIR="${COMMON_SCRIPTS_DIR:-$HOME/scripts}"

if [ -d "$COMMON_SCRIPTS_DIR" ]; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWSTASHSTATE=true
    . "$COMMON_SCRIPTS_DIR/git-completion.bash"
    . "$COMMON_SCRIPTS_DIR/git-sh-prompt"
    . "$COMMON_SCRIPTS_DIR/bashmarks.sh"
    export PATH="$PATH:$COMMON_SCRIPTS_DIR/bin"
else
    function __git_ps1() { echo; }
fi

