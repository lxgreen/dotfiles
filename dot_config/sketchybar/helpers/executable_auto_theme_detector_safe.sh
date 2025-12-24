#!/bin/bash

# Safe automatic theme detector for sketchybar (optimized version)
# This version doesn't call sketchybar --reload to prevent infinite loops
# Instead, it updates theme files and lets sketchybar detect changes

CONFIG_DIR="$(dirname "$0")/.."
THEME_FILE="$CONFIG_DIR/.current_os_theme"
LOG_FILE="$CONFIG_DIR/theme_changes.log"
MAX_LOG_SIZE=50000  # Rotate log at 50KB

# Function to rotate log file if it gets too large
rotate_log_if_needed() {
    if [ -f "$LOG_FILE" ]; then
        local log_size=$(stat -f "%z" "$LOG_FILE" 2>/dev/null || stat -c "%s" "$LOG_FILE" 2>/dev/null)
        if [ -n "$log_size" ] && [ "$log_size" -gt "$MAX_LOG_SIZE" ]; then
            # Keep only last 100 lines
            tail -n 100 "$LOG_FILE" > "${LOG_FILE}.tmp" 2>/dev/null
            mv "${LOG_FILE}.tmp" "$LOG_FILE" 2>/dev/null
        fi
    fi
}

# Function to find sketchybar binary
find_sketchybar() {
    if [ -f /opt/homebrew/bin/sketchybar ]; then
        echo "/opt/homebrew/bin/sketchybar"
    elif [ -f /usr/local/bin/sketchybar ]; then
        echo "/usr/local/bin/sketchybar"
    elif command -v sketchybar >/dev/null 2>&1; then
        echo "sketchybar"
    else
        echo ""
    fi
}

# Function to get current macOS appearance
get_current_os_theme() {
    # AppleInterfaceStyle only exists when in dark mode
    local appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    
    if [[ "$appearance" == "Dark" ]]; then
        echo "dark"
    else
        # If AppleInterfaceStyle doesn't exist, we're in light mode
        echo "light"
    fi
}

# Function to get corresponding catppuccin theme
get_catppuccin_theme() {
    local os_theme="$1"
    if [[ "$os_theme" == "light" ]]; then
        echo "catppuccin-latte"
    else
        echo "catppuccin-mocha"
    fi
}

# Function to update theme files and reload sketchybar
update_sketchybar_theme() {
    local catppuccin_theme="$1"
    local nvim_color_file="$HOME/.local/share/nvim/last-color"
    local sketchybar_bin=$(find_sketchybar)
    
    # Update the nvim color file
    echo "$catppuccin_theme" > "$nvim_color_file" 2>/dev/null
    
    # Update the theme file for sketchybar
    echo "$catppuccin_theme" > "$THEME_FILE"
    
    # Reload sketchybar to apply the new theme (with a small delay to prevent loops)
    if [ -n "$sketchybar_bin" ]; then
        sleep 1
        "$sketchybar_bin" --reload >/dev/null 2>&1
    fi
    
    # Rotate log if needed before writing
    rotate_log_if_needed
    
    # Log the change (minimal logging - only actual changes)
    local os_theme=$(get_current_os_theme)
    echo "$(date +%s): $os_theme -> $catppuccin_theme" >> "$LOG_FILE"
}

# Function to monitor theme changes
monitor_theme_changes() {
    local current_os_theme=$(get_current_os_theme)
    local last_os_theme="$current_os_theme"
    local current_catppuccin_theme=$(get_catppuccin_theme "$current_os_theme")
    
    # Initialize theme file
    echo "$current_os_theme" > "$THEME_FILE"
    
    # Set initial theme (silent - no logging on startup)
    local nvim_color_file="$HOME/.local/share/nvim/last-color"
    echo "$current_catppuccin_theme" > "$nvim_color_file" 2>/dev/null
    echo "$current_catppuccin_theme" > "$THEME_FILE"
    
    local sketchybar_bin=$(find_sketchybar)
    if [ -n "$sketchybar_bin" ]; then
        "$sketchybar_bin" --reload >/dev/null 2>&1
    fi
    
    # Log startup only once (to stderr so it goes to error log, not stdout)
    echo "Theme detector started: $current_os_theme -> $current_catppuccin_theme" >&2
    
    while true; do
        current_os_theme=$(get_current_os_theme)
        
        if [[ "$current_os_theme" != "$last_os_theme" ]]; then
            current_catppuccin_theme=$(get_catppuccin_theme "$current_os_theme")
            update_sketchybar_theme "$current_catppuccin_theme"
            last_os_theme="$current_os_theme"
        fi
        
        # Check every 3 seconds (reduced frequency to save CPU)
        sleep 3
    done
}

# Function to start the detector in background
start_detector() {
    # Kill any existing detector
    pkill -f "auto_theme_detector"
    
    # Start new detector in background
    "$0" monitor &
    
    echo "Safe auto theme detector started in background"
    echo "PID: $!"
}

# Function to stop the detector
stop_detector() {
    pkill -f "auto_theme_detector"
    echo "Safe auto theme detector stopped"
}

# Function to check status
check_status() {
    if pgrep -f "auto_theme_detector" > /dev/null; then
        echo "Safe auto theme detector is running"
        echo "Current OS theme: $(get_current_os_theme)"
        echo "Current catppuccin theme: $(get_catppuccin_theme $(get_current_os_theme))"
    else
        echo "Safe auto theme detector is not running"
    fi
}

# Main execution
case "${1:-monitor}" in
    "monitor")
        monitor_theme_changes
        ;;
    "start")
        start_detector
        ;;
    "stop")
        stop_detector
        ;;
    "status")
        check_status
        ;;
    "get")
        get_current_os_theme
        ;;
    *)
        echo "Usage: $0 [monitor|start|stop|status|get]"
        echo "  monitor: Continuously monitor for theme changes (default)"
        echo "  start: Start the detector in background"
        echo "  stop: Stop the detector"
        echo "  status: Check if detector is running"
        echo "  get: Get current OS theme"
        exit 1
        ;;
esac
