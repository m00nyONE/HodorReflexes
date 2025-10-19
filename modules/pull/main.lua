-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local localPlayer = "player"

local moduleDefinition = {
    name = "pull",
    friendlyName = GetString(HR_MODULES_PULL_FRIENDLYNAME),
    description = GetString(HR_MODULES_PULL_DESCRIPTION),
    version = "0.9.0",
    priority = 10,
    enabled = false,
    svVersion = 1,
    svDefault = {
        countdownDuration = 5,
    },

    minCountdownDuration = 3,
    maxCountdownDuration = 10,
    isCountdownActive = false,
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    self.logger:Debug("activated pull module")

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_MODULES_PULL_BINDING_COUNTDOWN', GetString(HR_MODULES_PULL_BINDING_COUNTDOWN))

    local countdownButton = {
        name = GetString(HR_MODULES_PULL_BINDING_COUNTDOWN),
        keybind = 'HR_MODULES_PULL_BINDING_COUNTDOWN',
        callback = function(...) self:SendPullCountdown(...) end,
        alignment = KEYBIND_STRIP_ALIGN_CENTER,
    }

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

    core.RegisterSubCommand("pull", GetString(HR_MODULES_PULL_COMMAND_HELP), function(...) self:SendPullCountdown(...) end)
end

function module:RenderPullCountdown(durationMS)
    local texturePath = "EsoUI/Art/HUD/HUD_Countdown_Badge_Dueling.dds"
    local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_COUNTDOWN_TEXT, SOUNDS.DUEL_START)
    messageParams:SetLifespanMS(durationMS)
    messageParams:SetIconData(texturePath)
    messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_COUNTDOWN)

    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
end

-- Register additional slash command
SLASH_COMMANDS["/pull"] = function(duration)
    module:SendPullCountdown(tonumber(duration))
end