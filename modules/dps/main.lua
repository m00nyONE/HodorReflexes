-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group
local LGCS = LibGroupCombatStats

local EVENT_PLAYER_DPS_UPDATE = LGCS.EVENT_PLAYER_DPS_UPDATE
local EVENT_GROUP_DPS_UPDATE = LGCS.EVENT_GROUP_DPS_UPDATE

local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN

local moduleDefinition = {
    name = "dps",
    friendlyName = GetString(HR_MODULES_DPS_FRIENDLYNAME),
    description = GetString(HR_MODULES_DPS_DESCRIPTION),
    version = "1.0.0",
    priority = 2,
    enabled = false,
    svDefault = {
        accountWide = true,
    },

    isTestRunning = false,

    damageList = nil,
}

local module = internal.moduleClass:New(moduleDefinition)

--- handle DPS data received from LGCS
--- @param tag string
--- @param data table
--- @return void
function module:onDPSDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    group.CreateOrUpdatePlayerData({
        name     = GetUnitName(tag),
        tag      = tag,
        dmg      = data.dmg,
        dps      = data.dps,
        dmgType  = data.dmgType,
    })
end

--- module activation function
--- @return void
function module:Activate()
    self.logger:Debug("activated dps module")

    local registerName = addon_name .. module.name

    local lgcs = LGCS.RegisterAddon(registerName, {"DPS"})
    if not lgcs then
        self.logger:Warn("Failed to register %s with LibGroupCombatStats.", registerName)
        return
    end

    lgcs:RegisterForEvent(EVENT_PLAYER_DPS_UPDATE, function(...) self:onDPSDataReceived(...) end)
    lgcs:RegisterForEvent(EVENT_GROUP_DPS_UPDATE, function(...) self:onDPSDataReceived(...) end)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) self:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) self:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, function(...) self:updateTest(...) end)

    group.RegisterPlayersDataFields({
        dmg = 0,
        dps = 0,
        dmgType = DAMAGE_UNKNOWN,
    })

    self:RunOnce("CreateLists")
end

--- create scrollLists for the module
function module:CreateLists()
    module:RunOnce("CreateDamageList")
end

