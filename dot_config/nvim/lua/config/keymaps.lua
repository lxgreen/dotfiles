-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = require("utils").map

-- word-motions
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "word-wise-w" })
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "word-wise-e" })
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "word-wise-b" })
map({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "word-wise-ge" })

-- gitlinker
map("n", "<leader>gC", '<cmd>lua require"gitlinker".get_repo_url()<cr>', { silent = true, desc = "Copy repo URL" })
map(
  "n",
  "<leader>gr",
  '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true, desc = "Open repo in browser" }
)
map(
  "n",
  "<leader>gb",
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true, desc = "Open current in remote" }
)
map(
  "v",
  "<leader>gb",
  '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { desc = "Open current in remote" }
)

-- neotree
map({ "n" }, "<leader>m", "<cmd>Neotree focus<CR>", { desc = "Open/focus file explorer" })

-- close buffer on Q
map({ "v", "n", "s" }, "<S-q>", "<cmd>q<cr><esc>", { desc = "Close buffer" })

-- restart LSP on <F3>
map({ "n", "o", "x", "i" }, "<F3>", "<Cmd>LspRestart<CR>", { desc = "Restart LSP", noremap = true })

-- indent right on <Tab> in visual mode
map("x", "<Tab>", ">gv", { desc = "Indent right", noremap = true })

-- commands
-- save file on W
vim.cmd([[command! -nargs=0 -bar W :w]])
vim.cmd([[command! -nargs=0 -bar NewDiary :lua require("diary").createDiaryEntry()]])

map("n", "gF", "<cmd>vertical wincmd f<cr>", { desc = "Split [f]ile under cursor", noremap = true })

map("n", "<leader>D", function()
  vim.cmd([[ vsplit ]])
  vim.lsp.buf.definition()
end, { desc = "Split [d]efinition" })

-- telescope
map("n", "<leader>a", "<cmd>Telescope ast_grep<cr>", { desc = "Find on [A]ST" }) -- depends on ast_grep

-- mundo
map({ "n", "i", "s", "o", "x" }, "<F7>", "<cmd>MundoToggle<CR>", { desc = "Toggle Undo Tree" })

-- notifications
map({ "n", "i", "s", "o", "x" }, "<F1>", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Notifications" })
map({ "n", "i", "s", "o", "x" }, "<F2>", "<cmd>Noice<CR>", { desc = "Show Notifications" })

-- change, delete, cut, paste
map({ "n", "o", "x" }, "d", '"_d', { noremap = true, desc = "Delete" })
map({ "n", "o", "x" }, "dd", '"_dd', { noremap = true, desc = "Delete line" })
map({ "n", "x" }, "D", '"_D', { noremap = true, desc = "Delete EOL" })
map({ "n", "o", "x" }, "c", '"_c', { noremap = true, desc = "Change" })
map({ "n", "o", "x" }, "cc", '"_cc', { noremap = true, desc = "Change line" })
map({ "n", "x" }, "C", '"_C', { noremap = true, desc = "Change EOL" })
map({ "n", "o", "x" }, "m", "d", { noremap = true, desc = "Cut" })
map({ "n", "o", "x" }, "mm", "dd", { noremap = true, desc = "Cut line" })
map({ "n", "x" }, "M", "D", { noremap = true, desc = "Cut EOL" })
map({ "n", "x" }, "<leader>P", '"+p', { noremap = true, desc = "Paste from clipboard" })

-- tmux navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft, { noremap = true, desc = "Navigate left" })
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown, { noremap = true, desc = "Navigate down" })
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp, { noremap = true, desc = "Navigate up" })
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight, { noremap = true, desc = "Navigate right" })
map("n", "<C-p>", nvim_tmux_nav.NvimTmuxNavigateLastActive, { noremap = true, desc = "Navigate last active" })
map("n", "<C-n>", nvim_tmux_nav.NvimTmuxNavigateNext, { noremap = true, desc = "Navigate next" })

-- harpoon
map({ "n", "o", "x" }, "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", { desc = "harpoon 1" })
map({ "n", "o", "x" }, "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", { desc = "harpoon 2" })
map({ "n", "o", "x" }, "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", { desc = "harpoon 3" })
map({ "n", "o", "x" }, "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", { desc = "harpoon 4" })
map({ "n", "o", "x" }, "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", { desc = "harpoon 5" })
map({ "n", "o", "x" }, "<leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<CR>", { desc = "harpoon 6" })
map({ "n", "o", "x" }, "+", "<cmd>lua require('harpoon.mark').add_file()<CR>", { desc = "harpoon +" })
map({ "n", "o", "x" }, "<leader>s+", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = "harpoons" })

local Util = require("lazyvim.util")
vim.keymap.set("n", "<leader>v", function()
  Util.terminal.open({ "vit" }, {
    size = {
      width = 1,
      height = 1,
    },
  })
end, { desc = "Vit tasks" })

map("n", "<leader>R", "<cmd>vs scp://lx@192.168.1.41//home/lx/nextcloud/docker-compose.yml<cr>", {
  desc = "Edit Docker Compose",
})

-- refactoring
map("x", "Xe", ":Refactor extract ", { noremap = true, silent = false, desc = "[E]xtract " })
map("x", "Xf", ":Refactor extract_to_file ", { noremap = true, silent = false, desc = "extract_to_file " })
map("x", "Xv", ":Refactor extract_var ", { noremap = true, silent = false, desc = "Refactor extract_var " })
map({ "n", "x" }, "Xi", ":Refactor inline_var", { noremap = true, silent = false, desc = "Refactor inline_var" })
map("n", "XI", ":Refactor inline_func", { noremap = true, silent = false, desc = "Refactor inline_func" })
map("n", "Xb", ":Refactor extract_block", { noremap = true, silent = false, desc = "Refactor extract_block" })
map(
  "n",
  "Xbf",
  ":Refactor extract_block_to_file",
  { noremap = true, silent = false, desc = "Refactor extract_block_to_file" }
)

-- text-case

map(
  "n",
  "gau",
  "<cmd>lua require('textcase').current_word('to_upper_case')<cr>",
  { desc = "Rename to upper case (current word)" }
)
map(
  "n",
  "gal",
  "<cmd>lua require('textcase').current_word('to_lower_case')<cr>",
  { desc = "Rename to lower case (current word)" }
)
map(
  "n",
  "gas",
  "<cmd>lua require('textcase').current_word('to_snake_case')<cr>",
  { desc = "Rename to snake case (current word)" }
)
map(
  "n",
  "gad",
  "<cmd>lua require('textcase').current_word('to_dash_case')<cr>",
  { desc = "Rename to dash case (current word)" }
)
map(
  "n",
  "gan",
  "<cmd>lua require('textcase').current_word('to_constant_case')<cr>",
  { desc = "Rename to constant case (current word)" }
)
map(
  "n",
  "gaa",
  "<cmd>lua require('textcase').current_word('to_phrase_case')<cr>",
  { desc = "Rename to phrase case (current word)" }
)
map(
  "n",
  "gac",
  "<cmd>lua require('textcase').current_word('to_camel_case')<cr>",
  { desc = "Rename to camel case (current word)" }
)
map(
  "n",
  "gap",
  "<cmd>lua require('textcase').current_word('to_pascal_case')<cr>",
  { desc = "Rename to pascal case (current word)" }
)
map(
  "n",
  "gat",
  "<cmd>lua require('textcase').current_word('to_title_case')<cr>",
  { desc = "Rename to title case (current word)" }
)
map(
  "n",
  "gaf",
  "<cmd>lua require('textcase').current_word('to_path_case')<cr>",
  { desc = "Rename to path case (current word)" }
)
map(
  "n",
  "ga.",
  "<cmd>lua require('textcase').current_word('to_dot_case')<cr>",
  { desc = "Rename to dot case (current word)" }
)

map("n", "gaU", "<cmd>lua require('textcase').lsp_rename('to_upper_case')<cr>", { desc = "Rename to upper case (LSP)" })
map("n", "gaL", "<cmd>lua require('textcase').lsp_rename('to_lower_case')<cr>", { desc = "Rename to lower case (LSP)" })
map("n", "gaS", "<cmd>lua require('textcase').lsp_rename('to_snake_case')<cr>", { desc = "Rename to snake case (LSP)" })
map("n", "gaD", "<cmd>lua require('textcase').lsp_rename('to_dash_case')<cr>", { desc = "Rename to dash case (LSP)" })
map(
  "n",
  "gaN",
  "<cmd>lua require('textcase').lsp_rename('to_constant_case')<cr>",
  { desc = "Rename to constant case (LSP)" }
)
map(
  "n",
  "gaA",
  "<cmd>lua require('textcase').lsp_rename('to_phrase_case')<cr>",
  { desc = "Rename to phrase case (LSP)" }
)
map("n", "gaC", "<cmd>lua require('textcase').lsp_rename('to_camel_case')<cr>", { desc = "Rename to camel case (LSP)" })
map(
  "n",
  "gaP",
  "<cmd>lua require('textcase').lsp_rename('to_pascal_case')<cr>",
  { desc = "Rename to pascal case (LSP)" }
)
map("n", "gaT", "<cmd>lua require('textcase').lsp_rename('to_title_case')<cr>", { desc = "Rename to title case (LSP)" })
map("n", "gaF", "<cmd>lua require('textcase').lsp_rename('to_path_case')<cr>", { desc = "Rename to path case (LSP)" })
map(
  "n",
  "ga>",
  "<cmd>lua require('textcase').lsp_rename('to_dot_case')<cr>",
  { desc = "Rename to dot case (current word)" }
)

map(
  "n",
  "gou",
  "<cmd>lua require('textcase').operator('to_upper_case')<cr>",
  { desc = "Rename to upper case (operator)" }
)
map(
  "n",
  "gol",
  "<cmd>lua require('textcase').operator('to_lower_case')<cr>",
  { desc = "Rename to lower case (operator)" }
)
map(
  "n",
  "gos",
  "<cmd>lua require('textcase').operator('to_snake_case')<cr>",
  { desc = "Rename to snake case (operator)" }
)
map(
  "n",
  "god",
  "<cmd>lua require('textcase').operator('to_dash_case')<cr>",
  { desc = "Rename to dash case (operator)" }
)
map(
  "n",
  "gon",
  "<cmd>lua require('textcase').operator('to_constant_case')<cr>",
  { desc = "Rename to constant case (operator)" }
)
map(
  "n",
  "goa",
  "<cmd>lua require('textcase').operator('to_phrase_case')<cr>",
  { desc = "Rename to phrase case (operator)" }
)
map(
  "n",
  "goc",
  "<cmd>lua require('textcase').operator('to_camel_case')<cr>",
  { desc = "Rename to camel case (operator)" }
)
map(
  "n",
  "gop",
  "<cmd>lua require('textcase').operator('to_pascal_case')<cr>",
  { desc = "Rename to pascal case (operator)" }
)
map(
  "n",
  "got",
  "<cmd>lua require('textcase').operator('to_title_case')<cr>",
  { desc = "Rename to title case (operator)" }
)
map(
  "n",
  "gof",
  "<cmd>lua require('textcase').operator('to_path_case')<cr>",
  { desc = "Rename to path case (operator)" }
)

require("ai-keymaps")

-- visual mode surround mappings
map("x", "'", [[:<C-u>lua MiniSurround.add('visual')<CR>']], { silent = true })
map("x", '"', [[:<C-u>lua MiniSurround.add('visual')<CR>"]], { silent = true })
map("x", "`", [[:<C-u>lua MiniSurround.add('visual')<CR>`]], { silent = true })
map("x", ")", [[:<C-u>lua MiniSurround.add('visual')<CR>)]], { silent = true })
map("x", "]", ":<C-u>lua MiniSurround.add('visual')<CR>]", { silent = true })
map("x", "}", [[:<C-u>lua MiniSurround.add('visual')<CR>}]], { silent = true })
map("x", ">", [[:<C-u>lua MiniSurround.add('visual')<CR>>]], { silent = true })
map("x", "*", [[:<C-u>lua MiniSurround.add('visual')<CR>*]], { silent = true })
map("x", "_", [[:<C-u>lua MiniSurround.add('visual')<CR>_]], { silent = true })
map("x", "~", [[:<C-u>lua MiniSurround.add('visual')<CR>~]], { silent = true })