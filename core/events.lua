-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local CM = core.CM
local EM = GetEventManager()

local localPlayer = "player"
local inCombat = false

--[[ doc.lua begin ]]
local HR_EVENT_GROUP_CHANGED = "HR_EVENT_GROUP_CHANGED"
local HR_EVENT_COMBAT_START = "HR_EVENT_COMBAT_START"
local HR_EVENT_COMBAT_END = "HR_EVENT_COMBAT_END"
addon.HR_EVENT_GROUP_CHANGED = HR_EVENT_GROUP_CHANGED
addon.HR_EVENT_COMBAT_START = HR_EVENT_COMBAT_START
addon.HR_EVENT_COMBAT_END = HR_EVENT_COMBAT_END
--[[ doc.lua end ]]


local function onGroupChanged()
    CM:FireCallbacks(HR_EVENT_GROUP_CHANGED)
end
local function onPlayerCombatState(_, c)
    if inCombat ~= c then
        if c then
            inCombat = true
            CM:FireCallbacks(HR_EVENT_COMBAT_START)
        else
            -- When the 2nd parameter is false, then it's not confirmed that the combat has ended.
            CM:FireCallbacks(HR_EVENT_COMBAT_END, false)
            -- A confirmed event is fired after 3 seconds.
            zo_callLater(function()
                if not IsUnitInCombat(localPlayer) then
                    inCombat = false
                    CM:FireCallbacks(HR_EVENT_COMBAT_END, true)
                end
            end, 3000)
        end
    end
end

--[[ doc.lua begin ]]
function addon.UnregisterCallback(eventName, callback)
    CM:UnregisterCallback(eventName, callback)
end
function addon.RegisterCallback(eventName, callback)
    assert(type(eventName) == "string", "eventName must be a string")
    assert(type(callback) == "function", "callback must be a function")

    if eventName == HR_EVENT_GROUP_CHANGED then
        EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED)
        EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT)
        EM:UnregisterForEvent(addon_name, EVENT_GROUP_UPDATE)
        EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS)
        EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED, onGroupChanged)
        EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT, onGroupChanged)
        EM:RegisterForEvent(addon_name, EVENT_GROUP_UPDATE, onGroupChanged)
        EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, onGroupChanged)
    end

    logger:Debug("RegisterCallback: eventName=%s, callback=%s", eventName, tostring(callback))
    CM:RegisterCallback(eventName, callback)
end
--[[ doc.lua end ]]