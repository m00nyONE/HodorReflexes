-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local addon_modules = addon.modules
local internal_modules = internal.modules

local localPlayer = "player"

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

    dialogExitInstance = string.format("%s_ExitInstance", addon_name),
    dialogSendExitInstance = string.format("%s_SendExitInstance", addon_name),
}

local module = internal.moduleClass:New(moduleDefinition)

function module:Activate()
    self.logger:Debug("activated exitInstance module")

    -- Bindings
    ZO_CreateStringId('SI_BINDING_NAME_HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT', GetString(HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT))
    ZO_CreateStringId('SI_BINDING_NAME_HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE', GetString(HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE))

    local exitInstanceRequestButton = {
        name = GetString(HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT),
        keybind = 'HR_MODULES_EXITINSTANCE_BINDING_SENDEJECT',
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

function module:ExitInstance()
    if not CanExitInstanceImmediately() then return end

    if not self.sv.confirmExitInstance then
        ExitInstanceImmediately()
        return
    end
    if not ZO_Dialogs_IsShowingDialog() then
        ZO_Dialogs_ShowDialog(self.dialogExitInstance, nil, nil, IsInGamepadPreferredMode())
        return
    end
end

function module:registerExitInstanceRequestDialog()
    ZO_Dialogs_RegisterCustomDialog(self.dialogExitInstance, {
        title = {
            text = GetString(HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TITLE),
        },
        mainText = {
            text = GetString(HR_MODULES_EXITINSTANCE_EXITINSTANCE_DIALOG_TEXT),
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
    ZO_Dialogs_RegisterCustomDialog(self.dialogSendExitInstance, {
        title = {
            text = GetString(HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TITLE),
        },
        mainText = {
            text = GetString(HR_MODULES_EXITINSTANCE_SENDEXITINSTANCE_DIALOG_TEXT),
        },
        buttons = {
            {
                text = SI_DIALOG_YES,
                callback = function() self:_sendExitInstanceRequestEvent() end,
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
