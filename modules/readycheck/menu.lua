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

function module:GetMenuOptions()
    return {
        {
            type = "checkbox",
            name = GetString(HR_MODULES_READYCHECK_MENU_UI_LOCKED),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_UI_LOCKED_TT),
            getFunc = function() return self.uiLocked end,
            setFunc = function(value)
                if not value then self:unlockUI() else self:lockUI() end
            end
        },
        {
            type = "checkbox",
            name = GetString(HR_MODULES_READYCHECK_MENU_CHAT),
            tooltip = GetString(HR_MODULES_READYCHECK_MENU_CHAT_TT),
            default = self.svDefault.enableChatMessages,
            getFunc = function() return self.sv.enableChatMessages end,
            setFunc = function(value) self.sv.enableChatMessages = value end,
        },
    }
end