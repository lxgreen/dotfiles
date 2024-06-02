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
