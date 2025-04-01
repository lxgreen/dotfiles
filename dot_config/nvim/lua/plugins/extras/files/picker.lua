local patterns = require("util").ignore_patterns
return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			exclude = patterns,
		},
	},
}
