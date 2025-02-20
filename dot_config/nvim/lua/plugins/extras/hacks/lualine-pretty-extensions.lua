return {
	"nvim-lualine/lualine.nvim",
	optional = true,

	opts = function()
		-- stylua: ignore start
		require("lualine.extensions.lazy").sections.lualine_a =		{ function() return "󰒲  lazy " end }
		require("lualine.extensions.mason").sections.lualine_a =	{ function() return " mason " end }

		require("lualine.extensions.fugitive").sections.lualine_a =	{ function() return "  git  " end }
		require("lualine.extensions.fugitive").sections.lualine_b =	{ function() return " " .. vim.fn.FugitiveHead() end }
		-- stylua: ignore end
	end,
}
