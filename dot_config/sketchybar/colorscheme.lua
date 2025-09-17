os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_themes/catppuccin ] && "
		.. "git clone https://github.com/catppuccin/lua.git $HOME/.local/share/sketchybar_themes/catppuccin"
)

local cat = require("catppuccin")

local themes = {
	["catppuccin-mocha"] = cat.transform(cat.mocha),
	["catppuccin-latte"] = cat.transform(cat.latte),
}

-- Function to get current OS theme
local function get_current_os_theme()
	-- AppleInterfaceStyle only exists when in dark mode
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
	local appearance = handle:read("*l")
	handle:close()
	
	if appearance == "Dark" then
		return "dark"
	else
		return "light"
	end
end

-- Function to get theme based on OS appearance
local function get_theme_for_os_mode()
	local os_theme = get_current_os_theme()
	if os_theme == "light" then
		return "catppuccin-latte"
	else
		return "catppuccin-mocha"
	end
end

-- Set the theme based on OS appearance
local selected = get_theme_for_os_mode()

-- Fallback: Load from nvim color file if available
local nvim_color_file = os.getenv("HOME") .. "/.local/share/nvim/last-color"
local f = io.open(nvim_color_file, "r")
if f then
	local lastcolor = f:read("l")
	f:close()
	for index, _ in pairs(themes) do
		if index == lastcolor then
			selected = lastcolor
		end
	end
end

-- Return the theme info
return {
	current = themes[selected](),
}
