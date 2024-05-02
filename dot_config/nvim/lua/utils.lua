local M = {}

M.map = function(modes, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { desc = opts }
  end
  local options = vim.tbl_extend("keep", opts or {}, { silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

function M.colors_get(flavor)
  return require("catppuccin.palettes").get_palette(flavor)
end

local function color_convert_dec2hex(n_value)
  if type(n_value) == "string" then
    n_value = tonumber(n_value)
  end

  local n_hex_val = string.format("%X", n_value) -- %X returns uppercase hex, %x gives lowercase letters
  local s_hex_val = n_hex_val .. ""

  if n_value < 16 then
    return "0" .. tostring(s_hex_val)
  else
    return s_hex_val
  end
end

function M.color_blend(color_first, color_second, percentage)
  local r1, g1, b1 = string.upper(color_first):match("#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
  local r2, g2, b2 = string.upper(color_second):match("#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")

  local r3 = tonumber(r1, 16) * (100 - percentage) / 100.0 + tonumber(r2, 16) * percentage / 100.0
  local g3 = tonumber(g1, 16) * (100 - percentage) / 100.0 + tonumber(g2, 16) * percentage / 100.0
  local b3 = tonumber(b1, 16) * (100 - percentage) / 100.0 + tonumber(b2, 16) * percentage / 100.0

  return "#" .. color_convert_dec2hex(r3) .. color_convert_dec2hex(g3) .. color_convert_dec2hex(b3)
end

function M.lualine_theme_create()
  local c = M.colors_get()

  local colors = {
    ["normal"] = c.blue,
    ["insert"] = c.green,
    ["visual"] = c.mauve,
    ["replace"] = c.red,
    ["command"] = c.peach,
    ["terminal"] = c.green,
    ["inactive"] = c.mantle,
  }

  local theme = {}

  for mode, color in pairs(colors) do
    theme[mode] = {
      a = { bg = M.color_blend(c.mantle, color, 70), fg = c.mantle },
      b = { bg = M.color_blend(c.mantle, color, 15), fg = color },
      c = { bg = M.color_blend(c.base, c.mantle, 50), fg = mode == "inactive" and c.surface2 or c.text },
    }
  end

  return theme
end

function M.create_visual_selection(start_line, start_col, end_line, end_col)
  -- Move the cursor to the start position
  vim.api.nvim_win_set_cursor(0, { start_line, start_col - 1 }) -- Lua is 1-indexed, API needs 0-indexed column

  -- Enter visual mode
  vim.api.nvim_command("normal! v")

  -- Move to the end position
  -- Calculate the motion to reach the end position from the start
  local move_cmd = tostring(end_line) .. "G" .. tostring(end_col) .. "|"
  vim.api.nvim_command("normal! " .. move_cmd)
end

function M.extends(configPath)
  local base = vim.fn.stdpath("config") .. configPath
  if vim.fn.filereadable(base) == 1 then
    dofile(base)
  end
end

return M
