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
    name = "exitinstance",
    friendlyName = GetString(HR_MODULES_EXITINSTANCE_FRIENDLYNAME),
    description = GetString(HR_MODULES_EXITINSTANCE_DESCRIPTION),
    version = "1.0.0",
    priority = 10,
    enabled = false,
    svVersion = 1,
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

    -- register custom dialog
    self:registerExitInstanceRequestDialog()
    self.registerExitInstanceRequestDialog = nil -- only once

    self:SetupKeybinds()

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
        ZO_Dialogs_ShowPlatformDialog(self.dialogExitInstance)
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
