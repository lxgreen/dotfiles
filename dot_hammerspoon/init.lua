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
