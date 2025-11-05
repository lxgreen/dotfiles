local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local brew = sbar.add("item", "brew", {
	icon = { 
		string = "􀐚", 
	},
	label = {
		width = "dynamic",
		padding_left = 8,
		padding_right = 8,
		font = {
			family = settings.font.numbers
		},
	},
	padding_left = 4,
	padding_right = 4,
	position = "right",
	update_freq = 30,
})

local function update()
	local file = assert(io.popen("brew outdated | wc -l | tr -d ' '"))
	local brew_info = assert(file:read("a"))
	local count = tonumber(brew_info)
	local icon = { 
		string = "􀐛",
	}
	local label = { 
		string = tostring(count), 
		font = {
			family = settings.font.numbers
		}
	}

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

-- Create bracket for brew widget
sbar.add("bracket", "brew.bracket", {brew.name}, {
	background = {
		color = colors.bg1,
		border_color = colors.rainbow[#colors.rainbow - 6],
		border_width = 1
	}
})

-- Add padding after the brew widget
sbar.add("item", "brew.padding", {
	position = "right",
	width = settings.group_paddings
})

-- Initialize brew widget after startup delay to avoid blocking startup
-- This allows fast startup while still initializing the widget
sbar.exec("sleep 1 && sketchybar --trigger brew_update")

-- Start brew monitoring to detect when brew operations complete
sbar.exec("$CONFIG_DIR/helpers/brew_monitor.sh monitor &")

-- Manual trigger for immediate brew check: sketchybar --trigger brew_update

return brew
