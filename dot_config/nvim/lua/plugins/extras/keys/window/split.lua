return {
	"LazyVim/LazyVim",
	optional = true,
	keys = {
		{ "gF", "<cmd>vertical wincmd f<cr>", desc = "Open [f]ile under cursor in split", noremap = true },
		{ "g.", "<cmd>lua vim.cmd('cd '.. vim.fn.expand('%:p:h'))<cr>", desc = "cd to current file path" },
		{ "g?", "<cmd>pwd<cr>", desc = "CWD", noremap = true },
		{
			"<leader>D",
			function()
				vim.cmd([[ vsplit ]])
				vim.lsp.buf.definition()
			end,
			desc = "Go to [D]efinition in split",
		},
		{
			"<leader>W",
			function()
				if vim.fn.exists(":EslintFixAll") > 0 then
					vim.cmd("EslintFixAll")
					vim.cmd("noa write")
				end
				vim.cmd("write")
			end,
			desc = "Fix and [W]rite",
		},
	},
}
