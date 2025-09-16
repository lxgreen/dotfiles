local function is_not_vs_code()
	return not vim.g.vscode
end

return {
	-- Don't completely disable Snacks in VS Code, just configure it minimally
	{
		"folke/snacks.nvim",
		cond = function() return vim.g.vscode end,
		opts = {
			-- Minimal config for VS Code compatibility
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			-- Disable UI-heavy features that don't work well in VS Code
			dashboard = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			styles = { enabled = false },
		},
	},
}
