local M = {}

function M.delete(buffer_number, force)
	if buffer_number == nil then
		return
	end

	local bufdelete = require("mini.bufremove").delete
	local buffer_modified = vim.api.nvim_get_option_value("modified", { buf = buffer_number })

	if force or not buffer_modified then
		bufdelete(buffer_number, force)
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(buffer_number)
	local message = buf_name == "" and "Save changes" or ("Save changes to %q?"):format(buf_name)
	local choice = vim.fn.confirm(message, "&Yep\n&Nop")

	if choice == 1 then -- Yes
		vim.cmd.write()
		bufdelete(buffer_number)
	elseif choice == 2 then -- No
		bufdelete(buffer_number, true)
	end
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

function M.os_theme_is_dark()
	local cmd_handle = io.popen("defaults read -g AppleInterfaceStyle 2>&1", "r")
	local cmd_result_raw = cmd_handle ~= nil and cmd_handle:read("*a")
	local cmd_result_safety = cmd_result_raw:gsub("[\n\r]", "")
	local os_theme_is_dark = cmd_result_safety == "Dark"

	if cmd_handle ~= nil then
		cmd_handle:close()
	end

	return os_theme_is_dark
end

function M.colorscheme_get_household()
	local colorschemes_available = {
		catppuccin = { "catppuccin-mocha", "catppuccin-latte" },
	}

	local colorschemes_enabled = {}

	for key, value in pairs(colorschemes_available) do
		local success, result = pcall(M.extras_enabled, "plugins.extras.colorschemes." .. key)

		if not success then
			table.insert(colorschemes_enabled, colorschemes_available["catppuccin"])
			break
		end

		if result then
			table.insert(colorschemes_enabled, value)
		end
	end

	if #colorschemes_enabled ~= 1 then
		vim.schedule(function()
			error("Unexpected behaviour: multiple active colorschemes")
		end)
	end

	return colorschemes_enabled[1]
end

function M.colorscheme_get_name()
	local is_dark = M.os_theme_is_dark()
	local colorscheme_household = M.colorscheme_get_household()

	return is_dark and colorscheme_household[1] or colorscheme_household[2]
end

function M.extras_enabled(extras_name)
	return vim.tbl_contains(LazyVim.config.json.data.extras, extras_name)
end

M.map = function(modes, lhs, rhs, opts)
	if type(opts) == "string" then
		opts = { desc = opts }
	end
	local options = vim.tbl_extend("keep", opts or {}, { silent = true })
	vim.keymap.set(modes, lhs, rhs, options)
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
