#!/bin/bash

# Brew Update Monitor (optimized version)
# Detects when brew operations complete and triggers widget updates
# Uses adaptive polling to reduce CPU usage when idle

# Configuration
BREW_PID_FILE="/tmp/sketchybar_brew_pid"
LAST_UPDATE_FILE="/tmp/sketchybar_brew_last_update"
CACHE_FILE="/tmp/sketchybar_brew_count_cache"

# Function to trigger brew widget update
trigger_brew_update() {
    sketchybar --trigger brew_update 2>/dev/null
    date +%s > "$LAST_UPDATE_FILE" 2>/dev/null
}

# Optimized function to check if brew is currently running
# Uses pgrep with more specific patterns and limits output
is_brew_running() {
    # Use -x flag for exact match when possible, and limit to first match
    pgrep -f "brew (upgrade|install|update|reinstall)" >/dev/null 2>&1
}

# Function to monitor brew operations with adaptive polling
monitor_brew() {
    local was_running=false
    local last_check_time=$(date +%s)
    local sleep_interval=5  # Start with 5 seconds
    local max_sleep=60      # Max sleep when idle
    local min_sleep=2       # Min sleep when active
    
    while true; do
        if is_brew_running; then
            if [ "$was_running" = false ]; then
                # Brew just started - reduce sleep interval for faster detection
                sleep_interval=$min_sleep
                was_running=true
            fi
        else
            if [ "$was_running" = true ]; then
                # Brew just finished - trigger update and reset
                # Clear cache to force fresh count on next update
                rm -f "$CACHE_FILE" 2>/dev/null
                trigger_brew_update
                was_running=false
                sleep_interval=$min_sleep
                last_check_time=$(date +%s)
            else
                # Brew is idle - use exponential backoff to reduce CPU usage
                local current_time=$(date +%s)
                local time_since_check=$((current_time - last_check_time))
                
                # Gradually increase sleep interval when idle (up to max_sleep)
                if [ $sleep_interval -lt $max_sleep ]; then
                    sleep_interval=$((sleep_interval + 1))
                fi
                
                # Only check occasionally when idle (every 30 seconds)
                if [ $time_since_check -ge 30 ]; then
                    trigger_brew_update
                    last_check_time=$current_time
                fi
            fi
        fi
        
        sleep $sleep_interval
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
