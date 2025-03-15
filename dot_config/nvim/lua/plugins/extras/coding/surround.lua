return {
	"echasnovski/mini.surround",
	lazy = false,
	vscode = true,
	opts = {
		mappings = {
			add = "'a", -- Add surrounding in Normal and Visual modes
			delete = "'d", -- Delete surrounding
			find = "'f", -- Find surrounding (to the right)
			find_left = "'F", -- Find surrounding (to the left)
			highlight = "'h", -- Highlight surrounding
			replace = "'c", -- Replace surrounding
			update_n_lines = "'n", -- Update `n_lines`

			suffix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},
		n_lines = 300,
	},
}
