-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local LC = LibCombat
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK


local combat = {
    damageHistory = {
        {
            timeStamp = 0,
            damageDone = 0,
        },
    },
    data = {
        dpstime = 0,
        hpstime = 0,
        groupDPSOut = 0,
        damageOutTotalGroup = 0,
    },
}
core.combat = combat

function core.InitializeCombat()
    combat:Reset()
    LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, function(...) combat:FightRecapCallback(...) end, addon_name .. "_Combat")

    addon.RegisterCallback(HR_EVENT_COMBAT_START, function() combat:Reset() end)
    addon.RegisterCallback(HR_EVENT_COMBAT_END, function() self:Reset() end)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) combat:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) combat:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, function(...) combat:updateTest(...) end)
end

function combat:Reset()
    self.data.dpstime = 0
    self.data.hpstime = 0
    self.data.groupDPSOut = 0
    self.data.damageOutTotalGroup = 0
    self.damageHistory = {}
end
function combat:FightRecapCallback(_, data)
    self.data.dpstime = data.dpstime or 0
    self.data.hpstime = data.hpstime or 0
    self.data.groupDPSOut = data.groupDPSOut or 0
    self.data.damageOutTotalGroup = data.damageOutTotalGroup or 0
    -- save history
    table.insert(self.damageHistory, {
        timestamp = GetGameTimeMilliseconds(),
        damage = data.damageOutTotalGroup
    })
end

function combat:GetCombatTime()
    return zo_roundToNearest(zo_max(self.data.dpstime, self.data.hpstime), 0.1)
end
function combat:GetGroupDPSOut()
    return self.data.groupDPSOut
end
function combat:GetDamageOutTotalGroup()
    return self.data.damageOutTotalGroup
end
function combat:GetGroupDPSOverTime(seconds)
    local now = GetGameTimeMilliseconds()
    local cutoff = now - (seconds * 1000) -- convert to milliseconds
    local oldest, newest

    -- find oldest and newest entries within the time frame
    for i = #self.damageHistory, 1, -1 do
        local entry = self.damageHistory[i]
        if not newest and entry.timestamp <= now then
            newest = entry
        end
        if entry.timestamp <= cutoff then
            oldest = entry
            break
        end
    end

    if oldest and newest and newest.timestamp > oldest.timestamp then
        local damageDiff = newest.damage - oldest.damage
        local timeDiff = newest.timestamp - oldest.timestamp
        return zo_round(damageDiff / (timeDiff / 1000)) -- convert to seconds
    end
    return self:GetGroupDPSOut()
end
function combat:GetTimeToKill(unitTag)
    local current, max, _ = GetUnitPower(unitTag, POWERTYPE_HEALTH)
    local groupDPS = self:GetGroupDPSOut()
    if groupDPS > 0 then
        return zo_roundToNearest(current / groupDPS, 0.1)
    end
    return 0
end

--- test functions

function combat:startTest()
    self.testBeginTime = GetGameTimeMilliseconds()
    self:Reset()

    for _, data in pairs(addon.playerData) do
        self.groupDPSOut = self.groupDPSOut + (data.dps or 0)
        self.damageOutTotalGroup = self.damageOutTotalGroup + (data.dmg or 0)
    end
end
function combat:stopTest()
    self.testBeginTime = nil
    self:Reset()
end
function combat:updateTest()
    self.dpstime = (GetGameTimeMilliseconds() - self.testBeginTime) / 1000

    for _, data in pairs(addon.playerData) do
        self.groupDPSOut = self.groupDPSOut + (data.dps or 0)
        self.damageOutTotalGroup = self.damageOutTotalGroup + (data.dmg or 0)
    end
    table.insert(self.damageHistory, {
        timestamp = GetGameTimeMilliseconds(),
        damage = self.damageOutTotalGroup
    })
end