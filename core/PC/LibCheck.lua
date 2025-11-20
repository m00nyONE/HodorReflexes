-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core
local logger = core.GetLogger("core/LibCheck")

--- checks if optional libraries are loaded, if not show a reminder dialog
--- @return void
function core.OptionalLibrariesCheck()
    local sw = core.sw
    local dialogName = string.format("%s_MISSING_LIBS", addon_name)

    if (not LibCustomIcons or not LibCustomNames) and not sw.libraryPopupDisabled then
        logger:Warn("LibCustomNames and/or LibCustomIcons are missing. Some features will be disabled.")

        local dialog = {
            title = {
                text = GetString(HR_MISSING_LIBS_TITLE),
            },
            mainText = {
                text = GetString(HR_MISSING_LIBS_TEXT),
            },
            buttons = {
                {
                    text = SI_OK,
                    keybind = "DIALOG_PRIMARY",
                    callback = function() end,
                },
                {
                    text = GetString(HR_MISSING_LIBS_DONTSHOWAGAIN),
                    keybind = "DIALOG_RESET",
                    callback = function()
                        sw.libraryPopupDisabled = true
                    end
                }
            },
            mustChoose = true,
            canQueue = true,
            allowShowOnDead = false,
            gamepadInfo = {
                dialogType = GAMEPAD_DIALOGS.BASIC,
            },
        }

        if IsInGamepadPreferredMode() then -- if gamepad, replace buttons with onshowcallback to avoid tainting the stack
            dialog.buttons = nil
            dialog.OnShownCallback = function(dialog) 
                local g_keybindState = KEYBIND_STRIP:GetTopKeybindStateIndex()
                local g_keybindGroupDesc = {
                    {
                        alignment = KEYBIND_STRIP_ALIGN_LEFT,
                        name = GetString(SI_OK),
                        keybind = "DIALOG_PRIMARY",
                        callback = function() end,
                    },
                    {
                        alignment = KEYBIND_STRIP_ALIGN_LEFT,
                        name = GetString(HR_MISSING_LIBS_DONTSHOWAGAIN),
                        keybind = "DIALOG_RESET",
                        callback = function() sw.libraryPopupDisabled = true end,
                    }
                }
                KEYBIND_STRIP:AddKeybindButtonGroup(g_keybindGroupDesc, g_keybindState)
            end
        end

        ZO_Dialogs_RegisterCustomDialog(dialogName, dialog)

        ZO_Dialogs_ShowPlatformDialog(dialogName)
    end

end