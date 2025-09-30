-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local module = {
    name = "pull",
    friendlyName = "Pull Countdown", -- TODO: translation
    description = "allows you to send pull countdowns to your group", -- TODO: translation
    version = "1.0.0",
    priority = 10,
    enabled = false,
}

local module_name = module.name
local module_version = module.version

local sv = nil
local svName = addon.svName
local svVersion = addon.svVersion
local svDefault = {
    enabled = true,
    countdownDuration = 5,
}

local EM = EVENT_MANAGER
local LAM = LibAddonMenu2
local LGB = LibGroupBroadcast
local localPlayer = "player"

local strformat = string.format

local protocolPullCountdown = {}
local MESSAGE_ID_PULLCOUNTDOWN = 31

local minCountdownDuration = 3
local maxCountdownDuration = 10
local isCountdownActive = false


local function renderPullCountdown(durationMS)
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_COUNTDOWN_TEXT, SOUNDS.DUEL_START)
    messageParams:SetLifespanMS(durationMS)
    messageParams:SetIconData("EsoUI/Art/HUD/HUD_Countdown_Badge_Dueling.dds")
    messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_COUNTDOWN)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

local function onPullCountdownMessageReceived(unitTag, data)
    if not IsUnitGroupLeader(unitTag) then return end
    if isCountdownActive then return end

    local duration = data.duration * 1000

    isCountdownActive = true
    zo_callLater(function() isCountdownActive = false end, duration)

    renderPullCountdown(duration)
end

function module.SendPullCountdown(duration)
    if not IsUnitGroupLeader('player') then
        d(string.format('|cFF0000%s|r', GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM)))
        return
    end

    if not duration then duration = sv.countdownDuration end
    if duration < minCountdownDuration then duration = minCountdownDuration end
    if duration > maxCountdownDuration then duration = maxCountdownDuration end

    protocolPullCountdown:Send({
        duration = duration
    })
end

local countdownButton = {
    name = GetString(HR_PULL_COUNTDOWN),
    keybind = 'HR_PULL_COUNTDOWN',
    callback = module.SendPullCountdown,
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

function module:MainMenuOptions()
    return {
        {
            type = "slider",
            name = "Default pull duration", -- TODO: translation
            tooltip = "changes the default pull duration when you use the keybind or use /pull", -- TODO: translation
            min = 3,
            max = 10,
            step = 1,
            default = 5,
            decimals = 0,
            clampInput = true,
            getFunc = function() return sv.countdownDuration end,
            setFunc = function(value) sv.countdownDuration = value end,
        }
    }
end

function module:RegisterLGBProtocols(handler)
    local CreateNumericField = LGB.CreateNumericField
    local protocolOptions = {
        isRelevantInCombat = false
    }

    protocolPullCountdown = handler:DeclareProtocol(MESSAGE_ID_PULLCOUNTDOWN, "PullCountdown")
    protocolPullCountdown:AddField(CreateNumericField("duration", {
        minValue = minCountdownDuration,
        maxValue = maxCountdownDuration,
    }))
    protocolPullCountdown:OnData(onPullCountdownMessageReceived)
    protocolPullCountdown:Finalize(protocolOptions)
end

function module:Initialize()
    sv = ZO_SavedVars:NewAccountWide(svName, svVersion, module_name, svDefault)

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_PULL_COUNTDOWN', GetString(HR_BINDING_PULL_COUNTDOWN))

    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader(localPlayer) then
            KEYBIND_STRIP:AddKeybindButton(countdownButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(countdownButton)
        end
    end
    -- Add hotkey to group window
    KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
    GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)
end

addon:RegisterModule(module_name, module)

SLASH_COMMANDS["/pull"] = function(duration)
    module.SendPullCountdown(tonumber(duration))
end