local sbar = require("sketchybar")
local colors = require("colors")

local icons = {
	en = "ᚤ",
	ru = "ꙋ",
	he = "𐤀",
	unknown = "􀃭",
}

local keyboard_layout = sbar.add("item", "keyboard_layout", {
	icon = { font = { size = 26 }, align = "right" },
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.white
	},
	padding_left = 0,
	padding_right = 4,
	display = "active",
	position = "right",
})

local function update()
	local layout = assert(io.popen("im-select"):read("a"):gsub("%s+", ""))

	local icon = {
		string = icons.unknown,
		color = colors.white,
	}
	
	local label = {
		string = layout,
		color = colors.white,
	}

	if layout == "com.apple.keylayout.ABC" then
		icon.string = icons.en
		icon.color = colors.green
		label.string = "EN"
		label.color = colors.green
	elseif layout == "com.apple.keylayout.Russian-Phonetic" then
		icon.string = icons.ru
		icon.color = colors.red
		label.string = "RU"
		label.color = colors.red
	elseif layout == "com.apple.keylayout.Hebrew" then
		icon.string = icons.he
		icon.color = colors.blue
		label.string = "HE"
		label.color = colors.blue
	else
		label.string = layout
		label.color = colors.white
	end

	sbar.animate("sin", 10, function()
		keyboard_layout:set({ icon = icon, label = label })
	end)
end

local function action()
	local layout = assert(io.popen("im-select"):read("a"):gsub("%s+", ""))
	
	local next_layout = "com.apple.keylayout.ABC"  -- Default to English
	
	if layout == "com.apple.keylayout.ABC" then
		next_layout = "com.apple.keylayout.Russian-Phonetic"
	elseif layout == "com.apple.keylayout.Russian-Phonetic" then
		next_layout = "com.apple.keylayout.Hebrew"
	elseif layout == "com.apple.keylayout.Hebrew" then
		next_layout = "com.apple.keylayout.ABC"
	end
	
	sbar.exec("im-select " .. next_layout)
	update()
end

sbar.add("event", "keyboard_layout_change", "AppleSelectedInputSourcesChangedNotification")
keyboard_layout:subscribe({ "forced", "keyboard_layout_change" }, update)
keyboard_layout:subscribe("mouse.clicked", action)

-- Mouse hover functionality
keyboard_layout:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		keyboard_layout:set({
			label = {
				width = "dynamic"
			}
		})
	end)
end)

keyboard_layout:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		keyboard_layout:set({
			label = {
				width = 0
			}
		})
	end)
end)

return keyboard_layout
