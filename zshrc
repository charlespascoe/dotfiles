export LANG=en_GB.UTF-8

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    SESSION_TYPE=remote/ssh
else
    case $(ps -o comm= -p "$PPID") in
        sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    esac
fi

export EDITOR=vim

export MANPAGER="MAN=1 vim +MANPAGER --not-a-term -"
export MANWIDTH=80
export REAL_MAN=/usr/bin/man

# Disable Brew auto-update when installing packages
export HOMEBREW_NO_AUTO_UPDATE=1

# Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Utilities

autoload -U zmv
autoload -Uz compinit && compinit # NOTE: compinit is also run again after loading aliases

# PATH tweaks
export PATH="$HOME/.dotfiles/bin:$PATH"

PROMPT_PREFIX=''

if [[ $SESSION_TYPE == remote/* ]]; then
    function precmd() {
        # Set the title to the current working directory, shortened Vim-style
        printf "\e]0; $HOST:`print -rD "$PWD" | sed -E 's:(\.?[^/])[^/]*/:\1/:g'`\a"
    }

    # To set the title in a similar way in bash when SSHing into a server:
    # export PROMPT_COMMAND='echo -en "\033]0;$USER@`hostname | egrep -o "^[^.]+"`:`dirs +0`\a"'

    # Prompt
    # PROMPT='%F{6}%n@%m %F{5}%~$vcs_info_msg_0_ %F{#8BE9FD}%#%f '
    # PROMPT_PREFIX='%F{6}%n@%m '
    PROMPT_PREFIX='%F{6}%m '
else
    function precmd() {
    # Set the title to the current working directory, shortened Vim-style
        printf "\e]0;`print -rD "$PWD" | sed -E 's:(\.?[^/])[^/]*/:\1/:g'`\a"
    }

    # To set the title in a similar way in bash when SSHing into a server:
    # export PROMPT_COMMAND='echo -en "\033]0;$USER@`hostname | egrep -o "^[^.]+"`:`dirs +0`\a"'
fi

# Prompt
PROMPT="$PROMPT_PREFIX"'%F{5}%~$vcs_info_msg_0_ %F{#8BE9FD}%#%f '

# Pass through Ctrl-S
stty -ixon

# Key mappings
bindkey "^[[4~" end-of-line
bindkey -v "^[[4~" end-of-line

# History
HISTFILE=~/.zsh_hist
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS

# Git
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
  ZVM_CURSOR_STYLE_ENABLED=true
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

  PROMPT="$PROMPT_PREFIX"'%F{5}%~$vcs_info_msg_0_ %F{'"$color"'}%B%#%b%f '
}

zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

[ -f $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh ] && source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf config

# export FZF_DEFAULT_COMMAND="fd --type f --ignore-file $HOME/.gitignore_global --strip-cwd-prefix"
# NOTE the tab between %a and %N (needed for 'cut')
# export FZF_DEFAULT_COMMAND="fd --type f -0 --ignore-file $HOME/.gitignore_global --strip-cwd-prefix | xargs -0 stat -f '%a	%N' | sort -nr | cut -f 2"
export FZF_DEFAULT_COMMAND="fzf_compgen f"
export FZF_CTRL_T_COMMAND="fzf_compgen f"
# Prevent sorting so that more recently accessed items appear first when
# filtering
export FZF_DEFAULT_OPTS='--no-sort'

_fzf_compgen_path() {
  fzf_compgen "f" "$1"
}

_fzf_compgen_dir() {
  fzf_compgen "d" "$1"
}

autoload -U add-zsh-hook

touch_dir() {
  if [ -d .git ]; then
    touch .
  fi
}

add-zsh-hook chpwd touch_dir

# Aliases and Utilities

. ~/.zsh_aliases

. ~/.dotfiles/bashmarks.sh

export PTPYTHON_CONFIG_HOME=~/.config/ptpython/

export BLOOP_DIR=~/.bloop

# Dynamic Bashmarks

# The patch version of Vim changes in the path, so this ensures 'n vim' goes to
# the right place (at least for vim 9.0)
export DIR_vim="$(dirname $(dirname $(readlink -f `which vim`)))/share/vim/vim90"

# Only load compinit after aliases etc.
compinit
