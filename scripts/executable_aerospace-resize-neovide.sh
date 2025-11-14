#!/bin/zsh

windows=$(aerospace list-windows --monitor all --app-bundle-id com.neovide.neovide --json)

if echo "$windows" | jq -e '.[0]' >/dev/null 2>&1; then
  window_id=$(echo "$windows" | jq -r '.[0]."window-id"')
  
  if [ -n "$window_id" ]; then
    # Cycle through three states: small (30px) -> large (200px) -> full -> small
    state_file="$HOME/.neovide_resize_state"
    current_state=$(cat "$state_file" 2>/dev/null || echo "")
    
    case "$current_state" in
      "small")
        # Currently small, resize to large (200px height)
        aerospace resize --window-id "$window_id" height 200
        echo "large" > "$state_file"
        ;;
      "large")
        # Currently large, resize to full (fill screen)
        # Use a very large height value to fill the screen
        aerospace resize --window-id "$window_id" height 10000
        echo "full" > "$state_file"
        ;;
      *)
        # Unknown or full state, resize to small (30px)
        aerospace resize --window-id "$window_id" height 30
        echo "small" > "$state_file"
        ;;
    esac
    
    aerospace focus --window-id "$window_id"
  else
    echo "ERROR: Failed to get Neovide window ID" >&2
    exit 1
  fi
else
  # No Neovide windows found, launch it
  echo "No Neovide windows found, launching..." >&2
  open -a Neovide
  
  # Wait for window to appear and get its ID
  max_attempts=10
  attempt=0
  window_id=""
  
  while [ $attempt -lt $max_attempts ] && [ -z "$window_id" ]; do
    sleep 0.5
    windows=$(aerospace list-windows --monitor all --app-bundle-id com.neovide.neovide --json)
    if echo "$windows" | jq -e '.[0]' >/dev/null 2>&1; then
      window_id=$(echo "$windows" | jq -r '.[0]."window-id"')
    fi
    attempt=$((attempt + 1))
  done
  
  if [ -n "$window_id" ]; then
    # Set up the window similar to focus-neovide.sh
    aerospace move-node-to-workspace --window-id "$window_id" 2
    aerospace workspace 2
    aerospace focus --window-id "$window_id"
    sleep 0.3
    aerospace layout vertical
    sleep 0.3
    aerospace move down
    sleep 0.3
    # Start with small size (30px)
    aerospace resize --window-id "$window_id" height 30
    state_file="$HOME/.neovide_resize_state"
    echo "small" > "$state_file"
  else
    echo "ERROR: Failed to launch Neovide or get window ID" >&2
    exit 1
  fi
fi

