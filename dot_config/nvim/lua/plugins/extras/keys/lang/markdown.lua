return {
	"tadmccorkle/markdown.nvim",
	ft = "markdown",
	keys = {
		{ "'i", "<Plug>(markdown_toggle_emphasis)", mode = { "n" }, desc = "Toggle emphasis" },
		{ "'I", "<Plug>(markdown_toggle_emphasis_line)", mode = { "n" }, desc = "Toggle emphasis line" },
		{ "'i", "<Plug>(markdown_toggle_emphasis_visual)", mode = { "v" }, desc = "Toggle emphasis (visual)" },
		{ "'di", "<Plug>(markdown_delete_emphasis)", mode = { "n" }, desc = "Delete emphasis" },
		{ "'ci", "<Plug>(markdown_change_emphasis)", mode = { "n" }, desc = "Change emphasis" },
		{ "<cr>", "<Plug>(markdown_add_link)", mode = { "n" }, desc = "Add link" },
		{ "<cr>", "<Plug>(markdown_add_link_visual)", mode = { "v" }, desc = "Add link (visual)" },
		{ "<cr>", "<Plug>(markdown_follow_link)", mode = { "n" }, desc = "Follow link" },
		{ "]]", "<Plug>(markdown_go_next_heading)", mode = { "n" }, desc = "Next heading" },
		{ "[[", "<Plug>(markdown_go_prev_heading)", mode = { "n" }, desc = "Previous heading" },
	},
}
