local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local default_app_icon = app_icons["Default"]

local all_workspaces = get_workspaces()
-- Limit to first 9 workspaces
local workspaces = {}
for i = 1, math.min(9, #all_workspaces) do
    workspaces[i] = all_workspaces[i]
end
local current_workspace = get_current_workspace()
local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

local function get_app_icon(app_name)
    local normalized_app_name = ""

    if type(app_name) == "string" then
        normalized_app_name = app_name:gsub("^%s*(.-)%s*$", "%1")
    end

    return app_icons[normalized_app_name] or default_app_icon
end

local function build_lookup(items)
    local lookup = {}

    if type(items) ~= "table" then
        return lookup
    end

    for _, item in ipairs(items) do
        if type(item) == "string" then
            lookup[item] = true
        elseif type(item) == "table" and type(item["app-name"]) == "string" then
            lookup[item["app-name"]] = true
        end
    end

    return lookup
end

local function set_space_label(space, icon_line)
    sbar.animate("tanh", 10, function()
        space:set({
            label = {
                string = icon_line,
                font = settings.icons
            }
        })
    end)
end

local function update_space_label(space_index, visible_apps_lookup)
    sbar.exec("aerospace list-windows --workspace " .. space_index .. " --format '%{app-name}' --json ", function(apps)
        local icon_line = ""
        local no_app = true

        if type(apps) == "table" then
            for _, app in ipairs(apps) do
                local app_name = app["app-name"]

                if visible_apps_lookup[app_name] then
                    no_app = false
                    icon_line = icon_line .. " " .. get_app_icon(app_name)
                end
            end
        end

        if no_app then
            icon_line = " —"
        end

        set_space_label(spaces[space_index], icon_line)
    end)
end

local function refresh_space_labels()
    sbar.exec("aerospace list-apps --macos-native-hidden no --format '%{app-name}' --json ", function(visible_apps)
        local visible_apps_lookup = build_lookup(visible_apps)

        for space_index, _ in ipairs(workspaces) do
            update_space_label(space_index, visible_apps_lookup)
        end
    end)
end

for i, workspace in ipairs(workspaces) do
    local selected = workspace == current_workspace
    local space = sbar.add("item", "item." .. i, {
        icon = {
            font = {
                family = settings.font.numbers
            },
            string = i,
            padding_left = settings.items.padding.left,
            padding_right = settings.items.padding.left / 2,
            color = settings.items.default_color(i),
            highlight_color = settings.items.highlight_color(i),
            highlight = selected
        },
        label = {
            padding_right = settings.items.padding.right,
            color = settings.items.default_color(i),
            highlight_color = settings.items.highlight_color(i),
            font = settings.icons,
            highlight = selected
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = settings.items.colors.background,
            border_width = 1,
            height = settings.items.height,
            border_color = selected and settings.items.highlight_color(i) or settings.items.default_color(i)
        },
        popup = {
            background = {
                border_width = 5,
                border_color = colors.black
            }
        }
    })

    spaces[i] = space

    -- Padding space between each item
    sbar.add("item", "item." .. i .. "padding", {
        script = "",
        width = settings.items.gap
    })

    -- Item popup
    local space_popup = sbar.add("item", {
        position = "popup." .. space.name,
        padding_left = 5,
        padding_right = 0,
        background = {
            drawing = true,
            image = {
                corner_radius = 9,
                scale = 0.2
            }
        }
    })

    space:subscribe("aerospace_workspace_change", function(env)
        local selected = env.FOCUSED_WORKSPACE == workspace
        space:set({
            icon = {
                highlight = selected
            },
            label = {
                highlight = selected
            },
            background = {
                border_color = selected and settings.items.highlight_color(i) or settings.items.default_color(i)
            }
        })

    end)

    space:subscribe("mouse.clicked", function(env)
        local SID = split(env.NAME, ".")[2]
        if env.BUTTON == "other" then
            space_popup:set({
                background = {
                    image = "item." .. SID
                }
            })
            space:set({
                popup = {
                    drawing = "toggle"
                }
            })
        else
            sbar.exec("aerospace workspace " .. SID)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({
            popup = {
                drawing = false
            }
        })
    end)
end

refresh_space_labels()

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

-- Handles the small icon indicator for spaces / menus changes
local spaces_indicator = sbar.add("item", {
    padding_left = -3,
    padding_right = 0,
    icon = {
        padding_left = 8,
        padding_right = 9,
        color = colors.green,
        string = icons.switch.on
    },
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.green
    },
    background = {
        color = colors.with_alpha(colors.green, 0.0),
        border_color = colors.with_alpha(colors.green, 0.0)
    }
})

-- Event handles
space_window_observer:subscribe("space_windows_change", function(env)
    refresh_space_labels()
end)

space_window_observer:subscribe("aerospace_focus_change", function(env)
    refresh_space_labels()
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        icon = currently_on and icons.switch.off or icons.switch.on
    })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 0.0
                },
                border_color = {
                    alpha = 1.0
                }
            },
            icon = {
                color = colors.green
            },
            label = {
                width = "dynamic"
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 0.0
                },
                border_color = {
                    alpha = 0.0
                }
            },
            icon = {
                color = colors.green},
            label = {
                width = 0
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)
