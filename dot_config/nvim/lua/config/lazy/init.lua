require("config.lazy.boot")
require("abbreviations")

local opts = {
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ "LazyVim/LazyVim", import = "lazyvim.plugins.extras" },
		{ import = "plugins" },
	},
	install = { colorscheme = { require("util").colorscheme_get_name() } },
	defaults = { lazy = false, version = false },
	checker = { enabled = true, notify = false },
	change_detection = { enabled = false },
	diff = { cmd = "diffview.nvim" },
	rocks = {
		hererocks = true, -- Enable hererocks to manage Lua versions and rocks for image.nvim
	},
	ui = {
		border = "rounded",
		backdrop = 100,
		title = "  󱎦  󰫮  󰬇  󰬆  ",
		size = { width = 0.9, height = 0.8 },
		icons = { lazy = "(H) ", keys = "󰥻" },
	},
	performance = { rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } } },
}

require("lazy").setup(opts)
