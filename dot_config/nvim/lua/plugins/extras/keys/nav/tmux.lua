return {
	"alexghergh/nvim-tmux-navigation",
	optional = true,
	keys = {
		{ "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", noremap = true, desc = "Navigate left", mode = { "n", "t" } },
		{ "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", noremap = true, desc = "Navigate down", mode = { "n", "t" } },
		{ "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", noremap = true, desc = "Navigate up", mode = { "n", "t" } },
		{ "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", noremap = true, desc = "Navigate right", mode = { "n", "t" } },
		{
			"<C-p>",
			"<cmd>NvimTmuxNavigateLastActive<cr>",
			noremap = true,
			desc = "Navigate last active",
			mode = { "n", "t" },
		},
		{ "<C-n>", "<cmd>NvimTmuxNavigateNext<cr>", noremap = true, desc = "Navigate next", mode = { "n", "t" } },
	},
}
