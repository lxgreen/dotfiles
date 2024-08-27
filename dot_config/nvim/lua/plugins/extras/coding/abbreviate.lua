return {
	"0styx0/abbreinder.nvim",
	dependencies = {
		"0styx0/abbremand.nvim",
	},
	opts = {
		value_highlight = {
			enabled = true,
			group = "Special", -- highlight to use
			time = 4000, -- -1 for permanent
		},
		tooltip = {
			enabled = true,
			time = 4000, -- time before tooltip closes
			opts = {}, -- see :help nvim_open_win
			highlight = {
				enabled = true,
				group = "Special", -- highlight to use
			},
			format = function(trigger, value) -- format to print reminder in
				return 'abbrev: "' .. trigger .. '"->' .. '"' .. value .. '"'
			end,
		},
	},
}
