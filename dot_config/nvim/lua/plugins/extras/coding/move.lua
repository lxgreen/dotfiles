return {
	{
		"echasnovski/mini.move",
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
		opts = { skipInsignificantPunctuation = false },
	},
}
