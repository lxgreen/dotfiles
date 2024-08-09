local opts = require("opts")
local sbar = require("sketchybar")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 35,
	color = opts.color.base,
	padding_right = 2,
	padding_left = 2,
})
