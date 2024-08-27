return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false, -- gitcommit in LazyGit
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			{
				"petertriho/cmp-git",
				config = function()
					local cmp_git = require("cmp_git")
					cmp_git.setup()
				end,
			},
			{
				"uga-rosa/cmp-dictionary",
				config = function()
					local dict = {
						["*"] = { "/usr/share/dict/words" },
						ft = {
							["markdown"] = { vim.fn.stdpath("config") .. "/lua/dictionaries/wix.names.txt" },
						},
					}

					require("cmp_dictionary").setup({
						paths = dict["*"],
						exact_length = 4,
						first_case_insensitive = true,
						max_number_items = 1000,
					})

					vim.api.nvim_create_autocmd("BufWinEnter", {
						pattern = "*",
						callback = function()
							local filetype = vim.bo.filetype
							local paths = dict.ft[filetype] or {}
							vim.list_extend(paths, dict["*"])
							require("cmp_dictionary").setup({
								paths = paths,
							})
						end,
					})
				end,
			},
		},
		opts = function(_, opts)
			local cmp = require("cmp")

			opts.window = {
				documentation = {
					winhighlight = "FloatBorder:CmpDocFloat,NormalFloat:CmpDocFloat",
					border = { "", "", "", " ", "", "", "", " " },
				},
			}

			opts.enabled = function()
				local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })

				if buftype == "prompt" then
					return false
				end

				local context = require("cmp.config.context")

				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end

			opts.sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,

					function(entry1, entry2)
						local _, entry1_under = entry1.completion_item.label:find("^_+")
						local _, entry2_under = entry2.completion_item.label:find("^_+")

						entry1_under = entry1_under or 0
						entry2_under = entry2_under or 0

						if entry1_under > entry2_under then
							return false
						elseif entry1_under < entry2_under then
							return true
						end
					end,

					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
				},
			}

			opts.sources = cmp.config.sources({
				{ name = "luasnip" },
				{
					name = "nvim_lsp",
					entry_filter = function(entry)
						return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
					end,
				},
				{ name = "nvim_lsp_signature_help" },
			}, {

				{ name = "copilot" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 3 },
				{ name = "nvim_lua" },
			})
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "workspaces" },
					{ name = "buffer" },
					{ name = "git" }, -- depends on https://github.com/petertriho/cmp-git
					{ name = "copilot" },
				}),
			})
		end,
	},
}
