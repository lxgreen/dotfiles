local lualine_theme_create = require("utils").lualine_theme_create

-- update highlight and theme on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = vim.schedule_wrap(function()
    require("lualine").setup({ options = { theme = lualine_theme_create() } })
    require("nvim-web-devicons").set_up_highlights(true)
  end),
})

vim.api.nvim_create_autocmd("BufHidden", {
  desc = "Delete [No Name] buffers",
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, event.buf, {})
      end)
    end
  end,
})

local ghost_group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "*github.com",
  callback = function()
    vim.cmd("setlocal filetype=markdown")
    vim.cmd("setlocal autowrite")
    vim.cmd("setlocal spell")
    vim.cmd("setlocal spelllang=en_us")
    vim.cmd("setlocal spellfile=~/.config/nvim/spell/en.utf-8.add")
  end,
  group = ghost_group,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "trans",
  callback = function()
    vim.bo.syntax = "json"
  end,
})

-- Function to switch to English keyboard layout
function on_leave_insert()
  -- vim.g.insert_mode_layout = vim.fn.system("im-select")
  os.execute("im-select com.apple.keylayout.ABC")
end

-- Function to save the current layout and restore it
function on_enter_insert()
  local layout = vim.g.insert_mode_layout or "com.apple.keylayout.ABC"
  os.execute("im-select " .. layout)
end

-- Set autocommands to switch layout on insert leave and to save/restore on insert enter/leave
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "markdown",
  callback = on_leave_insert,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "markdown",
  callback = on_enter_insert,
})
