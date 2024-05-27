local keys = {
  -- stylua: ignore start
  { "<leader>co",		[[<cmd>lua require("vtsls").commands.organize_imports(0)<cr> ]],	desc = "Organize Imports" },
  { "<leader>cM",		[[<cmd>lua require("vtsls").commands.add_missing_imports(0)<cr>]],	desc = "Add missing imports" },
  { "<leader>cD",		[[<cmd>lua require("vtsls").commands.fix_all(0)<cr>]],				desc = "Fix all diagnostics" },
  { "<leader>cLL",	[[<cmd>lua require("vtsls").commands.open_tsserver_log()<cr>]],		desc = "Open Vtsls Log" },
  { "<leader>cR",		[[<cmd>lua require("vtsls").commands.rename_file(0)<cr>]],			desc = "Rename File" },
  { "<leader>cu",		[[<cmd>lua require("vtsls").commands.file_references(0)<cr>]],		desc = "Show File Uses(References)" },
  -- stylua: ignore end
}
local settings = {
  vtsls = {
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = true,
      },
    },
  },

  javascript = {
    format = {
      indentSize = vim.o.shiftwidth,
      convertTabsToSpaces = vim.o.expandtab,
      tabSize = vim.o.tabstop,
    },

    -- enables inline hints
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },

    -- otherwise it would ask every time if you want to update imports, which is a bit annoying
    updateImportsOnFileMove = {
      enabled = "always",
    },

    -- cool feature, but increases ram usage
    -- referencesCodeLens = {
    --   enabled = true,
    --   showOnAllFunctions = true,
    -- },
  },

  typescript = {
    format = {
      indentSize = vim.o.shiftwidth,
      convertTabsToSpaces = vim.o.expandtab,
      tabSize = vim.o.tabstop,
    },

    updateImportsOnFileMove = {
      enabled = "always",
    },

    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = true },
      variableTypes = { enabled = true },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
      enumMemberValues = { enabled = true },
    },

    -- enables project wide error reporting similar to vscode
    -- tsserver = {
    --   experimental = {
    --     enableProjectDiagnostics = true,
    --   },
    -- },
  },
}

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- set default server config to use nvim-vtsls one, which would allow use to use the plugin
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "yioneko/nvim-vtsls" },
    opts = {
      servers = {
        vtsls = {
          keys = keys,
          settings = settings,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
          },
        },
        jsonls = {
          filetypes = { "json", "jsonc", "trans" },
          settings = {
            json = {
              format = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
}
