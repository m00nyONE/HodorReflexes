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

local localPlayer = "player"

function module:SetupKeybinds()
    local exitInstanceRequestButton = {
        name = GetString(HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT),
        keybind = 'HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT',
        callback = function(...) self:SendExitInstanceRequest(...) end,
        alignment = KEYBIND_STRIP_ALIGN_CENTER,
    }

    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader(localPlayer) then
            KEYBIND_STRIP:AddKeybindButton(exitInstanceRequestButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(exitInstanceRequestButton)
        end
    end
    -- Add hotkey to group window
    if KEYBOARD_GROUP_MENU_SCENE then
        KEYBOARD_GROUP_MENU_SCENE:RegisterCallback("StateChange", OnStateChanged)
    end
    if GAMEPAD_GROUP_SCENE then
        GAMEPAD_GROUP_SCENE:RegisterCallback("StateChange", OnStateChanged)
    end
end