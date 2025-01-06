return {
	optional = true,
	"aaronik/treewalker.nvim",
	keys = {
		{ "<C-k>", "<cmd>Treewalker Up<cr>", desc = "AST Up" },
		{ "<C-j>", "<cmd>Treewalker Down<cr>", desc = "AST Down" },
		{ "<C-l>", "<cmd>Treewalker Right<cr>", desc = "AST Right" },
		{ "<C-h>", "<cmd>Treewalker Left<cr>", desc = "AST Left" },
		{ "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", desc = "AST Swap Down" },
		{ "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", desc = "AST Swap Up" },
		{ "<C-S-l>", "<cmd>Treewalker SwapRight<CR>", desc = "AST Swap Right" },
		{ "<C-S-h>", "<cmd>Treewalker SwapLeft<CR>", desc = "AST Swap Left" },
	},
}
