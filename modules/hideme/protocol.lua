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

local protocolHideMe = {}
local MESSAGE_ID_HIDEME = 32

function module:RegisterLGBProtocols(handler)
    local CreateNumericField = LGB.CreateNumericField
    local CreateArrayField = LGB.CreateArrayField
    local protocolOptions = {
        isRelevantInCombat = false
    }

    protocolHideMe = handler:DeclareProtocol(MESSAGE_ID_HIDEME, "Hide Me")
    -- create array field. each hideField must have a unique ID. That way the protocol does not break when new fields are added later and group members still have not updated yet.
    -- its enough to send only the IDs of the fields that are supposed to be hidden. everything else will be considered visible.
    -- Example:
    -- protocolHideMe:AddField(CreateArrayField("hide", CreateNumericField("id", {
    --     minValue = 1,
    --     maxValue = 15,
    -- })))
    --protocolHideMe:AddField()
    protocolHideMe:OnData(function(...) self:onHideMeMessageReceived(...) end)
    protocolHideMe:Finalize(protocolOptions)
end

function module:onHideMeMessageReceived(unitTag, data)
    if AreUnitsEqual(unitTag, localPlayer) then return end -- don't receive own messages

    local hideDamage = false
    local hideHorn = false
    local hideColos = false
    local hideAtro = false
    local hideSaxhleel = false

    for _, id in ipairs(data.showHorn) do
        if id == 1 then hideDamage = true
        elseif id == 2 then hideHorn = true
        elseif id == 3 then hideColos = true
        elseif id == 4 then hideAtro = true
        elseif id == 5 then hideSaxhleel = true
    end


        module.logger:Debug("Received hide me message from %s: hide field ID %d", GetUnitName(unitTag), id)
    end

    group.CreateOrUpdatePlayerData({
        name     = GetUnitName(unitTag),
        tag      = unitTag,
        hideDamage = hideDamage,
        hideHorn = hideHorn,
        hideColos = hideColos,
        hideAtro = hideAtro,
        hideSaxhleel = hideSaxhleel,
    })

end

function module:SendHideMeMessage()
    protocolHideMe:Send({
        -- preferences data
    })
end
