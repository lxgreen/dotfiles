-- Wake handler to restart event providers and refresh the bar after sleep/wake cycles
-- This fixes the issue where sketchybar gets stuck after Mac goes to sleep

local sbar = require("sketchybar")

-- Create a hidden item that handles wake events
local wake_handler = sbar.add("item", "wake_handler", {
    drawing = false,
    updates = true,
})

-- Function to restart event providers
local function restart_event_providers()
    -- Kill and restart cpu_load event provider
    sbar.exec("killall cpu_load 2>/dev/null; sleep 0.5 && $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0 &")
    
    -- Kill and restart network_load event provider
    sbar.exec("killall network_load 2>/dev/null; sleep 0.5 && $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0 &")
end

-- Subscribe to system wake event
wake_handler:subscribe("system_woke", function(env)
    -- Log wake event for debugging
    sbar.exec("echo '[$(date)] System woke - restarting event providers' >> $CONFIG_DIR/wake_handler.log")
    
    -- Small delay to let the system stabilize after wake
    sbar.exec("sleep 1")
    
    -- Restart event providers that may have become unresponsive
    restart_event_providers()
    
    -- Force update the entire bar after a short delay
    sbar.exec("sleep 2 && sketchybar --update")
end)

-- Also handle system_will_sleep to gracefully stop providers
wake_handler:subscribe("system_will_sleep", function(env)
    sbar.exec("echo '[$(date)] System going to sleep' >> $CONFIG_DIR/wake_handler.log")
    
    -- Gracefully stop event providers before sleep
    sbar.exec("killall cpu_load 2>/dev/null")
    sbar.exec("killall network_load 2>/dev/null")
end)

return wake_handler
