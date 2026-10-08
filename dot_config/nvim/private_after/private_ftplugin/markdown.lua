vim.cmd("setlocal foldmethod=expr")

local buffer_number = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = false }

vim.opt.conceallevel = 2

-- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
vim.api.nvim_buf_set_keymap(
	buffer_number,
	"v",
	"<cr>",
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

-- follow markdown link under cursor on <CR>: URLs via vim.ui.open, everything else via zk LSP
local function follow_markdown_link()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	local function match_at_cursor(pattern)
		local init = 1
		while true do
			local s, e, cap = line:find(pattern, init)
			if not s then return nil end
			if col >= s and col <= e then return cap end
			init = e + 1
		end
	end

	local function is_non_url_markdown_link()
		local href = match_at_cursor("%[[^%]]-%]%(([^)]+)%)")
		if href and not href:match("^%a[%w+.-]*:") then
			return true
		end

		return match_at_cursor("%[%[([^%]]-)%]%]") ~= nil
	end

	local function preferred_zk_location(items)
		if #items <= 1 then return items[1] end

		for _, item in ipairs(items) do
			local text = vim.trim(item.text or "")
			if text:match("^#+%s+") then
				return item
			end
		end

		for _, item in ipairs(items) do
			local text = vim.trim(item.text or ""):lower()
			if text:match("^title:%s+") then
				return item
			end
		end

		local first = items[1]
		if first then
			for _, item in ipairs(items) do
				if item.filename == first.filename and item.lnum > 1 then
					return item
				end
			end
		end

		return first
	end

	local function follow_zk_note_link()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({
			bufnr = bufnr,
			name = "zk",
			method = "textDocument/definition",
		})
		if vim.tbl_isempty(clients) then
			vim.lsp.buf.definition()
			return
		end

		local client = clients[1]
		client:request(
			"textDocument/definition",
			vim.lsp.util.make_position_params(0, client.offset_encoding),
			function(_, result)
				if result then
					local locations = vim.islist(result) and result or { result }
					local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
					local item = preferred_zk_location(items)

					if item and item.user_data then
						vim.lsp.util.show_document(item.user_data, client.offset_encoding, {
							focus = true,
							reuse_win = true,
						})
						return
					end
				end

				vim.lsp.buf.definition()
			end,
			bufnr
		)
	end

	local url = match_at_cursor("%[[^%]]-%]%((https?://[^)]+)%)")
		or match_at_cursor("<(https?://[^>]+)>")
		or match_at_cursor("(https?://[^%s<>%)%]]+)")
	if url then
		vim.ui.open(url)
		return
	end

	if is_non_url_markdown_link() then
		follow_zk_note_link()
		return
	end

	vim.lsp.buf.definition()
end

vim.keymap.set("n", "<CR>", follow_markdown_link, {
	buffer = buffer_number,
	silent = true,
	desc = "Follow markdown link",
})
-- Search for the notes matching the current visual selection.
vim.api.nvim_buf_set_keymap(buffer_number, "v", "<leader>s", ":'<,'>ZkMatch<CR>", opts)
vim.api.nvim_buf_set_keymap(buffer_number, "n", "<leader>B", "<cmd>InsertBacklink<CR>", opts)
-- -- toggle checkbox
vim.api.nvim_buf_set_keymap(buffer_number, "n", "[]", "<Cmd>MkdnToggleTodo<CR>", opts)

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
