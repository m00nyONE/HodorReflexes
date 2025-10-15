-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local module_name = "dps"
local module = addon_modules[module_name]

local group = core.group

local LGCS = LibGroupCombatStats

local DAMAGE_UNKNOWN = LGCS.DAMAGE_UNKNOWN
local DAMAGE_TOTAL = LGCS.DAMAGE_TOTAL
local DAMAGE_BOSS = LGCS.DAMAGE_BOSS

--- callback function that gets called on test start
--- @return void
function module:startTest()
    self.isTestRunning = true

    for name, _ in pairs(addon.playersData) do
        local dmg = zo_random(500, 1200)

        group.CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            dmg = dmg,
            dps = dmg * 0.15,
            dmgType = DAMAGE_BOSS,
        })
    end
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

        group.CreateOrUpdatePlayerData({
            name = name, -- required
            tag = name, -- required
            dmg = dmg,
            dps = dmg * 0.15,
            dmgType = DAMAGE_BOSS,
        })
    end
end