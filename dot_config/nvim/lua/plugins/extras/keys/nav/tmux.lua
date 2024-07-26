return {
	"alexghergh/nvim-tmux-navigation",
	optional = true,
	keys = {
		{ "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", { noremap = true, desc = "Navigate left" } },
		{ "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", { noremap = true, desc = "Navigate down" } },
		{ "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", { noremap = true, desc = "Navigate up" } },
		{ "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", { noremap = true, desc = "Navigate right" } },
		{ "<C-p>", "<cmd>NvimTmuxNavigateLastActive<cr>", { noremap = true, desc = "Navigate last active" } },
		{ "<C-n>", "<cmd>NvimTmuxNavigateNext<cr>", { noremap = true, desc = "Navigate next" } },
	},
}
