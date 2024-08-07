local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspace = sbar.add("item", "aerospace", {
	position = "left",
	icon = {
		font = { family = settings.font.numbers },
		padding_left = 15,
		padding_right = 8,
		color = colors.white,
		highlight_color = colors.red,
	},
	label = {
		padding_right = 20,
		color = colors.grey,
		highlight_color = colors.white,
		font = "sketchybar-app-font:Regular:16.0",
		y_offset = -1,
	},
	padding_right = 1,
	padding_left = 1,
	background = {
		color = colors.bg1,
		border_width = 1,
		height = 26,
		border_color = colors.black,
	},
})

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

local function highlight_focused_workspace(env)
	sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
		for id in focused_workspace:gmatch("%S+") do
			local is_focused = tostring(id) == focused_workspace:match("%S+")
			sbar.animate("sin", 10, function()
				workspace:set({
					icon = {
						string = id,
						highlight = is_focused,
					},
				})
			end)
		end
	end)
end

-- Subscribe to the front_app_switched event to highlight the focused workspace
workspace:subscribe("front_app_switched", highlight_focused_workspace)

space_window_observer:subscribe("space_windows_change", function(env)
	local icon_line = ""
	local no_app = true
	for app, count in pairs(env.INFO.apps) do
		no_app = false
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["default"] or lookup)
		icon_line = icon_line .. " " .. icon
	end

	if no_app then
		icon_line = " —"
	end
	sbar.animate("sin", 10, function()
		workspace:set({
			label = icon_line,
		})
	end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
