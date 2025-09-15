#!/bin/bash

# Brew Update Monitor
# Detects when brew operations complete and triggers widget updates

# Configuration
BREW_PID_FILE="/tmp/sketchybar_brew_pid"
LAST_UPDATE_FILE="/tmp/sketchybar_brew_last_update"

# Function to trigger brew widget update
trigger_brew_update() {
    sketchybar --trigger brew_update 2>/dev/null
    echo "$(date)" > "$LAST_UPDATE_FILE"
}

# Function to check if brew is currently running
is_brew_running() {
    # Check for brew processes
    if pgrep -f "brew.*upgrade\|brew.*install\|brew.*update" > /dev/null; then
        return 0  # Brew is running
    else
        return 1  # Brew is not running
    fi
}

# Function to monitor brew operations
monitor_brew() {
    local was_running=false
    
    while true; do
        if is_brew_running; then
            if [ "$was_running" = false ]; then
                echo "$(date): Brew operation started"
                was_running=true
            fi
        else
            if [ "$was_running" = true ]; then
                echo "$(date): Brew operation completed - triggering update"
                trigger_brew_update
                was_running=false
            fi
        fi
        
        sleep 5  # Check every 5 seconds
    done
}

# Main execution
if [ "$1" = "monitor" ]; then
    monitor_brew
else
    # Single check mode
    if is_brew_running; then
        echo "brew_running"
    else
        echo "brew_idle"
    fi
fi
