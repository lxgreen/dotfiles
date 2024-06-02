local ht = require("haskell-tools")
local def_opts = { noremap = true, silent = true }
local wk = require("which-key")
ht.start_or_attach({
  hls = {
    on_attach = function(client, bufnr)
      local opts = vim.tbl_extend("keep", def_opts, { buffer = bufnr })
      wk.register({
        h = {
          name = "Haskell",
          s = { vim.lsp.codelens.run, "add [s]ignature", opts },
          h = { ht.hoogle.hoogle_signature, "search [H]oogle", opts },
          e = { ht.lsp.buf_eval_all, "[e]valuate buffer", opts },
        },
      }, { prefix = "<leader>" })
    end,
  },
})

-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }

wk.register({
  r = {
    name = "REPL",
    r = { ht.repl.toggle, "toggle [R]EPL", opts },
    q = { ht.repl.toggle, "[q]uit REPL", opts },
    b = {
      function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end,
      "[b]uffer REPL",
      def_opts,
    },
  },
}, { prefix = "<leader>" })

-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
ht.dap.discover_configurations(bufnr)
