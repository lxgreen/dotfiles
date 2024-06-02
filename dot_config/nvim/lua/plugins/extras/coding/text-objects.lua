return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"echasnovski/mini.ai",
		},
		build = ":TSUpdate",
		opts = {
			-- enable indentation
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "vv",
					node_incremental = ".",
					scope_incremental = ",",
					node_decremental = "<esc>",
				},
			},
		},
	},
}
