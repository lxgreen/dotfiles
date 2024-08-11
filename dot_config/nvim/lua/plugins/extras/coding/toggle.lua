return {
	{ "tpope/vim-speeddating", event = "LazyFile" },
	{
		"nguyenvukhang/nvim-toggler",
		event = "LazyFile",
		config = function()
			require("nvim-toggler").setup({
				inverses = {
					["!=="] = "===",
					["<"] = ">",
					["+"] = "-",
					["add"] = "remove",
					["before"] = "after",
					["const"] = "let",
					["enable"] = "disable",
					["every"] = "some",
					["first"] = "last",
					["global"] = "local",
					["increment"] = "decrement",
					["left"] = "right",
					["next"] = "prev",
					["on"] = "off",
					["open"] = "close",
					["split"] = "join",
					["start"] = "end",
					["top"] = "bottom",
					["true"] = "false",
					["up"] = "down",
					["yes"] = "no",
					["from"] = "to",
					["all"] = "none",
					["desktop"] = "mobile",
				},
				-- removes the default set of inverses
				remove_default_inverses = true,
			})
		end,
	},
}
