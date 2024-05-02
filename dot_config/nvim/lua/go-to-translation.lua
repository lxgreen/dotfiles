local function findMessagesFile()
  local results = vim.fs.find("messages_en.json", { path = vim.fn.getcwd(), type = "file", upward = false, limit = 1 })
  if #results == 0 then
    return nil
  else
    return results[1]
  end
end

-- TODO: check why this is not working
local function findOpenWindowForFile(filepath)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:find(vim.fn.fnamemodify(filepath, ":p")) then
      print(bufname .. " VS " .. vim.fn.fnamemodify(filepath, ":p"))
      return win
    end
  end
  return nil
end

local function escapeLuaPattern(s)
  return s:gsub("([%-%.%+%[%]%(%)%^%$%*%?%%])", "%%%1")
end

-- TODO: parametrize the file name and path
local function goToTranslationKey()
  -- Step 1: Check if inside a string literal
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local pattern = "'.-'" -- Adjust regex as needed for more complex patterns
  local s, e = string.find(line, pattern)
  if not s or not e or col < s or col > e then
    print("Place cursor inside a translation key first")
    return
  end
  local translationKey = string.sub(line, s + 1, e - 1)

  -- Step 2: Search for messages_en.json in the cwd
  local filepath = findMessagesFile()
  if not vim.fn.filereadable(filepath) then
    print("messages_en.json not found within the current working directory" .. vim.fn.getcwd())
    return
  end

  -- Step 3: Parse JSON and find the key
  local json = require("dkjson")
  local file = io.open(filepath, "r")
  local content = file:read("*a")
  file:close()
  local data = json.decode(content)
  if not data[translationKey] then
    print("Translation key not found")
    return
  end

  -- Step 4: Open the file in a vertical split and jump to the key
  local win = findOpenWindowForFile(filepath)
  if win then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("vsplit " .. filepath)
    vim.api.nvim_command("edit " .. filepath) -- Ensure the file is loaded
  end

  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr(filepath)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local escapedKey = escapeLuaPattern(translationKey)
    for i, l in ipairs(lines) do
      if l:match('"' .. escapedKey .. '"%s*:') then
        vim.api.nvim_win_set_cursor(0, { i, 3 })
        break
      end
    end
  end, 100) -- Defer the execution to ensure the buffer is fully loaded; adjust delay as necessary
end

-- Register the command
vim.api.nvim_create_user_command("GoToTranslationKey", goToTranslationKey, {})
