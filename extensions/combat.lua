-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_extensions = addon.extensions
local internal_extensions = internal.extensions

local LC = LibCombat
local HR_EVENT_COMBAT_START = addon.HR_EVENT_COMBAT_START
--local HR_EVENT_COMBAT_END = addon.HR_EVENT_COMBAT_END

local extensionDefinition = {
    name = "combat",
    version = "1.0.0",
    svDefault = {},

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

local extension = internal.extensionClass:New(extensionDefinition)

function extension:Activate()
    self:Reset()
    LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, function(...) self:FightRecapCallback(...) end, addon_name .. self.name)

    addon.RegisterCallback(HR_EVENT_COMBAT_START, function() self:Reset() end)
    --addon.RegisterCallback(HR_EVENT_COMBAT_END, function() self:Reset() end)
end

function extension:Reset()
    self.data.dpstime = 0
    self.data.hpstime = 0
    self.data.groupDPSOut = 0
    self.data.damageOutTotalGroup = 0
    self.damageHistory = {
        {
            timeStamp = 0,
            damageDone = 0,
        },
    }
end
function extension:FightRecapCallback(_, data)
    self.data.dpstime = data.dpstime or 0
    self.data.hpstime = data.hpstime or 0
    self.data.groupDPSOut = data.groupDPSOut or 0
    self.data.damageOutTotalGroup = data.damageOutTotalGroup or 0

    -- save history
    table.insert(self.data.damageHistory, {
        timestamp = GetGameTimeMilliseconds(),
        damage = data.damageOutTotalGroup
    })
end

function extension:GetCombatTime()
    return zo_roundToNearest(zo_max(self.data.dpstime, self.data.hpstime), 0.1)
end
function extension:GetGroupDPSOut()
    return self.data.groupDPSOut
end
function extension:GetDamageOutTotalGroup()
    return self.data.damageOutTotalGroup
end
function extension:GetGroupDPSOverTime(seconds)
    local now = GetGameTimeMilliseconds()
    local cutoff = now - seconds * 1000
    local oldest, newest

    -- Finde ältesten und neuesten Wert im Zeitraum
    for i = #self.data.damageHistory, 1, -1 do
        local entry = self.data.damageHistory[i]
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
        return damageDiff / timeDiff
    end
    return 0
end