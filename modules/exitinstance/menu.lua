-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "exitinstance"
local module = addon_modules[module_name]

function module:GetMainMenuOptions()
    return {
        {
            type = "checkbox",
            name = GetString(HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT),
            tooltip = GetString(HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT),
            default = true,
            getFunc = function() return self.sv.confirmExitInstance end,
            setFunc = function(value) self.sv.confirmExitInstance = value end
        },
        {
            type = "checkbox",
            name = GetString(HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS),
            tooltip = GetString(HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT),
            default = false,
            getFunc = function() return self.sv.ignoreExitInstanceRequests end,
            setFunc = function(value) self.sv.ignoreExitInstanceRequests = value end
        },

    }
end