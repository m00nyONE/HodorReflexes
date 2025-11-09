-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local util = addon.util

local addon_extensions = addon.extensions
local extension = addon_extensions.seasons

local dps_module = addon.modules.dps

local season = {
    name = "aprilfools",
    version = "1.0.0",
    description = "reverse dps ranking",
    dates = { "0104" },
}

--- activates the april fools season
--- @return void
function season:Activate()
    local function sortByDamageReversed(a, b)
        if a.dmg == b.dmg then
            return dps_module.sortByName(a, b)
        end
        return a.dmg < b.dmg
    end
    dps_module.sortByDamage = sortByDamageReversed
end

extension:NewSeason(season)