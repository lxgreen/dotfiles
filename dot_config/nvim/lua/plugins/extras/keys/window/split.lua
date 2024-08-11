return {
	"LazyVim/LazyVim",
	optional = true,
	keys = {
		{ "gF", "<cmd>vertical wincmd f<cr>", desc = "Split [f]ile under cursor", noremap = true },
		{ "g.", "<cmd>lua vim.cmd('cd '.. vim.fn.expand('%:p:h'))<cr>", desc = "cd to current file path" },
		{ "g?", "<cmd>pwd<cr>", desc = "CWD", noremap = true },
		{
			"<leader>D",
			function()
				vim.cmd([[ vsplit ]])
				vim.lsp.buf.definition()
			end,
			desc = "Split [d]efinition",
		},
		{
			"<leader>R",
			"<cmd>vs scp://lx@192.168.1.41//home/lx/nextcloud/docker-compose.yml<cr>",
			desc = "Edit Docker Compose",
		},
	},
}
