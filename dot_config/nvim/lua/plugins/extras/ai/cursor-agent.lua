return {
	"xTacobaco/cursor-agent.nvim",
	dependencies = { "nvim-lua/plenary.nvim" }, -- usually required for utility functions
	config = function()
		-- Optional: Keymaps
		vim.keymap.set("n", "<leader>ca", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle" })
		vim.keymap.set("v", "<leader>ca", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Selection" })
		vim.keymap.set("n", "<leader>cb", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Buffer" })

		-- Default setup
		require("cursor-agent").setup({
			cmd = "cursor-agent", -- Path to executable if not in $PATH
			args = {}, -- Extra args to pass to the CLI
		})
	end,
}
