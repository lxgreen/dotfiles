return {
	"chrisgrieser/nvim-spider",
	optional = true,
	keys = {
		{ "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "word-wise-w" } },
		{ "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "word-wise-e" } },
		{ "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "word-wise-b" } },
		{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "word-wise-ge" } },
	},
}
