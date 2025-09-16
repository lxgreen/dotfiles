local sbar = require("sketchybar")
local colors = require("colors")

local icons = {
	normal = "ℕ",
	insert = "𝕀",
	visual = "𝕍",
	cmd = "ℂ",
	pending = "􀈏",
}

local svim = sbar.add("item", "svim", {
	icon = {
		align = "right",
		font = { size = 22 },
		padding_left = 0,
		padding_right = 4,
	},
	label = {
		align = "left",
		font = { size = 16 },
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.white,
	},
	padding_left = 0,
	padding_right = 4,
	updates = true,
	position = "right",
	display = "active",
})

local function update(ENV)
	local icon = { string = "", color = colors.white }
	local label = { string = "", color = colors.white, width = 0 }

	if ENV.MODE == "I" then
		icon.string = icons.insert
		icon.color = colors.green
		label.string = ""
		label.width = 0
	elseif ENV.MODE == "N" then
		icon.string = icons.normal
		icon.color = colors.blue
		label.string = ""
		label.width = 0
	elseif ENV.MODE == "V" then
		icon.string = icons.visual
		icon.color = colors.magenta
		label.string = ""
		label.width = 0
	elseif ENV.MODE == "C" then
		icon.string = icons.cmd
		icon.color = colors.orange
		label.string = ENV.CMDLINE or ""
		label.color = colors.orange
		label.width = "dynamic"
	elseif ENV.MODE == "_" then
		icon.string = icons.pending
		label.string = ""
		label.width = 0
	end

	sbar.animate("sin", 10, function()
		svim:set({ icon = icon, label = label })
	end)
end

svim:subscribe({ "svim_update", "window_focus" }, update)

return svim
