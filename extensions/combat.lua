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

    data = {
        dpstime = 0,
        hpstime = 0,
    },
}

local extension = internal.extensionClass:New(extensionDefinition)

function extension:Activate()
    self:Reset()
    LC:RegisterCallbackType(LIBCOMBAT_EVENT_FIGHTRECAP, function(...) self:FightRecapCallback(...) end, addon_name .. self.name)

    addon.RegisterCallback(HR_EVENT_COMBAT_START, function() self:Reset() end)
    --addon.RegisterCallback(HR_EVENT_COMBAT_END, function() self:Reset() end)
end

function extension:GetCombatTime()
    return zo_roundToNearest(zo_max(self.data.dpstime, self.data.hpstime), 0.1)
end
function extension:Reset()
    self.data.dpstime = 0
    self.data.hpstime = 0
end
function extension:FightRecapCallback(_, data)
    self.data.dpstime = data.dpstime
    self.data.hpstime = data.hpstime
end