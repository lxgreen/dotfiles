local wezterm = require("wezterm")
local server_id_file = "/tmp/nvim-focuslost"

local function extract_filename(uri)
	local start, match_end = uri:find("$EDIT:")
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
			-- -> `/path/to/file`
			return host_and_path:sub(match_end)
		end
	end

	return nil
end

local function get_nvim_server_id()
	local server_id = io.open(server_id_file):read("*a")
	server_id = server_id:sub(1, -2)

	return server_id
end

local function get_pwd(pane)
	local pwd = pane:get_current_working_dir()
	pwd = pwd:gsub("^file://[^/]+", "")
	return pwd
end

local function extract_line_and_name(uri)
	local name = extract_filename(uri)

	if name then
		local line = 1
		-- check if name has a line number (e.g. `file:.../file.txt:123 or file:.../file.txt:123:456`)
		local start, match_end = name:find(":[0-9]+")
		if start then
			-- line number is 123
			line = name:sub(start + 1, match_end)
			-- remove the line number from the filename
			name = name:sub(1, start - 1)
		end

		return line, name
	end

	return nil, nil
end

local function open_in_nvim(full_path, line)
	local server_id = get_nvim_server_id()
	wezterm.run_child_process({ "/opt/homebrew/bin/nvr", "--servername", server_id, full_path, "-c", line })
end

-- Listen for the "open-uri" escape sequence and open the URI in
wezterm.on("open-uri", function(window, pane, uri)
	local line, name = extract_line_and_name(uri)

	if name then
		local pwd = get_pwd(pane)
		local full_path = pwd .. "/" .. name
		open_in_nvim(full_path, line)

		-- focus the pane above // TODO: Only for nvim on the top pane, need another way to focus the nvim pane
		window:perform_action({ ActivatePaneDirection = "Right" }, pane)

		-- prevent the default action from opening in a browser
		return false
	end

	-- if email
	if uri:find("mailto:") == 1 then
		return false -- disable opening email
	end
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}

	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)

		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)

				number_value = number_value - 1
			end

			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)

			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end

	window:set_config_overrides(overrides)
end)

local scheme_by_os = function(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha Extended"
	else
		return "Catppuccin Latte Extended"
	end
end

local scheme_extend = function(scheme_name)
	local scheme = wezterm.color.get_builtin_schemes()[scheme_name]

	scheme.background = scheme.tab_bar.inactive_tab.bg_color
	scheme.tab_bar.active_tab.bg_color = scheme.tab_bar.background
	scheme.tab_bar.active_tab.fg_color = scheme.tab_bar.inactive_tab.fg_color
	scheme.tab_bar.inactive_tab.bg_color = scheme.tab_bar.background
	scheme.tab_bar.inactive_tab.fg_color = scheme.tab_bar.new_tab_hover.bg_color
	scheme.tab_bar.inactive_tab_hover.bg_color = scheme.indexed[16]
	scheme.tab_bar.inactive_tab_hover.fg_color = scheme.tab_bar.background

	return scheme
end

return {
	unix_domains = {
		{
			name = "dev",
		},
	},
	default_gui_startup_args = { "connect", "dev" },
	color_scheme = scheme_by_os(wezterm.gui.get_appearance()),
	color_schemes = {
		["Catppuccin Mocha Extended"] = scheme_extend("Catppuccin Mocha"),
		["Catppuccin Latte Extended"] = scheme_extend("Catppuccin Latte"),
	},

	adjust_window_size_when_changing_font_size = false,
	line_height = 1.2,
	font_size = 16,
	font = wezterm.font_with_fallback({
		{ family = "JetBrains Mono", weight = "Medium" },
		"SF Pro",
	}),

	show_new_tab_button_in_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	tab_max_width = 24,
	use_fancy_tab_bar = false,
	cursor_thickness = "50%",
	underline_thickness = "250%",

	cursor_blink_rate = 0,
	default_cursor_style = "SteadyBar",

	window_decorations = "RESIZE",
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_background_opacity = 1.0,
	macos_window_background_blur = 0,

	debug_key_events = true,
	use_ime = true,

	keys = {
		{ key = "k", mods = "SUPER", action = wezterm.action.QuickSelect },
		{ key = "р", mods = "CTRL", action = wezterm.action.SendString("\x08") },
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
	},

	hyperlink_rules = {
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
			format = "$EDIT:$0",
		},
	},

	-- requires kitty.terminfo
	-- install with: tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo && tic -x -o ~/.terminfo "$tempfile" && rm "$tempfile"
	term = "xterm-kitty",
	enable_kitty_graphics = true,

	-- https://github.com/wez/wezterm/issues/119#issuecomment-1206593847
	-- TODO: figure out why it doesn't work
	-- mouse_bindings = {
	-- 	{
	-- 		event = { Up = { streak = 1, button = "Left" } },
	-- 		mods = "CTRL",
	-- 		action = wezterm.action.OpenLinkAtMouseCursor,
	-- 	},
	-- },
}
