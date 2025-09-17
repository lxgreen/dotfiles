local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")

local vpn = sbar.add("item", "vpn", {
	icon = { font = { size = 22 }, string = icons.vpn_off, color = colors.yellow },
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		color = colors.white,
	},
	padding_left = 0,
	padding_right = 4,
	position = "right",
	display = "active",
	update_freq = 30,
})

local function update()
	local icon = { font = { size = 22 }, string = icons.vpn_off, color = colors.yellow }
	local label = { string = "", color = colors.white }

	-- Use the new VPN monitor script for accurate GlobalProtect state detection
	local command = "$CONFIG_DIR/helpers/vpn_monitor.sh"

	-- Running command and capturing output
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()

	-- Parse the state from the output
	local state = result:match("(%w+)")
	if state == "connected" then
		icon.color = colors.green
		icon.string = icons.vpn_on
		label.string = "VPN ON"
		label.color = colors.green
	else
		icon.color = colors.red
		icon.string = icons.vpn_off
		label.string = "VPN OFF"
		label.color = colors.red
	end

	sbar.animate("sin", 10, function()
		vpn:set({ label = label, icon = icon })
	end)
end

-- Subscribe to real-time VPN state changes
vpn:subscribe({ "forced", "routine", "vpn_update", "update", "vpn_state_changed" }, update)

-- Mouse hover functionality
vpn:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		vpn:set({
			label = {
				width = "dynamic",
			},
		})
	end)
end)

vpn:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		vpn:set({
			label = {
				width = 0,
			},
		})
	end)
end)

-- Set up periodic VPN state monitoring (every 10 seconds)
-- This provides near real-time detection without complex daemon management
sbar.exec("while true; do $CONFIG_DIR/helpers/vpn_monitor.sh; sleep 10; done &")

return vpn
