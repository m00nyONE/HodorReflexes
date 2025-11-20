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
            type = "checkbox",
            name = GetString(HR_MODULES_READYCHECK_MENU_UI),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_UI_TT),
            default = self.svDefault.enableUI,
            getFunc = function() return self.sw.enableUI end,
            setFunc = function(value) self.sw.enableUI = value end,
        },
        {
            type = "checkbox",
            name = GetString(HR_MODULES_READYCHECK_MENU_CHAT),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_CHAT_TT),
            default = self.svDefault.enableChatMessages,
            getFunc = function() return self.sw.enableChatMessages end,
            setFunc = function(value) self.sw.enableChatMessages = value end,
        },
    }
end