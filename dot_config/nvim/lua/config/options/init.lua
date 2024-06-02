local OptionsUtil = require("config.options.util")

local options = {
	autochdir = false,
	swapfile = false,
	backup = true,
	backupdir = vim.fn.getenv("HOME") .. "/.local/state/nvim/backup/",
	smoothscroll = true,
	conceallevel = 2,
	foldmethod = "expr",
	foldexpr = "nvim_treesitter#foldexpr()",

	expandtab = false,
	smarttab = true,
	shiftwidth = 2,
	tabstop = 2,
	softtabstop = 2,
	autoindent = true,

	pumblend = 15,
	winblend = 5,

	timeout = true,
	timeoutlen = 350,
	ttimeoutlen = 0,

	showmode = false,

	splitbelow = true,
	splitright = true,

	showbreak = "↪",
	listchars = { eol = " ", space = "·", tab = "→ " },
	fillchars = { diff = " ", eob = " " },

	spelllang = "",
	langmap = OptionsUtil.langmap_create(),
}

vim.opt.iskeyword:append({ "!", "=", "<", ">" })

OptionsUtil.options_apply(options)
OptionsUtil.mouse_context_menu_fix()
