local settings = require("settings")
local colors = require("colors")
local opts = require("opts")
local sbar = require("sketchybar")

-- background = {
-- 	height = 32,
-- 	color = opts.color.transparent,
-- },
-- icon = {
-- 	color = opts.color.base,
-- 	font = opts.font.medium_20,
-- 	padding_left = 0,
-- 	padding_right = 0,
-- },
-- label = {
-- 	color = opts.color.text,
-- 	font = opts.font.medium_20,
-- 	y_offset = 0,
-- 	padding_left = 0,
-- 	padding_right = 0,
-- },

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		color = opts.color.base,
		-- color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 13.0,
		},
		color = opts.color.text,
		-- color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	background = {
		-- color = opts.color.transparent,
		height = 28,
		corner_radius = 9,
		border_width = 2,
		border_color = colors.bg2,
		image = {
			corner_radius = 9,
			border_color = colors.grey,
			border_width = 1,
		},
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.popup.border,
			color = colors.popup.bg,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})
