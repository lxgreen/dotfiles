local sbar = require("sketchybar")
local colors = require("colors")

local icons = {
	en = "ᚤ",
	ru = "ꙋ",
	he = "𐤀",
	unknown = "􀃭",
}

local keyboard_layout = sbar.add("item", {
	icon = { font = { size = 26 }, align = "right" },
	padding_left = 0,
	padding_right = 0,
	display = "active",
	position = "right",
})

local function update()
	local layout = assert(io.popen("im-select"):read("a"):gsub("%s+", ""))

	local icon = {
		string = icons.unknown,
		color = colors.white,
	}

	if layout == "com.apple.keylayout.ABC" then
		icon.string = icons.en
		icon.color = colors.green
	elseif layout == "com.apple.keylayout.Russian-Phonetic" then
		icon.string = icons.ru
		icon.color = colors.red
	elseif layout == "com.apple.keylayout.Hebrew" then
		icon.string = icons.he
		icon.color = colors.blue
	end

	sbar.animate("sin", 10, function()
		keyboard_layout:set({ icon = icon })
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

return keyboard_layout
