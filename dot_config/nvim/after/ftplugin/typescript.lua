require("go-to-translation")
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_keymap(buf, "n", "gT", "<cmd>GoToTranslationKey<CR>", { desc = "Go to translation key" })
