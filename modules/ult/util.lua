-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

-- return the ultimate in percent from 0-100. from 100-200 its scaled acordingly.
function module:getUltPercentage(ultValue, ultCost)
    if ultValue <= ultCost then
        return zo_floor((ultValue / ultCost) * 100)
    end

    return zo_min(200, 100 + zo_floor(100 * (ultValue - ultCost) / (500 - ultCost)))
end

-- return a color code depending on the ult percentage
function module:getUltPercentageColor(percentage, defaultColor)
    if percentage >= 100 then return '00FF00' end -- green
    if percentage >= 80 then return 'FFFF00' end -- yellow
    return defaultColor or 'FFFFFF' -- white
end

-- sorting functions
function module:sortByName(a, b)
    return a.name > b.name
end
function module:sortByUltValue(a, b)
    if a.ultValue == b.ultValue then
        return self:sortByName(a, b)
    end
    return a.ultValue > b.ultValue
end
function module:sortByUltPercentage(a, b)
    if a.lowestUltPercentage == b.lowestUltPercentage then
        return self:sortByUltValue(a, b)
    end
    return a.lowestUltPercentage > b.lowestUltPercentage
end

-- isAbility checks
local function isAbilityInList(abilityId, abilityList)
    for _, id in pairs(abilityList) do
        if abilityId == id then return true end
    end
    return false
end
function module:isHorn(abilityId)
    return isAbilityInList(abilityId, self.hornAbilityIds)
end
function module:isColos(abilityId)
    return isAbilityInList(abilityId, self.colosAbilityIds)
end
function module:isAtro(abilityId)
    return isAbilityInList(abilityId, self.atroAbilityIds)
end
function module:isBarrier(abilityId)
    return isAbilityInList(abilityId, self.barrierAbilityIds)
end
function module:isCryptCannon(abilityId)
    return isAbilityInList(abilityId, self.cryptCannonAbilityIds)
end

-- hasUnitX checks
function module:hasUnitHorn(playerData)
    if self:isHorn(playerData.ult1ID) or self:isHorn(playerData.ult2ID) then return true end
    return false
end
function module:hasUnitColos(playerData)
    if self:isColos(playerData.ult1ID) or self:isColos(playerData.ult2ID) then return true end
    return false
end
function module:hasUnitAtro(playerData)
    if self:isAtro(playerData.ult1ID) or self:isAtro(playerData.ult2ID) then return true end
    return false
end
function module:hasUnitBarrier(playerData)
    if self:isBarrier(playerData.ult1ID) or self:isBarrier(playerData.ult2ID) then return true end
    return false
end
function module:hasUnitCryptCannon(playerData)
    if self:isCryptCannon(playerData.ult1ID) or self:isCryptCannon(playerData.ult2ID) then return true end
    return false
end
function module:hasUnitSaxhleel(playerData)
    if playerData.ultActivatedSetID == 1 then return true end
    return false
end
function module:hasUnitMAorWM(playerData)
    if playerData.ultActivatedSetID == 4 or playerData.ultActivatedSetID == 5 then return true end
    return false
end
function module:hasUnitPillager(playerData)
    if playerData.ultActivatedSetID == 2 then return true end
    return false
end