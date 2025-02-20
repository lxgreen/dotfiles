return {
	{
		"lewis6991/satellite.nvim",
		enabled = false,
		opts = {
			current_only = true,
			zindex = 30,
			handlers = { diagnostic = { enable = false } },
			excluded_filetypes = {
				"alpha",
				"neo-tree",
				"snacks_picker_list",
				"neotest-summary",
				"aerial",
				"noice",
				"chatgpt-input",
				"neo-tree-preview",
			},
		},
	},
}
