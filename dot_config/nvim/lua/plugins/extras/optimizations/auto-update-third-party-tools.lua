return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			{ "williamboman/mason.nvim", version = "1.11.0" },
			{ "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
		},
		opts = {
			auto_update = true,
			ensure_installed = {},
			integrations = {
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = function(_, opts)
			for key, _ in pairs(require("lspconfig.configs")) do
				table.insert(opts.ensure_installed, key)
			end
		end,
	},
}
