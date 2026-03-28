return {
	{
		"greggh/claude-code.nvim",
		enabled = false,
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
	},
	{
		"folke/sidekick.nvim",
		opts = {
			nes = {
				enabled = false, -- disable Copilot NES if not using it
			},
			cli = {
				watch = true, -- auto-reload files modified by Claude
				win = {
					layout = "right",
					split = {
						width = 60,
					},
				},
				mux = {
					enabled = false, -- set to true + backend = "tmux"/"zellij" if you want persistent sessions
				},
			},
		},
	},
}
