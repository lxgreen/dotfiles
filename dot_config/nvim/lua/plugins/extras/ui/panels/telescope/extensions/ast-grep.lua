return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "Marskey/telescope-sg", config = require("telescope").setup({}) },

	opts = {
		extensions = {
			ast_grep = {
				-- config for ast_grep extension
				attach_mappings = function(prompt_bufnr, map)
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					local create_visual_selection = require("util").create_visual_selection
					-- replace the default action with a custom one
					actions.select_default:replace(function()
						-- open the file and create a visual selection
						actions.file_edit(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						-- vim.notify(vim.inspect(selection))
						create_visual_selection(selection.lnum, selection.col, selection.lnend, selection.colend)
					end)
					-- return true to indicate that the mapping was successfully attached
					return true
				end,
			},
		},
	},
}
