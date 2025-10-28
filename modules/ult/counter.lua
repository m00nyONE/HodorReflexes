-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local addon_extensions = addon.extensions
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local counterClass = internal.counterClass
local util = addon.util

local localPlayer = "player"

function module:CreateHornCounter()
    local def = {
        name = "horn",
        texture = "esoui/art/icons/ability_ava_003_a.dds",
        distance = 20,
        updateInterval = 100,
        svDefault = {
            accountWide = false,
            enabled = 1, -- 1=always, 2=only in combat, 0=off
            windowPosLeft = 400,
            windowPosTop = 200,
            scale = 1.0,
        },
        enableConditionFunc = function(...) self:HornCounterEnableCondition(...)  end,
        readyConditionFunc = function(...) return self:HornCounterReadyCondition(...) end,
    }
    self.hornCounter = counterClass:New(def)
end

function module:HornCounterEnableCondition()
    local playerData = addon.playersData[GetUnitName(localPlayer)]
    if playerData and (playerData.hasHorn or playerData.hasPillager) then
        return true
    end

    return false
end

function module:HornCounterReadyCondition(count, distance)
    for i = 1, GetGroupSize() do
        local unitTag = GetGroupUnitTagByIndex(i)
        if not util.IsUnitInPlayersRange(unitTag, distance) then
            if GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS then return false end
        end
    end

    return true
end