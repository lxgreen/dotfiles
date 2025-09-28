-- Simple autocmd-based approach for VS Code keybindings
-- This ensures keybindings are set after all plugins load

if vim.g.vscode then
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimKeymaps",
		callback = function()
			-- Override LazyVim keybindings for VS Code
			local function vscode_notify(cmd)
				return function()
					vim.fn.VSCodeNotify(cmd)
				end
			end

			-- File operations
			vim.keymap.set("n", "<leader>e", vscode_notify("workbench.files.action.focusFilesExplorer"), { desc = "Explorer" })
			vim.keymap.set("n", "<leader><Space>", vscode_notify("workbench.action.quickOpen"), { desc = "Find files" })
			vim.keymap.set("n", "<leader>/", vscode_notify("workbench.action.findInFiles"), { desc = "Live grep" })
			vim.keymap.set("n", "<leader>,", vscode_notify("workbench.action.showAllEditors"), { desc = "Find buffers" })
			vim.keymap.set("n", "<leader><CR>", vscode_notify("workbench.action.openRecent"), { desc = "Recent files" })
			
			-- Git operations
			vim.keymap.set("n", "<leader>gg", vscode_notify("workbench.view.scm"), { desc = "Git status" })
			vim.keymap.set("n", "<leader>gb", vscode_notify("gitlens.showQuickBranchHistory"), { desc = "Git branches" })
			vim.keymap.set("n", "<leader>gc", vscode_notify("git.commitStaged"), { desc = "Git commit" })
			
			-- Code navigation
			vim.keymap.set("n", "gd", vscode_notify("editor.action.revealDefinition"), { desc = "Go to definition" })
			vim.keymap.set("n", "gr", vscode_notify("editor.action.goToReferences"), { desc = "Go to references" })
			vim.keymap.set("n", "gi", vscode_notify("editor.action.goToImplementation"), { desc = "Go to implementation" })
			vim.keymap.set("n", "K", vscode_notify("editor.action.showHover"), { desc = "Hover" })
			
			-- Code actions
			vim.keymap.set("n", "<leader>ca", vscode_notify("editor.action.quickFix"), { desc = "Code action" })
			vim.keymap.set("n", "<leader>cr", vscode_notify("editor.action.rename"), { desc = "Rename" })
			vim.keymap.set("n", "<leader>cf", vscode_notify("editor.action.formatDocument"), { desc = "Format document" })
			
			-- Terminal
			vim.keymap.set("n", "<leader>ft", vscode_notify("workbench.action.terminal.toggleTerminal"), { desc = "Toggle terminal" })
			vim.keymap.set("n", "<c-`>", vscode_notify("workbench.action.terminal.toggleTerminal"), { desc = "Toggle terminal" })
			
			-- Problems/Diagnostics
			vim.keymap.set("n", "<leader>xx", vscode_notify("workbench.actions.view.problems"), { desc = "Problems" })
			vim.keymap.set("n", "<leader>xd", vscode_notify("editor.action.marker.next"), { desc = "Next diagnostic" })
			vim.keymap.set("n", "<leader>xD", vscode_notify("editor.action.marker.prev"), { desc = "Previous diagnostic" })
			
			-- Quit Cursor
			vim.keymap.set("n", "<leader>qq", vscode_notify("workbench.action.quit"), { desc = "Quit Cursor" })
			
			-- Flash.nvim keybindings for VSCode
			if package.loaded["flash"] or pcall(require, "flash") then
				vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })
				vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
				vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
				vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
				vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
			end
		end,
	})
end

-- Return empty table since we're using autocmds instead
return {}


