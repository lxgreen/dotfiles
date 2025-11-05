local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

-- Create a common bracket for npm, keyboard, and VPN widgets
-- This groups them together with a green border and no background
sbar.add("bracket", "widgets_group.bracket", {
	"npm_registry",
	"keyboard_layout",
	"vpn",
}, {
	background = {
		color = colors.transparent,
		border_color = colors.green,
		border_width = 1,
	},
})

-- Add padding after the grouped widgets (matching CPU/volume widgets)
sbar.add("item", "widgets_group.padding", {
	position = "right",
	width = settings.group_paddings,
})

sbar.add("item", "widgets_group.padding", {
	position = "left",
	width = settings.group_paddings,
})

return true
