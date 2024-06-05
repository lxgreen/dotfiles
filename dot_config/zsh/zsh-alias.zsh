# zsh
alias zr="exec zsh"
alias zshrc="nvim $ZDOTDIR"

#files
alias rmf="rm -rf"
alias dd='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias take='function _take() { mkdir -p $1 && cd $1 }; _take $1'
alias md='mkdir -p'
-(){
  cd -
}


# npm
alias regpub="npm config set registry https://registry.npmjs.org"
alias regwix="npm config set registry http://npm.dev.wixpress.com"

#yarn
alias yys="yarn && yarn start"
alias ys="yarn start"
alias yl="yarn link"
alias yld="rm -rf ~/.config/yarn/link/"
alias ya="yarn add"
alias ye="yarn e2e"
alias yb="yarn build"
alias yyb="yarn && yarn build"
alias yaw="yarn add -W"
alias yt="yarn test"
alias yyt="yarn && yarn test"

#CLIs
alias firefox='function _fox(){ (cd /Applications/Firefox\ Developer\ Edition.app/Contents/MacOS && ./firefox $1) }; _fox $1' # TODO: machine specific
alias ff='firefox NUL &'
alias man='batman'
alias cat="bat"
alias lg='lazygit'

# Catppuccin theme colors
export FZF_LATTE_COLORS="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
export FZF_MOCHA_COLORS="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# TODO: fix dynamic theme
alias fzf="fzf --color=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo $FZF_MOCHA_COLORS || echo $FZF_LATTE_COLORS)"

alias nsc='rm -rf ~/.local/state/nvim/swap'

alias bi="brew install"
alias bu="brew uninstall"
alias bl="brew list"

alias ww='w3m -no-mouse'
alias -g CL="| xargs wc -l"
alias -g G="| grep"
alias ll='exa -lah --git'
if [ -n "$(alias fd)" ]; then
  unalias fd
fi

#tmux
alias zz='tmuxp load -y zettel'
alias olo='tmuxp load -y rewrite-olo'
alias tls='tmux list-sessions'

#git
alias gmm='gcm && gup && gco - && gm master'
alias gcmrg='function _merge(){ git commit -m "Merge branch master into $1" };_merge `git branch --show-current`'

# fuzzy
alias gde='$XDG_CONFIG_HOME/zsh/gde'
alias cde='$XDG_CONFIG_HOME/zsh/cde'

#apps
alias e='nvim' # edit
alias t='vit'
alias ts='task export > ~/Sync/tasks/tasks.json'

# Inbox note
i() {
  if [[ -z $1 ]]; then
    zk new -g inbox -W ~/Sync/Notes/Inbox/
  else
    zk new -t $1 -g inbox -W ~/Sync/Notes/Inbox/
  fi
}

# Note
n() {
  if [[ -z $1 ]]; then
    zk edit -i -W ~/Sync/Notes/
  else
    zk edit $1 -W ~/Sync/Notes/
  fi
}

# View file/directory
v() {
  if [[ -z $1 ]]; then
    exa -lah
  elif [[ -d $1 ]]; then
    exa -lah $1
  else
    bat $1
  fi
}

# Add a new file/directory including the parent directories
a() {
  local p="$1"
  # Check if the path ends with a '/'
  if [[ "$p" =~ /$ ]]; then
    # Create directory structure if it doesn't exist
    mkdir -p "$p"
  else
    # Get the directory part of the path
    local dir=$(dirname "$p")
    # Create directory structure if it doesn't exist
    mkdir -p "$dir"
    # Create the file if it doesn't exist
    touch "$p"
  fi
}

c() {
  local name="$1"

    # Define common file extensions to search for
    local extensions=("conf" "config" "toml" "json" "yml" "yaml")

    # Construct paths
    local config_home_path="${XDG_CONFIG_HOME:-$HOME/.config}"
    local search_dirs=("$config_home_path/$name" "$HOME/.$name")

    # Check directories and files with no extension
    for target in "${search_dirs[@]}"; do
      if [[ -d "$target" || -f "$target" ]]; then
        $EDITOR "$target"
        return
      fi
    done

    # Check files with common extensions
    for ext in "${extensions[@]}"; do
      for target in "${search_dirs[@]}"; do
        if [[ -f "${target}.$ext" ]]; then
          $EDITOR "${target}.$ext"
          return
        fi
      done
    done

    echo "No matching file or directory found."
}

function cz() {
  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

  if [[ $# -eq 0 ]]; then
    chezmoi cd
  elif [[ $1 == "nvim" ]]; then
    chezmoi add "$config_home/nvim/"
  elif [[ $1 == "sbar" ]]; then
    chezmoi add "$config_home/sketchybar"
  else
    chezmoi "$@"
  fi
}

