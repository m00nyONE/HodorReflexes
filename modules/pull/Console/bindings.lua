-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "pull"
local module = addon_modules[module_name]

local LRM = LibRadialMenu
local texture = "EsoUI/Art/HUD/HUD_Countdown_Badge_Dueling.dds"

--- Setup keybinds for Pull module
--- @return void
function module:SetupKeybinds()
    local function sendPullCountdownWrapper()
        module:SendPullCountdown()
    end

    LRM:RegisterEntry(addon_name, "Pull countdown", "pull countdown", texture, sendPullCountdownWrapper, GetString(HR_MODULES_PULL_COMMAND_HELP))
end