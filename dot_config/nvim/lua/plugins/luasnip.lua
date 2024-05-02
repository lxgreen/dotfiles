-- creadit to https://github.com/Allaman/
local M = {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local vsc = require("luasnip.loaders.from_vscode")
    local lua = require("luasnip.loaders.from_lua")

    Snip = {
      snippet = require("luasnip.nodes.snippet").S,
      snippet_from_nodes = require("luasnip.nodes.snippet").SN,
      text = require("luasnip.nodes.textNode").T,
      func = require("luasnip.nodes.functionNode").F,
      insert = require("luasnip.nodes.insertNode").I,
      choise = require("luasnip.nodes.choiceNode").C,
      dynamic = require("luasnip.nodes.dynamicNode").D,
      restore = require("luasnip.nodes.restoreNode").R,
      lambda = require("luasnip.extras").lambda,
      rep = require("luasnip.extras").rep,
      partial = require("luasnip.extras").partial,
      match = require("luasnip.extras").match,
      nonempty = require("luasnip.extras").nonempty,
      dynamic_lambda = require("luasnip.extras").dynamic_lambda,
      fmt = require("luasnip.extras.fmt").fmt,
      fmta = require("luasnip.extras.fmt").fmta,
      conds = require("luasnip.extras.expand_conditions"),
      types = require("luasnip.util.types"),
      events = require("luasnip.util.events"),
      parse = require("luasnip.util.parser").parse_snippet,
      absolute_indexer = require("luasnip.nodes.absolute_indexer"),
    }

    ls.filetype_extend("typescriptreact", { "typescript", "javascript", "javascriptreact" })
    ls.filetype_extend("javascriptreact", { "javascript" })

    ls.config.set_config({
      history = true,
      enable_autosnippets = true,
      updateevents = "TextChanged,TextChangedI",
      delete_check_events = "TextChanged",
      ext_opts = {
        [Snip.types.choiceNode] = {
          active = {
            virt_text = { { " « ", "NonTest" } },
          },
        },
      },
    })

    -- load lua snippets
    lua.load({ paths = os.getenv("HOME") .. "/.config/nvim/lua/snippets/" })
    -- load friendly-snippets
    -- this must be loaded after custom snippets or they get overwritte!
    -- https://github.com/L3MON4D3/LuaSnip/blob/b5a72f1fbde545be101fcd10b70bcd51ea4367de/Examples/snippets.lua#L497
    vsc.lazy_load()

    -- <c-e> is my expansion key
    -- this will expand the current item or jump to the next item within the snippet.
    vim.keymap.set({ "i", "s" }, "<c-e>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true, desc = "Snippet: expand or jump forward" })

    -- <c-j> is my jump backwards key.
    -- this always moves to the previous item within the snippet
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true, desc = "Snippet: jump backwards" })

    -- <c-l> is selecting within a list of options.
    -- This is useful for choice nodes (introduced in the forthcoming episode 2)
    vim.keymap.set("i", "<c-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = "Snippet: iterate options list" })

    vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"), { desc = "Snippet: select choice" })

    -- shorcut to source my luasnips file again, which will reload my snippets
    vim.keymap.set("n", "<F5>", "<cmd>source ~/.local/share/nvim/lazy/LuaSnip/plugin/luasnip.lua<CR>")
  end,
}

return M
