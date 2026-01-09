-- VSCode-like navigation bindings: ]x, [x patterns
-- Provides impaired-like navigation similar to VSCode

if vim.g.vscode then
	-- VSCode mode: use VSCodeNotify
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimKeymaps",
		callback = function()
			local function vscode_notify(cmd)
				return function()
					vim.fn.VSCodeNotify(cmd)
				end
			end

			-- Hunks: ]h, [h
			-- Use nextChange/previousChange which works for git changes/hunks
			vim.keymap.set("n", "]h", vscode_notify("workbench.action.editor.nextChange"), { desc = "Next hunk" })
			vim.keymap.set(
				"n",
				"[h",
				vscode_notify("workbench.action.editor.previousChange"),
				{ desc = "Previous hunk" }
			)

			-- Errors: ]e, [e
			vim.keymap.set("n", "]e", vscode_notify("editor.action.marker.nextInFiles"), { desc = "Next error" })
			vim.keymap.set("n", "[e", vscode_notify("editor.action.marker.prevInFiles"), { desc = "Previous error" })

			-- Diagnostics (any): ]d, [d
			vim.keymap.set("n", "]d", vscode_notify("editor.action.marker.next"), { desc = "Next diagnostic" })
			vim.keymap.set("n", "[d", vscode_notify("editor.action.marker.prev"), { desc = "Previous diagnostic" })

			-- Search results: ]q, [q
			vim.keymap.set(
				"n",
				"]q",
				vscode_notify("search.action.focusNextSearchResult"),
				{ desc = "Next search result" }
			)
			vim.keymap.set(
				"n",
				"[q",
				vscode_notify("search.action.focusPreviousSearchResult"),
				{ desc = "Previous search result" }
			)

			-- Problems (across project): ]x, [x
			vim.keymap.set(
				"n",
				"]x",
				vscode_notify("workbench.action.problems.next"),
				{ desc = "Next problem" }
			)
			vim.keymap.set(
				"n",
				"[x",
				vscode_notify("workbench.action.problems.previous"),
				{ desc = "Previous problem" }
			)
		end,
	})
	return {}
end

-- -- Neovim mode: use native functions and plugins
return {
	"LazyVim/LazyVim",
	optional = true,
}
