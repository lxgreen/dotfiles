-- Only return plugin disables when in firenvim, otherwise return empty
if not vim.g.started_by_firenvim then
	return {}
end

return {
	-- Main firenvim plugin configuration
	{
		"glacambre/firenvim",
		build = ":call firenvim#install(0)",
		lazy = false,
		init = function()
			-- Firenvim-specific settings - set early
			vim.g.firenvim_config = {
				globalSettings = {
					alt = "all",
				},
				localSettings = {
					[".*"] = {
						cmdline = "neovim",
						content = "text",
						priority = 0,
						selector = "textarea",
						takeover = "never",
					},
					["https?://github\\.com/.*"] = {
						cmdline = "neovim",
						content = "markdown",
						priority = 1,
						selector = "textarea",
						takeover = "always",
						filename = "{hostname}_{pathname%10}_{selector%5}_{n}.md",
					},
				},
			}

			-- Set this as early as possible to prevent UI plugins from loading
			if vim.g.started_by_firenvim then
				-- Disable UI plugins before they load
				vim.g.lualine_laststatus = 0
				vim.g.snacks_dashboard_enabled = false
				vim.g.noice_enabled = false
				vim.g.neo_tree_remove_legacy_commands = 1
				vim.g.loaded_netrw = 1
				vim.g.loaded_netrwPlugin = 1
				vim.g.nvim_tree_disable_default_keybindings = 1

				-- Disable LSP and tools that might load native libraries
				vim.g.mason_enabled = false
				vim.g.lspconfig_enabled = false
			end
		end,
		config = function()
			if vim.g.started_by_firenvim then
				-- Disable UI elements
				vim.opt.laststatus = 0 -- Disable statusline
				vim.opt.showtabline = 0 -- Disable tabline
				vim.opt.signcolumn = "no" -- Disable sign column
				vim.opt.wrap = true -- Enable line wrap for better text area experience
				vim.opt.linebreak = true -- Break lines at word boundaries
				vim.opt.cmdheight = 1 -- Minimal command height
				vim.opt.ruler = false -- Disable ruler
				vim.opt.showmode = true -- Disable mode display

				-- Suppress warnings and messages
				vim.opt.shortmess:append("c") -- Don't show completion messages
				vim.opt.shortmess:append("F") -- Don't show file info when editing
				vim.opt.shortmess:append("W") -- Don't show "written" when writing
				vim.opt.shortmess:append("I") -- Don't show intro message
				vim.opt.shortmess:append("A") -- Don't show "ATTENTION" messages
				vim.opt.shortmess:append("s") -- Don't show "search hit BOTTOM" messages
				vim.opt.shortmess:append("S") -- Don't show search count message

				-- Suppress all error bells
				vim.opt.errorbells = false
				vim.opt.visualbell = false

				-- Disable swap file warnings
				vim.opt.swapfile = false
				vim.opt.backup = false
				vim.opt.writebackup = false

				-- Disable LSP
				vim.g.lsp_enabled = false
				vim.diagnostic.disable()

				-- Disable trouble
				vim.g.trouble_lualine = false

				-- Aggressively disable snacks
				vim.g.snacks_dashboard_enabled = false
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					callback = function()
						if package.loaded["snacks"] then
							local snacks = require("snacks")
							if snacks.dashboard then
								pcall(function()
									snacks.dashboard.close()
								end)
							end
							if snacks.notifier then
								pcall(function()
									snacks.notifier.hide()
								end)
							end
						end
					end,
				})

				-- Disable noice
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					callback = function()
						if package.loaded["noice"] then
							pcall(function()
								require("noice").disable()
								vim.cmd("Noice disable")
							end)
						end
					end,
				})

				-- Close any existing buffers that might show UI
				vim.schedule(function()
					-- Close dashboard if it opened
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						local name = vim.api.nvim_buf_get_name(buf)
						local ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
						if
							name:match("dashboard")
							or (ft and vim.api.nvim_get_option_value("filetype", { buf = buf }) == "dashboard")
						then
							pcall(vim.api.nvim_buf_delete, buf, { force = true })
						end
					end
				end)

				-- Close tree explorers if they open
				vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
					pattern = "*",
					callback = function(args)
						local ft = vim.bo[args.buf].filetype
						local bufname = vim.api.nvim_buf_get_name(args.buf)
						-- Close neo-tree, nvim-tree, oil, and other explorers
						if
							ft == "neo-tree"
							or ft == "NvimTree"
							or ft == "oil"
							or bufname:match("NvimTree")
							or bufname:match("neo%-tree")
						then
							pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
							-- Also try to close any tree windows
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								local buf = vim.api.nvim_win_get_buf(win)
								local name = vim.api.nvim_buf_get_name(buf)
								local winft = vim.bo[buf].filetype
								if
									winft == "neo-tree"
									or winft == "NvimTree"
									or name:match("NvimTree")
									or name:match("neo%-tree")
								then
									pcall(vim.api.nvim_win_close, win, true)
								end
							end
						end
					end,
				})

				-- Disable tree toggle commands
				vim.api.nvim_create_user_command("Neotree", function()
					-- Do nothing
				end, { nargs = "*" })
				vim.api.nvim_create_user_command("NvimTreeToggle", function()
					-- Do nothing
				end, {})
				vim.api.nvim_create_user_command("NvimTreeOpen", function()
					-- Do nothing
				end, {})

				-- Autosave on buffer leave or focus lost
				vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimLeave" }, {
					callback = function()
						if vim.bo.modified and vim.bo.buftype == "" then
							pcall(vim.cmd, "silent! write")
						end
					end,
				})
			end

			-- Set font for firenvim
			vim.api.nvim_create_autocmd({ "UIEnter" }, {
				callback = function()
					if vim.g.started_by_firenvim then
						-- Set font size to 15
						vim.opt.guifont = { "SF Mono", ":h15" }
					end
				end,
			})
		end,
	},

	-- Disable lualine
	{
		"nvim-lualine/lualine.nvim",
		enabled = false,
	},

	-- Disable snacks
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = { enabled = false },
			notifier = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			styles = {
				notification = { enabled = false },
			},
		},
	},

	-- Disable noice
	{
		"folke/noice.nvim",
		enabled = false,
	},

	-- Disable bufferline/tabline
	{
		"akinsho/bufferline.nvim",
		enabled = false,
	},

	-- Disable neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},

	-- Disable nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
	},

	-- Disable telescope UI
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
	},

	-- Disable which-key popup
	{
		"folke/which-key.nvim",
		enabled = false,
	},

	-- Disable trouble
	{
		"folke/trouble.nvim",
		enabled = false,
	},

	-- Disable notify
	{
		"rcarriga/nvim-notify",
		enabled = false,
	},

	-- Disable indent-blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
	},

	-- Disable gitsigns
	{
		"lewis6991/gitsigns.nvim",
		enabled = false,
	},

	-- Disable treesitter-context
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = false,
	},

	-- Disable LSP signature
	{
		"ray-x/lsp_signature.nvim",
		enabled = false,
	},

	-- Disable fidget (LSP progress)
	{
		"j-hui/fidget.nvim",
		enabled = false,
	},

	-- Disable mini.indentscope
	{
		"echasnovski/mini.indentscope",
		enabled = false,
	},

	-- Disable avante (AI assistant)
	{
		"yetone/avante.nvim",
		enabled = false,
	},

	-- Disable Mason (LSP installer - prevents loading native libraries)
	{
		"williamboman/mason.nvim",
		enabled = false,
	},

	-- Disable Mason-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = false,
	},

	-- Disable nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		enabled = false,
	},

	-- Disable conform (formatter)
	{
		"stevearc/conform.nvim",
		enabled = false,
	},

	-- Disable nvim-lint
	{
		"mfussenegger/nvim-lint",
		enabled = false,
	},

	-- Disable none-ls
	{
		"nvimtools/none-ls.nvim",
		enabled = false,
	},

	-- Disable nvim-dap (debugger)
	{
		"mfussenegger/nvim-dap",
		enabled = false,
	},

	-- Disable nvim-cmp (completion)
	{
		"hrsh7th/nvim-cmp",
		enabled = false,
	},

	-- Disable copilot
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
	},

	-- Disable treesitter (can also load native libraries)
	{
		"nvim-treesitter/nvim-treesitter",
		enabled = false,
	},

	-- Disable spider (advanced word motions)
	{
		"chrisgrieser/nvim-spider",
		enabled = false,
	},

	-- Disable image.nvim
	{
		"3rd/image.nvim",
		enabled = false,
	},
}
