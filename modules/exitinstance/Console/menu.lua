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

--- @return table
function module:GetMainMenuOptions()
    return {
        {
            type = LibHarvensAddonSettings.ST_CHECKBOX,
            label = GetString(HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT),
            tooltip = GetString(HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT),
            getFunction = function() return self.sv.confirmExitInstance end,
            setFunction = function(value) self.sv.confirmExitInstance = value end,
            default = true,
        },
        {
            type = LibHarvensAddonSettings.ST_CHECKBOX,
            label = GetString(HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS),
            tooltip = GetString(HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT),
            getFunction = function() return self.sv.ignoreExitInstanceRequests end,
            setFunction = function(value) self.sv.ignoreExitInstanceRequests = value end,
            default = false,
        },
    }
end