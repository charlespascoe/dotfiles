#!/bin/bash

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# JSON
alias formatjson='python -m json.tool'

# Docker
alias doc=docker

# Bash Aliases
alias ea='vim ~/.bash_aliases && . ~/.bash_aliases'

# Git
alias ga='git add -p'
alias repos='ssh git@vps "ls repos"'
alias ugr='git remote set-url origin'
alias gpat='git push --all && git push --tags'
alias ci='EDITOR="vim -c ShowDiff -c startinsert!" git ci'
function create-repo() { ssh git@vps "./create_repo.sh $1"; }
function fix() {
    vim "$1"
    git add "$1"
}

# Tmux
alias dev='start-agent && tm dev'
alias tmls='tmux ls'
function tm() { tmux -u attach -t $1 || tmux -u new -s $1; }
alias tsb='tmux show-buffer'

# Vim
source ~/.dotfiles/vim_aliases

alias draft='vim -c "cd ~/drafts/" -c "au BufUnload <buffer> ExportToClipboard" -c "startinsert" ~/drafts/`date +"%F_%H:%m:%S"`.bn'
alias draft-rtf='vim -c "cd ~/drafts/" -c "au BufUnload <buffer> ExportRTFToClipboard" -c "startinsert" ~/drafts/`date +"%F_%H:%m:%S"`.bn'

# Misc
alias c='clear'
alias hc='history -c'
alias ls='/bin/ls -lh --color=always --group-directories-first'
alias start-agent='eval `ssh-agent` && ssh-add'
alias stop-agent='killall ssh-agent'
function catt() { cat $1; echo; }
function nd() { mkdir -p $1; cd $1; }
function ireplace { ag -l "$1" | xargs sed -i -e "s/${1//\//\\\/}/${2//\//\\\/}/g"; }
function replace { ag -l "$1" | xargs sed -i.bak -e "s/${1//\//\\\/}/${2//\//\\\/}/g"; }
