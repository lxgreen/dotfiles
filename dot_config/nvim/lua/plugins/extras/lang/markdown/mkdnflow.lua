return {
	"jakewvincent/mkdnflow.nvim",
	ft = { "markdown" },
	enabled = false,
	config = function()
		require("mkdnflow").setup({
			modules = {
				bib = true,
				buffers = true,
				cmp = false,
				conceal = true,
				cursor = true,
				folds = true,
				links = true,
				lists = true,
				maps = true,
				paths = true,
				tables = false,
				yaml = false,
			},
			filetypes = { md = true, rmd = true, markdown = true },
			create_dirs = true,
			perspective = {
				priority = "root",
				fallback = "current",
				root_tell = "README.md",
				nvim_wd_heel = false,
				update = false,
			},
			wrap = true,
			bib = {
				default_path = nil,
				find_in_root = true,
			},
			silent = false,
			links = {
				style = "markdown",
				name_is_source = false,
				conceal = true,
				context = 0,
				implicit_extension = "md",
				transform_implicit = false,
				transform_explicit = function(text)
					text = text:gsub(" ", "-")
					text = text:lower()
					text = text .. ".md"
					return text
				end,
			},
			new_file_template = {
				use_template = true,
				placeholders = {
					before = {
						title = "link_title",
						date = "os_date",
					},
					after = {},
				},
				template = "---\ntitle: {{ title }}\ndate: {{ date }}\ntype: note\n---\n \n# {{ title }}\n \n---\n \nbacklink: ",
			},
			to_do = {
				symbols = { " ", "-", "X" },
				update_parents = true,
				not_started = " ",
				in_progress = "-",
				complete = "X",
			},
			tables = {
				trim_whitespace = true,
				format_on_move = true,
				auto_extend_rows = false,
				auto_extend_cols = false,
			},
			yaml = {
				bib = { override = false },
			},
			mappings = {
				MkdnEnter = { { "i", "n", "v" }, "<CR>" }, -- follow or add link
				MkdnTab = false,
				MkdnSTab = false,
				MkdnNextLink = { "n", "<Tab>" }, -- browse page links
				MkdnPrevLink = { "n", "<S-Tab>" },
				MkdnNextHeading = { "n", "]]" }, -- browse headings
				MkdnPrevHeading = { "n", "[[" },
				MkdnGoBack = { "n", "<BS>" }, -- browse notes
				MkdnGoForward = { "n", "<Del>" },
				MkdnCreateLink = false, -- see MkdnEnter
				MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
				MkdnFollowLink = false, -- see MkdnEnter
				MkdnDestroyLink = { "n", "<C-D>" }, -- remove link
				MkdnTagSpan = { "v", "<C-t>" }, -- tag selection to be linkable
				MkdnMoveSource = { "n", "<F2>" }, -- move/rename note file + update references
				MkdnYankAnchorLink = { "n", "yaa" },
				MkdnYankFileAnchorLink = { "n", "yfa" },
				MkdnIncreaseHeading = { "n", "+" },
				MkdnDecreaseHeading = { "n", "-" },
				MkdnToggleToDo = { { "n", "x" }, "[]" },
				MkdnNewListItem = false,
				MkdnNewListItemBelowInsert = { "n", "o" },
				MkdnNewListItemAboveInsert = { "n", "O" },
				MkdnExtendList = false,
				MkdnUpdateNumbering = { "n", "<leader>nn" },
				MkdnTableNextCell = { "n", "<Right>" },
				MkdnTablePrevCell = { "n", "<Left>" },
				MkdnTableNextRow = { "n", "<Down>" },
				MkdnTablePrevRow = { "n", "<Up>" },
			},
		})
	end,
}
