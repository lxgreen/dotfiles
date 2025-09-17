#!/bin/bash

# Sketchybar reload script with colorscheme support
# This script reloads sketchybar and can optionally switch themes

CONFIG_DIR="$(dirname "$0")/.."

# Function to reload sketchybar
reload_sketchybar() {
    echo "Reloading sketchybar..."
    sketchybar --reload
    echo "Sketchybar reloaded successfully"
}

# Function to switch theme and reload
switch_theme() {
    local theme="$1"
    local nvim_color_file="$HOME/.local/share/nvim/last-color"
    
    if [[ -n "$theme" ]]; then
        echo "Switching to theme: $theme"
        echo "$theme" > "$nvim_color_file"
        reload_sketchybar
    else
        echo "Usage: $0 switch <theme>"
        echo "Available themes: catppuccin-mocha, catppuccin-latte"
    fi
}

# Function to show current theme
show_current_theme() {
    local nvim_color_file="$HOME/.local/share/nvim/last-color"
    if [[ -f "$nvim_color_file" ]]; then
        local current_theme=$(cat "$nvim_color_file")
        echo "Current theme: $current_theme"
    else
        echo "No theme file found, using default: catppuccin-mocha"
    fi
}

# Main execution
case "${1:-reload}" in
    "reload")
        reload_sketchybar
        ;;
    "switch")
        switch_theme "$2"
        ;;
    "theme")
        show_current_theme
        ;;
    *)
        echo "Usage: $0 [reload|switch <theme>|theme]"
        echo "  reload: Reload sketchybar configuration (default)"
        echo "  switch <theme>: Switch to specified theme and reload"
        echo "  theme: Show current theme"
        echo ""
        echo "Available themes:"
        echo "  catppuccin-mocha (dark)"
        echo "  catppuccin-latte (light)"
        exit 1
        ;;
esac
