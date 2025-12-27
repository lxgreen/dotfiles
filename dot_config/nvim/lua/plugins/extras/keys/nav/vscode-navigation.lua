-- VSCode-like navigation bindings: ]x, [x patterns
-- Provides impaired-like navigation similar to VSCode
--
-- Note: [x conflicts with go-to-context.lua which uses [x for treesitter context.
-- This file takes precedence for conflict navigation as requested.

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
			vim.keymap.set("n", "[h", vscode_notify("workbench.action.editor.previousChange"), { desc = "Previous hunk" })

			-- Errors: ]e, [e
			vim.keymap.set("n", "]e", vscode_notify("editor.action.marker.nextInFiles"), { desc = "Next error" })
			vim.keymap.set("n", "[e", vscode_notify("editor.action.marker.prevInFiles"), { desc = "Previous error" })

			-- Warnings: ]w, [w
			vim.keymap.set("n", "]w", vscode_notify("editor.action.marker.nextInFiles"), { desc = "Next warning" })
			vim.keymap.set("n", "[w", vscode_notify("editor.action.marker.prevInFiles"), { desc = "Previous warning" })

			-- Diagnostics (any): ]d, [d
			vim.keymap.set("n", "]d", vscode_notify("editor.action.marker.next"), { desc = "Next diagnostic" })
			vim.keymap.set("n", "[d", vscode_notify("editor.action.marker.prev"), { desc = "Previous diagnostic" })

			-- Spelling: ]s, [s
			vim.keymap.set("n", "]s", vscode_notify("editor.action.marker.next"), { desc = "Next spelling error" })
			vim.keymap.set("n", "[s", vscode_notify("editor.action.marker.prev"), { desc = "Previous spelling error" })

			-- Search results: ]q, [q
			vim.keymap.set("n", "]q", vscode_notify("search.action.focusNextSearchResult"), { desc = "Next search result" })
			vim.keymap.set("n", "[q", vscode_notify("search.action.focusPreviousSearchResult"), { desc = "Previous search result" })
		end,
	})
	return {}
end

-- Neovim mode: use native functions and plugins
return {
	config = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimKeymaps",
			callback = function()
				-- Conflicts: ]x, [x
				if pcall(require, "git-conflict") then
					vim.keymap.set("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next conflict" })
					vim.keymap.set("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Previous conflict" })
				end

				-- Hunks: ]h, [h
				if pcall(require, "gitsigns") then
					vim.keymap.set("n", "]h", function()
						if vim.wo.diff then
							return "]h"
						end
						vim.schedule(function()
							require("gitsigns").next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next hunk" })

					vim.keymap.set("n", "[h", function()
						if vim.wo.diff then
							return "[h"
						end
						vim.schedule(function()
							require("gitsigns").prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous hunk" })
				end

				-- Errors: ]e, [e
				vim.keymap.set("n", "]e", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				end, { desc = "Next error" })
				vim.keymap.set("n", "[e", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end, { desc = "Previous error" })

				-- Warnings: ]w, [w
				vim.keymap.set("n", "]w", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
				end, { desc = "Next warning" })
				vim.keymap.set("n", "[w", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
				end, { desc = "Previous warning" })

				-- Diagnostics (any): ]d, [d
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_next()
				end, { desc = "Next diagnostic" })
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev()
				end, { desc = "Previous diagnostic" })

				-- Spelling: ]s, [s
				vim.keymap.set("n", "]s", function()
					if vim.wo.spell then
						vim.cmd("normal! ]s")
					else
						-- Fall back to diagnostics (for LSP-based spell checkers like ltex)
						vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO })
					end
				end, { desc = "Next spelling error" })
				vim.keymap.set("n", "[s", function()
					if vim.wo.spell then
						vim.cmd("normal! [s")
					else
						vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.INFO })
					end
				end, { desc = "Previous spelling error" })

				-- Search results (quickfix): ]q, [q
				vim.keymap.set("n", "]q", function()
					if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
						vim.cmd("cnext")
					else
						vim.cmd("try | cnext | catch | echo 'No quickfix list' | endtry")
					end
				end, { desc = "Next search result" })
				vim.keymap.set("n", "[q", function()
					if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
						vim.cmd("cprev")
					else
						vim.cmd("try | cprev | catch | echo 'No quickfix list' | endtry")
					end
				end, { desc = "Previous search result" })

				-- Additional suggested navigation bindings:

				-- TODO/FIXME comments: ]t, [t
				vim.keymap.set("n", "]t", function()
					vim.fn.search("\\v(TODO|FIXME|NOTE|HACK|XXX|BUG)", "W")
				end, { desc = "Next TODO/FIXME" })
				vim.keymap.set("n", "[t", function()
					vim.fn.search("\\v(TODO|FIXME|NOTE|HACK|XXX|BUG)", "bW")
				end, { desc = "Previous TODO/FIXME" })

				-- Changes (diff): ]c, [c
				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						vim.cmd("normal! ]c")
					else
						vim.notify("Not in diff mode", vim.log.levels.WARN)
					end
				end, { desc = "Next change (diff)" })
				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd("normal! [c")
					else
						vim.notify("Not in diff mode", vim.log.levels.WARN)
					end
				end, { desc = "Previous change (diff)" })

				-- Functions/methods: ]f, [f
				-- Uses simple pattern search - can be enhanced with treesitter if needed
				vim.keymap.set("n", "]f", function()
					vim.fn.search("\\v^(function|def|class|method|fn|const|let|var)\\s+\\w+", "W")
				end, { desc = "Next function" })
				vim.keymap.set("n", "[f", function()
					vim.fn.search("\\v^(function|def|class|method|fn|const|let|var)\\s+\\w+", "bW")
				end, { desc = "Previous function" })

				-- Locations (LSP): ]l, [l
				vim.keymap.set("n", "]l", function()
					if pcall(require, "trouble") then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						-- Fallback to location list
						vim.cmd("try | lnext | catch | echo 'No location list' | endtry")
					end
				end, { desc = "Next location" })
				vim.keymap.set("n", "[l", function()
					if pcall(require, "trouble") then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						vim.cmd("try | lprev | catch | echo 'No location list' | endtry")
					end
				end, { desc = "Previous location" })

				-- References: ]r, [r
				vim.keymap.set("n", "]r", function()
					if pcall(require, "trouble") then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						vim.cmd("try | lnext | catch | echo 'No references' | endtry")
					end
				end, { desc = "Next reference" })
				vim.keymap.set("n", "[r", function()
					if pcall(require, "trouble") then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						vim.cmd("try | lprev | catch | echo 'No references' | endtry")
					end
				end, { desc = "Previous reference" })
			end,
		})
	end,
}

