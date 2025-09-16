-- Simple test file to verify VS Code integration works
-- Run this with :lua require('config.vscode-test').test()

local M = {}

function M.test()
	if not vim.g.vscode then
		print("❌ Not running in VS Code")
		return
	end
	
	print("✅ Running in VS Code mode")
	
	-- Test if VSCodeNotify function exists
	if vim.fn.exists('*VSCodeNotify') == 1 then
		print("✅ VSCodeNotify function is available")
	else
		print("❌ VSCodeNotify function not found")
	end
	
	-- Test a few key mappings
	local test_keys = { "<leader>e", "<leader>ff", "<leader>fb" }
	for _, key in ipairs(test_keys) do
		local mapping = vim.fn.maparg(key, "n")
		if mapping:find("VSCodeNotify") then
			print("✅ " .. key .. " is mapped to VS Code command")
		else
			print("❌ " .. key .. " is not properly mapped: " .. mapping)
		end
	end
end

return M

