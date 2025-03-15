return {
	"johmsalas/text-case.nvim",
	vscode = true,
	opts = {
		prefix = "ga",
	},
	{
		"tpope/vim-abolish",
	},
	{
		"0styx0/abbreinder.nvim",
		dependencies = {
			{
				"0styx0/abbremand.nvim",
			},
		},
		config = function()
			-- config can be empty to stay with defaults
			-- or anything can be changed, with anything unspecified
			-- retaining the default values
			require("abbreinder").setup()
		end,
		event = "BufRead", -- if want lazy load
	},
}
