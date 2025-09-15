local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

-- Padding item required because of bracket
sbar.add("item", {
	position = "right",
	width = settings.group_paddings,
})

local cal = sbar.add("item", {
	icon = {
		string = icons.calendar,
		color = colors.white,
		padding_left = 8,
		font = {
			size = 14.0,
		},
	},
	label = {
		color = colors.white,
		padding_right = 8,
		width = 100,
		align = "right",
		font = {
			family = settings.icons,
		},
	},
	position = "right",
	update_freq = 1,
	padding_left = 1,
	padding_right = 1,
	background = {
		color = colors.bg2,
		border_color = colors.rainbow[#colors.rainbow],
		border_width = 1,
	},
})

-- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
--   background = {
--     color = colors.transparent,
--     height = 30,
--     border_color = colors.grey,
--   }
-- })

-- Padding item required because of bracket
sbar.add("item", {
	position = "right",
	width = settings.group_paddings,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({
		icon = icons.calendar,
		label = os.date("%m/%d %H:%M:%S"),
	})
end)
