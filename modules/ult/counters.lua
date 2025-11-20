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

local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN

--- Creates the horn counter
--- @return void
function module:CreateHornCounter()
    local effectRange = 20

    local function updateFunc()
        local count = 0
        local ready = true
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            if IsUnitOnline(unitTag) then
                if util.IsUnitInPlayersRange(unitTag, effectRange) then
                    count = count + 1
                elseif GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS then
                    ready = false
                end
            end
        end

        return count, ready
    end

    self.hornCounter = counterClass:New({
        name = "horn",
        texture = self.hornIcon,
        updateInterval = 100,
        svDefault = {
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
    addon.RegisterCallback(HR_EVENT_MAJOR_FORCE_BUFF_GAINED, function(_, durationMS)
        self.hornCounter:SetCooldown(durationMS)
    end)
end

--- Creates the pillager counter
--- @return void
function module:CreatePillagerCounter()
    local effectRange = 12

    local function updateFunc()
        local count = 0
        local ready = true
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            if IsUnitOnline(unitTag) then
                if util.IsUnitInPlayersRange(unitTag, effectRange) then
                    count = count + 1
                elseif GetGroupMemberSelectedRole(unitTag) == LFG_ROLE_DPS then
                    ready = false
                end
            end
        end

        return count, ready
    end

    self.pillagerCounter = counterClass:New({
        name = "pillager",
        texture = self.pillagerIcon,
        updateInterval = 100,
        svDefault = {
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
    addon.RegisterCallback(HR_EVENT_PILLAGER_BUFF_COOLDOWN, function(_, durationMS)
        self.pillagerCounter:SetCooldown(durationMS)
    end)
end

--- Creates the slayer counter
--- @return void
function module:CreateSlayerCounter()
    local effectRange = 28

    local function updateFunc()
        local unitsWithoutSlayer = {}
        local unitWithSlayer = nil
        local unitsAlreadyInOtherGroup = {}
        local overlap = 0
        local count = 0 -- not include ourselves. I know, looks weird but we need to be in the unitsWithoutSlayer table to check for overlap later

        local distancesToOtherSlayerHolder = {}
        local distancesToUs = {}

        -- pre calc units with and without slayer
        for i = 1, GetGroupSize() do
            local unitTag = GetGroupUnitTagByIndex(i)
            local playerData = addon.playersData[GetUnitName(unitTag)] or {}
            local hasSlayer = playerData.hasSlayer or false
            if hasSlayer and not AreUnitsEqual(unitTag, localPlayer) then -- we only include OTHER slayer holders.
                unitWithSlayer = unitTag -- we do not care if there are multiple slayer holders, just take the last one found. We inlcude ourselves later anyway. And if there are more than two in total, the group needs to probably rethink their strategy :D
            else
                table.insert(unitsWithoutSlayer, unitTag)
            end
        end

        -- calculate the distances to us and the potenial other slayer player.
        for _, unitTagWithoutSlayer in ipairs(unitsWithoutSlayer) do
            if unitWithSlayer then
                local distance = util.GetUnitDistanceToUnit(unitWithSlayer, unitTagWithoutSlayer)
                if distance and distance <= effectRange then -- only consider players within 28m of the other slayer holder
                    table.insert(distancesToOtherSlayerHolder, {unitTag = unitTagWithoutSlayer, distance = distance})
                end
            end
            local distance = util.GetPlayerDistanceToUnit(unitTagWithoutSlayer)
            if distance and distance <= effectRange then -- only consider players within 28m of us
                table.insert(distancesToUs, {unitTag = unitTagWithoutSlayer, distance = distance})
            end

        end
        -- sort the units by distance
        local sortFunc = function(a, b) return a.distance < b.distance end
        table.sort(distancesToOtherSlayerHolder, sortFunc)
        table.sort(distancesToUs, sortFunc)

        -- now we take the closest 5 players to the other slayer holder and put them in the "unitsAlreadyInOtherGroup" table. We only do this if unitWithSlayer exists
        for i = 1, math.min(5, #distancesToOtherSlayerHolder) do
            local unitTag = distancesToOtherSlayerHolder[i].unitTag
            unitsAlreadyInOtherGroup[unitTag] = true
        end
        -- now we calculate the ranges for ourselves. note: we check the closest 6 players to us, because we are also in the unitsWithoutSlayer table. If we encounter someone who is already in the other slayer stack, we increase the overlap by 1. Otherwise we increase the count by 1.
        for i = 1, math.min(6, #distancesToUs) do
            local unitTag = distancesToUs[i].unitTag
            if unitsAlreadyInOtherGroup[unitTag] then
                overlap = overlap + 1
            else
                count = count + 1
            end
        end

        return count, overlap == 0
    end

    self.slayerCounter = counterClass:New({
        name = "slayer",
        texture = self.slayerIcon,
        updateInterval = 100,
        svDefault = {
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