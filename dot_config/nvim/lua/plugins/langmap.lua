return {
	{
		"Wansmer/langmapper.nvim",
		priority = 1,
		lazy = false,
		enabled = true,

		opts = {
			default_layout = [[ABCDEFGHIJKLMNOPQRSTUVWXYZ{}~_+|abcdefghijklmnopqrstuvwxyz[]`-=\]],

			layouts = {
				ru = {
					id = "com.apple.keylayout.Russian-Phonetic",
					layout = [[АБЦДЕФГЧИЙКЛМНОПЯРСТУВШХЫЗЮЖЩЬЪЭабцдефгчийклмнопярстувшхызюжщьъэ]],
				},
			},
		},

		config = function(_, opts)
			local lm = require("langmapper")

			lm.setup(opts)
			lm.hack_get_keymap()

			local lmu = require("langmapper.utils")

			-- Translate Cyrillic input to English for plugins that use getcharstr directly
			-- (e.g. flash.nvim reads labels via vim.fn.getcharstr, bypassing keymaps)
			local orig_getcharstr = vim.fn.getcharstr
			vim.fn.getcharstr = function(...)
				local char = orig_getcharstr(...)
				return lmu.translate_keycode(char, "default", "ru")
			end

			-- langmap only covers normal mode; wire command mode via explicit cnoremap
			for _, ru_char in ipairs(vim.fn.split(opts.layouts.ru.layout, "\\zs")) do
				local en_char = lmu.translate_keycode(ru_char, "default", "ru")
				if ru_char ~= en_char then
					pcall(vim.keymap.set, "c", ru_char, en_char, { noremap = true })
				end
			end

		end,
	},

	{
		"folke/which-key.nvim",
		optional = true,
		dependencies = { "Wansmer/langmapper.nvim" },

		opts = function(_, opts)
			-- local lmu = require("langmapper.utils")
			--
			-- opts.triggers_blacklist = {
			-- 	o = lmu.trans_list({ ";", ".", '"', "'", "j", "k", "D", "s", "S" }),
			-- 	i = lmu.trans_list({ ";", ".", '"', "'", "j", "k", "D", "s", "S" }),
			-- 	n = lmu.trans_list({ ";", ".", '"', "'", "j", "k", "D", "s", "S" }),
			-- 	v = lmu.trans_list({ ";", ".", '"', "'", "j", "k", "D", "s", "S" }),
			-- }

			opts.plugins = { spelling = false }
			opts.icons = { group = " " }
			opts.layout = { spacing = 5 }
			opts.show_help = true
			-- opts.triggers_blacklist = { i = { "n" } }
			-- opts.triggers = {
			-- 	{ "<leader>", mode = { "n", "v" } },
			-- }
		end,

		config = function(_, opts)
			-- local lmu = require("langmapper.utils")
			-- local view = require("which-key.view")
			-- local execute = view.execute
			--
			-- view.execute = function(prefix_i, mode, buf)
			-- 	prefix_i = lmu.translate_keycode(prefix_i, "default", "ru")
			-- 	execute(prefix_i, mode, buf)
			-- end

			require("which-key").setup(opts)
			-- require("which-key").register(opts.spec)
		end,
	},
}
