export EDITOR=vim

# PATH tweaks
export PATH="$PATH:$HOME/.dotfiles/bin"

# Prompt
# PROMPT='%F{33}%~$vcs_info_msg_0_ %F{36}%#%f '
PROMPT='%F{#00B6DD}%~$vcs_info_msg_0_ %F{#00af87}%#%f '
# PROMPT='%F{#00B6DD}%~$vcs_info_msg_0_ %F{35}%B%#%b%f '

# Pass through Ctrl-S
stty -ixon

# Key mappings
bindkey "^[[4~" end-of-line
bindkey -v "^[[4~" end-of-line

# History
HISTFILE=~/.zsh_hist
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_space
setopt histignoredups

bindkey -v
bindkey '^R' history-incremental-search-backward

# Git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() {
  vcs_info

  if [ -n "$vcs_info_msg_0_" ] && [[ ! "$vcs_info_msg_0_" =~ '[+*$]' ]]; then
    vcs_info_msg_0_=" ${vcs_info_msg_0_:gs/ /}"
  fi
}
precmd_functions+=( precmd_vcs_info )

# Show count of stashed changes
function +vi-git-stash() {
  if [[ -s ${hook_com[base]}/.git/refs/stash ]]; then
    hook_com[misc]+="%F{242}$"
  fi
}

# setopt prompt_subst
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' stagedstr '%F{green}+'
# zstyle ':vcs_info:*' unstagedstr '%F{202}*'
# zstyle ':vcs_info:git*' formats ' %F{220}%b%B %u%c%m%F{220}%%b%f'
# zstyle ':vcs_info:git*' actionformats ' %F{220}%a|%b%B %u%c%m%F{220}%%b%f'
# zstyle ':vcs_info:git*+set-message:*' hooks git-stash
# zstyle ':vcs_info:*' enable git

setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{#6FFF88}+'
zstyle ':vcs_info:*' unstagedstr '%F{#FFAF6F}*'
zstyle ':vcs_info:git*' formats ' %F{#FFF180}%b%B %u%c%m%F{#FFF180}%%b%f'
zstyle ':vcs_info:git*' actionformats ' %F{#FFF180}%a|%b%B %u%c%m%F{#FFF180}%%b%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-stash
zstyle ':vcs_info:*' enable git

# Vi mode - clone https://github.com/jeffreytse/zsh-vi-mode into ~/.zsh-vi-mode

function zvm_config() {
  ZVM_CURSOR_STYLE_ENABLED=false
}

function zvm_after_select_vi_mode() {
  # color=36
  color='#00af87'

  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      # color=245
      color='#8a8a8a'
    ;;
    $ZVM_MODE_INSERT)
      # color=42
      color='#00d787'
    ;;
    $ZVM_MODE_VISUAL)
      # color=201
      color='#ff00ff'
    ;;
    $ZVM_MODE_VISUAL_LINE)
      # color=201
      color='#ff00ff'
    ;;
    $ZVM_MODE_REPLACE)
      # color=196
      color='#ff0000'
    ;;
  esac

  # color='#00af87'

  # PROMPT='%F{33}%~$vcs_info_msg_0_ %F{'"$color"'}%B%#%b%f '
  PROMPT='%F{#00B6DD}%~$vcs_info_msg_0_ %F{'"$color"'}%B%#%b%f '
}

source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Aliases and Utilities

. ~/.zsh_aliases

. ~/.dotfiles/bashmarks.sh

export PTPYTHON_CONFIG_HOME=~/.config/ptpython/
