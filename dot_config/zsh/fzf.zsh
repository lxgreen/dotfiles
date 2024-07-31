# fzf configuration

source <(fzf --zsh)

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

# Catppuccin theme colors
export FZF_LATTE_COLORS="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
export FZF_MOCHA_COLORS="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

if _has fzf + _has fd; then
    export FZF_DEFAULT_OPTS="--extended --color=$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo $FZF_MOCHA_COLORS || echo $FZF_LATTE_COLORS)"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers,changes --color=always --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Catppuccin-mocha || echo Catppuccin-latte) {} | head -100'"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi
