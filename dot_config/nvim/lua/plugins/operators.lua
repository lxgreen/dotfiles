return {
  "echasnovski/mini.operators",
  version = false,
  event = "LazyFile",
  config = function()
    require("mini.operators").setup({
      -- Each entry configures one operator.
      -- `prefix` defines keys mapped during `setup()`: in Normal mode
      -- to operate on textobject and line, in Visual - on selection.

      -- Evaluate text and replace with output
      evaluate = {
        prefix = "<leader>=",
        -- Function which does the evaluation
        func = nil,
      },

      -- Exchange text regions
      exchange = {
        prefix = "`x",
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = "`m",
      },

      -- Replace text with register
      replace = {
        prefix = "<leader>r",
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "`s",
        -- Function which does the sort
        func = nil,
      },
    })
  end,
}
