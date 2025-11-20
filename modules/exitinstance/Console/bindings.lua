-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "exitinstance"
local module = addon_modules[module_name]

local LRM = LibRadialMenu
local texture = "/esoui/art/menubar/gamepad/gp_playermenu_icon_logout.dds"

--- Setup keybinds for Exit Instance module
--- @return void
function module:SetupKeybinds()
    local function SendExitInstanceRequestWrapper()
        module:SendExitInstanceRequest()
    end

    LRM:RegisterEntry(addon_name, "Send Exit Instance Request", "Send Exit Instance Request", texture, SendExitInstanceRequestWrapper, GetString(HR_MODULES_EXITINSTANCE_COMMAND_HELP))
end