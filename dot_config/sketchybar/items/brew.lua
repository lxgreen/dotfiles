local sbar = require("sketchybar")
local colors = require("colors")

local brew = sbar.add("item", {
	icon = { string = "􀐛", font = { size = 22.0 } },

	label = {
		align = "center",
		color = colors.grey,
		string = "􀍠",
		width = 18,
	},

	position = "right",
	update_freq = 60, -- Check every minute for more reliable updates
	
})

local function update()
	local file = assert(io.popen("brew outdated | wc -l | tr -d ' '"))
	local brew_info = assert(file:read("a"))
	local count = tonumber(brew_info)
	local icon = { color = colors.green }
	local label = { string = tostring(count), color = colors.white, drawing = true }

	if count == 0 then
		label.drawing = false
		icon.string = "􀐚"
	elseif count < 9 then
		icon.color = colors.yellow
	elseif count < 19 then
		icon.color = colors.orange
	else
		icon.color = colors.red
	end

	sbar.animate("sin", 10, function()
		brew:set({ label = label, icon = icon })
	end)
end

local function action()
	sbar.exec([[wezterm start -- zsh -c "brew upgrade && sketchybar --trigger brew_update"]])
	-- Don't call update() here - let the terminal command trigger it after completion
end


-- Removed "forced" and "routine" from startup to eliminate 1.45s delay
-- Brew check now only runs on manual updates or brew_update events
brew:subscribe({ "brew_update", "update" }, update)
brew:subscribe("mouse.clicked", action)
brew:subscribe("mouse.clicked.right", function() 
    sbar.exec("sketchybar --trigger brew_update")
end)


-- Initialize brew widget after startup delay to avoid blocking startup
-- This allows fast startup while still initializing the widget
sbar.exec("sleep 1 && sketchybar --trigger brew_update")

-- Start brew monitoring to detect when brew operations complete
sbar.exec("$CONFIG_DIR/helpers/brew_monitor.sh monitor &")

-- Manual trigger for immediate brew check: sketchybar --trigger brew_update

return brew
