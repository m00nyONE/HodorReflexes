-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.logger.main

local util = core.util
local CM = core.CM
local EM = GetEventManager()
local isTestRunning = false
local localPlayer = "player"
local group = {}
core.group = group

local playersData = {}
addon.playersData = playersData
--[[ doc.lua begin ]]
local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED
local HR_EVENT_LOCKUI = addon.HR_EVENT_LOCKUI
local HR_EVENT_UNLOCKUI = addon.HR_EVENT_UNLOCKUI

local HR_EVENT_TEST_STARTED = "HR_EVENT_TEST_STARTED"
local HR_EVENT_TEST_STOPPED = "HR_EVENT_TEST_STOPPED"
local HR_EVENT_PLAYERSDATA_CLEANED = "HR_EVENT_PLAYERSDATA_CLEANED"
local HR_EVENT_PLAYERSDATA_UPDATED = "HR_EVENT_PLAYERSDATA_UPDATED"
local HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED = "HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED"
local HR_EVENT_TEST_TICK = "HR_EVENT_TEST_TICK"
addon.HR_EVENT_TEST_STARTED = HR_EVENT_TEST_STARTED
addon.HR_EVENT_TEST_STOPPED = HR_EVENT_TEST_STOPPED
addon.HR_EVENT_PLAYERSDATA_CLEANED = HR_EVENT_PLAYERSDATA_CLEANED
addon.HR_EVENT_PLAYERSDATA_UPDATED = HR_EVENT_PLAYERSDATA_UPDATED
addon.HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED = HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED
addon.HR_EVENT_TEST_TICK = HR_EVENT_TEST_TICK
--[[ doc.lua end ]]

local defaultPlayers = {
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

local playersDataDefaultFields = {
    --name = "",
    --userId = "",
    --classId = 0,
    --isPlayer = false,
    --tag = "",
}

function group.RegisterPlayersDataFields(fields)
    for key, defaultValue in pairs(fields) do
        playersDataDefaultFields[key] = defaultValue
    end
end

-- requires at least data.name and data.tag
function group.CreateOrUpdatePlayerData(data)
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
            logger:Debug("cleaning player data for '%s'", characterName)
            CM:FireCallbacks(HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED, data) -- TODO: unregister animations --anim.UnregisterUserFromAllNamespaces(data.userId)

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
        df("%s |cFF0000%s|r", addon_name, GetString(HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP))
        return
    end

    players = players or defaultPlayers

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
        group.CreateOrUpdatePlayerData(_getRandomPlayerData(name))
    end

    isTestRunning = true
    CM:FireCallbacks(HR_EVENT_TEST_STARTED)
    CM:FireCallbacks(HR_EVENT_UNLOCKUI)
    EM:RegisterForUpdate(addon_name .. "_TestUpdate", 1000, function()
        CM:FireCallbacks(HR_EVENT_TEST_TICK)
    end)
    df("%s |c00FF00%s|r", addon_name, GetString(HR_CORE_GROUP_COMMAND_TEST_ACTION_START))
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

-- register subcommand to test group functionality
core.RegisterSubCommand("group test", GetString(HR_CORE_GROUP_COMMAND_TEST_HELP), function(str)
    local players = zo_strmatch(str, "^%s*(.*)")
    logger:Debug("group test command received: '%s'", tostring(players))
    if players then
        if IsUnitGrouped(localPlayer) then
            df("|cFF0000%s|r %s", addon_name, GetString(HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP))
        else
            toggleTest(util.IsValidString(players) and {zo_strsplit(" ", players)})
        end
    end
end)

addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)