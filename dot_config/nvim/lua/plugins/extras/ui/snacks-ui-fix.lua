-- Fix Snacks UI handler conflicts
return {
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        enabled = false, -- Disable dressing for vim.ui.select to let Snacks handle it
      },
      input = {
        enabled = false, -- Disable dressing for vim.ui.input to let Snacks handle it
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      input = {
        enabled = true,
      },
      picker = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      -- Ensure Snacks handles UI functions
      vim.ui.input = require("snacks").input
      vim.ui.select = require("snacks").picker.select
    end,
  },
}

