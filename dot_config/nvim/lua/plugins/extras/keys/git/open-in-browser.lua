return {
	"ruifm/gitlinker.nvim",
	optional = true,

	keys = {
		{ "<leader>gC", '<cmd>lua require"gitlinker".get_repo_url()<cr>', { silent = true, desc = "Copy repo URL" } },
		{
			"<leader>gr",
			'<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
			{ silent = true, desc = "Open repo in browser" },
		},
		{
			"<leader>gb",
			'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
			{ silent = true, desc = "Open current in remote" },
			mode = { "n", "v" },
		},
	},
}
