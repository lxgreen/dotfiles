return {
	"alexghergh/nvim-tmux-navigation",
	enabled = false,
	config = function()
		require("nvim-tmux-navigation").setup({
			disable_when_zoomed = false,
		})
	end,
}
