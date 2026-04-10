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
		enabled = false,
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
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
