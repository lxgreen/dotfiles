return {
	"folke/flash.nvim",
	vscode = true,
	optional = true,
	opts = {
		modes = {
			search = { enabled = true },
			char = { enabled = true },
			treesitter = { enabled = true },
		},
		-- VSCode-friendly configuration
		jump = {
			autojump = false, -- More predictable behavior in VSCode
		},
		label = {
			uppercase = false,
			rainbow = {
				enabled = false, -- Better visibility in VSCode
			},
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
		-- Simulate nvim-treesitter incremental selection
		{
			"vv",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter({
					actions = {
						["v"] = "next",
						["<BS>"] = "prev",
					},
				})
			end,
			desc = "Treesitter Incremental Selection",
		},
	},
}
