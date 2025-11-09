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

--- @return table
function module:GetMainMenuOptions()
    return {
        {
            type = LibHarvensAddonSettings.ST_SLIDER,
            label = GetString(HR_MODULES_PULL_COUNTDOWN_DURATION),
            tooltip = GetString(HR_MODULES_PULL_COUNTDOWN_DURATION_TT),
            min = self.minCountdownDuration,
            max = self.maxCountdownDuration,
            step = 1,
            default = self.svDefault.countdownDuration,
            format = "%.0f",
            unit = GetString(HR_UNIT_SECONDS),
            getFunction = function() return self.sv.countdownDuration end,
            setFunction = function(value) self.sv.countdownDuration = value end,
        },
    }
end