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

local localPlayer = "player"

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

-- formatting functions
function module:getDamageFormat(dmgType)
    local formats = {
        [DAMAGE_UNKNOWN] = string.format('|c%s%s|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE)),
        [DAMAGE_TOTAL] = string.format('|c%s%s|r |c%s(DPS)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_TOTAL), self.sw.colorDamageTotal),
        [DAMAGE_BOSS] = string.format('|c%s%s|r |c%s(%s)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DPS_BOSS), self.sw.colorDamageTotal, GetString(HR_MODULES_DPS_DPS_TOTAL)),
    }
    return formats[dmgType] and formats[dmgType] or string.format('|c%s%s|r |c%s(DPS)|r', self.sw.colorDamageBoss, GetString(HR_MODULES_DPS_DAMAGE_MISC), self.sw.colorDamageTotal)
end

--
function module:isDamageListVisible()
    if self.sw.damageListEnabled == 1 then -- always show
        return true
    elseif self.sw.damageListEnabled == 2 then -- show out of combat
        return not IsUnitInCombat(localPlayer)
    elseif self.sw.damageListEnabled == 3 then -- show non bossfights
        return not IsUnitInCombat(localPlayer) or not DoesUnitExist('boss1') and not DoesUnitExist('boss2')
    else -- off
        return false
    end
end
