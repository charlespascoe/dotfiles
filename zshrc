export EDITOR=vim

# PATH tweaks
export PATH="$PATH:$HOME/.dotfiles/bin"

# Prompt
PROMPT='%F{5}%~$vcs_info_msg_0_ %F{#8BE9FD}%#%f '

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
    hook_com[misc]+="%F{246}$"
  fi
}

setopt prompt_subst
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{214}*'
zstyle ':vcs_info:git*' formats ' %F{yellow}%b%B %u%c%m%F{yellow}%%b%f'
zstyle ':vcs_info:git*' actionformats ' %F{yellow}%a|%b%B %u%c%m%F{yellow}%%b%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-stash
zstyle ':vcs_info:*' enable git

# Vi mode - clone https://github.com/jeffreytse/zsh-vi-mode into ~/.zsh-vi-mode

function zvm_config() {
  ZVM_CURSOR_STYLE_ENABLED=false
  ZVM_VI_HIGHLIGHT_BACKGROUND='#44475A'
}

function zvm_after_select_vi_mode() {
  color='#8BE9FD'

  case $ZVM_MODE in

    $ZVM_MODE_NORMAL)
      color=245
    ;;

    $ZVM_MODE_INSERT)
      color='#8BE9FD'
    ;;

    $ZVM_MODE_VISUAL)
      color=214
    ;;

    $ZVM_MODE_VISUAL_LINE)
      color=214
    ;;

    $ZVM_MODE_REPLACE)
      color='red'
    ;;

  esac

  PROMPT='%F{5}%~$vcs_info_msg_0_ %F{'"$color"'}%B%#%b%f '
}

source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Aliases and Utilities

. ~/.zsh_aliases

. ~/.dotfiles/bashmarks.sh

export PTPYTHON_CONFIG_HOME=~/.config/ptpython/

# Dynamic Bashmarks

# The patch version of Vim changes in the path, so this ensures 'n vim' goes to
# the right place (at least for vim 9.0)
export DIR_vim="$(dirname $(dirname $(readlink -f `which vim`)))/share/vim/vim90"
