local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")

local npm_registry = sbar.add("item", "npm_registry", {
	icon = { font = { size = 16.0 }, string = "📦", color = colors.blue },
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.white,
		font = {
			size = 10.0
		}
	},
	padding_left = 0,
	padding_right = 4,
	position = "right",
	display = "active",
	update_freq = 30, -- Check every 30 seconds
})

local function get_current_registry()
	local handle = io.popen("npm config get registry 2>/dev/null")
	local registry = handle:read("*a"):gsub("%s+", "")
	handle:close()
	return registry
end

local function update()
	local registry = get_current_registry()
	local icon = { font = { size = 16.0 }, color = colors.blue }
	local label = { string = registry, color = colors.white }

	-- Determine registry type and set appropriate icon/color
	if registry:match("wixpress%.com") then
		icon.string = "􀀰" -- SF Symbol for Wix private registry
		icon.color = colors.green
		label.color = colors.green
	elseif registry:match("npmjs%.org") or registry == "" then
		icon.string = "􀆪" -- SF Symbol for public registry
		icon.color = colors.orange
		label.color = colors.orange
	else
		icon.string = "❓" -- Unknown registry
		icon.color = colors.red
		label.color = colors.red
	end

	sbar.animate("sin", 10, function()
		npm_registry:set({ label = label, icon = icon })
	end)
end

local function switch_registry()
	local current_registry = get_current_registry()

	if current_registry:match("wixpress%.com") then
		-- Switch to public registry
		sbar.exec("npm config set registry https://registry.npmjs.org")
		sbar.exec("echo 'Switched to public npm registry'")
	else
		-- Switch to Wix private registry
		sbar.exec("npm config set registry http://npm.dev.wixpress.com")
		sbar.exec("echo 'Switched to Wix private npm registry'")
	end

	-- Wait a moment for the registry change to take effect, then update
	sbar.exec("sleep 0.1 && sketchybar --trigger npm_registry_update")
end

-- Subscribe to events
npm_registry:subscribe({ "forced", "routine", "npm_registry_update", "update" }, update)
npm_registry:subscribe("mouse.clicked", switch_registry)

-- Mouse hover functionality
npm_registry:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		npm_registry:set({
			label = {
				width = "dynamic",
			},
		})
	end)
end)

npm_registry:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		npm_registry:set({
			label = {
				width = 0,
			},
		})
	end)
end)

-- Initialize the widget
sbar.exec("sleep 2 && sketchybar --trigger npm_registry_update")

return npm_registry
