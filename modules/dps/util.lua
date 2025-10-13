-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

local LGCS = LibGroupCombatStats

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

-- sorting functions
function module:sortByName(a, b)
    return a.name > b.name
end
function module:sortByDamage(a, b)
    if a.dmg == b.dmg then
        return self:sortByName(a, b)
    end
    return a.dmg > b.dmg
end
function module:sortByDamageType(a, b)
    if a.dmgType == b.dmgType then
        return self:sortByDamage(a, b)
    end
    return a.dmgType > b.dmgType
end
