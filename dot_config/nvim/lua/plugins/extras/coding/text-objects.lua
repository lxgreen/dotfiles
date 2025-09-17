return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-mini/mini.ai",
		},
		build = ":TSUpdate",
		opts = {
			-- enable indentation
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "vv",
					node_incremental = "<Up>",
					node_decremental = "<Down>",
				},
			},
		},
	},
}
