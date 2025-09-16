-- Early VS Code initialization to prevent LazyVim errors
-- This ensures Snacks is available globally before LazyVim tries to use it

if not vim.g.vscode then
	return
end

-- Create a comprehensive Snacks stub that matches the real API
-- This prevents all "attempt to index global 'Snacks'" errors

-- Create toggle as a callable table (metatable approach)
local toggle_table = {
	option = function(option, values)
		return function()
			if values then
				local current = vim.opt_local[option]:get()
				local next_val = values[1]
				for i, val in ipairs(values) do
					if val == current and values[i + 1] then
						next_val = values[i + 1]
						break
					end
				end
				vim.opt_local[option] = next_val
			else
				vim.opt_local[option] = not vim.opt_local[option]:get()
			end
		end
	end
}

-- Make toggle_table callable
setmetatable(toggle_table, {
	__call = function(self, opts)
		return function()
			-- Minimal toggle implementation
			if opts and opts.set and opts.get then
				local current = opts.get()
				opts.set(not current)
			end
		end
	end
})

-- Create a comprehensive util table that LazyVim mini.lua expects
local util_table = {
	color = {},
	debug = function() end,
	-- Add any other util functions that might be accessed
}

_G.Snacks = _G.Snacks or {
	-- Core toggle functionality (used by format.lua)
	toggle = toggle_table,
	
	-- Picker functionality (needed by yanky.nvim)
	picker = {
		pick = function() end,
		setup = function() end,
	},
	
	-- Utility functions - make sure this is a proper table
	util = util_table,
	
	-- Configuration
	config = {
		styles = {},
	},
	
	-- Setup function
	setup = function() end,
	
	-- Common modules that might be accessed
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	statuscolumn = { enabled = false },
	dashboard = { enabled = false },
	scroll = { enabled = false },
	words = { enabled = false },
	styles = { enabled = false },
	notifier = { enabled = false },
	terminal = { enabled = false },
	zen = { enabled = false },
}

-- Add metatable to make Snacks more robust
setmetatable(_G.Snacks, {
	__index = function(table, key)
		-- Return empty table for any missing keys to prevent nil errors
		return {}
	end
})

-- Disable LazyVim format keymaps that might still cause issues
vim.g.lazyvim_format_enabled = false

print("🔧 VS Code Snacks stub loaded - LazyVim utilities should work now")

