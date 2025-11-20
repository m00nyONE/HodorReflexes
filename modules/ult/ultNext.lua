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

local HR_EVENT_PLAYERSDATA_UPDATED = addon.HR_EVENT_PLAYERSDATA_UPDATED
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEANED

-- holds references to the next players for special ults
local myHornNext = false
local myColosNext = false
local myAtroNext = false
local myBarrierNext = false
local myCryptCannonNext = false

function module:IsMyHornNext()
    return myHornNext
end
function module:IsMyColosNext()
    return myColosNext
end
function module:IsMyAtroNext()
    return myAtroNext
end
function module:IsMyBarrierNext()
    return myBarrierNext
end
function module:IsMyCryptCannonNext()
    return myCryptCannonNext
end

function module:CalculateUltNextUser()
    local nextHornUser = nil
    local nextColosUser = nil
    local nextAtroUser = nil
    local nextBarrierUser = nil
    local nextCryptCannonUser = nil

    -- find out who has the highest ult for special ults ( horn, colos )
    for _, entry in pairs(addon.playersData) do
        -- TODO: maybe a check is needed if the lowestUltPercentage >= 100 ? - cuz e.g. saxhleel percentage is not calculated when receiving ult but in the horn list instead
        if entry.hasHorn or entry.hasSaxhleel then
            if (not nextHornUser) or (entry.lowestUltPercentage > nextHornUser.lowestUltPercentage) then
                nextHornUser = entry
            end
        end
        if entry.hasColos then
            if (not nextColosUser) or (entry.lowestUltPercentage > nextColosUser.lowestUltPercentage) then
                nextColosUser = entry
            end
        end
        if entry.hasAtro then
            if (not nextAtroUser) or (entry.lowestUltPercentage > nextAtroUser.lowestUltPercentage) then
                nextAtroUser = entry
            end
        end
        if entry.hasBarrier then
            if (not nextBarrierUser) or (entry.lowestUltPercentage > nextBarrierUser.lowestUltPercentage) then
                nextBarrierUser = entry
            end
        end
        if entry.hasCryptCannon then
            if (not nextCryptCannonUser) or (entry.lowestUltPercentage > nextCryptCannonUser.lowestUltPercentage) then
                nextCryptCannonUser = entry
            end
        end
    end

    -- if the next user is the player, set the flags
    myHornNext = (nextHornUser and nextHornUser.isPlayer) or false
    myColosNext = (nextColosUser and nextColosUser.isPlayer) or false
    myAtroNext = (nextAtroUser and nextAtroUser.isPlayer) or false
    myBarrierNext = (nextBarrierUser and nextBarrierUser.isPlayer) or false
    myCryptCannonNext = (nextCryptCannonUser and nextCryptCannonUser.isPlayer) or false
end

function module:RegisterUltNextTracker()
    local function _calculateUltNextUserWrapper()
        self:CalculateUltNextUser()
    end

    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, _calculateUltNextUserWrapper)
    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_CLEANED, _calculateUltNextUserWrapper)
end

function module:CreateUltNextControls()

end