local function header_colorize(header)
	local lines = {}

	for i, chars in pairs(header) do
		local line = {
			type = "text",
			val = chars,
			opts = {
				hl = "FlashLabel",
				position = "center",
			},
		}

		table.insert(lines, line)
	end

	return lines
end

local function button(sc, icon, text, keybind)
	return {
		type = "button",
		val = text,
		opts = {
			position = "center",
			shortcut = "▌ " .. icon .. " ▐",
			cursor = 40,
			keymap = { "n", sc, keybind, {} },
			width = 42,
			align_shortcut = "right",
			hl = "FlashLabel",
			hl_shortcut = "NeogitDiffAddHighlight",
		},
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
			vim.api.nvim_feedkeys(key, "t", false)
		end,
	}
end

local buttons_wrap = function(border)
	return {
		type = "text",
		val = string.rep(" ", 37) .. border,
		opts = { position = "center", hl = "FlashLabel" },
	}
end

local header_text = {
	[[	⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀        ⢀⣀⣤⣤⣴⢉⣿⠙⢦⡒⠛⠉⠓⢶⣄⣀⣀⣀⣀⣤⠤⠦⠶⠒⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
	[[	⠀⠀⠀⠀⣀⣀⣀⣤⣄⣄⣄⣄⣄⣄⣤⣤⣤⣄⣄⣤⣤⣤⣤⣀⣤⣤⣤⢤⣤⣶⠋⠁⠀⣤⠋⣤⣯⠀⠀⠀⠛⣯⢿⠶⠉⠉⠀⣽⣦⣀⣀⣀⣤⣤⣄⣤⣤⠿⠿⣶⣤⣤⣀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⢀⡀⠀⠀⠀⠀⠀]],
	[[	⠀⠀⠀⠀⢒⣒⣒⢒⣒⣚⣒⣒⣒⣛⣒⣛⣛⣒⣒⣛⣛⣉⣉⣉⣛⣭⣭⠿⠒⠛⣉⣉⣭⢖⣿⠀⠀⠻⣄⢀⣤⣬⡛⠶⠶⠒⠛⠀⠻⣤⣭⣿⣶⢛⣶⠶⣶⡖⢦⢤⣤⣬⣉⣛⡛⠲⠶⠤⠤⠤⠤⢤⠤⢤⠤⠤⠤⢤⠤⠤⢤⢤⢤⣥⣭⣥⣭⠀⠀⠀]],
	[[	⠀⠀⠀⠀⠶⠶⠶⠶⠦⠶⠶⠶⠶⠶⠶⠒⠶⠶⠶⠶⠶⠶⠶⠒⠒⣶⣚⣛⣟⣭⣤⠛⣿⠿⠀⣶⠀⠀⣙⣦⠀⠀⠉⠛⠳⢦⣤⣄⣴⠶⣤⣤⠶⠋⠀⠀⣀⣉⣿⠛⠛⠛⠒⢦⢤⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣍⣭⣭⣭⣭⣉⣭⣭⣭⣉⠀⠀⠀]],
	[[	⠀⠀⠀⠠⣭⣥⢥⠭⠭⠭⣥⠭⣥⣭⣭⠭⢭⣭⣥⣥⠯⠿⠻⠛⠓⢒⣒⣛⣯⠟⣴⠋⠙⣦⠿⠀⣹⣛⠀⠉⠛⠛⣭⣉⣉⠛⠲⣤⣤⣤⣤⠤⠞⠛⠉⠉⠀⠀⠉⢿⣍⣛⣯⣭⣭⣉⣩⣽⣉⣋⣛⣛⣉⣉⣋⣉⣉⣉⣉⣙⣙⣓⣚⣛⢛⠛⠓⠀⠀⠀]],
	[[	⠀⠀⠀⠀⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣍⣭⣍⣭⢭⠯⢤⠖⠒⠋⣽⠃⣤⣤⣤⢴⠋⠀⢀⣽⣶⣤⠞⠓⢶⣭⠋⠉⠁⠀⣴⠾⢭⣍⠉⠙⣿⣿⣶⣤⣤⣤⣤⣤⣉⣉⣉⣛⠋⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠶⠖⠦⠶⠦⠦⠀⠀⠀]],
	[[	⠀⠀⠀⠀⠚⠚⠛⣒⢚⢛⣛⣛⠒⠛⣛⠛⠛⢚⠛⢛⣛⣒⣛⣛⣭⣭⣭⢭⡿⣵⠛⠀⠀⠀⣤⣶⣞⠁⠀⢉⣛⢶⣶⠚⠋⠛⠻⣯⠿⠁⠀⠀⠙⣿⢉⣀⠀⠀⠉⠿⣶⣚⣛⣶⠲⠶⠶⠶⠶⠶⠶⠶⠶⠦⣤⢤⢤⢤⠤⠤⢤⢤⢭⢥⣭⣭⣭⠀⠀⠀]],
	[[	⠀⠀⠀⠀⠶⠶⠶⠶⠒⠲⠶⠶⠶⠒⠒⠒⣶⣶⠶⠒⠒⠒⠚⢋⣉⣉⡽⠓⠋⢠⠖⠋⠛⠿⣾⠁⠙⣶⠛⠉⣠⣭⣷⣭⣽⢯⠭⢥⣤⣄⡀⣤⠶⠋⠉⣿⠛⢿⠉⠉⠓⠚⠿⣷⡳⢯⣭⣭⣭⣭⣭⣭⣉⣭⣭⣭⣍⣭⣭⣭⣉⣭⣉⣉⣉⣉⣉⠀⠀⠀]],
	[[	⠀⠀⠀⠨⢭⣭⢭⣭⣭⢭⣭⣭⢭⢭⢥⣭⣤⢤⣤⣤⡤⠶⢤⢤⢤⠶⠒⣒⣿⠋⣀⣴⠛⠉⠀⠀⣴⢿⡉⠙⣦⣶⠋⠀⠹⣷⠶⣤⣤⣀⣈⣤⣴⣖⠋⠀⠀⠀⠉⠻⣶⡤⠦⠤⣤⣭⣍⣋⣿⣛⣛⣛⣛⣛⣛⣛⣓⣛⣒⣒⣒⡒⢒⣒⣒⣒⢒⠀⠀⠀]],
	[[	⠀⠀⠀⢀⣋⣛⣋⣉⣉⣉⣉⣭⣭⣉⣉⣉⣉⣉⣭⣉⣭⣭⣭⣭⠿⠟⢛⣽⠛⠉⢀⣶⢋⣿⠛⡿⠀⠀⠛⣿⡁⠀⠀⠀⠀⠻⣍⣤⣤⣀⠀⣤⠶⣬⠲⣟⠲⢴⠶⢦⣤⣉⣻⢯⣭⣭⣲⣒⣒⣒⣒⠒⠒⠒⠒⠒⠒⠲⠖⠒⠒⠲⠖⠶⠶⠶⢦⠀⠀⠀]],
	[[	⠀⠀⠀⠐⠒⠒⣒⠶⠒⠒⠒⠒⠒⢒⠒⠒⢒⢒⢒⣛⠛⢒⣋⣉⣉⣭⣥⣶⣾⠛⠉⠀⣿⠈⣟⠀⠀⠀⣼⠁⠁⣿⣀⡀⠀⠀⠀⠛⣦⠀⢁⣀⣤⠒⢿⣉⠉⠶⣶⣤⣤⣀⣀⣉⠛⠶⠶⠦⠤⠤⢤⠦⠤⢤⢤⢤⢤⢤⣤⣤⣤⣤⣄⣤⣉⣭⣭⠀⠀⠀]],
	[[	⠀⠀⠀⠠⠤⠦⠦⠶⠶⠶⠶⠶⠶⠦⠴⠴⠦⠤⠦⢖⢶⣴⣒⣒⣚⣖⣿⠉⠀⠀⣠⣿⠁⠀⢻⣤⣴⠋⢰⠛⢶⣀⠙⣤⠙⢶⣶⠋⠙⣯⣭⣤⣤⣤⠶⠛⠛⣯⣤⣬⣿⣖⣚⠲⠓⢯⣭⣭⣭⣭⣭⣭⣍⣍⣭⣭⣭⣉⣉⣉⣉⣙⣉⣉⣭⣉⣉⠀⠀⠀]],
	[[	⠀⠀⠀⢈⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣭⣤⣤⣤⣤⢤⣤⠶⢒⠒⣛⣭⣤⡿⠀⠀⠀⣿⠀⣿⠋⠀⠀⢿⣿⣤⣿⢶⣤⣄⣀⣀⠉⢳⣦⣤⣤⣄⣤⣤⣀⠀⠀⠀⠙⠿⢯⣯⣏⣭⣉⣋⣉⣛⣛⣛⣛⣛⣛⣚⣚⣒⣒⠓⠒⢒⠒⠶⠒⠀⠀⠀]],
	[[	⠀⠀⠀⠐⣙⢛⣛⣛⣛⣛⣿⣛⡛⠛⠛⠛⠚⣛⣛⢛⢉⢉⠉⣀⣀⣤⣤⣤⣦⣴⣿⠁⠀⠀⠀⠈⣿⢠⡟⣦⠀⠀⠙⠶⠶⢿⣷⣴⣶⣄⣿⠉⠀⠈⢿⠛⠋⠶⠾⣿⣭⣟⣒⣶⣛⣛⣲⠒⠒⢒⠒⠶⠲⠦⠶⠦⠤⠦⠴⠦⠶⠤⠶⠶⠶⢤⠄⠀⠀⠀]],
	[[	⠀⠀⠀⢀⠒⠒⠒⠒⠲⣒⠒⠶⠶⠶⠶⠶⠶⠶⠖⠋⣓⣶⣛⣉⣉⣉⣭⠴⠛⣡⠏⠀⠀⠀⣠⠟⣯⣿⠀⠈⣦⠀⣀⣠⣄⠀⠀⠉⠛⠉⠀⠀⠀ ⠀⠀⢻⣤⣤⣀⣀⠀⠀⠙⢶⣶⣤⣤⡴⣤⣤⣤⣤⣤⣭⣭⢿⣤⣭⣭⣭⣭⣉⣭⣭⣭⣉⣉⠀⠀⠀]],
	[[	⠀⠀⠀⢠⣥⣭⣭⣭⣭⣤⣥⣥⣭⣭⣭⣭⣭⣭⣭⠿⠶⣤⢤⠶⠶⢒⠒⣿⣭⠋⠀⣴⡀⣤⠃⠀⣼⠁⠀⠀⠈⣿⠀⠀⠈⢳⣤⣤⣀⣀⣀⣀⣀⣀⣤⣀⣭⣷⣶⣤⣍⠛⠛⠶⠶⢦⣬⣍⣭⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣛⣛⣛⡃⠀⠀⠀]],
	[[	⠀⠀⠀⢈⣉⣉⣉⣉⣉⣉⣉⣉⣽⣭⣉⣛⣛⣛⣿⣿⣭⣯⣭⠿⠓⠛⣉⡶⠉⠀⣿⠀⠙⣤⣴⠉⠁⠀⠀⠀⣀⣬⣿⣶⣶⣶⣤⣭⣿⣾⢟⣿⣶⣖⣿⠿⣤⠀⠀⠉⠻⣿⣯⣯⣾⣒⣒⣒⣒⠒⢒⠒⠒⠒⠒⠒⠲⠶⠖⠒⠒⠒⠲⠶⠶⠶⠆⠀⠀⠀]],
	[[	⠀⠀⠀⠠⠶⠶⠒⠒⠚⠚⠒⠒⢒⣖⠒⠚⠒⠶⢒⣋⠉⠉⣉⢉⣩⣭⣥⣤⢾⡟⠀⠀⠀⠉⠻⣦⣶⠓⣾⣟⠉⠀⠀⠀⠈⢻⣤⣤⠿⠛⠉⠀⠈⠉⣀⣾⠿⣿⠛⠛⣦⣤⣤⣉⣉⣛⠳⠶⠶⠦⠤⠤⠤⢤⣤⠴⠴⠦⢤⠤⢤⢭⢤⣤⣤⣤⣤⠀⠀⠀]],
	[[	⠀⠀⠀⢠⣤⣤⣤⣤⠦⠦⠦⠤⠤⢭⢤⢴⣤⢤⢤⣤⣤⣤⠶⠶⠒⢚⣛⣿⣋⣤⠶⠛⠉⠉⠉⢀⡶⠋⠀⢀⡟⠙⣶⡶⢤⣤⣀⢉⣙⣳⠴⠶⠒⠉⠀⠀⠀⠀⠙⣿⣶⣶⣦⣤⣤⣤⣤⣭⣭⣭⣭⣭⣍⣭⣍⣭⣉⣍⣭⣭⣉⣍⣉⣉⣉⣭⣉⠀⠀⠀]],
	[[	⠀⠀⠀⢈⣉⣉⣉⣉⣍⣭⣥⣭⣍⣭⣭⣉⣉⣍⣉⣭⣭⣭⣭⠿⠷⢚⣿⠟⠁⠀⠀⠀⣀⣤⠞⣭⣤⢀⣴⠛⠙⣦⠀⠙⣦⣤⣤⣀⣀⣤⣍⠋⠛⠛⠋⠉⠉⠛⠛⢶⣭⣽⣛⢷⣭⣽⣿⣛⣛⣛⣛⣛⣛⣛⣛⣛⣒⢚⣒⣒⣒⠒⣒⣒⠒⢒⣒⠀⠀⠀]],
	[[	⠀⠀⠀⢰⢲⠒⠒⣒⣒⣒⣚⠒⠒⢚⣚⢒⣚⠛⣒⠚⣋⣉⣉⣉⣉⣤⣤⢤⣴⢿⣿⠛⠉⢛⣿⠘⣇⣽⠃⠀⠀⠙⣦⠀⠀⠀⠉⠛⠒⠶⠛⠉⠙⢛⣭⡿⠛⠒⠚⣦⣀⡀⢀⠉⠉⠻⠒⠲⠒⠒⠶⠲⠶⠶⠶⠶⠶⠶⠶⠶⠶⠦⠦⠶⠶⠦⠄⠀⠀⠀]],
	[[	⠀⠀⠀⠠⠦⠶⢤⡤⣤⡤⠦⠶⠦⠶⠶⢤⠴⠶⠶⠤⠴⠶⢚⣛⣛⣋⣭⣭⢴⣿⠉⠉⠉⣰⠁⠀⢹⣤⣀⠀⣤⣤⣤⠻⣟⣲⣖⢶⣶⣴⣶⣛⣉⣭⣤⣤⣤⣤⣤⣤⠉⠛⠶⣿⣟⠷⠧⣥⠵⢥⣭⣥⡭⣭⣭⣭⣭⣭⣥⣤⣭⣤⣥⣥⣭⣭⣅⠀⠀⠀]],
	[[	⠀⠀⠀⢨⣭⣭⣭⣭⣭⣭⣭⣭⣉⣉⣉⣭⠯⣭⣭⢯⣭⠧⠷⠶⠶⠒⠒⠋⢁⠀⣀⣤⣾⣿⠀⠀⠀⣿⠈⠛⣦⡀⢀⣙⠳⢶⣬⣿⠳⢶⣶⠿⠋⠉⠀⠀⠈⠻⣤⠀⠉⠙⠓⠶⣤⣤⣌⣍⣍⣯⣯⣋⣋⣋⣋⣋⣛⣋⣛⣋⣛⣓⣋⣛⣛⣛⡂⠀⠀⠀]],
	[[	⠀⠀⠀⢘⢒⢚⢛⢒⠚⠚⢚⢛⣋⣋⣛⣚⣒⣒⣶⣾⣶⣯⠿⣯⣭⠯⠯⠿⠛⣉⣿⡿⣿⠀⠀⠀⠀⠘⣆⣤⣤⣭⣻⣤⡛⢦⣦⠦⢬⣥⣀⣤⣤⣴⣤⣤⣤⠦⣤⠉⠛⢿⣿⣿⣿⣒⡒⢒⠒⢒⠒⠒⠒⠒⠲⠲⠲⠒⠲⠲⠒⠒⠶⠒⠒⠒⠆⠀⠀⠀]],
	[[	⠀⠀⠀⠐⠶L  O  V  E    W  I  L  L    T  E  A  R    U  S    A  P  A  R  T    A  G  A  I  N⣭⡅⠀⠀⠀]],
	[[	⠀⠀⠀⢩⣭⣭⣭⣭⣅⣭⣭⣭⣭⣭⣭⣥⣭⣭⣥⣭⣥⣭⠾⠒⠒⠒⠛⠉⣉⠟⣠⠋⣰⢻⡋⠙⣶⡖⠲⣿⠀⠈⣿⠀⠉⢷⣄⠀⠀⠀⢀⣤⠀⢀⣀⣠⣼⣿⢿⣿⠒⠒⠶⢦⣭⣍⣭⣍⣍⣍⣭⣉⣭⣭⣉⣉⣉⣛⣉⣉⣉⣉⣉⣉⣉⣓⡀⠀⠀⠀]],
	[[	⠀⠀⠀⢈⣉⣋⣋⣛⣋⣋⢋⢛⣋⣋⣋⣋⣋⣛⣛⣉⣭⣭⣭⠯⣭⢯⣶⣿⠟⠋⣤⢾⠋⠀⠻⣄⠀⠉⢿⡟⠀⠀⠙⣶⣤⣤⡀⣉⡿⠚⠉⠀⠈⢷⣯⡀⠀⠈⠙⠚⣯⣿⣿⣿⣍⣍⣛⡚⠛⠛⠛⠓⠒⠒⠒⠒⠒⠒⠲⠒⠒⠒⠒⠒⠒⠒⠂⠀⠀⠀]],
}

local section = {
	header = {
		type = "group",
		opts = { position = "center" },
		val = header_colorize(header_text),
	},
	buttons = {
		type = "group",
		opts = { lh = "AlphaButtons" },
		val = {
			button("l", "L", "󰒲  Lazy", "<cmd>Lazy<cr>"),
			button("x", "X", "󰏗  Extras", "<cmd>LazyExtras<cr>"),
			button("c", "C", "  Config", "<cmd>e ~/.config/nvim/<cr>"),
			button("q", "Q", "  Quit", "<cmd>qa<cr>"),
		},
	},
	footer = {
		type = "text",
		opts = { position = "center", hl = "AlphaFooter" },
		val = "",
	},
}

return {
	"goolord/alpha-nvim",
	opts = function(_, opts)
		opts.section = section
		opts.opts = {
			layout = {
				{ type = "padding", val = 1 },
				section.header,
				buttons_wrap("▁▁▁▁▁"),
				section.buttons,
				buttons_wrap("▔▔▔▔▔"),
				{ type = "padding", val = 1 },
				section.footer,
			},
		}

		if LazyVim.has("fzf-lua") then
			table.insert(
				opts.section.buttons.val,
				#opts.section.buttons.val - 2,
				button("f", "F", "  Find file", "<cmd>FzfLua files<cr>")
			)

			local pick = function()
				if LazyVim.pick.picker.name == "telescope" then
					return vim.cmd("Telescope projects")
				elseif LazyVim.pick.picker.name == "fzf" then
					local fzf_lua = require("fzf-lua")
					local history = require("project_nvim.utils.history")
					local results = history.get_recent_projects()
					fzf_lua.fzf_exec(results, {
						actions = {
							["default"] = {
								function(selected)
									fzf_lua.files({ cwd = selected[1] })
								end,
							},
						},
					})
				end
			end

			table.insert(
				opts.section.buttons.val,
				#opts.section.buttons.val - 2,
				button("p", "P", " " .. " Projects", pick)
			)
		end

		table.insert(
			opts.section.buttons.val,
			#opts.section.buttons.val - 2,
			button("r", "R", "  Recent files", [[<cmd>Telescope smart_open theme=dropdown previewer=false<cr>]])
		)

		if LazyVim.has("persistence.nvim") then
			table.insert(
				opts.section.buttons.val,
				#opts.section.buttons.val - 2,
				button("s", "S", "  Restore Session", [[<cmd>lua require("persistence").load()<cr>]])
			)
		end
	end,
}
