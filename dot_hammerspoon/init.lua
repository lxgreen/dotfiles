require("hs.ipc")

local EN = "com.apple.keylayout.ABC"
local RU = "com.apple.keylayout.Russian-Phonetic"
local HE = "com.apple.keylayout.Hebrew"

hs.hotkey.bind({"ctrl"}, "space", function()
  if hs.keycodes.currentSourceID() == EN then
    hs.keycodes.currentSourceID(RU)
  else
    hs.keycodes.currentSourceID(EN)
  end
end)

hs.hotkey.bind({"ctrl", "shift"}, "space", function()
  hs.keycodes.currentSourceID(HE)
end)

-- GlobalProtect: Ctrl+G opens the menu bar popup and presses Connect
local function gpButton(ax)
  for _, w in ipairs(ax:attributeValue("AXWindows") or {}) do
    for _, c in ipairs(w:attributeValue("AXChildren") or {}) do
      if c:attributeValue("AXRole") == "AXButton" then return c end
    end
  end
end

hs.hotkey.bind({"ctrl"}, "g", function()
  local app = hs.application.find("GlobalProtect")
  if not app then
    hs.alert.show("GlobalProtect is not running")
    return
  end
  local ax = hs.axuielement.applicationElement(app)
  local menuItem = ax:attributeValue("AXExtrasMenuBar"):attributeValue("AXChildren")[1]
  if not gpButton(ax) then menuItem:performAction("AXPress") end

  local tries = 0
  local timer
  timer = hs.timer.doEvery(0.1, function()
    tries = tries + 1
    local button = gpButton(ax)
    if button then
      timer:stop()
      if button:attributeValue("AXTitle") == "Connect" then
        button:performAction("AXPress")
      else
        hs.alert.show("GlobalProtect: already connected")
        menuItem:performAction("AXPress")
      end
    elseif tries > 30 then
      timer:stop()
      hs.alert.show("GlobalProtect: Connect button not found")
    end
  end)
end)
