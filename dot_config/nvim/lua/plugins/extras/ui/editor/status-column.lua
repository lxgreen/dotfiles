return {
	{
		"folke/snacks.nvim",
		cond = function() return not vim.g.vscode end, -- Disable in VS Code
		opts = {
			statuscolumn = {
				enabled = true,
				folds = {
					open = true, -- show open fold icons
					git_hl = true, -- use Git Signs hl for fold icons
				},
			},
		},
	},
}
