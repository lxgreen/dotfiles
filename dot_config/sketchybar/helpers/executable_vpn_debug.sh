#!/bin/bash

# Debug version of VPN monitor to understand detection logic

LOG_FILE="/Library/Logs/PaloAltoNetworks/GlobalProtect/PanGPS.log"

echo "=== VPN Detection Debug ==="
echo "Timestamp: $(date)"
echo

# Check GlobalProtect process
echo "1. GlobalProtect Process Check:"
if pgrep -f "GlobalProtect" >/dev/null; then
    echo "   ✓ GlobalProtect process is running"
    pgrep -f "GlobalProtect" | head -3
else
    echo "   ✗ GlobalProtect process not found"
fi
echo

# Check log file
echo "2. Log File Analysis:"
if [ -f "$LOG_FILE" ]; then
    echo "   ✓ Log file exists: $LOG_FILE"
    echo "   Recent connection indicators:"
    tail -50 "$LOG_FILE" 2>/dev/null | grep -E "IsConnected.*is [01]|Set state to" | tail -3
    echo
    echo "   Recent SSL status:"
    tail -20 "$LOG_FILE" 2>/dev/null | grep -i "ssl.*disconnect" | tail -2
else
    echo "   ✗ Log file not found: $LOG_FILE"
fi
echo

# Check network interfaces
echo "3. Network Interface Check:"
for utun in utun{0..9}; do
    if ifconfig "$utun" 2>/dev/null | grep -q "inet [0-9]"; then
        local ip=$(ifconfig "$utun" 2>/dev/null | grep "inet " | awk '{print $2}' | grep -v "^127\." | grep -v "^169\.254\.")
        if [ -n "$ip" ]; then
            echo "   ✓ $utun has VPN IP: $ip"
        else
            echo "   - $utun has link-local IP only"
        fi
    fi
done
echo

# Test connectivity
echo "4. Connectivity Test:"
if nc -z -w 1 bo.wix.com 443 2>/dev/null; then
    echo "   ✓ bo.wix.com:443 is reachable"
else
    echo "   ✗ bo.wix.com:443 is not reachable"
fi
echo

# Final detection result
echo "5. Detection Result:"
/Users/alexgr/.config/sketchybar/helpers/vpn_monitor.sh
echo
