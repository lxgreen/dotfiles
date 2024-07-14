return {
	"ThePrimeagen/harpoon",
	optional = true,
	enabled = false,

	keys = {
		{
			"<leader>h",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list(), {
					border = "rounded",
					title = "",
					ui_max_width = 80,
				})
			end,
			desc = "Harpoon Quick Menu",
		},
	},
}
