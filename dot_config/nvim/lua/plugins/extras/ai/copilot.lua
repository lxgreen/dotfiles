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
			},
		},
	},
}
