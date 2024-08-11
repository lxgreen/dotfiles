return {
	"folke/noice.nvim",
	optional = true,
	keys = {
		{ mode = { "n", "i", "s", "o", "x" }, "<F1>", "<cmd>NoiceDismiss<CR>", desc = "Dismiss Notifications" },
		{ mode = { "n", "i", "s", "o", "x" }, "<F2>", "<cmd>Noice<CR>", desc = "Show Notifications" },
	},
}
