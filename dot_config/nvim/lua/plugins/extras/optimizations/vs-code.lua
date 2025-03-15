local function is_not_vs_code()
	return not vim.g.vscode
end

return {
	{ "folke/snacks.nvim", cond = is_not_vs_code },
	-- { "echasnovski/mini.ai", cond = is_not_vs_code },
	-- { "echasnovski/mini.comment", cond = is_not_vs_code },
	-- { "echasnovski/mini.move", cond = is_not_vs_code },
	-- { "echasnovski/mini.pairs", cond = is_not_vs_code },
	-- { "echasnovski/mini.surround", cond = is_not_vs_code },
	-- { "nvim-treesitter/nvim-treesitter", cond = is_not_vs_code },
	-- { "nvim-treesitter/nvim-treesitter-textobjects", cond = is_not_vs_code },
	-- { "JoosepAlviste/nvim-ts-context-commentstring", cond = is_not_vs_code },
	-- { "gbprod/yanky.nvim", cond = is_not_vs_code },
}
