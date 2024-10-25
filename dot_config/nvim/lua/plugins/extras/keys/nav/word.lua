return {
	"chrisgrieser/nvim-spider",
	optional = true,
	keys = {
		{ "w", "<cmd>lua require('spider').motion('w')<CR>", desc = "word-wise-w", mode = { "n", "o", "x" } },
		{ "e", "<cmd>lua require('spider').motion('e')<CR>", desc = "word-wise-e", mode = { "n", "o", "x" } },
		{ "b", "<cmd>lua require('spider').motion('b')<CR>", desc = "word-wise-b", mode = { "n", "o", "x" } },
		{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "word-wise-ge", mode = { "n", "o", "x" } },
	},
}
