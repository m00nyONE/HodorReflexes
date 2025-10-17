-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "ult"
local module = addon_modules[module_name]

local group = core.group
local CM = core.CM

local HR_EVENT_MAJOR_FORCE_BUFF_GAINED = addon.HR_EVENT_MAJOR_FORCE_BUFF_GAINED
local HR_EVENT_MAJOR_BERSERK_BUFF_GAINED = addon.HR_EVENT_MAJOR_BERSERK_BUFF_GAINED
local HR_EVENT_MAJOR_SLAYER_BUFF_GAINED = addon.HR_EVENT_MAJOR_SLAYER_BUFF_GAINED
local HR_EVENT_PILLAGER_BUFF_GAINED = addon.HR_EVENT_PILLAGER_BUFF_GAINED
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_ATRO_CAST_STARTED = addon.HR_EVENT_ATRO_CAST_STARTED

local localPlayer = "player"


--- @type table<number> a pool of all ultimates in the game
local ultPool
--- generate a pool of all ultimates in the game
--- @return void
local function genUltPool()
    ultPool = {}
    for skillType = 1, GetNumSkillTypes() do
        for skillLineIndex = 1, GetNumSkillLines(skillType) do
            for skillIndex = 1, GetNumSkillAbilities(skillType, skillLineIndex) do
                if IsSkillAbilityUltimate(skillType, skillLineIndex, skillIndex) then
                    local _tempIds = {} -- create temporary table for all sill Ids of each morph
                    for morph = 0, 2 do -- there is only 1 base rank and 2 morphs
                        local abilityId, _ = GetSpecificSkillAbilityInfo(skillType, skillLineIndex, skillIndex, morph, 0)
                        table.insert(_tempIds, abilityId)
                        if abilityId == 0 then _tempIds = {} end -- if the ability Id is 0, clear all previously collected Ids from the temporary table because there is no ultimate without 2 morphs
                    end
                    -- iterate over temporary Id table and write it to our final destination
                    for _, _abilityId in ipairs(_tempIds) do
                        table.insert(ultPool, _abilityId)
                    end
                end
            end
        end
    end
end

--- callback function that gets called on test start
--- @return void
function module:startTest()
    self.isTestRunning = true


    if not ultPool then genUltPool() end

    for name, data in pairs(addon.playersData) do
        local ultValue = zo_random(1, 500)
        local ult1ID = ultPool[zo_random(1, #ultPool)]
        local ult2ID = ultPool[zo_random(1, #ultPool)]
        if data.classId == 5 then
            ult1ID = 122395
            ult2ID = 40223
        end
        if data.classId == 2 then
            ult1ID = 23492
        end
        local ult1Cost = GetAbilityCost(ult2ID)
        local ult2Cost = GetAbilityCost(ult2ID)
        local ult1Percentage = self:getUltPercentage(ultValue, ult1Cost)
        local ult2Percentage = self:getUltPercentage(ultValue, ult2Cost)

        local ultActivatedSetID = zo_random(0, 5)

        local mockData = {
            ult1ID = ult1ID,
            ult2ID = ult2ID,
            ultActivatedSetID = ultActivatedSetID,
        }

        group.CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            ultValue = ultValue,
            ult1ID = ult1ID,
            ult2ID = ult2ID,
            ult1Cost = ult1Cost,
            ult2Cost = ult2Cost,
            ult1Percentage = ult1Percentage,
            ult2Percentage = ult2Percentage,
            lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage),
            -- special ults
            hasHorn = self:hasUnitHorn(mockData),
            hasColos = self:hasUnitColos(mockData),
            hasAtro = self:hasUnitAtro(mockData),
            hasBarrier = self:hasUnitBarrier(mockData),
            hasCryptCannon = self:hasUnitCryptCannon(mockData),
            -- ult activated sets
            hasSaxhleel = self:hasUnitSaxhleel(mockData),
            hasMAorWM = self:hasUnitMAorWM(mockData),
            hasPillager = self:hasUnitPillager(mockData),
            ultActivatedSetID = ultActivatedSetID,
        })
    end

    -- manually force updates on lists without the usual debounce to initialize them early during the test
    self.hornList:Update()
    self.colosList:Update()
    self.atroList:Update()
    self.miscList:Update()

    -- fire some buff/debuff events for testing purposes
    CM:FireCallbacks(HR_EVENT_HORN_BUFF_GAINED, localPlayer, 30 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_FORCE_BUFF_GAINED, localPlayer, 15 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED, localPlayer, 17 * 1000)
    CM:FireCallbacks(HR_EVENT_ATRO_CAST_STARTED, localPlayer, 15 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_BERSERK_BUFF_GAINED, localPlayer, 10 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_SLAYER_BUFF_GAINED, localPlayer, 50 * 1000)
    CM:FireCallbacks(HR_EVENT_PILLAGER_BUFF_GAINED, localPlayer, 10 * 1000) -- no need to fire HR_EVENT_PILLAGER_BUFF_COOLDOWN as this is done automatically when the BUFF_GAINED event is fired
end
--- callback function that gets called on test stop
--- @return void
function module:stopTest()
    self.isTestRunning = false
end
--- callback function that gets called on test tick
--- @return void
function module:updateTest()
    if not self.isTestRunning then return end

    for name, data in pairs(addon.playersData) do
        local ultValue = data.ultValue + zo_random(2, 5)
        if ultValue > 500 then ultValue = 0 end
        local ult1Percentage = self:getUltPercentage(ultValue, data.ult1Cost)
        local ult2Percentage = self:getUltPercentage(ultValue, data.ult2Cost)

        group.CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            ultValue = ultValue,
            ult1Percentage = ult1Percentage,
            ult2Percentage = ult2Percentage,
            lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage),
        })
    end
end