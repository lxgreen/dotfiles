return {
	"nvim-mini/mini.surround",
	optional = true,
	keys = {
		{ "'", [[:<C-u>lua MiniSurround.add('visual')<CR>']], { silent = true }, mode = { "x" } },
		{ '"', [[:<C-u>lua MiniSurround.add('visual')<CR>"]], { silent = true }, mode = { "x" } },
		{ "`", [[:<C-u>lua MiniSurround.add('visual')<CR>`]], { silent = true }, mode = { "x" } },
		{ "]", ":<C-u>lua MiniSurround.add('visual')<CR>]", { silent = true }, mode = { "x" } },
		{ "<leader>}", [[:<C-u>lua MiniSurround.add('visual')<CR>}]], { silent = true }, mode = { "x" } },
		{ "<leader>)", [[:<C-u>lua MiniSurround.add('visual')<CR>)]], { silent = true }, mode = { "x" } },
		{ "<leader>>", [[:<C-u>lua MiniSurround.add('visual')<CR>>]], { silent = true }, mode = { "x" } },
		{ "*", [[:<C-u>lua MiniSurround.add('visual')<CR>*]], { silent = true }, mode = { "x" } },
		{ "_", [[:<C-u>lua MiniSurround.add('visual')<CR>_]], { silent = true }, mode = { "x" } },
		{ "~", [[:<C-u>lua MiniSurround.add('visual')<CR>~]], { silent = true }, mode = { "x" } },
	},
}
