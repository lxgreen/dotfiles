local function is_not_vs_code()
	return not vim.g.vscode
end

return {
	{ "folke/snacks.nvim", cond = is_not_vs_code },
}
