--[[ doc.lua begin ]]
--- @class HodorReflexes
local addon = {
    name = "HodorReflexes",
    version = "dev",
    author = "|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r",
    svName = "HodorReflexesSV",
    svVersion = 1,

    modules = {},
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
    },
    -- NoLibsInstalled
    libraryPopupDisabled = false,
}

local EM = GetEventManager()
local CM = ZO_CallbackObject:New()
local LAM = LibAddonMenu2
local LGB = LibGroupBroadcast
local LCI = LibCustomIcons
local LCN = LibCustomNames

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

local localPlayer = "player"

local _LGBHandler = {}
local _LGBProtocols = {}

local registeredExtraMainMenuOptionControls = {}

local inCombat = false -- previous combat state

local function spairs(t, sortFunction) -- thanks @Solinur <3

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if sortFunction given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if sortFunction then
        table.sort(keys, function(a,b) return sortFunction(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


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
local function getMenuOptionControls(moduleName, moduleClass)
    return {
        type = "submenu",
        name = string.format("|cFFFACD%s|r", moduleClass.friendlyName),
        controls = {
            {
                type = "description",
                text = moduleClass.description,
            },
            {
                type = "checkbox",
                name = function()
                    return string.format(sv.modules[moduleName] and "|c00FF00%s|r" or "|cFF0000%s|r", "Enable Module")
                end,
                tooltip = "enables/disables the module",
                getFunc = function() return sv.modules[moduleName] end,
                setFunc = function(value) sv.modules[moduleName] = value end,
                requiresReload = true,
            },
            {
                type = "divider",
            },
        }
    }
end

local function sortByPriority(t, a, b)
    if t[a].priority == t[b].priority then
        return a < b
    end
    return t[a].priority < t[b].priority
end

local function InitializeModules()
    if not sv.modules then
        sv.modules = svDefault.modules
    end

    for moduleName, moduleClass in spairs(addon_modules, sortByPriority) do
        -- inject the Module header into settings with the "enable" checkbox
        local moduleHeaderOptions = getMenuOptionControls(moduleName, moduleClass)

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
                local extraOptionControls = moduleClass:MainMenuOptions()
                for _, v in ipairs(extraOptionControls) do
                    table.insert(moduleHeaderOptions.controls, v)
                end
                moduleClass.MainMenuOptions = nil
            end

            moduleClass:Initialize()
            moduleClass.Initialize = nil
            moduleClass.enabled = true
        end

        table.insert(registeredExtraMainMenuOptionControls, moduleHeaderOptions)
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

    local options = { } -- main menu settings
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

local function ShowMissingLibsPopup()
    ZO_Dialogs_RegisterCustomDialog("HODORREFLEXES_MISSING_LIBS", {
        title = {
            text = GetString(HR_MISSING_LIBS_TITLE),
        },
        mainText = {
            text = GetString(HR_MISSING_LIBS_TEXT),
        },
        buttons = {
            {
                text = GetString(HR_MISSING_LIBS_OK),
                keybind = "DIALOG_PRIMARY",
                callback = function() end,
            },
            {
                text = GetString(HR_MISSING_LIBS_DONTSHOWAGAIN),
                keybind = "DIALOG_RESET",
                callback = function()
                    sv.libraryPopupDisabled = true
                end,
            },
        },
        mustChoose = true,
        canQueue = true,
        allowShowOnDead = false,
    }, nil, IsInGamepadPreferredMode())

    ZO_Dialogs_ShowDialog("HODORREFLEXES_MISSING_LIBS")
end

local function Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, nil, svDefault)

    RegisterLGBHandler()
    InitializeExtensions()
    InitializeModules()

    BuildMenu()

    EM:RegisterForEvent(addon_name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, onPlayerActivated)

    if (not LCI or not LCN) and not sv.libraryPopupDisabled then
        ShowMissingLibsPopup()
    end
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