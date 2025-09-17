# Automatic Theme Switching for Sketchybar

This configuration automatically switches sketchybar themes when you change your macOS appearance (light/dark mode).

## How It Works

1. **OS Theme Detection**: Monitors macOS appearance changes every 2 seconds
2. **Automatic Mapping**: 
   - Light mode → `catppuccin-latte` (light theme)
   - Dark mode → `catppuccin-mocha` (dark theme)
3. **Auto Reload**: Automatically reloads sketchybar when theme changes

## Usage

### Start Automatic Theme Detection
```bash
./helpers/start_auto_theme.sh
```

### Manual Control
```bash
# Check status
./helpers/auto_theme_detector.sh status

# Start detector
./helpers/auto_theme_detector.sh start

# Stop detector
./helpers/auto_theme_detector.sh stop

# Get current OS theme
./helpers/auto_theme_detector.sh get
```

### Manual Theme Switching (if needed)
```bash
# Switch to light theme
./helpers/reload.sh switch catppuccin-latte

# Switch to dark theme
./helpers/reload.sh switch catppuccin-mocha
```

## Features

- ✅ **Automatic Detection**: Detects macOS appearance changes
- ✅ **Real-time Switching**: Changes theme within 2 seconds
- ✅ **Background Monitoring**: Runs continuously in background
- ✅ **Logging**: Logs all theme changes to `theme_changes.log`
- ✅ **Manual Override**: Can still manually switch themes if needed

## Files

- `helpers/auto_theme_detector.sh` - Main theme detection script
- `helpers/start_auto_theme.sh` - Startup script
- `helpers/reload.sh` - Manual reload/theme switching
- `theme_changes.log` - Log of all theme changes
- `.current_os_theme` - Current OS theme state

## Integration

The colorscheme system automatically:
1. Detects current OS theme on startup
2. Loads appropriate catppuccin theme
3. Updates all sketchybar colors accordingly

No manual intervention required - just change your macOS appearance and sketchybar will follow!
