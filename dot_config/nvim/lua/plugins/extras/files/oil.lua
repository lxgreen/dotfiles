return {
	"stevearc/oil.nvim",
	enabled = true,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {
		confirm = false,
		delete_to_trash = true,
	} } },
	lazy = false,
}
