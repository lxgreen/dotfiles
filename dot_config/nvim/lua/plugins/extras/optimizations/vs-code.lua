local function is_not_vs_code()
	return not vim.g.vscode
end

return {
	-- Disable UI and picker plugins that don't work well in VS Code
	{ "nvim-lualine/lualine.nvim", cond = is_not_vs_code },
	{ "akinsho/bufferline.nvim", cond = is_not_vs_code },
	{ "stevearc/oil.nvim", cond = is_not_vs_code },
	{ "ibhagwan/fzf-lua", cond = is_not_vs_code },
	{ "nvim-telescope/telescope.nvim", cond = is_not_vs_code },
	{ "folke/edgy.nvim", cond = is_not_vs_code },
	{ "gbprod/yanky.nvim", cond = is_not_vs_code }, -- Yanky causes picker errors in VS Code
	
	-- Configure Snacks for VS Code compatibility
	{
		"folke/snacks.nvim",
		priority = 1000, -- Load early to replace our stub
		config = function()
			if vim.g.vscode then
				-- Load real Snacks with minimal config for VS Code
				require("snacks").setup({
					-- Disable UI-heavy features
					dashboard = { enabled = false },
					scroll = { enabled = false },
					statuscolumn = { enabled = false },
					words = { enabled = false },
					styles = { enabled = false },
					notifier = { enabled = false },
					terminal = { enabled = false },
					zen = { enabled = false },
					
					-- Keep essential functionality that LazyVim depends on
					bigfile = { enabled = true },
					quickfile = { enabled = true },
					toggle = { enabled = true },
					util = { enabled = true },
					picker = { enabled = false }, -- Disable picker in VS Code
				})
				
				-- Replace our stub with the real Snacks
				_G.Snacks = require("snacks")
				print("✅ Real Snacks loaded for VS Code compatibility")
			end
		end,
	},
}
