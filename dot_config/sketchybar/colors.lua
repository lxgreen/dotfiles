-- Function to get colors from current theme
local function get_colors()
	local colorscheme = require("colorscheme")
	local theme = colorscheme.current

	return {
		-- Basic colors from catppuccin theme (already converted to numbers)
		black = theme.base, -- Use base as black
		white = theme.text, -- Use text as white
		green = theme.green,
		blue = theme.blue,
		yellow = theme.yellow,
		orange = theme.orange,
		red = 0xFFFF0000,
		magenta = theme.purple, -- Map purple to magenta
		grey = theme.surface, -- Use surface as grey
		transparent = 0x00000000,

		-- Bar colors
		bar = {
			bg = theme.base & 0xd0ffffff, -- with transparency
			border = theme.base,
		},

		-- Popup colors
		popup = {
			bg = theme.base & 0xc0ffffff, -- with transparency
			border = theme.surface,
		},

		-- Background colors
		bg1 = theme.surface,
		bg2 = theme.surface, -- Use same as bg1 for now

		-- Rainbow colors using catppuccin palette
		rainbow = {
			theme.orange,
			theme.yellow,
			theme.green,
			theme.blue,
			theme.purple,
			theme.pink,
			theme.blue, -- Repeat some colors to fill array
			theme.purple,
			theme.pink,
			theme.orange,
		},

		-- Utility function for alpha blending
		with_alpha = function(color, alpha)
			if alpha > 1.0 or alpha < 0.0 then
				return color
			end
			return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
		end,
	}
end

-- Return colors based on current theme
return get_colors()
