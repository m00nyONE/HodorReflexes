-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local localPlayer = "player"
local LGB = LibGroupBroadcast

local _sendExitInstanceRequest = {}
local EVENT_EXIT_INSTANCE_REQUEST_NAME = "ExitInstanceRequest"
local EVENT_ID_EXITINSTANCEREQUEST = 3

local moduleDefinition = {
    name = "exitinstance",
    friendlyName = GetString(HR_MODULES_EXITINSTANCE_FRIENDLYNAME),
    description = GetString(HR_MODULES_EXITINSTANCE_DESCRIPTION),
    version = "1.0.0",
    priority = 10,
    enabled = false,
    svDefault = {
        ignoreExitInstanceRequests = false,
        confirmExitInstance = true,
    },

    exitInstanceDialogName = string.format("%s_ExitInstanceDialog", addon_name)
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    self.logger:Debug("activated exitInstance module")

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_MODULES_EXITINSTANCE_BINDING_SENDEXITINSTANCEREQUEST', GetString(HR_MODULES_EXITINSTANCE_BINDING_SENDEXITINSTANCEREQUEST))
    ZO_CreateStringId('SI_BINDING_NAME_HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE', GetString(HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE))

    local exitInstanceRequestButton = {
        name = GetString(HR_MODULES_EXITINSTANCE_BINDING_SENDEXITINSTANCEREQUEST),
        keybind = 'HR_MODULES_EXITINSTANCE_BINDING_SENDEXITINSTANCEREQUEST',
        callback = function(...) self:SendExitInstanceRequest(...) end,
        alignment = KEYBIND_STRIP_ALIGN_CENTER,
    }

    local function OnStateChanged(_, newState)
        if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader(localPlayer) then
            KEYBIND_STRIP:AddKeybindButton(exitInstanceRequestButton)
        elseif newState == SCENE_FRAGMENT_HIDING then
            KEYBIND_STRIP:RemoveKeybindButton(exitInstanceRequestButton)
        end
    end
    -- Add hotkey to group window
    KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
    GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)

    -- register custom dialog
    self:registerExitInstanceRequestDialog()
    self.registerExitInstanceRequestDialog = nil -- only once


    -- register "eject" subcommand
    core.RegisterSubCommand("eject", GetString(HR_MODULES_EXITINSTANCE_COMMAND_HELP), function(...) self:SendExitInstanceRequest(...) end)
end

function module:RegisterLGBProtocols(handler)
    _sendExitInstanceRequest = handler:DeclareCustomEvent(EVENT_ID_EXITINSTANCEREQUEST, EVENT_EXIT_INSTANCE_REQUEST_NAME)
    local success = LGB:RegisterForCustomEvent(EVENT_EXIT_INSTANCE_REQUEST_NAME, function(...) self:onExitInstanceRequestEventReceived(...) end)
    if not success then
        self.logger.Error("error registering for EXIT_INSTANCE_EVENT")
    end
end

function module:ExitInstance()
    if CanExitInstanceImmediately() then
        if self.sv.confirmExitInstance and not ZO_Dialogs_IsShowingDialog() then
            ZO_Dialogs_ShowDialog(self.exitInstanceDialogName, nil, nil, IsInGamepadPreferredMode())
        else
            ExitInstanceImmediately()
        end
    end
end

function module:onExitInstanceRequestEventReceived(unitTag, data)
    if not IsUnitGroupLeader(unitTag) then return end
    if self.sv.ignoreExitInstanceRequests then return end

    self:ExitInstance()
end

function module:SendExitInstanceRequest()
    if not IsUnitGroupLeader(localPlayer) then
        df('|cFF0000%s|r', GetString(HR_MODULES_EXITINSTANCE_NOT_LEADER))
        return
    end

    _sendExitInstanceRequest()
end


function module:registerExitInstanceRequestDialog()
    ZO_Dialogs_RegisterCustomDialog(self.exitInstanceDialogName, {
        title = {
            text = GetString(HR_MODULES_EXITINSTANCE_DIALOG_TITLE),
        },
        mainText = {
            text = GetString(HR_MODULES_EXITINSTANCE_DIALOG_MAIN_TEXT),
        },
        buttons = {
            {
                text = SI_DIALOG_YES,
                callback = function() ExitInstanceImmediately() end,
            },
            {
                text = SI_DIALOG_NO,
                callback = function() end, -- do nothing on escape or no button
            },
        },
        noChoiceCallback = function() end, -- do nothing on escape or no button
        canQueue = false,
        allowShowOnDead = true,
        gamepadInfo = {
            dialogType = GAMEPAD_DIALOGS.BASIC,
        },
    })
end
