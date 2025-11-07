-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local LC = LibCombat
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK

local localPlayer = "player"

local CM = core.CM

local combat = {
    damageHistory = {
        {
            timestamp = 0,
            damage = 0,
        },
    },
    data = {
        dpstime = 0,
        hpstime = 0,
        groupDPSOut = 0,
        damageOutTotalGroup = 0,
    },
    logger = core.GetLogger("core/combat"),

    saveHistory = false, -- will be set to true if a function gets called that needs that feature. Until then, lets save some memory :-)
}
addon.combat = combat -- expose combat class as it can be useful for others too

--- initializes the combat class.
--- @return void
function core.InitializeCombat()
    combat:Reset()
    LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, function(...) combat:FightRecapCallback(...) end, addon_name .. "_Combat")

    addon.RegisterCallback(HR_EVENT_COMBAT_START, function() combat:Reset() end)
    --addon.RegisterCallback(HR_EVENT_COMBAT_END, function() combat:Reset() end)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, function(...) combat:startTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, function(...) combat:stopTest(...) end)
    addon.RegisterCallback(HR_EVENT_TEST_TICK, function(...) combat:updateTest(...) end)
end

--- resets the combat data.
--- @return void
function combat:Reset()
    self.data.dpstime = 0
    self.data.hpstime = 0

    self.data.groupDPSOut = 0
    self.data.damageOutTotalGroup = 0

    ZO_ClearTable(self.damageHistory)
    self.logger:Debug("Combat data reset")
end

--- For internal use only!
--- Fight recap callback to update combat data.
--- @param _ any unused
--- @param data table the fight recap data
function combat:FightRecapCallback(_, data)
    self.data.dpstime = data.dpstime or 0
    self.data.hpstime = data.hpstime or 0
    self.data.groupDPSOut = data.groupDPSOut or 0
    self.data.damageOutTotalGroup = data.damageOutTotalGroup or 0
    -- save history
    if self.saveHistory == false then return end
    self:SaveDamageToHistory(data.damageOutTotalGroup)
end

--- saves the current damage to the history.
--- @param damage number the current damage to save
--- @return void
function combat:SaveDamageToHistory(damage)
    table.insert(self.damageHistory, {
        timestamp = GetGameTimeMilliseconds(),
        damage = damage
    })
    self:CleanupOldHistory(60)
end

--- cleans up old entries from the damage history.
--- @param olderThanSeconds number
--- @return void
function combat:CleanupOldHistory(olderThanSeconds)
    local now = GetGameTimeMilliseconds()
    local cutoff = now - olderThanSeconds * 1000
    for i = #self.damageHistory, 1, -1 do
        if self.damageHistory[i].timestamp and self.damageHistory[i].timestamp < cutoff then
            table.remove(self.damageHistory, i)
        end
    end
end

--- gets the current combat time in seconds.
--- @return number the current combat time in seconds, rounded to nearest 0.1s
function combat:GetCombatTime()
    return zo_roundToNearest(zo_max(self.data.dpstime, self.data.hpstime), 0.1)
end

--- gets the current group DPS out.
--- @return number the current group DPS out.
function combat:GetGroupDPSOut()
    return self.data.groupDPSOut
end

--- gets the total damage done by the group in the current combat.
--- @return number the total damage done by the group in the current combat.
function combat:GetDamageOutTotalGroup()
    return self.data.damageOutTotalGroup
end

--- calculates the group DPS over a given time frame.
--- @param seconds number the time frame in seconds
--- @return number the calculated group DPS over the given time frame. If not enough data is available, returns the current group DPS out.
function combat:GetGroupDPSOverTime(seconds)
    self.saveHistory = true -- enable history saving as this function needs it

    if IsUnitInCombat(localPlayer) or self._testBeginTime ~= nil then -- we do not want the value to shrink after beeing out of combat
        self._lastCombatTime = GetGameTimeMilliseconds()
    end
    self._lastCombatTime = self._lastCombatTime or GetGameTimeMilliseconds() -- we sadly need this because the IsUnitInCombat check above will not be true if this function is called "outside of combat"  and no test is running even tho we are already in combat
    local cutoff = self._lastCombatTime - (seconds * 1000) -- convert to milliseconds
    local oldest, newest

    -- find oldest and newest entries within the time frame
    for i = #self.damageHistory, 1, -1 do
        local entry = self.damageHistory[i]
        if not newest and entry.timestamp <= self._lastCombatTime then
            newest = entry
        end
        if entry.timestamp <= cutoff then
            oldest = entry
            break
        end
    end

    -- calculate DPS
    if oldest and newest and newest.timestamp > oldest.timestamp then
        local damageDiff = newest.damage - oldest.damage
        local timeDiff = newest.timestamp - oldest.timestamp
        return zo_round(damageDiff / (timeDiff / 1000)) -- convert to seconds
    end
    return self:GetGroupDPSOut()
end

--- estimates the time to kill for a given unit based on current health and group DPS.
--- this is absolutely NOT accurate when not used on bosses or in situations where there are a lot of adds involved.
--- it also does not work well when the unit has invulnerability phases or healing.
--- @param unitTag string the unit tag of the target unit
--- @return number time to kill in seconds, rounded to nearest 0.1s. Returns 0 if group DPS is 0.
function combat:GetTimeToKill(unitTag)
    local current, max, _ = GetUnitPower(unitTag, POWERTYPE_HEALTH)
    local groupDPS = self:GetGroupDPSOverTime(15) -- use last 15 seconds for better accuracy
    if groupDPS > 0 then
        return zo_roundToNearest(current / groupDPS, 0.1)
    end
    return 0
end

--- test functions

--- @return void
function combat:startTest()
    self.logger:Debug("Starting combat test")
    self._testBeginTime = GetGameTimeMilliseconds()
    self:Reset()
    -- we have to fire the event a bit later than usual to let all other parts and modules prepare
    zo_callLater(function()
        CM:FireCallbacks(HR_EVENT_COMBAT_START)
    end, 100)

    -- initial calculation of group DPS and total damage from mock data
    for _, data in pairs(addon.playersData) do
        if not data.dps then return end
        self.data.groupDPSOut = self.data.groupDPSOut + (data.dps * 1000 or 0)
        self.data.damageOutTotalGroup = self.data.damageOutTotalGroup + (data.dps * 1000 * self.data.dpstime) or 0
    end

    -- save history -- here we do not check for saveHistory as we want to have that initial entry at the start. if this feature is not needed, then it's only one entry that gets deleted after the test anyways
    self:SaveDamageToHistory(self.data.damageOutTotalGroup)
end
--- @return void
function combat:stopTest()
    self.logger:Debug("Stopping combat test")
    self._testBeginTime = nil
    CM:FireCallbacks(HR_EVENT_COMBAT_END)
    self:Reset()
end
--- @return void
function combat:updateTest()
    self.data.dpstime = (GetGameTimeMilliseconds() - self._testBeginTime) / 1000

    self.data.groupDPSOut = 0
    self.data.damageOutTotalGroup = 0

    -- recalculate group DPS and total damage from mock data
    for _, data in pairs(addon.playersData) do
        if not data.dps then return end
        self.data.groupDPSOut = self.data.groupDPSOut + (data.dps * 1000 or 0)
        self.data.damageOutTotalGroup = self.data.damageOutTotalGroup + (data.dps * 1000 * self.data.dpstime) or 0
    end

    -- save history
    if self.saveHistory == false then return end
    self:SaveDamageToHistory(self.data.damageOutTotalGroup)
end