local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")

local vpn = sbar.add("item", {
	icon = { font = { size = 26 }, string = icons.trigrams.fire, color = colors.yellow },
	position = "right",
	update_freq = 10 * 60,
})

local function update()
	local icon = { font = { size = 26 }, string = icons.trigrams.fire, color = colors.yellow }
	local label = { string = "", color = colors.white, drawing = true }

	sbar.animate("sin", 10, function()
		vpn:set({ label = label, icon = icon })
	end)

	local command = "curl --connect-timeout 3 -f --silent --output /dev/null 'https://bo.wix.com'"

	-- Running command and capturing exit code
	local handle = io.popen(command .. "; echo $?")
	local result = handle:read("*a")
	handle:close()

	-- Extracting the exit code from the output
	local exit_code = tonumber(result)

	if exit_code == 0 then
		icon.color = colors.green
		icon.string = icons.trigrams.heaven
	else
		icon.color = colors.red
		icon.string = icons.trigrams.earth
	end

	sbar.animate("sin", 10, function()
		vpn:set({ label = label, icon = icon })
	end)
end

vpn:subscribe({ "forced", "routine", "vpn_update", "update" }, update)
vpn:subscribe("mouse.clicked", update)

return vpn
