return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "Marskey/telescope-sg",
      config = function()
        require("telescope").setup({})
      end,
    },
    config = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local create_visual_selection = require("utils").create_visual_selection
      local mappings = {
        n = {
          ["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
        i = {
          ["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      }

      require("telescope").setup({
        defaults = {
          mappings = mappings,
        },
        extensions = {
          ast_grep = {
            -- config for ast_grep extension
            attach_mappings = function(prompt_bufnr, map)
              -- replace the default action with a custom one
              actions.select_default:replace(function()
                -- open the file and create a visual selection
                actions.file_edit(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- vim.notify(vim.inspect(selection))
                create_visual_selection(selection.lnum, selection.col, selection.lnend, selection.colend)
              end)
              -- return true to indicate that the mapping was successfully attached
              return true
            end,
          },
        },
      })
      require("telescope").load_extension("ast_grep")
      require("telescope").load_extension("yank_history")
      require("telescope").load_extension("harpoon")
    end,
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
  },
}
