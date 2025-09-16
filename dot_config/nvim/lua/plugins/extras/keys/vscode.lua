-- VS Code specific keybindings that work better with vscode-neovim extension
return {
	{
		"LazyVim/LazyVim",
		cond = function() return vim.g.vscode end,
		keys = {
			-- File operations using VS Code's native commands
			{ "<leader>ff", "<cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>", desc = "Find buffers" },
			
			-- Git operations
			{ "<leader>gg", "<cmd>call VSCodeNotify('workbench.view.scm')<CR>", desc = "Git status" },
			{ "<leader>gb", "<cmd>call VSCodeNotify('gitlens.showQuickBranchHistory')<CR>", desc = "Git branches" },
			
			-- Code navigation
			{ "gd", "<cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", desc = "Go to definition" },
			{ "gr", "<cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", desc = "Go to references" },
			{ "gi", "<cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>", desc = "Go to implementation" },
			
			-- Code actions
			{ "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<CR>", desc = "Code action" },
			{ "<leader>cr", "<cmd>call VSCodeNotify('editor.action.rename')<CR>", desc = "Rename" },
			
			-- Format
			{ "<leader>cf", "<cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", desc = "Format document" },
			
			-- Terminal
			{ "<leader>ft", "<cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>", desc = "Toggle terminal" },
			
			-- Explorer
			{ "<leader>e", "<cmd>call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>", desc = "Explorer" },
			
			-- Problems/Diagnostics
			{ "<leader>xx", "<cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>", desc = "Problems" },
		},
	},
}

