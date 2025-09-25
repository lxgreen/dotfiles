return {
	"snrogers/mermaider.nvim",
	dependencies = {
		"3rd/image.nvim", -- Required for image display
	},
	config = function()
		require("mermaider").setup({
			-- Command to use for mermaid rendering
			cmd = "mmdc", -- Use the installed mermaid CLI
			-- Output format for rendered diagrams
			output_format = "svg",
			-- Temp directory for rendering
			temp_dir = vim.fn.stdpath("cache") .. "/mermaider",
			-- Mermaid CLI arguments
			args = {
				"-t", "default", -- theme
				"-b", "transparent", -- background
				"--scale", "2", -- scale factor
			},
		})
	end,
	ft = { "mmd", "mermaid", "markdown" }, -- Added markdown support
}
