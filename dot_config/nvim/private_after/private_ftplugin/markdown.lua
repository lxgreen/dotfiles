vim.cmd("setlocal foldmethod=manual")

local buffer_number = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = false }

-- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
vim.api.nvim_buf_set_keymap(
	buffer_number,
	"v",
	"n",
	":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
	opts
)

vim.api.nvim_create_user_command("InsertBacklink", function()
	vim.api.nvim_put({ "---" }, "l", true, true)
	vim.api.nvim_put({ "" }, "l", true, true)
	-- Insert the text 'back' in a new line below the current line
	vim.api.nvim_put({ "back" }, "l", true, true)

	-- Calculate the cursor position to start of the inserted text
	local line = vim.api.nvim_get_current_line()
	local start_pos = string.find(line, "back")

	-- Set the marks '< and '> around the word 'back'
	vim.fn.setpos("'<", { 0, vim.fn.line("."), start_pos, 0 })
	vim.fn.setpos("'>", { 0, vim.fn.line("."), start_pos + 3, 0 })
	vim.cmd(":'<,'>ZkInsertLinkAtSelection")
end, { desc = "Insert backlink" })

-- insert link in input + selection modes
vim.api.nvim_buf_set_keymap(buffer_number, "i", "[[", "<cmd>ZkInsertLink<CR>", opts)
vim.api.nvim_buf_set_keymap(buffer_number, "v", "[[", ":'<,'>ZkInsertLinkAtSelection<CR>", opts)
-- Search for the notes matching the current visual selection.
vim.api.nvim_buf_set_keymap(buffer_number, "v", "<leader>s", ":'<,'>ZkMatch<CR>", opts)
vim.api.nvim_buf_set_keymap(buffer_number, "n", "<leader>B", "<cmd>InsertBacklink<CR>", opts)
-- -- toggle checkbox
vim.api.nvim_buf_set_keymap(buffer_number, "n", "[]", "<Cmd>Telekasten toggle_todo<CR>", opts)
-- go back
vim.api.nvim_buf_set_keymap(buffer_number, "n", "<bs>", ":edit #<cr>", { silent = true })
-- open notes on <Space><Space>
vim.api.nvim_buf_set_keymap(
	buffer_number,
	"n",
	"<leader><Space>",
	"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
	{ silent = true, desc = "Open Notes" }
)

local wk = require("which-key")
wk.register({
	S = { "<Cmd>Slides<CR>", "[S]lides" },
	Z = {
		name = "[Z]ettelkasten",
		b = { "<Cmd>ZkBacklinks<CR>", "[B]acklinks" },
		l = { "<Cmd>ZkLinks<CR>", "[L]inks" },
		o = { "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "[O]pen Notes" },
		g = { "<Cmd>ZkTags<CR>", "Ta[g]s" },
		s = { "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", "[S]earch" },
		n = { "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", "[N]ew Note" },
		w = {
			name = "bro[w]se",
			i = { "<Cmd>Telekasten show_calendar<CR>", "d[i]ary" },
			t = { "<Cmd>NewDiary <bar> Telekasten goto_today<CR>", "[t]oday" },
			w = { "<Cmd>e ~/Sync/Notes/index.md<CR>", "[w]iki root" },
		},
	},
	T = {
		name = "[T]able",
		t = { "<cmd>MkdnTable 3 3<cr>", "3x3 [T]able" },
		f = { "<cmd>MkdnTableFormat<cr>", "[F]ormat" },
		c = { "<cmd>MkdnTableNewColAfter<cr>", "Insert [C]olumn After" },
		C = { "<cmd>MkdnTableNewColBefore<cr>", "Insert [C]olumn Before" },
		r = { "<cmd>MkdnTableNewRowBelow<cr>", "Insert [R]ow Below" },
		R = { "<cmd>MkdnTableNewRowAbove<cr>", "Insert [R]ow Above" },
	},
}, { prefix = "<leader>", silent = true, noremap = true, buffer = buffer_number })
