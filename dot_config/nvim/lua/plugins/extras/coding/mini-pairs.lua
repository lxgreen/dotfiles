return {
	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {
			-- Disable auto-pairing for quotes completely
			mappings = {
				['"'] = false,
				["'"] = false,
				["`"] = false,
			},
		},
	},
}
