-- VS Code keybinding overrides that run after LazyVim setup
-- This file ensures VS Code keybindings take priority

if not vim.g.vscode then
	return
end

-- Debug: Check if Snacks is available
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyLoad",
	callback = function(event)
		if event.data == "snacks.nvim" then
			print("✅ Snacks loaded in VS Code mode")
			-- Ensure Snacks is globally available for LazyVim utilities
			if not _G.Snacks then
				_G.Snacks = require("snacks")
				print("✅ Set global Snacks reference")
			end
		end
	end,
})

-- Wait for LazyVim to finish loading, then override keybindings
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- Small delay to ensure all plugins have loaded
		vim.defer_fn(function()
			-- Ensure Snacks is available globally
			if not _G.Snacks and package.loaded["snacks"] then
				_G.Snacks = require("snacks")
				print("✅ Set global Snacks reference (fallback)")
			end
			
			local function vscode_notify(cmd)
				return function()
					vim.fn.VSCodeNotify(cmd)
				end
			end

			-- Clear existing keybindings first
			pcall(vim.keymap.del, "n", "<leader>e")
			pcall(vim.keymap.del, "n", "<leader>ff")
			pcall(vim.keymap.del, "n", "<leader>fg")
			pcall(vim.keymap.del, "n", "<leader>fb")
			pcall(vim.keymap.del, "n", "<leader>fr")

			-- Set VS Code keybindings with high priority
			vim.keymap.set("n", "<leader>e", vscode_notify("workbench.files.action.focusFilesExplorer"), { desc = "Explorer", silent = true })
			vim.keymap.set("n", "<leader>ff", vscode_notify("workbench.action.quickOpen"), { desc = "Find files", silent = true })
			vim.keymap.set("n", "<leader>fg", vscode_notify("workbench.action.findInFiles"), { desc = "Live grep", silent = true })
			vim.keymap.set("n", "<leader>fb", vscode_notify("workbench.action.showAllEditors"), { desc = "Find buffers", silent = true })
			vim.keymap.set("n", "<leader>fr", vscode_notify("workbench.action.openRecent"), { desc = "Recent files", silent = true })
			
			-- Additional VS Code keybindings
			vim.keymap.set("n", "<leader>gg", vscode_notify("workbench.view.scm"), { desc = "Git status", silent = true })
			vim.keymap.set("n", "<leader>ca", vscode_notify("editor.action.quickFix"), { desc = "Code action", silent = true })
			vim.keymap.set("n", "<leader>cr", vscode_notify("editor.action.rename"), { desc = "Rename", silent = true })
			vim.keymap.set("n", "<leader>cf", vscode_notify("editor.action.formatDocument"), { desc = "Format", silent = true })
			vim.keymap.set("n", "<leader>xx", vscode_notify("workbench.actions.view.problems"), { desc = "Problems", silent = true })
			
			-- Code navigation
			vim.keymap.set("n", "gd", vscode_notify("editor.action.revealDefinition"), { desc = "Go to definition", silent = true })
			vim.keymap.set("n", "gr", vscode_notify("editor.action.goToReferences"), { desc = "Go to references", silent = true })
			vim.keymap.set("n", "K", vscode_notify("editor.action.showHover"), { desc = "Hover", silent = true })

			print("VS Code keybindings loaded successfully!")
		end, 200)
	end,
})




