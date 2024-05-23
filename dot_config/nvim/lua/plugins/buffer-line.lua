local hls_create = function(c)
  local hls = {
    fill = { bg = c.mantle },
    modified = { bg = c.mantle },
    pick = { bg = c.mantle },
    trunc_marker = { bg = c.mantle },
    buffer_visible = { fg = c.subtext0 },
    modified_visible = { fg = c.peach },
    duplicate_visible = { bg = c.base },
    separator = { fg = c.menlo },
    tab_selected = { fg = c.text, style = { "bold" } },
    tab_separator = { fg = c.mantle, bg = c.mantle },
    tab_separator_selected = { fg = c.base, bg = c.base },
  }

	-- stylua: ignore start
	local items = {
		"buffer", "close_button", "diagnostic", "error", "error_diagnostic",
		"hint", "indicator", "info", "info_diagnostic", "modified",
		"numbers", "pick", "warning", "warning_diagnostic",
	}
  -- stylua: ignore end

  for _, item in ipairs(items) do
    local key_selected = item .. "_selected"
    local key_visible = item .. "_visible"

    if hls[key_selected] == nil then
      hls[key_selected] = {}
    end

    if hls[key_visible] == nil then
      hls[key_visible] = {}
    end

    hls[key_selected].bg = c.base
    hls[key_visible].bg = c.base
  end

  return hls
end

return {
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    opts = {
      options = {
        always_show_bufferline = true,
        truncate_names = false,
        indicator = { icon = "▎", style = "icon" },
        separator_style = "thin",
        left_trunc_marker = "",
        right_trunc_marker = "",
        modified_icon = "",
        close_icon = "󰅖",
        offsets = {
          { filetype = "neo-tree", separator = true, text = "" },
          { filetype = "DiffviewFiles", separator = false, text = "" },
        },

        groups = {
          options = { toggle_hidden_on_enter = true },
          items = {},
        },

        custom_filter = function(buf)
          local ft = vim.bo[buf].filetype

          if ft == "alpha" then
            return false
          end

          return true
        end,
      },
    },

    config = function(_, opts)
      local c = require("utils").colors_get
      local catppuccin_bufferline = require("catppuccin.groups.integrations.bufferline")
      local bufferline_groups = require("bufferline.groups")

      table.insert(opts.options.groups, bufferline_groups.builtin.pinned:with({ icon = "" }))
      table.insert(opts.options.groups, bufferline_groups.builtin.ungrouped)

      opts.highlights = catppuccin_bufferline.get({
        styles = { "bold" },
        custom = {
          mocha = hls_create(c("mocha")),
          latte = hls_create(c("latte")),
        },
      })
      require("bufferline").setup(opts)
    end,
  },

  {
    "tiagovla/scope.nvim",
    config = true,
    keys = {
      {
        "<leader>b<tab>",
        [[<cmd>lua require("scope.core").move_current_buf({})<cr>]],
        desc = "Move buffer",
      },
    },
  },
}
