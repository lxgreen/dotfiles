local config = require("ai-config")

return {
  {
    ft = { "typescript", "typescriptreact" },
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = {
      {
        "gw",
        mode = { "n", "x" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        "gW",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    },
  },
  {
    "robitx/gp.nvim",
    keys = { "<C-g>", mode = "n", desc = "AI Chat" },
    config = function()
      require("gp").setup(config)

      -- or setup with your own config (see Install > Configuration in Readme)
      -- require("gp").setup(config)

      -- shortcuts might be setup here (see Usage > Shortcuts in Readme)
    end,
  },
}
