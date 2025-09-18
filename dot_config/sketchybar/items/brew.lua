local sbar = require("sketchybar")
local colors = require("colors")

local brew = sbar.add("item", "brew", {
	icon = { string = "􀐛", font = { size = 14.0 } },
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.grey,
		font = {
			size = 10.0
		}
	},
	padding_left = 0,
	padding_right = 4,
	position = "right",
	display = "active",
	update_freq = 30,
})

local function update()
	local file = assert(io.popen("brew outdated | wc -l | tr -d ' '"))
	local brew_info = assert(file:read("a"))
	local count = tonumber(brew_info)
	local icon = { color = colors.green }
	local label = { string = tostring(count), color = colors.white }

	if count == 0 then
		icon.string = "􀐚"
		label.string = "0"
		label.color = colors.green
	elseif count < 9 then
		icon.color = colors.yellow
		label.string = tostring(count)
		label.color = colors.yellow
	elseif count < 19 then
		icon.color = colors.orange
		label.string = tostring(count)
		label.color = colors.orange
	else
		icon.color = colors.red
		label.string = tostring(count)
		label.color = colors.red
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

-- Mouse hover functionality
brew:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		brew:set({
			label = {
				width = "dynamic",
			},
		})
	end)
end)

brew:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		brew:set({
			label = {
				width = 0,
			},
		})
	end)
end)

-- Initialize brew widget after startup delay to avoid blocking startup
-- This allows fast startup while still initializing the widget
sbar.exec("sleep 1 && sketchybar --trigger brew_update")

-- Start brew monitoring to detect when brew operations complete
sbar.exec("$CONFIG_DIR/helpers/brew_monitor.sh monitor &")

-- Manual trigger for immediate brew check: sketchybar --trigger brew_update

return brew
