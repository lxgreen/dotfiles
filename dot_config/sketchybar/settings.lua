local colorscheme = require("colorscheme")
local colors = colorscheme.current
local icons = require("icons")

return {
	paddings = 3,
	group_paddings = 5,
	modes = {
		main = {
			icon = icons.apple,
			color = colors.blue,
		},
		service = {
			icon = icons.gear,
			color = colors.orange,
		},
	},
	bar = {
		height = 36,
		padding = {
			x = 10,
			y = 0,
		},
		background = colors.base,
	},
	items = {
		height = 26,
		gap = 5,
		padding = {
			right = 16,
			left = 12,
			top = 0,
			bottom = 0,
		},
		default_color = function(workspace)
			local rainbow_colors = {colors.red, colors.orange, colors.yellow, colors.green, colors.blue, colors.purple, colors.pink}
			return rainbow_colors[workspace + 1] or colors.blue
		end,
		highlight_color = function(workspace)
			return colors.text
		end,
		colors = {
			background = colors.surface,
		},
		corner_radius = 6,
	},

	icons = "sketchybar-app-font:Regular:16.0", -- alternatively available: NerdFont

	font = {
		text = "FiraCode Nerd Font Mono", -- Used for text
		numbers = "FiraCode Nerd Font Mono", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
}
