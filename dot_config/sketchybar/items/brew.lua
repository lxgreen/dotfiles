local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local brew = sbar.add("item", "brew", {
	icon = { 
		string = "􀐚", 
	},
	label = {
		width = "dynamic",
		padding_left = 6,
		padding_right = 6,
		font = {
			family = settings.font.numbers
		},
	},
	padding_left = 8,
	padding_right = 8,
	position = "right",
	update_freq = 30,
})

local function update()
	-- Use helper script to count outdated packages (ensures proper PATH)
	sbar.exec("$CONFIG_DIR/helpers/brew_count.sh", function(output)
		local count = 0
		
		if output and output ~= "" then
			-- Remove all whitespace and extract first number
			local cleaned = output:gsub("%s+", "")
			count = tonumber(cleaned) or 0
			
			-- Fallback: try to extract number with pattern matching
			if count == 0 and cleaned ~= "0" then
				local num_match = cleaned:match("(%d+)")
				if num_match then
					count = tonumber(num_match) or 0
				end
			end
		end
		
		-- Update label with count - always show, including 0
		brew:set({ 
			icon = { 
				string = "􀐛"
			},
			label = {
				string = tostring(count),
				width = "dynamic",
				padding_left = 6,
				padding_right = 6
			}
		})
	end)
end

local function action()
	sbar.exec([[wezterm start -- zsh -c "brew upgrade && sketchybar --trigger brew_update"]])
	-- Don't call update() here - let the terminal command trigger it after completion
end

-- Subscribe to routine events for periodic updates (every 30 seconds)
-- Also subscribe to brew_update events for immediate updates after brew operations
brew:subscribe({ "brew_update", "routine" }, update)
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
