local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "dps",
    friendlyName = "Damage",
    description = "Shows group dps statistics",
    version = "1.0.0",

    playersData = {}
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enabled = true,
    disablePvP = true,

    enableDamageList = 0,
    enableDamageIcons = true,
    damageRowColor = {0, 1, 0, 0.36},

    styleDamageHeaderOpacity = 0.8,
    styleDamageRowEvenOpacity = 0.65,
    styleDamageRowOddOpacity = 0.45,
    styleDamageNumFont = 'gamepad',
    styleBossDamageColor = 'b2ffb2',
    styleTotalDamageColor = 'faffb2',
}

local CM = ZO_CallbackObject:New()
local EM = EVENT_MANAGER
local LAM = LibAddonMenu2
local LGCS = LibGroupCombatStats
local localPlayer = "player"

local lgcs = {}
local playersData = module.playersData

local EVENT_GROUP_DPS_UPDATE = LGCS.EVENT_GROUP_DPS_UPDATE
local EVENT_PLAYER_DPS_UPDATE = LGCS.EVENT_PLAYER_DPS_UPDATE

local HR_EVENT_GROUP_CHANGED = addon.HR_EVENT_GROUP_CHANGED

--- creates a player entry inside the playersData table
local function createOrUpdatePlayer(data)
    if not data or not data.name then return end

    local playerData = playersData[data.name]
    if not playerData then
        playerData = {
            name     = data.name,
            userId   = data.userId,
            classId  = data.classId,
            isPlayer = data.isPlayer,
        }
        playersData[data.name] = playerData
    end

    -- Update / overwrite fields
    playerData.tag        = data.tag
    playerData.dmg        = data.dmg
    playerData.dps        = data.dps
    playerData.dmgType    = data.dmgType
    playerData.lastUpdate = GetGameTimeMilliseconds()
end

--- processes incoming dps data messages and creates/updates the player's entry inside the playersData table
local function onDPSDataReceived(tag, data)
    if not IsUnitGrouped(tag) then return end

    createOrUpdatePlayer({
        name     = GetUnitName(tag),
        userId   = GetUnitDisplayName(tag),
        classId  = GetUnitClassId(tag),
        isPlayer = AreUnitsEqual(tag, localPlayer),
        tag      = tag,
        dmg      = data.dmg,
        dps      = data.dps,
        dmgType  = data.dmgType,
    })
end

--- cleans group data and deletes all players that are not in the group anymore
local function cleanPlayersData(forceDelete)
    local _existingGroupCharacters = {}
    local _groupSize = GetGroupSize()

    for i = 1, _groupSize do
        local tag = GetGroupUnitTagByIndex(i)
        if IsUnitPlayer(tag) and IsUnitOnline(tag) then
            local characterName = GetUnitName(tag)
            _existingGroupCharacters[characterName] = true
            if playersData[characterName] then
                playersData[characterName].tag = tag
            end
        end
    end
    for name, _ in pairs(playersData) do
        if not _existingGroupCharacters[name] or forceDelete then
            playersData[name] = nil
        end
    end
end

--- triggers when a group member joins/leaves/offlines/updates
local function onGroupChange()
    cleanPlayersData()
end


-- initialization functions

local function onPlayerActivated()

end

function module:MainMenuOptions()
    return {
    }
end

function module:Initialize()
    lgcs = LGCS.RegisterAddon(addon_name .. module_name, {"DPS"})
    if not lgcs then
        d("Failed to register addon with LibGroupCombatStats.")
        return
    end
    lgcs:RegisterForEvent(EVENT_GROUP_DPS_UPDATE, onDPSDataReceived)
    lgcs:RegisterForEvent(EVENT_PLAYER_DPS_UPDATE, onDPSDataReceived)

    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChange)

    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    local eventRegisterName = addon_name .. module_name .. "PlayerActivated"
    EM:UnregisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED)
    EM:RegisterForEvent(eventRegisterName, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

addon:RegisterModule(module_name, module)