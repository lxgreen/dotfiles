local AutocmdsUtil = require("config.autocmds.util")

return {
	"f-person/auto-dark-mode.nvim",
	opts = {
		update_interval = 1000,
		set_dark_mode = function()
			AutocmdsUtil.colorscheme_update()
			vim.api.nvim_set_option("background", "dark")
		end,
		set_light_mode = function()
			AutocmdsUtil.colorscheme_update()
			vim.api.nvim_set_option("background", "light")
		end,
	},
	init = function()
		require("auto-dark-mode").init()
	end,
}
