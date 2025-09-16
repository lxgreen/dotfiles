-- Load early VS Code compatibility layer
if vim.g.vscode then
	require("config.vscode-early-init")
end

require("config.lazy.init")

if LazyVim.has("langmapper.nvim") then
	require("langmapper").automapping({ "global", "buffer" })
end

-- Load VS Code overrides if running in VS Code
if vim.g.vscode then
	require("config.vscode-overrides")
end
