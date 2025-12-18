#!/bin/bash

# Count outdated brew packages
# This script ensures brew and jq are found and used correctly

# Source shell profile to get proper environment (if available)
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" >/dev/null 2>&1
elif [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile" >/dev/null 2>&1
elif [ -f "$HOME/.profile" ]; then
    source "$HOME/.profile" >/dev/null 2>&1
fi

# Set PATH to include common Homebrew locations
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Find brew binary - try explicit paths first since PATH might not be set
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

# Get the count with timeout to prevent hanging
# Use timeout if available, otherwise just run the command
if command -v timeout >/dev/null 2>&1; then
    JSON_OUTPUT=$(timeout 5 "$BREW_BIN" outdated --json 2>/dev/null)
else
    JSON_OUTPUT=$("$BREW_BIN" outdated --json 2>/dev/null)
fi

# Check if command succeeded and output is valid
if [ $? -ne 0 ] || [ -z "$JSON_OUTPUT" ] || [ "$JSON_OUTPUT" = "null" ]; then
    echo 0
    exit 0
fi

# Parse JSON and get count
COUNT=$(echo "$JSON_OUTPUT" | "$JQ_BIN" -r '(.formulae // [] | length) + (.casks // [] | length)' 2>/dev/null)

# Validate count is a number
if [ -z "$COUNT" ] || ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
    COUNT=0
fi

echo -n "$COUNT"

