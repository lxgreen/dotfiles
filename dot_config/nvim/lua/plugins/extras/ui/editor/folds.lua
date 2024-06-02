return {
	"anuvyklack/pretty-fold.nvim",
	-- event = "LazyFile",
	lazy = false,
	config = function()
		require("pretty-fold").setup()
	end,
}
