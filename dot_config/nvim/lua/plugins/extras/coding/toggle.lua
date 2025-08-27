return {
	{ "tpope/vim-repeat" },
	{ "tpope/vim-speeddating" },
	{
		"nguyenvukhang/nvim-toggler",
		vscode = true,
		event = "LazyFile",
		config = function()
			local inverses_module = require("config.inverses")

			-- Function to restart nvim-toggler with updated config
			local function restart_toggler()
				-- Re-setup nvim-toggler with fresh inverses from file
				require("nvim-toggler").setup({
					inverses = inverses_module.get_inverses(),
					remove_default_inverses = true,
					remove_default_keybinds = true,
				})

				vim.notify("nvim-toggler restarted with updated inverses", vim.log.levels.INFO)
			end

			-- Initial setup
			require("nvim-toggler").setup({
				inverses = inverses_module.get_inverses(),
				remove_default_inverses = true,
				remove_default_keybinds = true,
			})

			-- Create custom command for adding inverse mappings
			vim.api.nvim_create_user_command("AddInverse", function(opts)
				-- Get visual selection if in visual mode
				local selection = ""
				if opts.range > 0 then
					local start_pos = vim.fn.getpos("'<")
					local end_pos = vim.fn.getpos("'>")
					local lines = vim.fn.getline(start_pos[2], end_pos[2])

					if #lines == 1 then
						-- Single line selection
						local start_col = start_pos[3]
						local end_col = end_pos[3]
						selection = string.sub(lines[1], start_col, end_col)
					else
						-- Multi-line selection (take first line for simplicity)
						selection = lines[1]
					end

					-- Trim whitespace
					selection = vim.trim(selection)
				end

				-- Prompt for first word (pre-fill with selection if available)
				local word1 = vim.fn.input({
					prompt = "First word: ",
					default = selection,
				})

				if word1 == "" then
					vim.notify("Cancelled: First word cannot be empty", vim.log.levels.WARN)
					return
				end

				-- Prompt for second word
				local word2 = vim.fn.input({
					prompt = "Second word (inverse of '" .. word1 .. "'): ",
				})

				if word2 == "" then
					vim.notify("Cancelled: Second word cannot be empty", vim.log.levels.WARN)
					return
				end

				-- Add the inverse mapping
				local success, message = inverses_module.add_inverse(word1, word2)

				if success then
					vim.notify(message, vim.log.levels.INFO)
					-- Restart toggler with updated config
					restart_toggler()
				else
					vim.notify("Error: " .. message, vim.log.levels.ERROR)
				end
			end, {
				range = true,
				desc = "Add inverse mapping for nvim-toggler",
			})

			-- Add key binding for visual mode
			vim.keymap.set("v", "<leader>i", ":AddInverse<CR>", {
				desc = "Add inverse mapping for selected text",
				silent = true,
			})
		end,
	},
}
