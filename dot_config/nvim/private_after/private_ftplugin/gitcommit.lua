-- Runs once when the gitcommit is opened for the first time.
if vim.g.workspaces_source_loaded == true then
  return
end
local cmp = require("cmp")
local workspaces = require("workspaces-cmp")
cmp.register_source("workspaces", workspaces)
vim.g.workspaces_source_loaded = true
