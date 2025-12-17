-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/events")

local CM = core.CM
local EM = GetEventManager()

local localPlayer = "player"
local inCombat = false

--[[ doc.lua begin ]]
local HR_EVENT_PLAYER_ACTIVATED = "HR_EVENT_PLAYER_ACTIVATED"
local HR_EVENT_GROUP_CHANGED = "HR_EVENT_GROUP_CHANGED"
local HR_EVENT_COMBAT_START = "HR_EVENT_COMBAT_START"
local HR_EVENT_COMBAT_END = "HR_EVENT_COMBAT_END"
local HR_EVENT_RETICLE_TARGET_CHANGED = "HR_EVENT_RETICLE_TARGET_CHANGED"
addon.HR_EVENT_PLAYER_ACTIVATED = HR_EVENT_PLAYER_ACTIVATED
addon.HR_EVENT_GROUP_CHANGED = HR_EVENT_GROUP_CHANGED
addon.HR_EVENT_COMBAT_START = HR_EVENT_COMBAT_START
addon.HR_EVENT_COMBAT_END = HR_EVENT_COMBAT_END
addon.HR_EVENT_RETICLE_TARGET_CHANGED = HR_EVENT_RETICLE_TARGET_CHANGED
--[[ doc.lua end ]]


--[[ doc.lua begin ]]
--- unregisters callbacks from events
--- @param eventName string the event name
--- @param callback function the callback function
--- @return void
function addon.UnregisterCallback(eventName, callback)
    CM:UnregisterCallback(eventName, callback)
    logger:Debug("UnregisterCallback: eventName=%s, callback=%s", eventName, tostring(callback))
end
--- registers callbacks to events
--- @param eventName string the event name
--- @param callback function the callback function
--- @return void
function addon.RegisterCallback(eventName, callback)
    assert(type(eventName) == "string", "eventName must be a string")
    assert(type(callback) == "function", "callback must be a function")

    -- only register events when they are actually used somewhere
    if eventName == HR_EVENT_RETICLE_TARGET_CHANGED then
        EM:UnregisterForEvent(addon_name, EVENT_RETICLE_TARGET_CHANGED)
        EM:RegisterForEvent(addon_name, EVENT_RETICLE_TARGET_CHANGED, function()
            CM:FireCallbacks(HR_EVENT_RETICLE_TARGET_CHANGED)
        end)
    end

    CM:RegisterCallback(eventName, callback) -- no need to unregister first as ZO_CallbackObject does that internally
    logger:Debug("RegisterCallback: eventName=%s, callback=%s", eventName, tostring(callback))
end

--- core events ---

--- Player combat state change event handler
--- @param _ any unused
--- @param c boolean true if in combat, false otherwise
--- @return void
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
-- group change event handler (with delay to avoid spam)
local UPDATE_GROUP_CHANGED_NAMESPACE = addon_name .. "_EVENT_GROUP_CHANGED"
local function onGroupChanged()
    EM:UnregisterForUpdate(UPDATE_GROUP_CHANGED_NAMESPACE)
    CM:FireCallbacks(HR_EVENT_GROUP_CHANGED)
end
local function onGroupChangedDelayed()
    EM:UnregisterForUpdate(UPDATE_GROUP_CHANGED_NAMESPACE)
    EM:RegisterForUpdate(UPDATE_GROUP_CHANGED_NAMESPACE, 100, onGroupChanged)
end
--- player activated event handler
--- @return void
local function onPlayerActivated()
    -- fire HR_EVENT_PLAYER_ACTIVATED
    CM:FireCallbacks(HR_EVENT_PLAYER_ACTIVATED)

    -- Player can be in combat after reloadui
    EM:UnregisterForEvent(addon_name, EVENT_PLAYER_COMBAT_STATE)
    EM:RegisterForEvent(addon_name, EVENT_PLAYER_COMBAT_STATE, onPlayerCombatState)
    onPlayerCombatState(nil, IsUnitInCombat(localPlayer))

    -- Group event handling (with delay to avoid spam)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_UPDATE)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED, onGroupChangedDelayed)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT, onGroupChangedDelayed)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_UPDATE, onGroupChangedDelayed)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, onGroupChangedDelayed)
    onGroupChangedDelayed()
end

--- Register core events
--- @return void
function core.RegisterCoreEvents()
    EM:UnregisterForEvent(addon_name, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(addon_name, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end
--[[ doc.lua end ]]