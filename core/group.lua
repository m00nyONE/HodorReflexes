-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/group")

local util = addon.util
local CM = core.CM
local EM = GetEventManager()
local isTestRunning = false
local localPlayer = "player"
local group = {}
core.group = group

--[[ doc.lua begin ]]
--- @type table<string, table> playersData
local playersData = {}
addon.playersData = playersData

local TEST_TICK_INTERVAL = 1000 -- milliseconds

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

--- default list of players used for the test mode
--- @type table<string> defaultPlayers
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

--- @type table<string, any> playersDataDefaultFields
local playersDataDefaultFields = {
    --name = "",
    --userId = "",
    --classId = 0,
    --isPlayer = false,
    --tag = "",
}

--- registers additional default fields for player data
--- @param fields table<string, any> a table of key-value pairs to be added to the default fields
--- @return void
function group.RegisterPlayersDataFields(fields)
    for key, defaultValue in pairs(fields) do
        playersDataDefaultFields[key] = defaultValue
    end
end

--- creates or updates player data.
--- requires at least data.name and data.tag
--- @param data table<string, any> a table of key-value pairs to be added/updated to the player data
--- @return void
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

    ZO_DeepTableCopy(data, playerData)

    playerData.tag = tag
    playerData.lastUpdate = GetGameTimeMilliseconds()

    CM:FireCallbacks(HR_EVENT_PLAYERSDATA_UPDATED, playerData)
end

--- cleans up playersData by removing entries for players no longer in the group
--- @param forceDelete boolean if true, all player data will be removed
--- @return void
local function cleanPlayersData(forceDelete)
    forceDelete = forceDelete or false
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
            CM:FireCallbacks(HR_EVENT_PLAYERSDATA_CHARACTER_REMOVED, data)

            playersData[characterName] = nil
        end
    end

    CM:FireCallbacks(HR_EVENT_PLAYERSDATA_CLEANED, forceDelete)
end

--- toggles the test mode
--- @param players table<string>? optional list of player names to use for the test mode, defaults to `defaultPlayers`
--- @return void
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
            classId = GetClassInfo(zo_random(1, GetNumClasses())), -- we use GetClassInfo here to get the real ID out of the iterator - GetClassInfo's first return value is the classId
            isPlayer = name == GetUnitDisplayName(localPlayer),
        }
    end

    for _, name in ipairs(players) do
        group.CreateOrUpdatePlayerData(_getRandomPlayerData(name))
    end

    isTestRunning = true
    CM:FireCallbacks(HR_EVENT_TEST_STARTED)
    CM:FireCallbacks(HR_EVENT_UNLOCKUI)
    EM:RegisterForUpdate(addon_name .. "_TestUpdate", TEST_TICK_INTERVAL, function()
        if not core.sw.enableTestTick then return end -- we still want to keep the test tick loop running, even if the tick events are disabled. That way the ticks can be enabled again during runtime without restarting the test.
        CM:FireCallbacks(HR_EVENT_TEST_TICK)
    end)
    df("%s |c00FF00%s|r", addon_name, GetString(HR_CORE_GROUP_COMMAND_TEST_ACTION_START))
end

--- event handler for group changes
--- @return void
local function onGroupChanged()
    if isTestRunning then
        cleanPlayersData(true)
        isTestRunning = false
        EM:UnregisterForUpdate(addon_name .. "_TestUpdate")
        CM:FireCallbacks(HR_EVENT_TEST_STOPPED)
        CM:FireCallbacks(HR_EVENT_LOCKUI)
        return
    end

    cleanPlayersData(false)
end

--- registers subcommand to test group functionality
--- @param str string the command string
--- @return void
core.RegisterSubCommand("test", GetString(HR_CORE_GROUP_COMMAND_TEST_HELP), function(str)
    if IsUnitGrouped(localPlayer) then
        df("|cFF0000%s|r %s", addon_name, GetString(HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP))
        return
    end

    local players = nil -- set to nil to use default players if none are provided
    for name in zo_strgmatch(str, "@[^@]+") do
        players = players or {}
        local nameTrimmed = zo_strgsub(name, "^%s*(.-)%s*$", "%1")
        table.insert(players, nameTrimmed)
    end

    toggleTest(players)
end)

--- register callback for group changes
addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChanged)