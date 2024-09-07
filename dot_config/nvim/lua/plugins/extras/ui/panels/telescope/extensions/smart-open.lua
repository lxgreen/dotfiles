return {
	"nvim-telescope/telescope.nvim",
	optional = true,

	dependencies = {
		"danielfalk/smart-open.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
			{ "nvim-telescope/telescope-fzf-native.nvim", make = "build" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
		config = true,
	},

	opts = {
		extensions = {
			smart_open = {
				match_algorithm = "fzf",
				rcwd_only = true,
				filename_first = false,
			},
		},
	},

	keys = {
		{
			"<leader><space>",
			[[<cmd>Telescope smart_open theme=dropdown previewer=false<cr>]],
			desc = "Find Files (Smart open)",
		},
	},
}
