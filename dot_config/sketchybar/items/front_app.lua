local colors = require("colors")
local settings = require("settings")

local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = {
        drawing = true,
        font = "sketchybar-app-font:Regular:16.0",
        padding_left = 3,
        padding_right = 3
    },
    label = {
        font = {
            style = settings.font.style_map["Bold"],
            size = 13.0
        }
    },
    updates = true
})

local function update_front_app(app_name)
    local icon = app_icons[app_name] or app_icons["Default"]
    
    front_app:set({
        icon = {
            string = icon,
            font = "sketchybar-app-font:Regular:16.0"
        },
        label = {
            string = app_name
        }
    })
end

front_app:subscribe("front_app_switched", function(env)
    update_front_app(env.INFO)
end)

-- Refresh front app after system wake
front_app:subscribe("system_woke", function(env)
    sbar.exec("osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'", function(result)
        local app_name = result:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
        if app_name and app_name ~= "" then
            update_front_app(app_name)
        end
    end)
end)

front_app:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)
