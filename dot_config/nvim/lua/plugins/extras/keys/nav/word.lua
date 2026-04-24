local function motion(key)
	return function()
		local pos = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], true)[1]
		local code = vim.fn.strgetchar(line:sub(pos[2] + 1), 0)
		if vim.bo.filetype == "markdown" or (code >= 0x0400 and code <= 0x04FF) then
			vim.fn.feedkeys(key, "n")
		else
			require("spider").motion(key)
		end
	end
end

return {
	"chrisgrieser/nvim-spider",
	optional = true,
	keys = {
		{ "w", motion("w"), desc = "word-wise-w", mode = { "n", "o", "x" } },
		{ "e", motion("e"), desc = "word-wise-e", mode = { "n", "o", "x" } },
		{ "b", motion("b"), desc = "word-wise-b", mode = { "n", "o", "x" } },
		{ "ge", motion("ge"), desc = "word-wise-ge", mode = { "n", "o", "x" } },
	},
}
