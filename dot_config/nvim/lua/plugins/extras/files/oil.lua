return {
	"stevearc/oil.nvim",
	enabled = true,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = false,
	},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	config = function(_, opts)
		require("oil").setup(opts)
		-- Override oil's BufWriteCmd to never show confirmation (confirm=false)
		-- Oil registers its autocmd in the "Oil" augroup — must specify group to clear it
		vim.api.nvim_clear_autocmds({ event = "BufWriteCmd", group = "Oil" })
		vim.api.nvim_create_autocmd("BufWriteCmd", {
			group = "Oil",
			pattern = "oil://*",
			nested = true,
			callback = function()
				require("oil").save({ confirm = false })
			end,
		})
	end,
}
