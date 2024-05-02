return {
  {
    "coffebar/neovim-project",
    enabled = false,
    opts = {
      projects = { -- define project roots
        "~/dev/*",
        "~/restaurants-dev/*",
        "~/.config/*",
        "~/Sync/Notes"
      },
      -- Overwrite some of Session Manager options
      session_manager_opts = {
        autosave_ignore_dirs = {
          vim.fn.expand("~"), -- don't create a session for $HOME/
          "/tmp",
        },
        autosave_ignore_filetypes = {
          -- All buffers of these file types will be closed before the session is saved
          "ccc-ui",
          "gitcommit",
          "gitrebase",
          "qf",
          "dirbuf"
        },
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = { "nvim-telescope/telescope.nvim", "Shatur/neovim-session-manager" },
    priority = 100,
  }
}
