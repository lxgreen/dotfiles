return {
	{
		"vigoux/ltex-ls.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			{
				"icewind/ltex-client.nvim",
				config = function()
					require("ltex-client").setup({
						user_dictionaries_path = vim.fn.stdpath("config") .. "/dict",
					})
				end,
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			use_spellfile = false,
			servers = {
				ltex = {
					enabled = { "markdown" },
					language = "auto",
					diagnosticSeverity = "information",
					sentenceCacheSize = 2000,
					additionalRules = {
						enablePickyRules = true,
						motherTongue = "en",
					},
					disabledRules = {},
				},
			},
		},
	},
}
