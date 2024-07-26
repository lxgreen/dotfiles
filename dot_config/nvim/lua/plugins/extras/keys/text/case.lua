return {
	"johmsalas/text-case.nvim",
	optional = true,
	keys = {
		{
			"gau",
			"<cmd>lua require('textcase').current_word('to_upper_case')<cr>",
			{ desc = "Rename to upper case (current word)" },
		},
		{
			"gal",
			"<cmd>lua require('textcase').current_word('to_lower_case')<cr>",
			{ desc = "Rename to lower case (current word)" },
		},
		{
			"gas",
			"<cmd>lua require('textcase').current_word('to_snake_case')<cr>",
			{ desc = "Rename to snake case (current word)" },
		},
		{
			"gad",
			"<cmd>lua require('textcase').current_word('to_dash_case')<cr>",
			{ desc = "Rename to dash case (current word)" },
		},
		{
			"gan",
			"<cmd>lua require('textcase').current_word('to_constant_case')<cr>",
			{ desc = "Rename to constant case (current word)" },
		},
		{
			"gaa",
			"<cmd>lua require('textcase').current_word('to_phrase_case')<cr>",
			{ desc = "Rename to phrase case (current word)" },
		},
		{
			"gac",
			"<cmd>lua require('textcase').current_word('to_camel_case')<cr>",
			{ desc = "Rename to camel case (current word)" },
		},
		{
			"gap",
			"<cmd>lua require('textcase').current_word('to_pascal_case')<cr>",
			{ desc = "Rename to pascal case (current word)" },
		},
		{
			"gat",
			"<cmd>lua require('textcase').current_word('to_title_case')<cr>",
			{ desc = "Rename to title case (current word)" },
		},
		{
			"gaf",
			"<cmd>lua require('textcase').current_word('to_path_case')<cr>",
			{ desc = "Rename to path case (current word)" },
		},
		{
			"ga.",
			"<cmd>lua require('textcase').current_word('to_dot_case')<cr>",
			{ desc = "Rename to dot case (current word)" },
		},
		{
			"ga,",
			"<cmd>lua require('textcase').current_word('to_comma_case')<cr>",
			{ desc = "Rename to comma case (current word)" },
		},

		{
			"gaU",
			"<cmd>lua require('textcase').lsp_rename('to_upper_case')<cr>",
			{ desc = "Rename to upper case (LSP)" },
		},
		{
			"gaL",
			"<cmd>lua require('textcase').lsp_rename('to_lower_case')<cr>",
			{ desc = "Rename to lower case (LSP)" },
		},
		{
			"gaS",
			"<cmd>lua require('textcase').lsp_rename('to_snake_case')<cr>",
			{ desc = "Rename to snake case (LSP)" },
		},
		{
			"gaD",
			"<cmd>lua require('textcase').lsp_rename('to_dash_case')<cr>",
			{ desc = "Rename to dash case (LSP)" },
		},
		{
			"gaN",
			"<cmd>lua require('textcase').lsp_rename('to_constant_case')<cr>",
			{ desc = "Rename to constant case (LSP)" },
		},
		{
			"gaA",
			"<cmd>lua require('textcase').lsp_rename('to_phrase_case')<cr>",
			{ desc = "Rename to phrase case (LSP)" },
		},
		{
			"gaC",
			"<cmd>lua require('textcase').lsp_rename('to_camel_case')<cr>",
			{ desc = "Rename to camel case (LSP)" },
		},
		{
			"gaP",
			"<cmd>lua require('textcase').lsp_rename('to_pascal_case')<cr>",
			{ desc = "Rename to pascal case (LSP)" },
		},
		{
			"gaT",
			"<cmd>lua require('textcase').lsp_rename('to_title_case')<cr>",
			{ desc = "Rename to title case (LSP)" },
		},
		{
			"gaF",
			"<cmd>lua require('textcase').lsp_rename('to_path_case')<cr>",
			{ desc = "Rename to path case (LSP)" },
		},
		{
			"ga>",
			"<cmd>lua require('textcase').lsp_rename('to_dot_case')<cr>",
			{ desc = "Rename to dot case (current word)" },
		},
		{
			"ga<",
			"<cmd>lua require('textcase').lsp_rename('to_comma_case')<cr>",
			{ desc = "Rename to comma case (current word)" },
		},

		{
			"gou",
			"<cmd>lua require('textcase').operator('to_upper_case')<cr>",
			{ desc = "Rename to upper case (operator)" },
		},
		{
			"gol",
			"<cmd>lua require('textcase').operator('to_lower_case')<cr>",
			{ desc = "Rename to lower case (operator)" },
		},
		{
			"gos",
			"<cmd>lua require('textcase').operator('to_snake_case')<cr>",
			{ desc = "Rename to snake case (operator)" },
		},
		{
			"god",
			"<cmd>lua require('textcase').operator('to_dash_case')<cr>",
			{ desc = "Rename to dash case (operator)" },
		},
		{
			"gon",
			"<cmd>lua require('textcase').operator('to_constant_case')<cr>",
			{ desc = "Rename to constant case (operator)" },
		},
		{
			"goa",
			"<cmd>lua require('textcase').operator('to_phrase_case')<cr>",
			{ desc = "Rename to phrase case (operator)" },
		},
		{
			"goc",
			"<cmd>lua require('textcase').operator('to_camel_case')<cr>",
			{ desc = "Rename to camel case (operator)" },
		},
		{
			"gop",
			"<cmd>lua require('textcase').operator('to_pascal_case')<cr>",
			{ desc = "Rename to pascal case (operator)" },
		},
		{
			"got",
			"<cmd>lua require('textcase').operator('to_title_case')<cr>",
			{ desc = "Rename to title case (operator)" },
		},
		{
			"gof",
			"<cmd>lua require('textcase').operator('to_path_case')<cr>",
			{ desc = "Rename to path case (operator)" },
		},
		{
			"go>",
			"<cmd>lua require('textcase').operator('to_dot_case')<cr>",
			{ desc = "Rename to dot case (operator)" },
		},
		{
			"go,",
			"<cmd>lua require('textcase').operator('to_comma_case')<cr>",
			{ desc = "Rename to comma case (operator)" },
		},
	},
}
