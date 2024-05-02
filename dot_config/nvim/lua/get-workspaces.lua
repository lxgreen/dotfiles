local M = {}

local function runCommand(command)
  local handle = io.popen(command, "r")
  local result = handle:read("*a")
  handle:close()
  return result
end

local function isCommandAvailable(command)
  local result = runCommand(command)
  return result ~= "" and not result:match("command not found")
end

M.getWorkspaces = function()
  -- Check if 'yarn' and 'jq' are available
  if not isCommandAvailable("yarn --version") or not isCommandAvailable("jq --version") then
    print("Install yarn and jq.")
    return {}
  end

  local ws = runCommand("yarn workspaces list --json")
  if ws:match("No project found") or ws:match("info Visit") then
    -- print("Project does not use yarn workspaces.")
    return {}
  else
    local command = "yarn workspaces list --json | jq -r '.name' 2>&1"
    local workspaces = vim.split(runCommand(command), "\n")

    local clean = {}
    for _, workspace in ipairs(workspaces) do
      local name = workspace:gsub("^@[^/]+/", "")
      table.insert(clean, name)
    end
    return clean
  end
end

return M
