-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

HodorReflexes.modules.pull = {
    name = "HodorReflexes_Pull",
    version = "1.0.0",

    default = {
        enabled = true,
        countdownDuration = 5,
    },

    sv = nil, -- saved variables
}

local HR = HodorReflexes
local M = HR.modules.pull
local LGB = LibGroupBroadcast
local protocolPullCountdown = {}
local MESSAGE_ID_PULLCOUNTDOWN = 31

local minCountdownDuration = 3
local maxCountdownDuration = 10
local isCountdownActive = false

local strformat = string.format

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

    --d(strformat('|c00FFFF%s %s|r', GetUnitDisplayName(name), GetString(HR_COUNTDOWN_INIT_CHAT)))
    isCountdownActive = true
    zo_callLater(function() isCountdownActive = false end, duration)

    renderPullCountdown(duration)
end

function M.SendPullCountdown(duration)
    if not IsUnitGroupLeader('player') then
        d(string.format('|cFF0000%s|r', GetString(HR_MENU_VOTE_ACTIONS_COUNTDOWN_CONFIRM)))
        return
    end

    if not duration then duration = M.sv.countdownDuration end
    if duration < minCountdownDuration then duration = minCountdownDuration end
    if duration > maxCountdownDuration then duration = maxCountdownDuration end

    protocolPullCountdown:Send({
        duration = duration
    })
end

local countdownButton = {
    name = GetString(HR_PULL_COUNTDOWN),
    keybind = 'HR_PULL_COUNTDOWN',
    callback = M.SendPullCountdown,
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

function M.DeclareLGBProtocols(handler)
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

function M.Initialize()
    -- Retrieve savedVariables
    M.sv = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'pull', M.default)

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_PULL_COUNTDOWN', GetString(HR_BINDING_PULL_COUNTDOWN))
    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader('player') then
            KEYBIND_STRIP:AddKeybindButton(countdownButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(countdownButton)
        end
    end
    -- Add hotkey to group window
    if KEYBOARD_GROUP_MENU_SCENE then
        KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
    end
    if GAMEPAD_GROUP_SCENE then
        GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)
    end
end

SLASH_COMMANDS["/pull"] = function(duration)
    M.SendPullCountdown(tonumber(duration))
end
