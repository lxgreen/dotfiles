return {
  {
    "zk-org/zk-nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("zk").setup({
        -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
        -- it's recommended to use "telescope" or "fzf"
        picker = "telescope",

        lsp = {
          -- `config` is passed to `vim.lsp.start_client(config)`
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start_client()`
          },

          -- automatically attach buffers in a zk notebook that match the given filetypes
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
  },
  {
    "renerocksai/telekasten.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telekasten").setup({
        home = vim.fn.expand("~/Sync/Notes"),
        take_over_my_home = true,
        auto_set_filetype = false,
        auto_set_syntax = false,
        -- dir names for special notes (absolute path or subdir name)
        dailies = vim.fn.expand("~/Sync/Notes/diary/"),
        image_subdir = "attachments",
        calendar_opts = {
          weeknm = 5,
          calendar_monday = 0,
        },
      })
    end,
  },
  {
    "renerocksai/calendar-vim",
  },
}
