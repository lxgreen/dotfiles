# SketchyBar Configuration

A highly optimized SketchyBar configuration with performance improvements and comprehensive widget support.

## Features

- ⚡ **Optimized Startup**: Pre-compiled binaries for instant startup
- 🕐 **Real-time Clock**: Calendar widget with seconds display
- 📊 **System Monitoring**: CPU, network, battery, and volume widgets
- 🚀 **Aerospace Integration**: Window management and workspace indicators
- 🎨 **Modern UI**: Clean design with SF Symbols and custom styling

## Quick Start

1. **Install Dependencies**:
   ```bash
   # Install required packages
   brew install lua sketchybar switchaudio-osx nowplaying-cli
   brew tap FelixKratz/formulae
   
   # Install fonts
   brew install --cask sf-symbols
   brew install --cask homebrew/cask-fonts/font-sf-mono
   brew install --cask homebrew/cask-fonts/font-sf-pro
   
   # Install SketchyBar app font
   curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
   
   # Install SbarLua
   (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
   ```

2. **Compile Helper Binaries**:
   ```bash
   cd ~/.config/sketchybar/helpers
   make
   ```

3. **Start SketchyBar**:
   ```bash
   sketchybar --reload
   ```

## Compilation Instructions

### Initial Setup

The configuration includes custom C binaries for system monitoring. These must be compiled before first use:

```bash
# Navigate to the helpers directory
cd ~/.config/sketchybar/helpers

# Compile all helper binaries
make
```

This will compile:
- `event_providers/cpu_load/bin/cpu_load` - CPU monitoring
- `event_providers/network_load/bin/network_load` - Network monitoring  
- `menus/bin/menus` - Menu system

### Recompilation

**When to recompile:**
- After modifying C source files in `helpers/event_providers/`
- After system updates that might affect binary compatibility
- When adding new event providers

**How to recompile:**
```bash
# Clean and rebuild all binaries
cd ~/.config/sketchybar/helpers
make clean && make

# Or rebuild specific components
cd ~/.config/sketchybar/helpers/event_providers
make clean && make

cd ~/.config/sketchybar/helpers/menus  
make clean && make
```

### Performance Optimization

**Important**: The configuration is optimized for fast startup by pre-compiling binaries. The compilation step has been removed from the startup process to eliminate 2-5 second delays.

- ✅ **Pre-compiled**: Binaries are compiled once and reused
- ✅ **Fast startup**: ~35-50ms startup time
- ✅ **Stable**: Event providers start with proper delays

## Configuration Structure

```
~/.config/sketchybar/
├── sketchybarrc          # Main entry point
├── init.lua              # Core initialization with performance monitoring
├── helpers/
│   ├── init.lua          # Helper initialization (compilation disabled)
│   ├── makefile          # Build system
│   ├── vpn_monitor.sh    # VPN state detection script
│   ├── event_providers/  # C binaries for system monitoring
│   │   ├── cpu_load/     # CPU monitoring
│   │   └── network_load/ # Network monitoring
│   └── menus/            # Menu system
├── items/                # Widget configurations
│   ├── calendar.lua      # Clock with seconds (1s updates)
│   ├── widgets/          # System monitoring widgets
│   └── ...
├── colors.lua            # Color scheme
├── icons.lua             # Icon definitions
└── settings.lua          # Global settings
```

## Widgets

### System Monitoring
- **CPU**: Real-time CPU usage with color-coded graph
- **Network**: Upload/download speeds with network interface monitoring
- **Battery**: Battery status with remaining time
- **Volume**: Audio control with device switching

### Applications
- **Calendar**: Date and time with seconds display (updates every 1 second)
- **Front App**: Currently focused application
- **Brew**: Package update notifications
- **VPN**: Real-time GlobalProtect connection status monitoring with instant state detection

### Window Management
- **Aerospace**: Workspace and window management integration
- **Spaces**: macOS Spaces integration
- **Menus**: Application menu integration

## VPN Real-Time Detection

The configuration includes a sophisticated VPN monitoring system for GlobalProtect:

### How It Works
- **State Detection**: Uses `ifconfig utun4` interface flags for reliable detection
  - **Connected**: `flags=8051` (UP,POINTOPOINT,RUNNING,MULTICAST)
  - **Disconnected**: `flags=8050` (POINTOPOINT,RUNNING,MULTICAST)
- **Change Detection**: Tracks state changes in `/tmp/sketchybar_vpn_last_state`
- **Instant Updates**: Triggers `sketchybar --trigger vpn_update` when state changes
- **Background Monitoring**: Continuous monitoring every 10 seconds

### Files
- `helpers/vpn_monitor.sh` - VPN state detection script
- `items/vpn.lua` - VPN widget configuration
- `/tmp/sketchybar_vpn_last_state` - State tracking file

### Features
- ✅ **Instant Updates**: Widget changes immediately when VPN connects/disconnects
- ✅ **Accurate Detection**: No false positives or hanging
- ✅ **Reliable**: Uses the most reliable system indicator (interface flags)
- ✅ **Background Monitoring**: Continuous state monitoring without blocking

## Performance Monitoring

The configuration includes built-in performance monitoring:

- **Startup timing**: Automatically measures and logs configuration loading time
- **Event provider delays**: Prevents startup conflicts with staggered initialization
- **Optimized updates**: Balanced update frequencies for smooth performance

## Troubleshooting

### Slow Startup
If you experience slow startup times:

1. **Check compilation status**:
   ```bash
   ls -la ~/.config/sketchybar/helpers/event_providers/*/bin/
   ls -la ~/.config/sketchybar/helpers/menus/bin/
   ```

2. **Recompile if needed**:
   ```bash
   cd ~/.config/sketchybar/helpers && make
   ```

3. **Check for conflicts**:
   ```bash
   # Kill existing processes
   killall cpu_load network_load
   sketchybar --reload
   ```

### Widget Issues
- **Calendar not updating**: Check if `update_freq = 1` is set
- **CPU/Network not showing**: Verify event providers are running
- **Aerospace integration**: Ensure Aerospace is installed and running
- **VPN status incorrect**: 
  - Check if `helpers/vpn_monitor.sh` is executable: `chmod +x helpers/vpn_monitor.sh`
  - Test VPN detection manually: `./helpers/vpn_monitor.sh`
  - Check interface flags: `ifconfig utun4 | grep flags`
  - Verify GlobalProtect is using `utun4` interface

### Performance Issues
- **High CPU usage**: Check widget update frequencies
- **Memory leaks**: Restart SketchyBar periodically
- **Slow updates**: Verify event provider binaries are compiled

## Customization

### Adding New Widgets
1. Create widget file in `items/` directory
2. Add to `items/init.lua` if needed
3. Recompile any new event providers

### Modifying Update Frequencies
Edit the `update_freq` parameter in widget files:
```lua
-- Fast updates (1 second)
update_freq = 1

-- Medium updates (30 seconds)  
update_freq = 30

-- Slow updates (5 minutes)
update_freq = 300
```

### Color Scheme
Modify `colors.lua` to change the appearance:
```lua
local colors = {
    white = "#FFFFFF",
    black = "#000000",
    -- ... add your colors
}
```

## Dependencies

- **SketchyBar**: Main application
- **Lua**: Scripting language
- **SbarLua**: Lua bindings for SketchyBar
- **Aerospace**: Window manager (optional)
- **SwitchAudioSource**: Audio device switching
- **nowplaying-cli**: Media control

## License

This configuration is provided as-is for educational and personal use.

## Contributing

Feel free to submit issues or pull requests for improvements and bug fixes.
