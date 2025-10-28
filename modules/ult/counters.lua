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

local HR_EVENT_PLAYERSDATA_UPDATED = addon.HR_EVENT_PLAYERSDATA_UPDATED
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED

function module:CreateHornCounter()
    local function updateFunc()
        local count = 0
        local ready = true
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            if util.IsUnitInPlayersRange(unitTag, 20) then
                count = count + 1
            elseif GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS then
                ready = false
            end
        end

        return count, ready
    end

    self.hornCounter = counterClass:New({
        name = "horn",
        texture = self.hornIcon,
        updateInterval = 100,
        svDefault = {
            accountWide = false,
            enabled = 0, -- 1=always, 2=only in combat, 0=off
            windowPosLeft = 400,
            windowPosTop = 200,
            scale = 1.0,
        },
        updateFunc = updateFunc,
    })

    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, function(playerData)
        if not playerData.isPlayer then return end

        if playerData.hasHorn or playerData.hasSaxhleel then
            self.hornCounter:SetActive(true)
        else
            self.hornCounter:SetActive(false)
        end
    end)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, function()
        if not IsUnitGrouped(localPlayer) then
            self.hornCounter:SetActive(false)
        end
    end)
end

function module:CreatePillagerCounter()
    local function updateFunc()
        local count = 0
        local ready = true
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            if util.IsUnitInPlayersRange(unitTag, 12) then
                count = count + 1
            elseif GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS then
                ready = false
            end
        end

        return count, ready
    end

    self.pillagerCounter = counterClass:New({
        name = "pillager",
        texture = self.pillagerIcon,
        updateInterval = 100,
        svDefault = {
            accountWide = false,
            enabled = 0, -- 1=always, 2=only in combat, 0=off
            windowPosLeft = 500,
            windowPosTop = 200,
            scale = 1.0,
        },
        updateFunc = updateFunc,
    })

    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, function(playerData)
        if not playerData.isPlayer then return end

        if playerData.hasPillager then
            self.pillagerCounter:SetActive(true)
        else
            self.pillagerCounter:SetActive(false)
        end
    end)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, function()
        if not IsUnitGrouped(localPlayer) then
            self.pillagerCounter:SetActive(false)
        end
    end)
end

function module:CreateSlayerCounter()
    local function updateFunc()
        local count = 0
        local ready = false
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            if util.IsUnitInPlayersRange(unitTag, 28) then
                count = count + 1
            end
            if count == 6 then
                return 6, true
            end
        end

        return count, ready
    end

    self.slayerCounter = counterClass:New({
        name = "slayer",
        texture = self.slayerIcon,
        updateInterval = 100,
        svDefault = {
            accountWide = false,
            enabled = 0, -- 1=always, 2=only in combat, 0=off
            windowPosLeft = 500,
            windowPosTop = 200,
            scale = 1.0,
        },
        updateFunc = updateFunc,
    })

    addon.RegisterCallback(HR_EVENT_PLAYERSDATA_UPDATED, function(playerData)
        if not playerData.isPlayer then return end

        if playerData.hasSlayer then
            self.slayerCounter:SetActive(true)
        else
            self.slayerCounter:SetActive(false)
        end
    end)
    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, function()
        if not IsUnitGrouped(localPlayer) then
            self.slayerCounter:SetActive(false)
        end
    end)
end