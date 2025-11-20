-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group

local module_name = "hideme"
local module = addon_modules[module_name]

local LGB = LibGroupBroadcast
local localPlayer = "player"

local EM = GetEventManager()

local protocolHideMe = {}
local MESSAGE_ID_HIDEME = 32

--- Register LGB protocols for HideMe module
--- @param handler LibGroupBroadcastHandler
--- @return void
function module:RegisterLGBProtocols(handler)
    local CreateFlagField = LGB.CreateFlagField
    local CreateNumericField = LGB.CreateNumericField
    local CreateArrayField = LGB.CreateArrayField
    local protocolOptions = {
        isRelevantInCombat = false
    }

    -- Each hideField must have a unique ID. That way the protocol does not break when new fields are added later and group members still have not updated yet.
    -- Its enough to send only the IDs of the fields that are supposed to be hidden. everything else will be considered visible.
    protocolHideMe = handler:DeclareProtocol(MESSAGE_ID_HIDEME, "Hide Me")
    protocolHideMe:AddField(CreateFlagField("syncRequest", {
        defaultValue = false,
    }))
    protocolHideMe:AddField(CreateArrayField(CreateNumericField("ids", {
        minValue = 1,
        maxValue = 15,
    }),{
        minLength = 0,
        maxLength = 15
    }))
    protocolHideMe:OnData(function(...) self:onHideMeMessageReceived(...) end)
    protocolHideMe:Finalize(protocolOptions)
end

local playerDataCache = {}
--- Handle received HideMe messages
--- @param unitTag string
--- @param data table
--- @return void
function module:onHideMeMessageReceived(unitTag, data)
    if data.syncRequest and not AreUnitsEqual(unitTag, localPlayer) then
        self.logger:Debug("Received HideMe sync request from %s, sending current preferences.", GetUnitName(unitTag))
        self:SendHideMeMessageDebounced()
    end
    self.logger:Debug("Received HideMe message from %s with IDs: %s", GetUnitName(unitTag), table.concat(data.ids, ", "))

    ZO_ClearTable(playerDataCache) -- we need to clear it here because the table is variable. Even tho we later set everything to false, it can be that the client has an older version than the sender and thus receiving additional data it cannot process
    playerDataCache.name = GetUnitName(unitTag)
    playerDataCache.tag = unitTag

    for _, hideId in pairs(self.hideIds) do
        playerDataCache[hideId.name] = false
    end

    for _, id in pairs(data.ids) do
        local hideOptionName = self.hideIds[id] and self.hideIds[id].name
        if hideOptionName then
            playerDataCache[hideOptionName] = true
        end
    end

    group.CreateOrUpdatePlayerData(playerDataCache)
end

local hideProtocolCache = {}
local hideProtocolDataCache = {}
--- Send HideMe message with current preferences
--- @param syncRequest boolean|nil whether this is a sync request response
--- @return void
function module:SendHideMeMessage(syncRequest)
    ZO_ClearTable(hideProtocolDataCache)
    for id, enabled in pairs(self.sv.preferences) do -- intentionally use pairs instead of ipairs to avoid sending empty IDs
        if enabled then
            table.insert(hideProtocolDataCache, id)
        end
    end
    self.logger:Debug("Sending HideMe message with IDs: %s", table.concat(hideProtocolDataCache, ", "))
    hideProtocolCache.syncRequest = syncRequest or false
    hideProtocolCache.ids = hideProtocolDataCache
    protocolHideMe:Send(hideProtocolCache)
end

--- Send HideMe message with current preferences, debounced to avoid spamming
--- @param syncRequest boolean|nil whether this is a sync request response
--- @return void
function module:SendHideMeMessageDebounced(syncRequest)
    EM:RegisterForUpdate(addon_name .. "_HidemeMessageDebounce", self.updateDebounceInterval, function()
        EM:UnregisterForUpdate(addon_name .. "_HidemeMessageDebounce")
        self:SendHideMeMessage(syncRequest)
    end)
end
