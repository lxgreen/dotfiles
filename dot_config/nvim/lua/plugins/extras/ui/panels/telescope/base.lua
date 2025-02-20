local dotfiles_path = vim.fn.getenv("DOTFILES_SRC_PATH")
dotfiles_path = dotfiles_path == vim.NIL and "" or dotfiles_path

local function open_selected(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local multi = picker:get_multi_selection()

	if not vim.tbl_isempty(multi) then
		require("telescope.actions").close(prompt_bufnr)

		for _, j in pairs(multi) do
			if j.path ~= nil then
				vim.cmd(string.format("%s %s", "edit", j.path))
			end
		end
	else
		require("telescope.actions").select_default(prompt_bufnr)
	end
end

local function get_mappings()
	local actions = require("telescope.actions")

	return {
		n = {
			["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
		},
		i = {
			["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			["<cr>"] = open_selected,
		},
	}
end

local file_ignore_patterns = {
	".git/",
	"node_modules/",
	".cache/",
	".next/",
	"messages_ar.json",
	"messages_bg.json",
	"messages_ca.json",
	"messages_cs.json",
	"messages_da.json",
	"messages_de.json",
	"messages_el.json",
	"messages_es.json",
	"messages_fi.json",
	"messages_fr.json",
	"messages_he.json",
	"messages_hi.json",
	"messages_hu.json",
	"messages_id.json",
	"messages_it.json",
	"messages_ja.json",
	"messages_ko.json",
	"messages_lt.json",
	"messages_ms.json",
	"messages_nl.json",
	"messages_no.json",
	"messages_pl.json",
	"messages_pt.json",
	"messages_ro.json",
	"messages_ru.json",
	"messages_sk.json",
	"messages_sl.json",
	"messages_sv.json",
	"messages_th.json",
	"messages_tl.json",
	"messages_tr.json",
	"messages_uk.json",
	"messages_vi.json",
	"messages_zh.json",
}

local ignore_patterns = {
	"*.git/*",
	"*/node_modules/*",
	"*.cache/*",
	"*.next/*",
	"messages_*.json",
	"!messages_en.json",
}

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"danielfalk/smart-open.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
			{ "nvim-telescope/telescope-fzf-native.nvim", make = "build" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
		config = true,
	},
	opts = {
		defaults = {
			layout_strategy = "vertical",
			layout_config = {
				height = 0.95,
				width = 0.8,
				preview_cutoff = 20,
			},
			file_ignore_patterns = file_ignore_patterns,
			mappings = get_mappings(),
			extensions = {
				smart_open = {
					match_algorithm = "fzf",
					cwd_only = true,
					filename_first = false,
					ignore_patterns = ignore_patterns,
				},
			},
		},
	},

	keys = {
		{
			"<leader>fc",
			"<cmd>Telescope find_files cwd=" .. dotfiles_path .. "<cr>",
			desc = "Find dotfile",
		},
	},

	config = function(_, opts)
		require("telescope").setup(opts)

		if LazyVim.has("telescope-file-browser.nvim") then
			require("telescope").load_extension("file_browser")
		end

		if LazyVim.has("telescope-fzf-native.nvim") then
			require("telescope").load_extension("fzf")
		end

		if LazyVim.has("telescope-live-grep-args.nvim") then
			require("telescope").load_extension("live_grep_args")
		end

		if LazyVim.has("scope.nvim") then
			require("telescope").load_extension("scope")
		end

		if LazyVim.has("smart-open") then
			require("telescope").load_extension("smart-open")
		end
	end,
}
