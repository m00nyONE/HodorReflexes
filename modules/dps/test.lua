-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

local group = core.group

local LGCS = LibGroupCombatStats

local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

local playerDataCache = {}
--- callback function that gets called on test start
--- @return void
function module:startTest()
    self.isTestRunning = true

    for name, _ in pairs(addon.playersData) do
        local dmg = zo_random(500, 1200)

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.dmg = dmg
        playerDataCache.dps = dmg * 0.15
        playerDataCache.dmgType = DAMAGE_BOSS

        group.CreateOrUpdatePlayerData(playerDataCache)
    end

    -- manually force updates on lists without the usual debounce to initialize them early during the test
    self.damageList:Update()
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
        local dmg = data.dmg + zo_random(-15, 15)
        if dmg > 1200 then dmg = 1200 end
        if dmg < 500 then dmg = 500 end

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.dmg = dmg
        playerDataCache.dps = dmg * 0.15
        playerDataCache.dmgType = DAMAGE_BOSS

        group.CreateOrUpdatePlayerData(playerDataCache)
    end
end