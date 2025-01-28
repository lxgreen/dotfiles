return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = true },
			panel = { enabled = false },
			filetypes = {
				markdown = false,
				telekasten = false,
				help = false,
				typescript = true,
				javascript = true,
				javascriptreact = true,
				typescriptreact = true,
				json = true,
				css = true,
				scss = true,
				lua = true,
			},
		},
	},
}
