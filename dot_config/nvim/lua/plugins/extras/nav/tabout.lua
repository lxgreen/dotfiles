return {
	{
		"abecodes/tabout.nvim",
		lazy = false,
		vscode = true,
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
					{ open = "<", cloose = ">" },
					{ open = "*", cloose = "*" },
					{ open = "_", cloose = "_" },
					{ open = "~", cloose = "~" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})

			-- VSCode-specific fix: Ensure Tab key works in insert mode
			-- VSCode may intercept Tab keypresses, so we need to ensure they reach Neovim
			if vim.g.vscode then
				-- Force tabout to work by ensuring Tab is properly handled in insert mode
				vim.api.nvim_create_autocmd("InsertEnter", {
					callback = function()
						-- Ensure tabout is active in insert mode
						if package.loaded["tabout"] then
							-- Re-initialize tabout mappings if needed
							pcall(function()
								require("tabout").setup({})
							end)
						end
					end,
				})

				-- Debug: Check if tabout is loaded
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					callback = function()
						if package.loaded["tabout"] then
							print("✅ tabout.nvim loaded in VSCode mode")
						else
							print("⚠️  tabout.nvim not loaded - check configuration")
						end
					end,
				})
			end
		end,
		dependencies = { -- These are optional
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
			"hrsh7th/nvim-cmp",
		},
		opt = true, -- Set this to true if the plugin is optional
		event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
	},
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			-- Disable default tab keybinding in LuaSnip
			return {}
		end,
	},
}
