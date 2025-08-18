--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes",
    version = "dev",
    author = "|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r",
    svName = "HodorReflexesSV",
    svVersion = 1,

    modules = {},
    group = {},
}
local addon_debug = false
local addon_name = addon.name
local addon_version = addon.version
local addon_author = addon.author
local addon_modules = addon.modules
_G[addon_name] = addon
--[[ doc.lua end ]]

-- saved Variables
local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    modules = {
      ["mock"] = false,
      ["vote"] = true,
      ["pull"] = true,
      ["dps"] = true,
      ["ult"] = true,
      ["events"] = true,
      ["exitinstance"] = true,
    }
}

local EM = GetEventManager()
local CM = ZO_CallbackObject:New()
local LAM = LibAddonMenu2
local LGB = LibGroupBroadcast

--[[ doc.lua begin ]]
-- Addon events (to be used with RegisterCallback)
-- Use HodorReflexes.RegisterCallback(event, callback) to register a callback.
local HR_EVENT_PLAYER_ACTIVATED = "PlayerActivated"
local HR_EVENT_COMBAT_START = "CombatStart"
local HR_EVENT_COMBAT_END = "CombatEnd"
local HR_EVENT_RETICLE_TARGET_CHANGED = "ReticleTargetChanged"
local HR_EVENT_UNIT_DIED = "UnitDied"
local HR_EVENT_INTERRUPT = "Interrupt"
local HR_EVENT_STUNNED = "Stunned"
local HR_EVENT_GROUP_CHANGED = "GroupChanged"
addon.HR_EVENT_PLAYER_ACTIVATED = HR_EVENT_PLAYER_ACTIVATED
addon.HR_EVENT_COMBAT_START = HR_EVENT_COMBAT_START
addon.HR_EVENT_COMBAT_END = HR_EVENT_COMBAT_END
addon.HR_EVENT_RETICLE_TARGET_CHANGED = HR_EVENT_RETICLE_TARGET_CHANGED
addon.HR_EVENT_UNIT_DIED = HR_EVENT_UNIT_DIED
addon.HR_EVENT_INTERRUPT = HR_EVENT_INTERRUPT
addon.HR_EVENT_STUNNED = HR_EVENT_STUNNED
addon.HR_EVENT_GROUP_CHANGED = HR_EVENT_GROUP_CHANGED
--[[ doc.lua end ]]

local PRE_DELETION_HOOK = "PRE_DELETION_HOOK"
local POST_CREATION_HOOK = "POST_CREATION_HOOK"

local group = addon.group
local groupData = {}
group.groupData = groupData

local localPlayer = "player"

local _LGBHandler = {}
local _LGBProtocols = {}

local registeredExtraMainMenuOptionControls = {}

local inCombat = false -- previous combat state

local function onGroupChange(forceDelete)
    local _existingGroupCharacters = {}
    local _groupSize = GetGroupSize()

    for i = 1, _groupSize do
        local tag = GetGroupUnitTagByIndex(i)
        if IsUnitPlayer(tag) then
            local userId = GetUnitDisplayName(tag)
            if userId and IsUnitOnline(tag) then
                local isPlayer = AreUnitsEqual(tag, localPlayer)
                local characterName = GetUnitName(tag)

                _existingGroupCharacters[userId] = true

                if groupData[userId] then
                    groupData[userId].tag = tag
                else
                    groupData[userId] = {
                        tag = tag,
                        isPlayer = isPlayer,
                        characterName = characterName,
                    }
                    CM:FireCallbacks(POST_CREATION_HOOK)
                end
            end
        end
    end

    for userId, _ in pairs(groupData) do
        if not _existingGroupCharacters[userId] or forceDelete then
            -- allow modules to release objects before deletion
            CM:FireCallbacks(PRE_DELETION_HOOK, groupData[userId])

            addon.anim.UnregisterUser(userId)
            groupData[userId] = nil
        end
    end
end

--[[ doc.lua begin ]]
function group.UnregisterPreDeletionHook(callback)
    assert(type(callback) == "function", "callback is not a function")
    CM:UnregisterCallback(PRE_DELETION_HOOK, callback)
end
function group.RegisterPreDeletionHook(callback)
    assert(type(callback) == "function", "callback is not a function")
    CM:RegisterCallback(PRE_DELETION_HOOK, callback)
end

function group.UnregisterPostCreationHook(callback)
    assert(type(callback) == "function", "callback is not a function")
    CM:UnregisterCallback(POST_CREATION_HOOK, callback)
end
function group.RegisterPostCreationHook(callback)
    assert(type(callback) == "function", "callback is not a function")
    CM:RegisterCallback(POST_CREATION_HOOK, callback)
end
--[[ doc.lua end ]]

--[[ doc.lua begin ]]
function addon.UnregisterCallback(eventName, callback)
    CM:UnregisterCallback(eventName, callback)
end
function addon.RegisterCallback(eventName, callback)
    CM:RegisterCallback(eventName, callback)

    if eventName == HR_EVENT_RETICLE_TARGET_CHANGED then
        EM:UnregisterForEvent(addon_name .. "RectileTargetChanged", EVENT_RETICLE_TARGET_CHANGED)

        EM:RegisterForEvent(addon_name .. "RectileTargetChanged", EVENT_RETICLE_TARGET_CHANGED,function()
            CM:FireCallbacks(HR_EVENT_RETICLE_TARGET_CHANGED)
        end)
    elseif eventName == HR_EVENT_UNIT_DIED then
        EM:UnregisterForEvent(addon_name .. "UnitDied", EVENT_COMBAT_EVENT)
        EM:UnregisterForEvent(addon_name .. "UnitDiedXP", EVENT_COMBAT_EVENT)

        -- EVENT_COMBAT_EVENT: ACTION_RESULT_DIED / ACTION_RESULT_DIED_XP
        -- onUnitDied(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
        local function onUnitDied(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
            CM:FireCallbacks(HR_EVENT_UNIT_DIED, result, targetName, targetType, targetUnitId)
        end

        EM:RegisterForEvent(addon_name .. "UnitDied", EVENT_COMBAT_EVENT, onUnitDied)
        EM:AddFilterForEvent(addon_name .. "UnitDied", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED)
        EM:RegisterForEvent(addon_name .. "UnitDiedXP", EVENT_COMBAT_EVENT, onUnitDied)
        EM:AddFilterForEvent(addon_name .. "UnitDiedXP", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED_XP)
    elseif eventName == HR_EVENT_INTERRUPT then
        EM:UnregisterForEvent(addon_name .. "Interrupt", EVENT_COMBAT_EVENT)

        -- EVENT_COMBAT_EVENT: ACTION_RESULT_INTERRUPT
        -- onInterrupt(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
        local function onInterrupt(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
            CM:FireCallbacks(HR_EVENT_INTERRUPT, result, targetName, targetType, targetUnitId)
        end

        EM:RegisterForEvent(addon_name .. "Interrupt", EVENT_COMBAT_EVENT, onInterrupt)
        EM:AddFilterForEvent(addon_name .. "Interrupt", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_INTERRUPT)
    elseif eventName == HR_EVENT_STUNNED then
        EM:UnregisterForEvent(addon_name .. "Stunned", EVENT_COMBAT_EVENT)

        -- EVENT_COMBAT_EVENT: ACTION_RESULT_STUNNED
        -- onStunned(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
        local function onStunned(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
            CM:FireCallbacks(HR_EVENT_STUNNED, result, targetName, targetType, targetUnitId)
        end

        EM:RegisterForEvent(addon_name .. "Stunned", EVENT_COMBAT_EVENT, onStunned)
        EM:AddFilterForEvent(addon_name .. "Stunned", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_STUNNED)
    end

    CM:RegisterCallback(eventName, callback)
end

function addon.Donation()
    SCENE_MANAGER:Show('mailSend')
    zo_callLater(function()
        ZO_MailSendToField:SetText("@m00nyONE")
        ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
        ZO_MailSendBodyField:SetText("ticket-XXXX on Discord.")
        ZO_MailSendBodyField:TakeFocus()
    end, 250)
end
--[[ doc.lua end ]]
function addon:RegisterModule(moduleName, moduleClass)
    assert(type(moduleName) == "string", "moduleName must be a string")
    assert(type(moduleClass) == "table", "moduleClass must be a table")
    assert(type(moduleClass.Initialize) == "function", "moduleClass does not contain Initialize function")
    assert(addon_modules[moduleName] == nil, "module already registered")

    addon_modules[moduleName] = moduleClass
end

local function getMenuPanelConfig(listName, panelName)
    panelName = panelName or listName
    return {
        type = 'panel',
        name = listName and string.format('Hodor Reflexes - %s', listName) or 'Hodor Reflexes',
        displayName = panelName and string.format('Hodor Reflexes - |cFFFACD%s|r', panelName) or 'Hodor Reflexes',
        author = addon_author,
        version = string.format('|c00FF00%s|r', addon_version),
        website = 'https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html#donate',
        donation = addon.Donation,
        registerForRefresh = true,
    }
end
local function getMenuOptionControls()
    local options = {
        {
            type = "header",
            name = string.format("|cFFFACD%s|r", "Modules")
        },
        {
            type = "description",
            text = "available modules"
        },
    }
    for moduleName, module in pairs(addon_modules) do
        local checkbox = {
            type = "checkbox",
            name = module.friendlyName,
            tooltip = module.description,
            getFunc = function() return sv.modules[moduleName] end,
            setFunc = function(value) sv.modules[moduleName] = value end,
            requiresReload = true,
        }
        table.insert(options, checkbox)
    end

    return options
end

local function InitializeModules()
    if not sv.modules then
        sv.modules = svDefault.modules
    end

    for moduleName, moduleClass in pairs(addon_modules) do
        if sv.modules[moduleName] then
            -- register LibGroupBroadcast Protocols if available
            if moduleClass.RegisterLGBProtocols then
                moduleClass:RegisterLGBProtocols(_LGBHandler)
                moduleClass.RegisterLGBProtocols = nil
            end
            -- build Module menu if available
            if moduleClass.BuildMenu then
                moduleClass:BuildMenu(getMenuPanelConfig(moduleName))
                moduleClass.BuildMenu = nil
            end
            -- inject menu options into main menu if available
            if moduleClass.MainMenuOptions then
                local optionControls = moduleClass:MainMenuOptions()
                for _, v in ipairs(optionControls) do
                    table.insert(registeredExtraMainMenuOptionControls, v)
                end
                moduleClass.MainMenuOptions = nil
            end

            moduleClass:Initialize()
            moduleClass.Initialize = nil
        end
    end

    addon.RegisterModule = nil
end
local function InitializeExtensions()
    -- nothing here atm
end
local function RegisterLGBHandler()
    local handler = LGB:RegisterHandler("HodorReflexes")
    handler:SetDisplayName("Hodor Reflexes")
    handler:SetDescription("provides various group tools like pull countdowns and exit instance requests")

    _LGBHandler = handler
end
local function BuildMenu()
    local panel = getMenuPanelConfig()

    local options = getMenuOptionControls()
    for _, v in ipairs(registeredExtraMainMenuOptionControls) do
        table.insert(options, v)
    end

    LAM:RegisterAddonPanel(addon_name .. "Options", panel)
    LAM:RegisterOptionControls(addon_name .. "Options", options)
end

local function onPlayerCombatState(_, c)
    if inCombat ~= c then
        if c then
            inCombat = true
            CM:FireCallbacks(HR_EVENT_COMBAT_START)
        else
            -- When the 2nd parameter is false, then it's not confirmed that the combat has ended.
            CM:FireCallbacks(HR_EVENT_COMBAT_END, false)
            -- A confirmed event is fired after 3 seconds.
            zo_callLater(function()
                if not IsUnitInCombat("player") then
                    inCombat = false
                    CM:FireCallbacks(HR_EVENT_COMBAT_END, true)
                end
            end, 3000)
        end
    end
end
local function onGroupChanged()
    EM:UnregisterForUpdate(addon_name .. "GroupChangeDelayed")
    CM:FireCallbacks(HR_EVENT_GROUP_CHANGED)
end
local function onGroupChangeDelayed()
    EM:UnregisterForUpdate(addon_name .. "GroupChangeDelayed")
    EM:RegisterForUpdate(addon_name .. "GroupChangeDelayed", 1000, onGroupChanged)
end
local function onPlayerActivated()
    addon.player.Initialize()

    CM:FireCallbacks(HR_EVENT_PLAYER_ACTIVATED)

    EM:UnregisterForEvent(addon_name .. "Combat", EVENT_PLAYER_COMBAT_STATE)
    EM:RegisterForEvent(addon_name .. "Combat", EVENT_PLAYER_COMBAT_STATE, onPlayerCombatState)
    onPlayerCombatState(nil, IsUnitInCombat(localPlayer))

    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_UPDATE)
    EM:UnregisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_JOINED)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_LEFT)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_UPDATE)
    EM:RegisterForEvent(addon_name, EVENT_GROUP_MEMBER_CONNECTED_STATUS)
    onGroupChangeDelayed()
end

local function Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, nil, svDefault)

    addon.RegisterCallback(HR_EVENT_GROUP_CHANGED, onGroupChange)

    RegisterLGBHandler()
    InitializeExtensions()
    InitializeModules()

    BuildMenu()

    EM:RegisterForEvent(addon_name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

EM:RegisterForEvent(addon_name, EVENT_ADD_ON_LOADED, function(_, name)
    if name == addon_name then
        Initialize()
        EM:UnregisterForEvent(addon_name, EVENT_ADD_ON_LOADED)
    end
end)

local function LockUI()

end

SLASH_COMMANDS["/hodor"] = function(str)
    if str == "lock" then LockUI() return end
    if str == "version" then d(addon_version) return end
    if str == "donate" then addon.Donation() return end
end