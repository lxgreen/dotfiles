local AutocmdsUtil = require("config.autocmds.util")

-- Save last nvim server id when nvim loses focus (FocusLost)
-- used in Wezterm to open picked file in nvim
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("focus_lost", {}),
	pattern = "*",
	callback = function()
		local servername = vim.v.servername
		vim.fn.writefile({ servername }, "/tmp/nvim-focuslost")
	end,
})

vim.api.nvim_create_autocmd("Signal", {
	desc = "Change colorscheme after system theme changed",
	callback = vim.schedule_wrap(AutocmdsUtil.colorscheme_update),
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyUpdate",
	desc = "Update dotfiles (chezmoi apply)",
	callback = vim.schedule_wrap(AutocmdsUtil.chezmoi_update),
})
