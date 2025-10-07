-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local group = core.group
local isTestRunning = false
local localPlayer = "player"
local LGCS = LibGroupCombatStats
local EVENT_PLAYER_SKILLLINES_UPDATE = LGCS.EVENT_PLAYER_SKILLLINES_UPDATE
local EVENT_GROUP_SKILLLINES_UPDATE = LGCS.EVENT_GROUP_SKILLLINES_UPDATE
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED

local moduleDefinition = {
    name = "skilllines",
    friendlyName = GetString(HR_MODULES_SKILLLINES_FRIENDLYNAME),
    description = GetString(HR_MODULES_SKILLLINES_DESCRIPTION),
    version = "0.9.0",
    priority = 10,
    enabled = false,
    svDefault = {
        accountWide = true,
    },
}

local module = internal.moduleClass:New(moduleDefinition)

local function onSkillLinesDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    group.CreateOrUpdatePlayerData({
        name = GetUnitName(tag),
        tag = tag,
        skillLines = {
            first = data.first or 0,
            second = data.second or 0,
            third = data.third or 0,
        }
    })

end

local function startTest()
    isTestRunning = true

    for name, _ in pairs(addon.playersData) do
        group.CreateOrUpdatePlayerData({
            name = name,
            tag = name,
            skillLines = {
                first = 22,
                second = 22,
                third = 22,
            }
        })
    end
end
local function stopTest()
    isTestRunning = false
end

function module:Activate()
    self.logger:Debug("activated skilllines module")

    local registerName = addon_name .. module.name

    local lgcs = LGCS.RegisterAddon(registerName, {"SKILLLINES"})
    if not lgcs then
        self.logger:Warn("Failed to register %s with LibGroupCombatStats.", registerName)
        return
    end

    lgcs:RegisterForEvent(EVENT_PLAYER_SKILLLINES_UPDATE, onSkillLinesDataReceived)
    lgcs:RegisterForEvent(EVENT_GROUP_SKILLLINES_UPDATE, onSkillLinesDataReceived)

    addon.RegisterCallback(HR_EVENT_TEST_STARTED, startTest)
    addon.RegisterCallback(HR_EVENT_TEST_STOPPED, stopTest)

    group.RegisterPlayersDataFields({
        skillLines = {
            first = 0,
            second = 0,
            third = 0,
        }
    })
end
