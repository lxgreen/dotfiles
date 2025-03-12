---@diagnostic disable: redefined-local
local os = require("os")
local io = require("io")
local wezterm = require("wezterm")
local utils = require("utils")

local M = {
	config = {},
}

local function get_last_focused_nvim()
	-- keep in sync with the autocmd.lua file at the neovim config
	local server_id_file = "/tmp/nvim-focuslost"

	local server_id = io.open(server_id_file):read("*a")
	server_id = server_id:sub(1, -2)

	return server_id
end

local function get_nvim_instances()
	local last_focused_nvim = get_last_focused_nvim()
	local success, stdout, stderr = wezterm.run_child_process({
		-- access to env vars required (from: https://github.com/wez/wezterm/discussions/635#discussioncomment-567049)
		os.getenv("SHELL"),
		"-c",
		-- source: https://github.com/neovim/neovim/issues/21600#issuecomment-1368651863
		'find (echo "$TMPDIR/nvim.$USER") -type s',
	})

	if success then
		local nvim_instances = {}

		for server_id in stdout:gmatch("([^\n]*)\n?") do
			---@diagnostic disable-next-line: unused-local
			local _path, _name, pid, _counter = string.match(server_id, "^(.*)/([^/]+)%.(%d+)%.(%d+)$")

			table.insert(nvim_instances, {
				server_id = server_id,
				pid = tonumber(pid),
				last_focused = server_id == last_focused_nvim,
			})
		end

		return nvim_instances
	end

	wezterm.log_error(stderr)

	return nil
end

local function extract_filename(uri)
	local start, match_end = uri:find("$EDITOR:")
	if start == 1 then
		-- skip past the colon
		return uri:sub(match_end + 1)
	end

	-- `file://hostname/path/to/file`
	local start, match_end = uri:find("file:")
	if start == 1 then
		-- skip "file://", -> `hostname/path/to/file`
		local host_and_path = uri:sub(match_end + 3)
		local start, match_end = host_and_path:find("/")
		if start then
			return host_and_path:sub(match_end)
		end
	end

	return nil
end

local function get_pwd(pane)
	return pane:get_current_working_dir().file_path
end

local function extract_line_and_name(uri)
	local name = extract_filename(uri)

	if name then
		local line = 1
		local col = 1
		local start, match_end = name:find(":[0-9]+")
		if start then
			line = name:sub(start + 1, match_end)
			local colStart, colEnd = name:find(":[0-9]+", match_end + 1)
			if colStart then
				col = name:sub(colStart + 1, colEnd)
				line = name:sub(start + 1, colStart - 1)
			end
			name = name:sub(1, start - 1)
		end

		return line, col, name
	end

	return nil, nil, nil
end

local function open_file_in_nvim(full_path, line, col, server_id)
	local nvim_command = string.format("<C-\\><C-N>:e %s<CR>:normal %dG<CR>:normal 0%dl<CR>", full_path, line, col - 1)
	wezterm.run_child_process({ "/opt/homebrew/bin/nvim", "--server", server_id, "--remote-send", nvim_command })
end

-- NOTE: this does not work on remote (muxed) panes
-- TODO: rewrite to omit the process_info usage
M.open_in_nvim = function(window, pane, uri)
	local line, col, name = extract_line_and_name(uri)

	wezterm.log_info("uri", uri, line, col, name)

	if name then
		local pwd = get_pwd(pane)
		local full_path = name:match("^/") and name or pwd .. "/" .. name

		wezterm.log_info("pwd " .. pwd)

		wezterm.log_info("full_path " .. full_path)

		local nvim_instances = get_nvim_instances()

		if nvim_instances == nil then
			return false
		end

		wezterm.log_info(nvim_instances)

		-- local nvim_panes = {}
		local chosen_nvim_pane = nil
		local process_info_missing = false

		-- gather infos from all neovim instances in the active tab
		for _, pane in ipairs(window:active_tab():panes()) do
			local process_info = pane:get_foreground_process_info()
			
			-- Handle the case where process_info is nil (in multiplexer mode)
			if process_info == nil then
				process_info_missing = true
			else
				for _, child_process in pairs(process_info.children) do
					for _, nvim_instance in ipairs(nvim_instances) do
						if child_process.pid == nvim_instance.pid then
							local nvim_pane = {
								pane = pane,
								pid = child_process.pid,
								server_id = nvim_instance.server_id,
								cwd = child_process.cwd,
								last_focused = nvim_instance.last_focused,
							}

							-- table.insert(nvim_panes, nvim_pane)

							if
								utils.is_subpath(nvim_pane.cwd, pwd)
								and not (chosen_nvim_pane and chosen_nvim_pane.last_focused)
							then
								chosen_nvim_pane = nvim_pane
							end
						end
					end
				end
			end
		end

		-- wezterm.log_info('nvim_panes', nvim_panes)

		if chosen_nvim_pane then
			-- wezterm.log_info("chosen nvim pane", chosen_nvim_pane)
			open_file_in_nvim(full_path, line, col, chosen_nvim_pane.server_id)
			chosen_nvim_pane.pane:activate()
		else
			-- If process_info is nil or no suitable pane was found, create a new vertical split pane
			wezterm.log_info("No suitable nvim pane found or process_info is nil. Creating a new vertical split.")
			local current_pane = window:active_tab():active_pane()
			local new_pane = current_pane:split({ direction = "Right" })
			
			-- Create the nvim command to open the file at the specific line and column
			local nvim_open_command = string.format("/opt/homebrew/bin/nvim +%d +normal\\ 0%dl %s", line, col - 1, full_path)
			new_pane:send_text(nvim_open_command .. "\r")
		end

		-- prevent the default action from opening in a browser
		return false
	end

	-- if email
	if uri:find("mailto:") == 1 then
		return false -- disable opening email
	end
end

wezterm.on("open-uri", function(window, pane, uri)
	M.open_in_nvim(window, pane, uri)
end)

M.config.hyperlink_rules = {
	-- These are the default rules, but you currently need to repeat
	-- them here when you define your own rules, as your rules override
	-- the defaults

	-- URL with a protocol
	{
		regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
		format = "$0",
	},

	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},

	-- new in nightly builds; automatically highly file:// URIs.
	{
		regex = "\\bfile://\\S*\\b",
		format = "$0",
	},

	-- Now add a new item at the bottom to match things that are
	-- probably filenames
	{
		regex = "[/.A-Za-z0-9_-]+\\.[A-Za-z0-9]+(:\\d+)*(?=\\s*|$)",
		format = "$EDITOR:$0",
	},
}

M.config.quick_select_patterns = {
	"[/.A-Za-z0-9_-]+\\.[A-Za-z0-9]+(:\\d+)*(?=\\s*|$)",
}

return M
