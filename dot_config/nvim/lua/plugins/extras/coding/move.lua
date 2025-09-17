return {
	{
		"nvim-mini/mini.move",
		vscode = true,
		event = "LazyFile",
		opts = {
			mappings = {
				-- Move visual selection in Visual mode.
				left = "[k",
				right = "]k",
				down = "]l",
				up = "[l",

				-- Move current line in Normal mode
				line_left = "[k",
				line_right = "]k",
				line_down = "]l",
				line_up = "[l",
			},

			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		},
	},
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		vscode = true,
		dependencies = {
			"theHamsta/nvim_rocks",
			build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
			config = function()
				require("nvim_rocks").ensure_installed("luautf8")
			end,
		},
		opts = {
			skipInsignificantPunctuation = true,
			consistentOperatorPending = false,
			subwordMovement = true,
			customPatterns = {},
		},
	},
}
