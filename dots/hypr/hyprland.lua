package.path = os.getenv("HOME") .. "/.local/share/groobarchy/dots/hypr/?.lua;" .. package.path

local profile = os.getenv("PROFILE")

require("shared/autostart")
require("shared/env")
require("shared/general")
require("shared/devices")
require("shared/keybinds")
require("shared/rules")
require("shared/animations")
require("shared/decor")

require(profile .. "/monitors")
require(profile .. "/workspaces")
require(profile .. "/device-keybinds")

require("shared/hy3")
