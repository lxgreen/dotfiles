#!/bin/bash

# Count outdated brew packages (optimized version)
# Uses caching to reduce CPU usage and avoids slow operations

# Cache file and settings
CACHE_FILE="/tmp/sketchybar_brew_count_cache"
CACHE_TTL=300  # Cache for 5 minutes (300 seconds)

# Set PATH to include common Homebrew locations (no shell profile sourcing)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Find brew binary - try explicit paths first
BREW_BIN=""
if [ -f /opt/homebrew/bin/brew ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
elif [ -f /usr/local/bin/brew ]; then
    BREW_BIN="/usr/local/bin/brew"
elif command -v brew >/dev/null 2>&1; then
    BREW_BIN="brew"
fi

# Find jq binary - try explicit paths first
JQ_BIN=""
if [ -f /opt/homebrew/bin/jq ]; then
    JQ_BIN="/opt/homebrew/bin/jq"
elif [ -f /usr/local/bin/jq ]; then
    JQ_BIN="/usr/local/bin/jq"
elif command -v jq >/dev/null 2>&1; then
    JQ_BIN="jq"
fi

# If we can't find brew or jq, return 0
if [ -z "$BREW_BIN" ] || [ -z "$JQ_BIN" ]; then
    echo 0
    exit 0
fi

# Check cache first (if forced update via BREW_FORCE_UPDATE, skip cache)
if [ -z "$BREW_FORCE_UPDATE" ] && [ -f "$CACHE_FILE" ]; then
    CACHE_TIME=$(stat -f "%m" "$CACHE_FILE" 2>/dev/null || stat -c "%Y" "$CACHE_FILE" 2>/dev/null)
    CURRENT_TIME=$(date +%s)
    AGE=$((CURRENT_TIME - CACHE_TIME))
    
    if [ $AGE -lt $CACHE_TTL ]; then
        # Return cached value
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Get the count with aggressive timeout to prevent hanging
# Use timeout if available, otherwise use background process with kill
if command -v timeout >/dev/null 2>&1; then
    # Use shorter timeout (3 seconds) to prevent hanging
    JSON_OUTPUT=$(timeout 3 "$BREW_BIN" outdated --json 2>/dev/null)
    EXIT_CODE=$?
else
    # Fallback: run in background and kill if takes too long
    TMP_OUTPUT=$(mktemp)
    "$BREW_BIN" outdated --json > "$TMP_OUTPUT" 2>/dev/null &
    BREW_PID=$!
    sleep 3
    if kill -0 "$BREW_PID" 2>/dev/null; then
        kill "$BREW_PID" 2>/dev/null
        EXIT_CODE=124
        JSON_OUTPUT=""
    else
        wait "$BREW_PID"
        EXIT_CODE=$?
        JSON_OUTPUT=$(cat "$TMP_OUTPUT" 2>/dev/null)
    fi
    rm -f "$TMP_OUTPUT"
fi

# Check if command succeeded and output is valid
if [ $EXIT_CODE -ne 0 ] || [ -z "$JSON_OUTPUT" ] || [ "$JSON_OUTPUT" = "null" ]; then
    # If we have a cached value, use it even if expired
    if [ -f "$CACHE_FILE" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
    echo 0
    exit 0
fi

# Parse JSON and get count
COUNT=$(echo "$JSON_OUTPUT" | "$JQ_BIN" -r '(.formulae // [] | length) + (.casks // [] | length)' 2>/dev/null)

# Validate count is a number
if [ -z "$COUNT" ] || ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
    COUNT=0
fi

# Cache the result
echo -n "$COUNT" > "$CACHE_FILE"

echo -n "$COUNT"

