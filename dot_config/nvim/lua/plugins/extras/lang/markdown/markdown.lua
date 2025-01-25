return {
	{
		"MeanderingProgrammer/markdown.nvim",
		enabled = false,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("markview").setup({
				preview = {
					modes = { "n", "no", "c" },
					hybrid_modes = { "n" },
					callbacks = {
						on_enable = function(_, win)
							vim.wo[win].conceallevel = 2
							vim.wo[win].concealcursor = "c"
						end,
					},
				},
			})
		end,
	},
	{
		"aspeddro/slides.nvim",
		ft = { "markdown" },
		config = function()
			require("slides").setup({})
		end,
	},
	{
		"zk-org/zk-nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("zk").setup({
				-- can be "telescope", "fzf" or "select" (`vim.ui.select`)
				-- it's recommended to use "telescope" or "fzf"
				picker = "telescope",

				lsp = {
					-- `config` is passed to `vim.lsp.start_client(config)`
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
						-- on_attach = ...
						-- etc, see `:h vim.lsp.start_client()`
					},

					-- automatically attach buffers in a zk notebook that match the given filetypes
					auto_attach = {
						enabled = true,
						filetypes = { "markdown" },
					},
				},
			})
		end,
	},
}
