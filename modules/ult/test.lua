-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
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
local HR_EVENT_PILLAGER_BUFF_COOLDOWN = addon.HR_EVENT_PILLAGER_BUFF_COOLDOWN
local HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED = addon.HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED
local HR_EVENT_HORN_BUFF_GAINED = addon.HR_EVENT_HORN_BUFF_GAINED
local HR_EVENT_ATRO_CAST_STARTED = addon.HR_EVENT_ATRO_CAST_STARTED

local localPlayer = "player"


--- @type table<number> a pool of all ultimates in the game
local ultPool
--- generate a pool of all ultimates in the game except for special ultimates for testing purposes
--- @return void
function module:genUltPoolForTest()
    local ignoredSpecialUlts = {}
    for _, id in ipairs(self.hornAbilityIds) do table.insert(ignoredSpecialUlts, id) end
    for _, id in ipairs(self.colosAbilityIds) do table.insert(ignoredSpecialUlts, id) end
    for _, id in ipairs(self.atroAbilityIds) do table.insert(ignoredSpecialUlts, id) end
    for _, id in ipairs(self.barrierAbilityIds) do table.insert(ignoredSpecialUlts, id) end
    local function isIgnoredSpecialUlt(abilityId)
        for _, id in ipairs(ignoredSpecialUlts) do
            if abilityId == id then return true end
        end
        return false
    end

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
                        if not isIgnoredSpecialUlt(_abilityId) then
                            -- only add non-special ultimates to the pool. Special ultimates are handled separately and are assigned manually during the test
                            table.insert(ultPool, _abilityId)
                        end
                    end
                end
            end
        end
    end
end

local playerDataCache = {}
--- callback function that gets called on test start
--- @return void
function module:startTest()
    self.isTestRunning = true


    if not ultPool then self:genUltPoolForTest() end

    local limits = {
        horn = 1,
        saxhleel = 1,
        colos = 2,
        atro = 2,
        slayer = 2,
        pillager = 1,
        cryptCannon = 1,
    }


    for name, _ in pairs(addon.playersData) do
        local ultValue = zo_random(1, 500)
        local ult1ID = ultPool[zo_random(1, #ultPool)]
        local ult2ID = ultPool[zo_random(1, #ultPool)]
        local ultActivatedSetID = 0

        if limits.horn > 0 then
            ult1ID = self.hornAbilityIds[zo_random(1, #self.hornAbilityIds)]
            limits.horn = limits.horn - 1
        elseif limits.saxhleel > 0 then
            ultActivatedSetID = 1 -- saxhleel
            limits.saxhleel = limits.saxhleel - 1
        elseif limits.colos > 0 then
            ult1ID = self.colosAbilityIds[zo_random(1, #self.colosAbilityIds)]
            limits.colos = limits.colos - 1
        elseif limits.atro > 0 then
            ult1ID = self.atroAbilityIds[zo_random(1, #self.atroAbilityIds)]
            limits.atro = limits.atro - 1
        elseif limits.cryptCannon > 0 then
            ult1ID = self.cryptCannonAbilityIds[zo_random(1, #self.cryptCannonAbilityIds)]
            ult2ID = self.cryptCannonAbilityIds[zo_random(1, #self.cryptCannonAbilityIds)]
            limits.cryptCannon = limits.cryptCannon - 1
        elseif limits.pillager > 0 then -- tests both pillager & barrier
            ult1ID = self.barrierAbilityIds[zo_random(1, #self.barrierAbilityIds)]
            ultActivatedSetID = 2 -- pillager
            limits.pillager = limits.pillager - 1
        elseif limits.slayer > 0 then
            ultActivatedSetID = zo_random(4, 5) -- MA or WM
            limits.slayer = limits.slayer - 1
        end

        local ult1Cost = GetAbilityCost(ult2ID)
        local ult2Cost = GetAbilityCost(ult2ID)
        local ult1Percentage = self:getUltPercentage(ultValue, ult1Cost)
        local ult2Percentage = self:getUltPercentage(ultValue, ult2Cost)

        local mockData = {
            ult1ID = ult1ID,
            ult2ID = ult2ID,
            ultActivatedSetID = ultActivatedSetID,
        }

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.ultValue = ultValue
        playerDataCache.ult1ID = ult1ID
        playerDataCache.ult2ID = ult2ID
        playerDataCache.ult1Cost = ult1Cost
        playerDataCache.ult2Cost = ult2Cost
        playerDataCache.ult1Percentage = ult1Percentage
        playerDataCache.ult2Percentage = ult2Percentage
        playerDataCache.lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage)
        -- special ults
        playerDataCache.hasHorn = self:hasUnitHorn(mockData)
        playerDataCache.hasColos = self:hasUnitColos(mockData)
        playerDataCache.hasAtro = self:hasUnitAtro(mockData)
        playerDataCache.hasBarrier = self:hasUnitBarrier(mockData)
        playerDataCache.hasCryptCannon = self:hasUnitCryptCannon(mockData)
        -- ult activated sets
        playerDataCache.hasSaxhleel = self:hasUnitSaxhleel(mockData)
        playerDataCache.hasSlayer = self:hasUnitSlayer(mockData)
        playerDataCache.hasPillager = self:hasUnitPillager(mockData)
        playerDataCache.ultActivatedSetID = ultActivatedSetID

        group.CreateOrUpdatePlayerData(playerDataCache)

        -- cleanup
        mockData = nil
    end

    -- cleanup
    limits = nil

    -- manually force updates on lists without the usual debounce to initialize them early during the test
    self.hornList:Update()
    self.hornList:ResizeList()
    self.colosList:Update()
    self.colosList:ResizeList()
    self.atroList:Update()
    self.atroList:ResizeList()
    self.miscList:Update()
    self.miscList:ResizeList()
    self.compactList:Update()
    self.compactList:ResizeList()

    -- fire some buff/debuff events for testing purposes
    CM:FireCallbacks(HR_EVENT_HORN_BUFF_GAINED, localPlayer, 30 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_FORCE_BUFF_GAINED, localPlayer, 15 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_VULNERABILITY_DEBUFF_GAINED, localPlayer, 17 * 1000)
    CM:FireCallbacks(HR_EVENT_ATRO_CAST_STARTED, localPlayer, 15 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_BERSERK_BUFF_GAINED, localPlayer, 10 * 1000)
    CM:FireCallbacks(HR_EVENT_MAJOR_SLAYER_BUFF_GAINED, localPlayer, 50 * 1000)
    CM:FireCallbacks(HR_EVENT_PILLAGER_BUFF_GAINED, localPlayer, 10 * 1000)
    CM:FireCallbacks(HR_EVENT_PILLAGER_BUFF_COOLDOWN, localPlayer, 45 * 1000)
end
--- callback function that gets called on test stop
--- @return void
function module:stopTest()
    self.isTestRunning = false
    self.pillagerCooldownEndTime = 0
end
--- callback function that gets called on test tick
--- @return void
function module:updateTest()
    if not self.isTestRunning then return end
    ZO_ClearTable(playerDataCache) -- we have to clear the cache because it stil contains data from when the test started.

    for name, data in pairs(addon.playersData) do
        local ultValue = data.ultValue + zo_random(2, 5)
        if ultValue > 500 then ultValue = 0 end
        local ult1Percentage = self:getUltPercentage(ultValue, data.ult1Cost)
        local ult2Percentage = self:getUltPercentage(ultValue, data.ult2Cost)

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.ultValue = ultValue
        playerDataCache.ult1Percentage = ult1Percentage
        playerDataCache.ult2Percentage = ult2Percentage
        playerDataCache.lowestUltPercentage = zo_min(ult1Percentage, ult2Percentage)

        group.CreateOrUpdatePlayerData(playerDataCache)
    end
end