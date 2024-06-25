return {
	"piersolenski/wtf.nvim",

	opts = {
		openai_api_key = vim.fn.getenv("OPENAI_API_KEY"),
		openai_model_id = "gpt-4o",
		language = "english",
	},

	keys = {
		{
			"<leader>gw",
			[[<cmd>lua require("wtf").ai()<cr>]],
			desc = "Debug diagnostic with AI",
			mode = { "n", "x" },
		},
		{
			"<leader>cg",
			[[<cmd>lua require("wtf").search()<cr>]],
			desc = "Search diagnostic with Google",
			mode = { "n" },
		},
	},
}
