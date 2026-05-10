-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "hps"
local module = addon_modules[module_name]

local group = core.group

local playerDataCache = {}
--- callback function that gets called on test start
--- @return void
function module:startTest()
    self.isTestRunning = true

    for name, _ in pairs(addon.playersData) do
        local hps = zo_random(300, 600)

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.hps = hps
        playerDataCache.overheal = hps * 0.15

        group.CreateOrUpdatePlayerData(playerDataCache)
    end

    -- manually force updates on lists without the usual debounce to initialize them early during the test
    self.hpsList:Update()
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
        local hps = data.hps + zo_random(-15, 15)
        if hps > 600 then hps = 600 end
        if hps < 300 then hps = 300 end

        playerDataCache.name = name -- required
        playerDataCache.tag = name -- required
        playerDataCache.hps = hps
        playerDataCache.overheal = hps * 0.15

        group.CreateOrUpdatePlayerData(playerDataCache)
    end
end