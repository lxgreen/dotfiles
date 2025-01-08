local wezterm = require("wezterm")
local open_in_nvim = require("open-in-nvim")

wezterm.on("update-status", function(window, _pane)
	window:set_right_status(wezterm.format({
		{ Text = window:active_workspace() },
	}))
end)

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "Configuration reloaded!", nil, 2000)
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
	-- NOTE: uncomment to	enable mux
	-- default_gui_startup_args = { "connect", "dev" },
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
	hide_tab_bar_if_only_one_tab = false,
	tab_bar_at_bottom = false,
	tab_max_width = 24,
	use_fancy_tab_bar = false,
	cursor_thickness = "50%",
	underline_thickness = "250%",
	status_update_interval = 200,
	scrollback_lines = 10000,

	cursor_blink_rate = 0,
	default_cursor_style = "SteadyBar",

	window_decorations = "RESIZE",
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_background_opacity = 1.0,
	macos_window_background_blur = 0,
	debug_key_events = true,
	use_ime = true,
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		{
			key = "f",
			mods = "LEADER",
			action = wezterm.action.QuickSelectArgs({
				patterns = {
					[[[/.A-Za-z0-9_-]+\.[A-Za-z0-9]+[:\d+]*(?=\s*|$)]],
				},
				action = wezterm.action_callback(function(window, pane)
					local path = window:get_selection_text_for_pane(pane)
					open_in_nvim.open_in_nvim(window, pane, "$EDITOR:" .. path)
				end),
			}),
		},
		{ key = "р", mods = "CTRL", action = wezterm.action.SendString("\x08") },
		{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
		{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
		-- { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
		{
			key = "\\",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "h",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},
		{
			key = "o",
			mods = "LEADER",
			action = wezterm.action.SwitchToWorkspace({
				name = "WORK",
			}),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action.SwitchToWorkspace({
				name = "CONFIG",
				spawn = {
					args = { "nvim", os.getenv("HOME") .. "/.config" },
					cwd = os.getenv("HOME") .. "/.config",
					label = "CONFIGURATION",
				},
			}),
		},
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				local notes_workspace = "Notes"
				local notes_dir = os.getenv("HOME") .. "/Sync/Notes/"
				local command = { "zk", "edit", "-i", "-W", notes_dir }

				-- Switch to the "Notes" workspace
				window:perform_action(wezterm.action.SwitchToWorkspace({ name = notes_workspace }), pane)

				-- Spawn a new tab in the "Notes" workspace with the command
				window:perform_action(
					wezterm.action.SpawnCommandInNewTab({
						cwd = notes_dir,
						args = command,
					}),
					pane
				)
			end),
		},
		-- Show the launcher in fuzzy selection mode and have it list all workspaces
		-- and allow activating one.
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
	},

	-- requires kitty.terminfo
	-- install with: tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo && tic -x -o ~/.terminfo "$tempfile" && rm "$tempfile"
	term = "xterm-kitty",
	enable_kitty_graphics = true,

	-- https://github.com/wez/wezterm/issues/119#issuecomment-1206593847
	-- TODO: figure out why it doesn't work
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},

	hyperlink_rules = open_in_nvim.config.hyperlink_rules,
	quick_select_patterns = open_in_nvim.config.quick_select_patterns,
}
