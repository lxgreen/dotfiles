return {
	"folke/sidekick.nvim",
	keys = {
		{
			"<leader>aa",
			'<cmd>lua require("sidekick.cli").toggle({ name = "claude", focus = true })<cr>',
			desc = "Claude",
			mode = "n",
		},
	},
}
