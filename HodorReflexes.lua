-- SPDX-FileCopyrightText: 2025 andy.s m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

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
--_G[addon_name] = addon
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
        ["readycheck"] = true,
    },
    libraryPopupDisabled = false,
}

-- Core Addon Table
HodorReflexes = {
	name = "HodorReflexes",
	version = "dev",

	-- Saved variables configuration
	sv = nil,                  -- Saved variables instance
	svVersion = 1,             -- Version of the saved variables structure
	svName = "HodorReflexesSV", -- Saved variables table name

	modules = {},              -- Contains public modules like "share", "vote", etc.
}

-- Addon events (to be used with RegisterCallback)
-- Use HodorReflexes.RegisterCallback(event, callback) to register a callback.
HR_EVENT_PLAYER_ACTIVATED = "PlayerActivated"
HR_EVENT_COMBAT_START = "CombatStart"
HR_EVENT_COMBAT_END = "CombatEnd"
HR_EVENT_RETICLE_TARGET_CHANGED = "ReticleTargetChanged"
HR_EVENT_UNIT_DIED = "UnitDied"
HR_EVENT_INTERRUPT = "Interrupt"
HR_EVENT_STUNNED = "Stunned"
HR_EVENT_GROUP_CHANGED = "GroupChanged"
HR_EVENT_LOCKUI = "LockUI"
HR_EVENT_UNLOCKUI = "UnlockUI"
HR_EVENT_TEST_TICK = "TestTick"


local PRE_DELETION_HOOK = "PRE_DELETION_HOOK"
local POST_CREATION_HOOK = "POST_CREATION_HOOK"

-- Import global variables and libraries
local HR = HodorReflexes
local EM = EVENT_MANAGER
local LAM = LibAddonMenu2
local LGB = LibGroupBroadcast
local LCI = LibCustomIcons
local LCN = LibCustomNames

HR.HR_EVENT_PLAYER_ACTIVATED = HR_EVENT_PLAYER_ACTIVATED
HR.HR_EVENT_COMBAT_START = HR_EVENT_COMBAT_START
HR.HR_EVENT_COMBAT_END = HR_EVENT_COMBAT_END
HR.HR_EVENT_RETICLE_TARGET_CHANGED = HR_EVENT_RETICLE_TARGET_CHANGED
HR.HR_EVENT_UNIT_DIED = HR_EVENT_UNIT_DIED
HR.HR_EVENT_INTERRUPT = HR_EVENT_INTERRUPT
HR.HR_EVENT_STUNNED = HR_EVENT_STUNNED
HR.HR_EVENT_GROUP_CHANGED = HR_EVENT_GROUP_CHANGED
HR.HR_EVENT_LOCKUI = HR_EVENT_LOCKUI
HR.HR_EVENT_UNLOCKUI = HR_EVENT_UNLOCKUI
HR.HR_EVENT_TEST_TICK = HR_EVENT_TEST_TICK

addon_modules = HR.modules

HR.cm = ZO_CallbackObject:New()
HR.CM = HR.cm

local localPlayer = "player"

local _LGBHandler = {}
local _LGBProtocols = {}

local optionControls = {} -- additional addon settings provided by modules
local registeredExtraMainMenuOptionControls = {}


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

-- EVENT_PLAYER_ACTIVATED handler
-- Automatically fires PlayerCombatState and GroupChanged callbacks.
function HR.PlayerActivated()

	HR.player.Initialize()

	HR.cm:FireCallbacks(HR_EVENT_PLAYER_ACTIVATED)

	-- Player can be in combat after reloadui
	EM:RegisterForEvent(HR.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, HR.PlayerCombatState)
	HR.PlayerCombatState(nil, IsUnitInCombat("player"))

	-- Group event handling (with delay to avoid spam)
	local function OnGroupChangeDelayed()
		EM:UnregisterForUpdate(HR.name .. "GroupChangeDelayed")
		EM:RegisterForUpdate(HR.name .. "GroupChangeDelayed", 1000, HR.GroupChanged)
	end
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_JOINED, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_LEFT, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_UPDATE, OnGroupChangeDelayed)
	EM:RegisterForEvent(HR.name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, OnGroupChangeDelayed)
	OnGroupChangeDelayed()

end

-- EVENT_PLAYER_COMBAT_STATE handler
local inCombat = false -- previous combat state
function HR.PlayerCombatState(_, c)
	if inCombat ~= c then
		if c then
			inCombat = true
			HR.cm:FireCallbacks(HR_EVENT_COMBAT_START)
		else
			-- When the 2nd parameter is false, then it's not confirmed that the combat has ended.
			HR.cm:FireCallbacks(HR_EVENT_COMBAT_END, false)
			-- A confirmed event is fired after 3 seconds.
			zo_callLater(function()
				if not IsUnitInCombat("player") then
					inCombat = false
					HR.cm:FireCallbacks(HR_EVENT_COMBAT_END, true)
				end
			end, 3000)
		end
	end
end

-- EVENT_RETICLE_TARGET_CHANGED handler
function HR.ReticleTargetChanged()
	HR.cm:FireCallbacks(HR_EVENT_RETICLE_TARGET_CHANGED)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_DIED / ACTION_RESULT_DIED_XP
--function HR.UnitDied(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.UnitDied(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_UNIT_DIED, result, targetName, targetType, targetUnitId)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_INTERRUPT
--function HR.Interrupt(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.Interrupt(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_INTERRUPT, result, targetName, targetType, targetUnitId)
end

-- EVENT_COMBAT_EVENT: ACTION_RESULT_STUNNED
--function HR.Stunned(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
function HR.Stunned(_, result, _, _, _, _, _, _, targetName, targetType, _, _, _, _, _, targetUnitId, _)
	HR.cm:FireCallbacks(HR_EVENT_STUNNED, result, targetName, targetType, targetUnitId)
end

-- EVENT_GROUP_MEMBER_JOINED, EVENT_GROUP_MEMBER_LEFT, EVENT_GROUP_UPDATE handler
function HR.GroupChanged()
	EM:UnregisterForUpdate(HR.name .. "GroupChangeDelayed")
	HR.cm:FireCallbacks(HR_EVENT_GROUP_CHANGED)
end

function HR.RegisterCallback(eventName, callback)

	-- Only start listening to some events when there is at least one callback attached
	if eventName == HR_EVENT_RETICLE_TARGET_CHANGED then
		EM:UnregisterForEvent(HR.name, EVENT_RETICLE_TARGET_CHANGED)
		EM:RegisterForEvent(HR.name, EVENT_RETICLE_TARGET_CHANGED, HR.ReticleTargetChanged)
	elseif eventName == HR_EVENT_UNIT_DIED then
		EM:UnregisterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT)
		EM:UnregisterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT, HR.UnitDied)
		EM:AddFilterForEvent(HR.name .. "UnitDied", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED)
		EM:RegisterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT, HR.UnitDied)
		EM:AddFilterForEvent(HR.name .. "UnitDiedXP", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED_XP)
	elseif eventName == HR_EVENT_INTERRUPT then
		EM:UnregisterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT, HR.Interrupt)
		EM:AddFilterForEvent(HR.name .. "Interrupt", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_INTERRUPT)
	elseif eventName == HR_EVENT_STUNNED then
		EM:UnregisterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT)

		EM:RegisterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT, HR.Stunned)
		EM:AddFilterForEvent(HR.name .. "Stunned", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_STUNNED)
	end

    HR.cm:RegisterCallback(eventName, callback)
end

function HR:UnregisterCallback(eventName, callback)
    HR.cm:UnregisterCallback(eventName, callback)
end

function HR.RegisterOptionControls(options)
	for _, v in ipairs(options) do
		table.insert(optionControls, v)
	end
end

function HR.GetModulePanelConfig(listName, panelName)
	panelName = panelName or listName
	return {
		type = 'panel',
		name = listName and string.format('Hodor Reflexes - %s', listName) or 'Hodor Reflexes',
		displayName = panelName and string.format('Hodor Reflexes - |cFFFACD%s|r', panelName) or 'Hodor Reflexes',
		author = '|cFFFF00@andy.s|r, |c76c3f4@m00nyONE|r',
		version = string.format('|c00FF00%s|r', HR.version),
		website = 'https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html#donate',
		donation = HR.Donation,
		registerForRefresh = true,
	}
end

function HR.Donation()
	SCENE_MANAGER:Show('mailSend')
	zo_callLater(function() 
		ZO_MailSendToField:SetText("@m00nyONE")
		ZO_MailSendSubjectField:SetText("Donation for Hodor Reflexes")
		ZO_MailSendBodyField:SetText("ticket-XXXX on Discord.")
		ZO_MailSendBodyField:TakeFocus()
	end, 250)
end

function HR.GetOptionControls()
	return optionControls
end

function HR.LockUI()

	-- public modules
	if HR.modules.share then HR.modules.share.LockUI() end
	if HR.modules.vote then HR.modules.vote.LockUI() end

	if HodorReflexesMenu_LockUI then LAM.util.RequestRefreshIfNeeded(HodorReflexesMenu_LockUI) end

	HR.cm:FireCallbacks(HR_EVENT_LOCKUI)
    d("HodorReflexes UI Locked")
end

local function UnlockUI()
	HR.cm:FireCallbacks(HR_EVENT_UNLOCKUI)
    d("HodorReflexes UI Unlocked")
end

SLASH_COMMANDS["/hodor"] = function(str)
	if str == "lock" then HR.LockUI() return end
	if str == "unlock" then UnlockUI() return end
	if str == "version" then d(HR.version) return end
end

function HR:RegisterModule(moduleName, moduleClass)
	assert(type(moduleName) == "string", "moduleName must be a string")
	assert(type(moduleClass) == "table", "moduleClass must be a table")
	assert(type(moduleClass.Initialize) == "function", "moduleClass does not contain Initialize function")
	assert(addon_modules[moduleName] == nil, "module already registered")

	addon_modules[moduleName] = moduleClass
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
                        return string.format(HR.sv.modules[moduleName] and "|c00FF00%s|r" or "|cFF0000%s|r", "Enable Module")
                    end,
                    tooltip = "enables/disables the module",
                    getFunc = function() return HR.sv.modules[moduleName] end,
                    setFunc = function(value) HR.sv.modules[moduleName] = value end,
                    requiresReload = true,
                },
                {
                    type = "divider",
                },
            }
        }
end

local function buildMenu()

	local panel = HR.GetModulePanelConfig()

	local options = {}
	-- Add options provided by modules
	local extraOptions = HR.GetOptionControls()
	for _, v in ipairs(extraOptions) do
		options[#options + 1] = v
	end
	for _, v in ipairs(registeredExtraMainMenuOptionControls) do
		table.insert(options, v)
	end

	LAM:RegisterAddonPanel(HR.name .. "Options", panel)
	LAM:RegisterOptionControls(HR.name .. "Options", options)

end

local function sortByPriority(t, a, b)
    if t[a].priority == t[b].priority then
        return a < b
    end
    return t[a].priority < t[b].priority
end

local function initializeModules()
	if not HR.sv.modules then
		HR.sv.modules = svDefault.modules
	end

	for moduleName, moduleClass in spairs(addon_modules, sortByPriority) do
        if not moduleClass.isOldModule then
            -- inject the Module header into settings with the "enable" checkbox
            local moduleHeaderOptions = getMenuOptionControls(moduleName, moduleClass)

            if HR.sv.modules[moduleName] then
                -- register LibGroupBroadcast Protocols if available
                if moduleClass.RegisterLGBProtocols then
                    moduleClass:RegisterLGBProtocols(_LGBHandler)
                    moduleClass.RegisterLGBProtocols = nil
                end
                -- build Module menu if available
                if moduleClass.BuildMenu then
                    moduleClass:BuildMenu(HR.GetModulePanelConfig(moduleName))
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
	end

	addon.RegisterModule = nil
end

local function registerLGBHandler()
	local handler = LGB:RegisterHandler("HodorReflexes")
	handler:SetDisplayName("Hodor Reflexes")
	handler:SetDescription("provides various group tools like pull countdowns and exit instance requests")

	_LGBHandler = handler
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

function HR.IsModuleEnabled(name)
    if HR.modules[name] and HR.modules[name].enabled then
        return true
    end
    return false
end

-- Main initialization function for the addon
local function Initialize()

	-- Retrieve saved variables
	HR.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, nil, svDefault)

	registerLGBHandler()

	-- Register events
	EM:RegisterForEvent(HR.name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, HR.PlayerActivated)

	-- initialize registered modules
	initializeModules()

	-- public modules
	if HR.modules.share then HR.modules.share.Initialize() end
	--if HR.modules.vote then HR.modules.vote.Initialize() end
	if HR.modules.events then HR.modules.events.Initialize() end
	--if HR.modules.pull then
	--	HR.modules.pull.DeclareLGBProtocols(_LGBHandler)
	--	HR.modules.pull.Initialize()
	--end
	--if HR.modules.exitinstance then
	--	HR.modules.exitinstance.DeclareLGBProtocols(_LGBHandler)
	--	HR.modules.exitinstance.Initialize()
	--end

	buildMenu()

    if (not LCI or not LCN) and not sv.libraryPopupDisabled then
        ShowMissingLibsPopup()
    end
end

EM:RegisterForEvent(HR.name, EVENT_ADD_ON_LOADED, function(_, name)
	if name == HR.name then
		Initialize()
		EM:UnregisterForEvent(HR.name, EVENT_ADD_ON_LOADED)
	end
end)