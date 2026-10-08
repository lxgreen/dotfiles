return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
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
				picker = "snacks_picker",
				snacks_picker = {
					layout = {
						preset = "ivy",
					},
				},

				lsp = {
					-- `config` is passed to `vim.lsp.start_client(config)`
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
						-- on_attach = ...
						-- etc, see `:h vim.lsp.start_client()`
					},

					auto_attach = {
						enabled = true,
						filetypes = { "markdown" },
					},
				},
			})
		end,
	},
	{ "OXY2DEV/markview.nvim", enabled = false },
	{
		"yousefhadder/markdown-plus.nvim",
		ft = { "markdown" },
		opts = {
			enabled = true,
			filetypes = { "markdown" },
			features = {
				links = true,
				list_management = true,
				table = true,
				text_formatting = true,
				thematic_break = true,
				images = true,
				headers_toc = true,
				quotes = true,
				callouts = true,
				code_block = true,
				html_block_awareness = true,
				footnotes = true,
			},
			keymaps = {
				enabled = true,
			},
			table = {
				enabled = true,
				auto_format = true,
				default_alignment = "left",
				confirm_destructive = true,
				keymaps = {
					enabled = true,
					prefix = "<localleader>t",
					insert_mode_navigation = true,
				},
			},
			list = {
				smart_outdent = true,
				checkbox_completion = {
					enabled = true,
					format = "emoji",
					date_format = "%Y-%m-%d",
					remove_on_uncheck = true,
					update_existing = true,
				},
			},
			links = {
				smart_paste = {
					enabled = true,
					timeout = 5,
				},
			},
		},
	},
}
