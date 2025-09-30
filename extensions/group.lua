-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local extension = {
    name = "group",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version

addon[extension_name] = extension

local CM = addon.CM
local playersData = {}
extension.playersData = playersData

addon.HR_EVENT_TEST_STARTED = "HR_EVENT_TEST_STARTED"
addon.HR_EVENT_TEST_STOPPED = "HR_EVENT_TEST_STOPPED"
addon.HR_EVENT_PLAYERSDATA_CLEANED = "HR_EVENT_PLAYERSDATA_CLEANED"
addon.HR_EVENT_PLAYERSDATA_UPDATED = "HR_EVENT_PLAYERSDATA_UPDATED"

local anim = addon.anim
local util = addon.util
local isTestRunning = false
local localPlayer = "player"
local strformat = string.format
local EM = GetEventManager()

local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_TEST_STARTED = addon.HR_EVENT_TEST_STARTED
local HR_EVENT_TEST_STOPPED = addon.HR_EVENT_TEST_STOPPED
local HR_EVENT_TEST_TICK = addon.HR_EVENT_TEST_TICK
local HR_EVENT_PLAYERSDATA_CLEANED = addon.HR_EVENT_PLAYERSDATA_CLEAN
local HR_EVENT_PLAYERSDATA_UPDATED = addon.HR_EVENT_PLAYERSDATA_UPDATED

local playersDataDefaultFields = {
    --name = "",
    --userId = "",
    --classId = 0,
    --isPlayer = false,
    --tag = "",
}

function extension.RegisterPlayersDataFields(fields)
    for key, defaultValue in pairs(fields) do
        playersDataDefaultFields[key] = defaultValue
    end
end

-- requires at least data.name and data.tag
function extension.CreateOrUpdatePlayerData(data)
    if not data or not data.name or not data.tag then return end

    local tag = data.tag

    local characterName = data.name or GetUnitName(tag)
    local playerData = playersData[characterName]
    if not playerData then
        playerData = {
            name = characterName,
            userId = data.userId or GetUnitDisplayName(tag),
            classId = data.classId or GetUnitClassId(tag),
            isPlayer = data.isPlayer or AreUnitsEqual(tag, localPlayer),
        }
        for key, defaultValue in pairs(playersDataDefaultFields) do
            playerData[key] = defaultValue
        end
        playersData[characterName] = playerData
    end

    for key, value in pairs(data) do
        playerData[key] = value
    end

    playerData.tag = tag
    playerData.lastUpdate = GetGameTimeMilliseconds()

    CM:FireCallbacks(HR_EVENT_PLAYERSDATA_UPDATED, playerData)
end
local CreateOrUpdatePlayerData = extension.CreateOrUpdatePlayerData

local function cleanPlayersData(forceDelete)
    local _existingGroupCharacters = {}

    for i = 1, GetGroupSize() do
        local tag = GetGroupUnitTagByIndex(i)
        if IsUnitPlayer(tag) and IsUnitOnline(tag) then
            local characterName = GetUnitName(tag)
            _existingGroupCharacters[characterName] = true
            if playersData[characterName] then
                playersData[characterName].tag = tag
            end
        end
    end
    for characterName, data in pairs(playersData) do
        if not _existingGroupCharacters[characterName] or forceDelete then
            anim.UnregisterUserFromAllNamespaces(data.userId)
            playersData[characterName] = nil
        end
    end

    CM:FireCallbacks(HR_EVENT_PLAYERSDATA_CLEANED)
end

local function toggleTest(players)
    if isTestRunning then
        cleanPlayersData(true)
        isTestRunning = false
        CM:FireCallbacks(HR_EVENT_LOCKUI)
        CM:FireCallbacks(HR_EVENT_TEST_STOPPED)
        EM:UnregisterForUpdate(addon_name .. "_TestUpdate")
        d(strformat("|cFF0000%s|r", GetString(HR_TEST_STOPPED)))
        return
    end

    players = players or {
        '@WarfireX',
        '@LikoXie',
        '@andy.s',
        '@Alcast',
        '@NefasQS',
        '@Wheel5',
        '@PK44',
        '@LokiClermeil',
        '@m00nyONE',
        '@skinnycheeks',
        '@seadotarley',
        '@Solinur'
    }

    local function _getRandomPlayerData(name)
        return {
            tag = name,
            name = name,
            userId = name,
            classId = zo_random(1, GetNumClasses()),
            isPlayer = name == GetUnitDisplayName(localPlayer),
        }
    end

    for _, name in ipairs(players) do
        CreateOrUpdatePlayerData(_getRandomPlayerData(name))
    end

    isTestRunning = true
    CM:FireCallbacks(HR_EVENT_TEST_STARTED)
    CM:FireCallbacks(HR_EVENT_UNLOCKUI)
    EM:RegisterForUpdate(addon_name .. "_TestUpdate", 1000, function()
        CM:FireCallbacks(HR_EVENT_TEST_TICK)
    end)
    d(strformat("|c00FF00%s|r", GetString(HR_TEST_STARTED)))
end

local function onGroupChanged()
    if isTestRunning then
        cleanPlayersData(true)
        isTestRunning = false
        CM:FireCallbacks(HR_EVENT_TEST_STOPPED)
        CM:FireCallbacks(HR_EVENT_LOCKUI)
        return
    end

    cleanPlayersData(false)
end

addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)

SLASH_COMMANDS["/hodor.group"] = function(str)
    local players = zo_strmatch(str, "^test%s*(.*)")
    if players then
        if IsUnitGrouped(localPlayer) then
            d(strformat("|cFF0000%s|r", GetString(HR_TEST_LEAVE_GROUP)))
        else
            toggleTest(util.IsValidString(players) and {zo_strsplit(" ", players)})
        end
    end
end