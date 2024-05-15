local sbar = require("sketchybar")

local function exec_cmd(cmd, callback)
	sbar.exec(cmd, function(result)
		if callback then
			callback(result)
		end
	end)
end

local function update_session()
	exec_cmd('tmux list-sessions -F "#S"', function(sessions)
		for _, session in ipairs(sessions) do
			local item_name = "tmux." .. session
			if not sbar.has_item(item_name) then
				sbar.add("item", item_name, {
					position = "left",
					background = {
						color = 0x44ffffff,
						corner_radius = 5,
						height = 20,
						drawing = false,
					},
					label = session,
					script = "tmux attach -t " .. session,
					on_click = function()
						exec_cmd("tmux switch-client -t " .. session)
					end,
				})
			end
		end
	end)
end
