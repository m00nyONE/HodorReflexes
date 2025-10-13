-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group
local hud = core.hud
local LGCS = LibGroupCombatStats

local localPlayer = "player"

local EVENT_GROUP_ULT_UPDATE = LGCS.EVENT_GROUP_ULT_UPDATE
local EVENT_PLAYER_ULT_UPDATE = LGCS.EVENT_PLAYER_ULT_UPDATE

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK

local moduleDefinition = {
    name = "ult",
    friendlyName = GetString(HR_MODULES_ULT_FRIENDLYNAME),
    description = GetString(HR_MODULES_ULT_DESCRIPTION),
    version = "1.0.0",
    priority = 1,
    enabled = false,
    svDefault = {
        accountWide = true,
    },

    uiLocked = true,
    isTestRunning = false,
}

local module = internal.moduleClass:New(moduleDefinition)

-- return the ultimate in percent from 0-100. from 100-200 its scaled acordingly.
function module:getUltPercentage(ultValue, ultCost)
    if ultValue <= ultCost then
        return zo_floor((ultValue / ultCost) * 100)
    end

    return zo_min(200, 100 + zo_floor(100 * (ultValue - ultCost) / (500 - ultCost)))
end

function module:onULTDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    group.CreateOrUpdatePlayerData({
        name     = GetUnitName(tag),
        tag      = tag,
        dmg      = data.dmg,
        dps      = data.dps,
        dmgType  = data.dmgType,
    })

    --updateLists()
end

function module:Activate()
    self.logger:Debug("activated ult module")

    local registerName = addon_name .. module.name

    local lgcs = LGCS.RegisterAddon(registerName, {"ULT"})
    if not lgcs then
        self.logger:Warn("Failed to register %s with LibGroupCombatStats.", registerName)
        return
    end

    lgcs:RegisterForEvent(EVENT_PLAYER_ULT_UPDATE, function(...) self:onULTDataReceived(...) end)
    lgcs:RegisterForEvent(EVENT_GROUP_ULT_UPDATE, function(...) self:onULTDataReceived(...) end)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) self:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) self:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, function(...) self:updateTest(...) end)

    addon.RegisterCallback(HR_EVENT_LOCKUI, function(...) self:lockUI(...) end)
    addon.RegisterCallback(HR_EVENT_UNLOCKUI, function(...) self:unlockUI(...) end)

    group.RegisterPlayersDataFields({
        ultValue = 0,
        ult1ID = 0,
        ult2ID = 0,
        ult1Cost = 0,
        ult2Cost = 0,
        ult1Percentage = 0,
        ult2Percentage = 0,
        lowestUltPercentage = 0,
        ultActivatedSetID = 0, -- TODO: remove later
        --hasSaxhleel = false,
        --hasMAorWM = false,
        --hasPillager = false,
    })
end

function module:lockUI()
    self.uiLocked = true
    --refreshVisibility()
    --hud.LockControls(damageListWindow)
end

function module:unlockUI()
    self.uiLocked = false
    --refreshVisibility()
    --hud.UnlockControls(damageListWindow)
end
