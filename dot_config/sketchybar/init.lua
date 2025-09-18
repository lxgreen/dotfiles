-- Require the sketchybar module
sbar = require("sketchybar")

-- Performance monitoring: Start timing
local start_time = os.clock()

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
-- require("test")
require("items")
sbar.end_config()

- Performance monitoring: Log startup time
local startup_time = os.clock() - start_time
sbar.exec("echo 'Sketchybar startup took: " .. string.format("%.3f", startup_time) .. " seconds'")

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
