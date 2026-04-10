return {
	"stevearc/oil.nvim",
	keys = {
		{ "-", "<CMD>Oil<CR>", { desc = "Open parent directory" } },
		{
			"<leader>e",
			function()
				vim.cmd("vsplit")
				require("oil").open()
				vim.cmd("wincmd H")
				vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.25))
			end,
			desc = "Open parent directory in vsplit",
		},
	},
}
