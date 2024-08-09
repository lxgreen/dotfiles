os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_themes/catppuccin ] && "
		.. "git clone https://github.com/catppuccin/lua.git $HOME/.local/share/sketchybar_themes/catppuccin"
)

local cat = require("colors.catppuccin")

local themes = {
	["catppuccin-mocha"] = cat.transform(cat.mocha),
	["catppuccin-latte"] = cat.transform(cat.latte),
}

-- Set the default theme
local selected = "catppuccin-mocha"

-- Load color file
local filename = os.getenv("HOME") .. "/.local/share/nvim/last-color"
local f = assert(io.open(filename, "r"))
local lastcolor = f:read("l")
f:close()
for index, _ in pairs(themes) do
	if index == lastcolor then
		selected = lastcolor
	end
end

-- Return the theme info
return {
	current = themes[selected](),
}
