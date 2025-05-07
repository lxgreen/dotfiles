return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = {
		mode = "legacy",
		provider = "openai",
		cursor_applying_provider = "openai",
		behaviour = {
			enable_cursor_planning_mode = true,
		},
		file_selector = { provider = "snacks" },

		hints = { enabled = true },

		windows = {
			sidebar_header = { align = "left", rounded = false },
			input = { prefix = " ", height = 6 },
			edit = { border = "rounded" },
			ask = { start_insert = false },
		},
		-- NOTE: AFTER MODIFICATION, RESTART RAG DOCKER-BASED SERVICE BY `docker rm -fv avante-rag-service`
		rag_service = {
			enabled = true, -- Enables the RAG service
			host_mount = os.getenv("HOME"), -- Host mount path for the rag service
			provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
			llm_model = "gpt-4o", -- The LLM model to use for RAG service
			embed_model = "", -- The embedding model to use for RAG service
			endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
		},
		openai = {
			endpoint = "https://api.openai.com/v1",
			model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
			timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
			temperature = 0,
			max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
			--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			"saghen/blink.cmp",
			optional = true,
			dependencies = { "saghen/blink.compat" },

			opts = {
				sources = {
					default = { "avante_commands", "avante_mentions", "avante_files" },
					compat = { "avante_commands", "avante_mentions", "avante_files" },

					providers = {
						avante_commands = {
							name = "avante_commands",
							module = "blink.compat.source",
							score_offset = 90,
							opts = {},
						},

						avante_files = {
							name = "avante_files",
							module = "blink.compat.source",
							score_offset = 100,
							opts = {},
						},

						avante_mentions = {
							name = "avante_mentions",
							module = "blink.compat.source",
							score_offset = 1000,
							opts = {},
						},
					},
				},
			},
		},
		{
			"catppuccin/nvim",
			optional = true,
			opts = { integrations = { avante = true } },
		},
	},
}
