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

local localPlayer = "player"

local EVENT_PLAYER_DPS_UPDATE = LGCS.EVENT_PLAYER_DPS_UPDATE
local EVENT_GROUP_DPS_UPDATE = LGCS.EVENT_GROUP_DPS_UPDATE

local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local moduleDefinition = {
    name = "dps",
    friendlyName = GetString(HR_MODULES_DPS_FRIENDLYNAME),
    description = GetString(HR_MODULES_DPS_DESCRIPTION),
    version = "1.0.0",
    priority = 2,
    enabled = false,
    svDefault = {
        accountWide = true,
        disableInPvP = true,

        damageListHeaderOpacity = 0.8,
        damageListRowEvenOpacity = 0.65,
        damageListRowOddOpacity = 0.45,
        damageListPlayerHighlightColor = {0, 1, 0, 0.36}, -- green

        colorDamageTotal = "faffb2", -- light yellow
        colorDamageBoss = "b2ffb2", -- light green
    },
    --svDefaultDamageList = {
    --    damageListEnabled = 0, -- 0=off, 1=always, 2=out of combat, 3=non bossfights
    --    damageListWidth = 227,
    --    damageListPosLeft = 0,
    --    damageListPosTop = 50,
    --},

    isTestRunning = false,

    --damageList = internal.ListClass:New("dps"),
}

local module = internal.moduleClass:New(moduleDefinition)

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
end
