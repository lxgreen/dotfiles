return {
	"Wansmer/sibling-swap.nvim",
	enabled = false,
	dependencies = { "nvim-treesitter" },
	keys = {
		{ "<c-,>", [[<cmd>lua require('sibling-swap').swap_with_left()<cr>]], desc = "Swap argument left" },
		{ "<c-.>", [[<cmd>lua require('sibling-swap').swap_with_right()<cr>]], desc = "Swap argument right" },
	},
	opts = {
		highlight_node_at_cursor = { hl_opts = { link = "Search" } },
		use_default_keymaps = false,
	},
}
