. ~/.zsh_aliases

. ~/.dotfiles/bashmarks.sh

export EDITOR=vim

# PATH tweaks
export PATH="$PATH:$HOME/.dotfiles/bin"

# Prompt
PROMPT='%F{33}%~$vcs_info_msg_0_ %F{36}%#%f '

# Pass through Ctrl-S
stty -ixon

# History
HISTFILE=~/.zsh_hist
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
setopt hist_ignore_space
setopt histignoredups

bindkey -v
bindkey '^R' history-incremental-search-backward

# Git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{202}*'
zstyle ':vcs_info:git*' formats ' %F{220}%b%B%m%u%c%F{220}%%b%f'
zstyle ':vcs_info:*' enable git
