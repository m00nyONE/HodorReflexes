-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = internal.group

local module_name = "hideme"
local module = addon_modules[module_name]

local LGB = LibGroupBroadcast
local localPlayer = "player"

local EM = GetEventManager()

local protocolHideMe = {}
local MESSAGE_ID_HIDEME = 32

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
    protocolHideMe:AddField(CreateArrayField("hideIds", CreateNumericField("id", {
        minValue = 1,
        maxValue = 15,
    })))
    protocolHideMe:OnData(function(...) self:onHideMeMessageReceived(...) end)
    protocolHideMe:Finalize(protocolOptions)
end

function module:onHideMeMessageReceived(unitTag, data)
    if AreUnitsEqual(unitTag, localPlayer) then return end -- don't receive own messages

    if data.syncRequest then
        self:SendHideMeMessageDebounced()
    end

    local playerData = {
        name     = GetUnitName(unitTag),
        tag      = unitTag,
    }

    for _, id in ipairs(data.hideIds) do
        local hideOptionName = self.hideIds[id.id] and self.hideIds[id.id].name
        if hideOptionName then
            playerData[hideOptionName] = true
        end
    end

    group.CreateOrUpdatePlayerData(playerData)
end

function module:SendHideMeMessage(syncRequest)
    local data = {}
    for id, enabled in pairs(self.sv.preferences) do -- intentionally use pairs instead of ipairs to avoid sending empty IDs
        if enabled then
            table.insert(data, {id = id})
        end
    end
    protocolHideMe:Send({
        syncRequest = syncRequest or false,
        hideIds = data
    })
end

function module:SendHideMeMessageDebounced(syncRequest)
    EM:RegisterForUpdate(addon_name .. "_HidemeMessageDebounce", self.updateDebounceInterval, function()
        EM:UnregisterForUpdate(addon_name .. "_HidemeMessageDebounce")
        self:SendHideMeMessage(syncRequest)
    end)
end
