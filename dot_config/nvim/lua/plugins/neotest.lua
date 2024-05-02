-- https://github.com/nvim-neotest/neotest-jest/issues/60
return {
  {
    "nvim-neotest/neotest",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- this adding nvim-treesitter
      "haydenmeade/neotest-jest",
      "nvim-neotest/nvim-nio",
    },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    opts = function(_, opts)
      opts.status = { virtual_text = true }
      opts.output = { open_on_run = true }
      table.insert(
        opts.adapters,
        0,
        require("neotest-jest")({
          ignore_file_types = { "markdown" },
          jestCommand = "yarn test:unit",
          -- TODO: this ENV should be set by per project, currently allows to run yoshi tests locally (no sled)
          env = {
            CI = true,
            ARTIFACT_VERSION = "1.0.0",
            BUILD_ID = 123456789,
            agentType = "ci",
            GIT_REMOTE_URL = "git@github.com:some-org/some-repo.git",
            BUILD_VCS_NUMBER = "0123456789abcdef0123456789abcdef",
          },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = false, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
    },
  },
}
