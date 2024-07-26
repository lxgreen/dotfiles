return {
	"LazyVim/LazyVim",
	optional = true,
	keys = {
		{ mode = { "v", "n", "s" }, "<S-q>", "<cmd>q<cr><esc>", { desc = "Close window" } },
		{ mode = { "v", "n", "s" }, "<leader><S-q>", "<cmd>wqa<cr>", { desc = "Save all and quit" } },
		{ mode = { "x" }, "<Tab>", ">gv", { desc = "Indent right", noremap = true } },
		{ mode = { "n", "v" }, ";", ":", { noremap = true } },
	},
}
