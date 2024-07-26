return {
	"LazyVim/LazyVim",
	optional = true,
	keys = {
		{
			"<leader>v",
			function()
				vim.cmd([[ edit term://vit | norm i ]])
			end,
			{ desc = "Vit tasks" },
		},
	},
}
