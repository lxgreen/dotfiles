return {
	"LunarVim/bigfile.nvim",
	config = function()
		require("bigfile").setup({
			filesize = 1,
		})
	end,
}
