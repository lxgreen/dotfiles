return {
	"LazyVim/LazyVim",
	keys = {
		{
			"<c-/>",
			function()
				Snacks.terminal(nil, { win = { position = "bottom", relative = "editor" } })
			end,
			desc = "Terminal (cwd)",
			mode = { "n", "t" },
		},
	},
}
