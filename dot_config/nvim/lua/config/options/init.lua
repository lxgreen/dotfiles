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

	-- cancel window transparency
	pumblend = 0,
	winblend = 0,

	timeout = true,
	timeoutlen = 200, -- Reduced from 350ms for faster key response
	ttimeoutlen = 0,

	showmode = false,

	splitbelow = true,
	splitright = true,

	showbreak = "↪",
	listchars = { eol = " ", space = "·", tab = "→ " },
	fillchars = { diff = " ", eob = " " },

	spell = false,
	spelllang = "en,ru",
	spelloptions = { "camel" },
	spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",

	langmap = OptionsUtil.langmap_create(),
}

vim.opt.iskeyword:append({ "!", "=", "<", ">" })
vim.o.guifont = "JetBrains Mono:h18"

-- set path to Node v20
vim.g.node_host_prog = "$HOME/.local/share/fnm/aliases/nvim_node/bin/node"

-- TODO: move to separate module
if vim.g.neovide then
	vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<D-c>", '"+y') -- Copy
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

OptionsUtil.options_apply(options)
OptionsUtil.mouse_context_menu_fix()
