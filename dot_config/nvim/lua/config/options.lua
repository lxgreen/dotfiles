-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
-- globals, buffers, 100 marks, 1000 searches & commands, 1MiB per item
opt.shada = { "!", "%", "'100", "/1000", ":1000", "s1000" }

opt.autochdir = false -- don't cd on file open

opt.timeoutlen = 500
opt.ttimeoutlen = 0

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

opt.spell = true
opt.spelllang = "en_us"
opt.spelloptions = { "camel" } -- treat each camelCase part as a word

opt.splitbelow = true -- horizontal splits will automatically be below
opt.splitright = true -- vertical splits will automatically be to the right

opt.showbreak = "↪"
opt.listchars = { eol = "↩", space = "·", tab = "→ " }
opt.fillchars = {
  diff = " ",
  eob = " ",
  fold = "╌",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

opt.scrolloff = 999 -- keep cursor centered vertically

opt.expandtab = true -- use spaces instead of tabs
opt.tabstop = 2 -- number of spaces tabs count for
opt.shiftwidth = 2 -- number of spaces to use for autoindenting, >> <<, etc
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.inccommand = "split" -- show live preview of :s in split window
opt.langmap =
  [[АБЦДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗЮЖЩЬЪЭ;ABCDEFGHIJKLMNOPQRSTUVWXYZ{}~_+|,абцдефгчийклмнопярстувшхызюжщьъэ;abcdefghijklmnopqrstuvwxyz[]`-=\]]
-- opt.sessionoptions = {
--   "blank",
--   "buffers",
--   "curdir",
--   "folds",
--   "globals",
--   "help",
--   "localoptions",
--   "options",
--   "resize",
--   "winsize",
--   "tabpages",
--   "terminal",
-- }
opt.iskeyword:append({ "!", "=", "<", ">" })
