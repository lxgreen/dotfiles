-- Disable LazyVim features that cause issues in VS Code

if not vim.g.vscode then
	return {}
end

return {
	-- Disable LazyVim's built-in keymaps that cause Snacks errors
	{
		"LazyVim/LazyVim",
		opts = {
			-- Disable default LazyVim keymaps that use Snacks
			defaults = {
				keymaps = false, -- Disable all default LazyVim keymaps
			},
		},
	},
}

