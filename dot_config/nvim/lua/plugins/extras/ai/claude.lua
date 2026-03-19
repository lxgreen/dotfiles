return {
	"greggh/claude-code.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup()
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
