-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

--- get the ultimate in percent from 0-100. from 100-200 its scaled accordingly.
--- @param ultValue number current ult value
--- @param ultCost number ult cost of the ability
--- @return number percentage from 0-200
function module:getUltPercentage(ultValue, ultCost)
    if ultValue <= ultCost then
        return zo_floor((ultValue / ultCost) * 100)
    end

    return zo_clamp(100 + zo_floor(100 * (ultValue - ultCost) / (500 - ultCost)), 0, 200)
end

--- get a hex color code depending on the ult percentage
--- @param percentage number ult percentage from 0-200
--- @param defaultColor string|nil optional default color if percentage is below 80%
--- @return string hex color code
function module:getUltPercentageColor(percentage, defaultColor)
    if percentage >= 100 then return '00FF00' end -- green
    if percentage >= 80 then return 'FFFF00' end -- yellow
    return defaultColor or 'FFFFFF' -- white
end

-- sorting functions

--- sort by name descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByName(a, b)
    return a.name > b.name
end

--- sort by ultValue descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByUltValue(a, b)
    if a.ultValue == b.ultValue then
        return module.sortByName(a, b)
    end
    return a.ultValue > b.ultValue
end

--- sort by ultPercentage descending
--- @param a table
--- @param b table
--- @return boolean
function module.sortByUltPercentage(a, b)
    if a.lowestUltPercentage == b.lowestUltPercentage then
        return module.sortByUltValue(a, b)
    end
    return a.lowestUltPercentage > b.lowestUltPercentage
end

-- ability checks

--- checks if an abilityId is in a list of abilityIds
--- @param abilityId number
--- @param abilityList table
--- @return boolean
local function isAbilityInList(abilityId, abilityList)
    for _, id in pairs(abilityList) do
        if abilityId == id then return true end
    end
    return false
end

--- checks if the abilityId is a horn
--- @param abilityId number
--- @return boolean
function module:isHorn(abilityId)
    return isAbilityInList(abilityId, self.hornAbilityIds)
end

--- checks if the abilityId is a colos
--- @param abilityId number
--- @return boolean
function module:isColos(abilityId)
    return isAbilityInList(abilityId, self.colosAbilityIds)
end

--- checks if the abilityId is an atro
--- @param abilityId number
--- @return boolean
function module:isAtro(abilityId)
    return isAbilityInList(abilityId, self.atroAbilityIds)
end

--- checks if the abilityId is a barrier
--- @param abilityId number
--- @return boolean
function module:isBarrier(abilityId)
    return isAbilityInList(abilityId, self.barrierAbilityIds)
end

--- checks if the abilityId is a crypt cannon
--- @param abilityId number
--- @return boolean
function module:isCryptCannon(abilityId)
    return isAbilityInList(abilityId, self.cryptCannonAbilityIds)
end

-- hasUnitX checks

--- checks if the player has a horn ult ability
--- @param playerData table
--- @return boolean
function module:hasUnitHorn(playerData)
    if self:isHorn(playerData.ult1ID) or self:isHorn(playerData.ult2ID) then return true end
    return false
end

--- checks if the player has a colos ult ability
--- @param playerData table
--- @return boolean
function module:hasUnitColos(playerData)
    if self:isColos(playerData.ult1ID) or self:isColos(playerData.ult2ID) then return true end
    return false
end

--- checks if the player has an atro ult ability
--- @param playerData table
--- @return boolean
function module:hasUnitAtro(playerData)
    if self:isAtro(playerData.ult1ID) or self:isAtro(playerData.ult2ID) then return true end
    return false
end

--- checks if the player has a barrier ult ability
--- @param playerData table
--- @return boolean
function module:hasUnitBarrier(playerData)
    if self:isBarrier(playerData.ult1ID) or self:isBarrier(playerData.ult2ID) then return true end
    return false
end

--- checks if the player has a crypt cannon ult ability
--- @param playerData table
--- @return boolean
function module:hasUnitCryptCannon(playerData)
    if self:isCryptCannon(playerData.ult1ID) or self:isCryptCannon(playerData.ult2ID) then return true end
    return false
end

--- checks if the player has the saxhleel ult activated set
--- @param playerData table
--- @return boolean
function module:hasUnitSaxhleel(playerData)
    if playerData.ultActivatedSetID == 1 then return true end
    return false
end

--- checks if the player has the MasterArchitect or WarMachine ult activated set
--- @param playerData table
--- @return boolean
function module:hasUnitSlayer(playerData)
    if playerData.ultActivatedSetID == 4 or playerData.ultActivatedSetID == 5 then return true end
    return false
end

--- checks if the player has the Pillager ult activated set
--- @param playerData table
--- @return boolean
function module:hasUnitPillager(playerData)
    if playerData.ultActivatedSetID == 2 then return true end
    return false
end
