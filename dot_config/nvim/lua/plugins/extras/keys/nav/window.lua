return {
	"folke/which-key.nvim",
	optional = true,
	keys = {
		{ "<C-h>", "<C-w>h", desc = "Go to left window", noremap = true, silent = true },
		{ "<C-j>", "<C-w>j", desc = "Go to lower window", noremap = true, silent = true },
		{ "<C-k>", "<C-w>k", desc = "Go to upper window", noremap = true, silent = true },
		{ "<C-l>", "<C-w>l", desc = "Go to right window", noremap = true, silent = true },
	},
}
