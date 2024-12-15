return {
	"saecki/live-rename.nvim",
	keys = {
		{
			"<leader>ci",
			function()
				require("live-rename").rename()
			end,
			desc = "Inline rename",
		},
	},
}
