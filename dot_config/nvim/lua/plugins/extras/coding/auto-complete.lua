return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"Kaiser-Yang/blink-cmp-avante",
			-- ... Other dependencies
		},
		opts = {
			sources = {
				-- Add 'avante' to the list
				default = { "avante", "lsp", "path", "buffer" },
				providers = {
					avante = {
						module = "blink-cmp-avante",
						name = "Avante",
						opts = {
							-- options for blink-cmp-avante
						},
					},
				},
			},
		},
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("blink.cmp").setup({
				completion = {
					menu = {
						draw = {
							-- We don't need label_description now because label and label_description are already
							-- combined together in label by colorful-menu.nvim.
							columns = { { "kind_icon" }, { "label", gap = 1 } },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
					},
				},
			})
		end,
	},
}
