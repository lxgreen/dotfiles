#!/bin/bash

# GlobalProtect VPN State Monitor - Simple Version
# Uses interface flags for reliable detection

# Configuration
LAST_STATE_FILE="/tmp/sketchybar_vpn_last_state"

# Function to check VPN state
check_vpn_state() {
    # Check if utun4 has UP flag (8051 = UP,POINTOPOINT,RUNNING,MULTICAST)
    if ifconfig utun4 2>/dev/null | grep -q "flags=8051"; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

# Function to trigger sketchybar update
trigger_vpn_update() {
    sketchybar --trigger vpn_update 2>/dev/null
}

# Get current state
current_state=$(check_vpn_state)

# Check if state changed
last_state="unknown"
if [ -f "$LAST_STATE_FILE" ]; then
    last_state=$(cat "$LAST_STATE_FILE")
fi

# If state changed, trigger update
if [ "$current_state" != "$last_state" ]; then
    echo "$current_state" > "$LAST_STATE_FILE"
    trigger_vpn_update
fi

# Always output current state
echo "$current_state"