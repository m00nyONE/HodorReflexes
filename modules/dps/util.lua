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

local util = core.util

local LGCS = LibGroupCombatStats

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local localPlayer = "player"

-- sorting functions

--- sort by name descending
--- @param a table
--- @param b table
--- @return boolean
function module:sortByName(a, b)
    return a.name > b.name
end
--- sort by damage descending
--- @param a table
--- @param b table
--- @return boolean
function module:sortByDamage(a, b)
    if a.dmg == b.dmg then
        return self:sortByName(a, b)
    end
    return a.dmg > b.dmg
end
--- sort by damageType descending
--- @param a table
--- @param b table
--- @return boolean
function module:sortByDamageType(a, b)
    if a.dmgType == b.dmgType then
        return self:sortByDamage(a, b)
    end
    return a.dmgType > b.dmgType
end


-- formatting functions

--- get header format for damage list.
--- @return string
function module:getDamageHeaderFormat(dmgType)
    if dmgType == DAMAGE_TOTAL then
        return string.format('|c%s%s|r |c%s(DPS)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_TOTAL), self.sw.colorDamageTotal)
    elseif dmgType == DAMAGE_BOSS then
        return string.format('|c%s%s|r |c%s(%s)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DPS_BOSS), self.sw.colorDamageTotal, GetString(HR_MODULES_DPS_DPS_TOTAL))
    elseif dmgType == DAMAGE_UNKNOWN then
        return string.format('|c%s%s|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE))
    end

    return string.format('|c%s%s|r |c%s(DPS)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_MISC), self.sw.colorDamageTotal)
end
--- get row format for damage list.
--- @return string
function module:getDamageRowFormat(dmgType, dmg, dps)
    if dmgType == DAMAGE_TOTAL then
        return string.format('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', self.sw.colorDamageBoss, dmg / 100, self.sw.colorDamageTotal, dps)
    end

    return string.format('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', self.sw.colorDamageBoss, dmg / 10, self.sw.colorDamageTotal, dps)
end

-- visibility checks

--- returns true if damage list should be visible based on settings
--- @return boolean
function module:isDamageListVisible()
    return util.IsListVisible(self.sw.damageListEnabled)
end
