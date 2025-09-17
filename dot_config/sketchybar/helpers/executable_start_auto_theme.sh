#!/bin/bash

# Startup script for automatic theme detection
# This script starts the auto theme detector when sketchybar starts

CONFIG_DIR="$(dirname "$0")/.."

echo "Starting automatic theme detection..."

# Start the auto theme detector
"$CONFIG_DIR/helpers/auto_theme_detector.sh" start

echo "Automatic theme detection started successfully"
echo "Sketchybar will now automatically switch themes when you change macOS appearance"
echo ""
echo "To check status: $CONFIG_DIR/helpers/auto_theme_detector.sh status"
echo "To stop: $CONFIG_DIR/helpers/auto_theme_detector.sh stop"
