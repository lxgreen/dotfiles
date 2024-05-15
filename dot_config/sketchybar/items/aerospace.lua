local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Helper function to handle async command execution and response
local function exec_cmd(cmd, callback)
	sbar.exec(cmd, function(result)
		if callback then
			callback(result)
		end
	end)
end

-- Function to update workspace items
local function update_workspaces()
	exec_cmd("aerospace list-workspaces --all", function(result)
		local workspaces = result -- Assuming `result` is JSON formatted and parsing is needed
		for _, ws in ipairs(workspaces) do
			local item_name = "space." .. ws.id
			if not sbar.has_item(item_name) then
				sbar.add("item", item_name, {
					position = "left",
					background = {
						color = 0x44ffffff,
						corner_radius = 5,
						height = 20,
						drawing = false,
					},
					label = ws.id,
					script = "~/.config/sketchybar/plugins/aerospace.sh " .. ws.id,
					on_click = function()
						exec_cmd("aerospace workspace " .. ws.id)
					end,
				})
			end
		end
	end)
end

-- Subscribe to workspace change events
sbar.add("event", "aerospace_workspace_change")
sbar.subscribe("aerospace_workspace_change", update_workspaces)

-- Initial call to setup workspace items
update_workspaces()
