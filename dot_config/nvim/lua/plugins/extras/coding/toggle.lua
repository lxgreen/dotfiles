return {
	{ "tpope/vim-speeddating", vscode = true, event = "LazyFile" },
	{
		"nguyenvukhang/nvim-toggler",
		vscode = true,
		event = "LazyFile",
		config = function()
			require("nvim-toggler").setup({
				inverses = {
					["!="] = "==",
					["!=="] = "===",
					["+"] = "-",
					["<"] = ">",
					["<="] = ">=",
					["add"] = "remove",
					["all"] = "none",
					["before"] = "after",
					["const"] = "let",
					["desktop"] = "mobile",
					["enable"] = "disable",
					["every"] = "some",
					["first"] = "last",
					["from"] = "to",
					["global"] = "local",
					["increment"] = "decrement",
					["left"] = "right",
					["next"] = "prev",
					["on"] = "off",
					["open"] = "close",
					["public"] = "private",
					["split"] = "join",
					["start"] = "end",
					["top"] = "bottom",
					["true"] = "false",
					["up"] = "down",
					["yes"] = "no",
				},
				-- removes the default set of inverses
				remove_default_inverses = true,
				remove_default_keybinds = true,
			})
		end,
	},
}
