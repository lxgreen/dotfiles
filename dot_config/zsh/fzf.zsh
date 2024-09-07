# fzf configuration

# this replaces the vendor `source <(fzf --zsh)` for dynamic theme 
source $ZDOTDIR/plugins/fzf.zsh

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

if _has fzf + _has fd; then
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers,changes --color=always --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Catppuccin-mocha || echo Catppuccin-latte) {} | head -100'"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export _ZO_FZF_OPTS="--height 40% --layout=reverse --border"
