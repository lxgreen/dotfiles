local c_blend = require("utils").color_blend

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true, -- disables setting the background color.
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      highlight_overrides = {
        all = function(c)
          return {
            AerialLine = { fg = "none", bg = c.crust },
            AlphaFooter = { fg = c.surface1, style = {} },
            AlphaHeader1 = { fg = c.surface2 },
            AlphaHeader2 = { fg = c_blend(c.base, c.blue, 5) },
            AlphaHeader3 = { fg = c_blend(c.base, c.sky, 5) },
            AlphaHeader4 = { fg = c_blend(c.base, c.green, 5) },
            AlphaHeader5 = { fg = c_blend(c.base, c.yellow, 5) },
            AlphaHeader6 = { fg = c_blend(c.base, c.peach, 5) },
            AlphaHeader7 = { fg = c_blend(c.base, c.red, 5) },
            AlphaHeader8 = { fg = c.surface2 },
            AlphaShortcut = { bg = c_blend(c.base, c.crust, 50), fg = c_blend(c.base, c.surface1, 50) },
            AlphaShortcutBorder = { fg = c_blend(c.base, c.surface1, 50) },
            ChatGPTQuestion = { fg = c.mauve },
            ChatGPTTotalTokens = { bg = "none", fg = c.overlay2 },
            ChatGPTTotalTokensBorder = { fg = c.text },
            CmpDocFloat = { bg = c.mantle, blend = 15 },
            DiffviewDiffAdd = { bg = c_blend(c.green, c.base, 93) },
            DiffviewDiffDelete = { bg = c_blend(c.red, c.base, 93) },
            DiffviewNormal = { bg = c.mantle },
            DiffviewWinSeparator = { link = "NeoTreeWinSeparator" },
            EdgyNormal = { link = "NormalFloat" },
            EdgyTitle = { bg = c.mantle },
            FlashPrompt = { bg = c.mantle },
            FloatBorder = { fg = c_blend(c.base, c.lavender, 50) },
            FloatTitle = { fg = c.lavender, style = { "bold" } },
            Folded = { bg = c.base, fg = c.surface2 },
            GitConflictCurrent = { bg = c_blend(c.blue, c.base, 90) },
            GitConflictCurrentLabel = { bg = c_blend(c.blue, c.base, 85) },
            GitConflictIncoming = { bg = c_blend(c.green, c.base, 90) },
            GitConflictIncomingLabel = { bg = c_blend(c.green, c.base, 85) },
            GitSignsAdd = { fg = c_blend(c.green, c.base, 50) },
            GitSignsAddInline = { bg = c_blend(c.green, c.base, 83) },
            GitSignsAddPreview = { bg = c_blend(c.green, c.base, 93) },
            GitSignsChange = { fg = c_blend(c.yellow, c.base, 50) },
            GitSignsDelete = { fg = c_blend(c.red, c.base, 50) },
            GitSignsDeleteInline = { bg = c_blend(c.red, c.base, 83) },
            GitSignsDeletePreview = { bg = c_blend(c.red, c.base, 93) },
            IblIndent = { fg = c_blend(c.base, c.surface2, 40) },
            IblScope = { fg = c_blend(c.base, c.surface2, 75) },
            LazyReasonKeys = { fg = c.overlay0 },
            NeoTreeDotfile = { fg = c.overlay0 },
            NeoTreeFadeText1 = { fg = c.surface1 },
            NeoTreeFadeText2 = { fg = c.surface2 },
            NeoTreeFileStats = { fg = c.surface1 },
            NeoTreeFileStatsHeader = { fg = c.surface2 },
            NeoTreeFloatBorder = { link = "FloatBorder" },
            NeoTreeFloatNormal = { link = "NormalFloat" },
            NeoTreeFloatTitle = { link = "FloatTitle" },
            NeoTreeMessage = { fg = c.surface1 },
            NeoTreeModified = { fg = c.peach },
            NeoTreeRootName = { fg = c.green },
            NeoTreeTabActive = { fg = c.text, bg = c_blend(c.base, c.text, 10) },
            NeoTreeTabInactive = { fg = c.overlay1, bg = c.base },
            NeoTreeTabSeparatorActive = { bg = c.base, fg = c.base },
            NeoTreeWinSeparator = { link = "WinSeparator" },
            NoiceCmdline = { bg = c.mantle },
            NoiceCmdlinePopupBorder = { link = "FloatBorder" },
            NoiceScrollbar = { link = "NormalFloat" },
            NoiceScrollbarThumb = { bg = c_blend(c.base, c.surface0, 50) },
            NoicePopupmenuSelected = { link = "Visual" },
            NoiceFormatEvent = { fg = c.overlay1 },
            NoiceFormatKind = { fg = c.overlay0 },
            NoiceLspProgressTitle = { fg = c.overlay0 },
            NoicePopup = { link = "CmpDocFloat" },
            NonText = { fg = c.base },
            NormalFloat = { bg = c.base },
            TelescopeResultsDiffAdd = { link = "NeoTreeGitAdded" },
            TelescopeBorder = { link = "FloatBorder" },
            TelescopePromptBorder = { link = "FloatBorder" },
            TelescopeResultsDiffChange = { link = "NeoTreeGitModified" },
            TelescopeResultsDiffDelete = { link = "NeoTreeGitDeleted" },
            TelescopeResultsDiffUntracked = { link = "NeoTreeGitUntracked" },
            TelescopeSelection = { link = "Visual" },
            TelescopeTitle = { link = "FloatTitle" },
            TreesitterContext = { bg = c.base, blend = 10 },
            TreesitterContextBottom = { fg = c.surface2, blend = 0, style = { "underline" } },
            TreesitterContextLineNumber = { bg = c.base or c.base },
            TroubleCount = { bg = "none" },
            TroubleNormal = { link = "NormalFloat" },
            Visual = { style = {} },
            WhichKeyFloat = { bg = c.mantle },
            Whitespace = { fg = c.base },
            ZenBg = { bg = c.mantle },
          }
        end,

        mocha = function(c)
          return {
            AerialGuide = { fg = c.surface0 },
            GitSignsCurrentLineBlame = { fg = c.surface2 },
            IlluminatedWordRead = { bg = c_blend(c.base, c.surface2, 55) },
            IlluminatedWordText = { bg = c_blend(c.base, c.sapphire, 55) },
            IlluminatedWordWrite = { bg = c_blend(c.base, c.sapphire, 55) },
            NeoTreeIndentMarker = { fg = c.base },
            SatelliteBar = { bg = c.surface0, blend = 15 },
            SpectreBorderCustom = { fg = c.surface0 },
            SymbolUsageText = { fg = c.surface2 },
            Visual = { bg = c_blend(c.base, c.surface2, 30) },
            NeoTreeTabSeparatorInactive = { bg = c.base, fg = c.base },
            NeoTreeCursorLine = { bg = c.base },
            WinSeparator = { fg = c_blend(c.base, c.crust, 40) },
          }
        end,

        latte = function(c)
          return {
            AerialGuide = { fg = c.crust },
            GitSignsCurrentLineBlame = { fg = c.surface0 },
            IlluminatedWordRead = { bg = c_blend(c.base, c.surface2, 50) },
            IlluminatedWordText = { bg = c_blend(c.base, c.sapphire, 40) },
            IlluminatedWordWrite = { bg = c_blend(c.base, c.sapphire, 40) },
            NeoTreeIndentMarker = { fg = c.surface0 },
            Normal = { bg = c.base },
            SatelliteBar = { bg = c.crust, blend = 15 },
            SpectreBorderCustom = { fg = c.crust },
            SymbolUsageText = { fg = c.surface0 },
            Visual = { bg = c_blend(c.base, c.surface2, 85) },
            NeoTreeTabSeparatorInactive = { bg = c.base, fg = c.base },
            NeoTreeCursorLine = { bg = c.crust },
            WinSeparator = { fg = c.crust },
          }
        end,
      },
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
        markdown = true,
        which_key = true,
        neotree = true,
        treesitter = true,
        noice = true,
        neotest = true,
        notify = true,
        telekasten = true,
        mini = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    })

    require("notify").setup({
      background_colour = "#000000",
    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
