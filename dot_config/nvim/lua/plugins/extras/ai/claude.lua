return {
	"greggh/claude-code.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
			window = {
				position = "vertical",
				split_ratio = 0.35,
			},
		})
	end,
	keys = {
		{
			mode = "n",
			"<leader>aa",
			"<cmd>ClaudeCode<CR>",
			desc = "Claude Code",
		},
	},
}
