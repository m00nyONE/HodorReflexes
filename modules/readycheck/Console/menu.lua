-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "readycheck"
local module = addon_modules[module_name]

--- @return table
function module:GetMainMenuOptions()
    return {
        {
            type = LibHarvensAddonSettings.ST_CHECKBOX,
            label = GetString(HR_MODULES_READYCHECK_MENU_UI),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_UI_TT),
            default = self.svDefault.enableUI,
            getFunction = function() return self.sw.enableUI end,
            setFunction = function(value) self.sw.enableUI = value end,
        },
        {
            type = LibHarvensAddonSettings.ST_CHECKBOX,
            label  = GetString(HR_MODULES_READYCHECK_MENU_CHAT),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_CHAT_TT),
            default = self.svDefault.enableChatMessages,
            getFunction = function() return self.sw.enableChatMessages end,
            setFunction = function(value) self.sw.enableChatMessages = value end,
        },
    }
end