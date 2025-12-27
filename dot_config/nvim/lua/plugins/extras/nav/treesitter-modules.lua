local languages =
	{ "javascript", "typescript", "json", "toml", "bash", "fish", "markdown", "css", "html", "xml", "yaml" }
return {
	"MeanderingProgrammer/treesitter-modules.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	vscode = true,
	opts = {
		ensure_installed = languages,
		fold = { enable = true },
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "vv",
				node_incremental = ".",
				scope_incremental = ",",
				node_decremental = "<Esc>",
			},
		},
	},
}
