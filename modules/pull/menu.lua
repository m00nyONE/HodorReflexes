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

function module:GetMainMenuOptions()
    return {
        {
            type = "slider",
            name = GetString(HR_MODULES_PULL_COUNTDOWN_DURATION),
            tooltip = GetString(HR_MODULES_PULL_COUNTDOWN_DURATION_TT),
            min = self.minCountdownDuration,
            max = self.maxCountdownDuration,
            step = 1,
            default = self.svDefault.countdownDuration,
            decimals = 0,
            getFunc = function() return self.sv.countdownDuration end,
            setFunc = function(value) self.sv.countdownDuration = value end,
        },
    }
end