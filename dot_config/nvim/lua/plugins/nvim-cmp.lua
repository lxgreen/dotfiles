return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    {
      "petertriho/cmp-git",
      config = function()
        local cmp_git = require("cmp_git")
        cmp_git.setup()
      end,
    },
    {
      "uga-rosa/cmp-dictionary",
      config = function()
        local dict = {
          ["*"] = { "/usr/share/dict/words" },
          ft = {
            ["markdown"] = { vim.fn.stdpath("config") .. "/lua/dictionaries/wix.names.txt" },
          },
        }

        require("cmp_dictionary").setup({
          paths = dict["*"],
          exact_length = 4,
          first_case_insensitive = true,
          max_number_items = 1000,
        })

        vim.api.nvim_create_autocmd("BufWinEnter", {
          pattern = "*",
          callback = function()
            local filetype = vim.bo.filetype
            local paths = dict.ft[filetype] or {}
            vim.list_extend(paths, dict["*"])
            require("cmp_dictionary").setup({
              paths = paths,
            })
          end,
        })
      end,
    },
    "onsails/lspkind.nvim",
  },
  opts = function(_, opts)
    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    -- required for luasnip integration
    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    opts.window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    }

    local lspkind = require("lspkind")

    opts.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- can also be a function to dynamically calculate max width such as
        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
        ellipsis_char = "…", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      }),
    }

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          -- experimental: added confirm behavior to replace, select = false
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- this way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    -- insert `(` after select function or method item
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local handlers = require("nvim-autopairs.completion.handlers")

    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        filetypes = {
          -- "*" is a alias to all filetypes
          ["*"] = {
            ["("] = {
              kind = {
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
              },
              handler = handlers["*"],
            },
          },
        },
      })
    )

    -- common sources
    opts.sources = {
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      {
        name = "dictionary",
        keyword_length = 2,
      },
    }

    -- uses custom floating menu
    opts.native_menu = false
    opts.ghost_text = true

    -- specific filetype settings
    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "workspaces" },
        { name = "buffer" },
        { name = "git" }, -- depends on https://github.com/petertriho/cmp-git
        { name = "copilot" },
        { name = "luasnip" },
      }),
    })

    cmp.setup.filetype("markdown", {
      sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_pattern = [[\%(\w\+\%(:\)\)\?]] }, -- : triggers tag completion after whitespace
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        {
          name = "dictionary",
          keyword_length = 2,
        },
      }),
    })

    -- requires native_menu = false
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        {
          name = "dictionary",
          keyword_length = 2,
        },
      },
    })

    local function delay(cb, time)
      local timer = vim.loop.new_timer()
      timer:start(
        time,
        0,
        vim.schedule_wrap(function()
          cb()
          timer:stop()
        end)
      )
    end

    -- fixes % expansion in cmdline
    local function handle_tab_complete(direction)
      return function()
        if vim.api.nvim_get_mode().mode == "c" and cmp.get_selected_entry() == nil then
          local text = vim.fn.getcmdline()
          ---@diagnostic disable-next-line: param-type-mismatch
          local expanded = vim.fn.expandcmd(text)
          if expanded ~= text then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, true, true) .. expanded, "n", false)
            -- triggering right away won't work, need to wait a cycle
            delay(cmp.complete, 0)
          elseif cmp.visible() then
            direction()
          else
            cmp.complete()
          end
        else
          if cmp.visible() then
            direction()
          else
            cmp.complete()
          end
        end
      end
    end

    -- requires native_menu = false
    -- still doesn't work properly with %:p %:p:h
    cmp.setup.cmdline(":", {
      completion = { completeopt = "menu,menuone,noselect" }, -- don't pre-select first item
      mapping = cmp.mapping.preset.cmdline({
        ["<Tab>"] = { c = handle_tab_complete(cmp.select_next_item) },
        ["<S-Tab>"] = { c = handle_tab_complete(cmp.select_prev_item) },
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          keyword_pattern = [=[[^[:blank:]%]*]=],
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- Set up lspconfig for every language server
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")
    lspconfig["tsserver"].setup({
      capabilities = capabilities,
    })
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
    })
    lspconfig["jsonls"].setup({
      capabilities = capabilities,
    })
    lspconfig["hls"].setup({
      capabilities = capabilities,
    })
    -- lspconfig.ast_grep.setup({})
  end,
}
