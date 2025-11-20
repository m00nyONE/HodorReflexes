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

    if (not LibCustomNames) and (not sw.libraryPopupDisabled) then
        logger:Warn("LibCustomNames is missing. Some features will be disabled.")
        ZO_Dialogs_RegisterCustomDialog(dialogName, {
            title = {
                text = GetString(HR_MISSING_LIBS_TITLE_CONSOLE),
            },
            mainText = {
                text = GetString(HR_MISSING_LIBS_TEXT_CONSOLE),
            },
            OnShownCallback = function(dialog) -- no need for the isgamepadpreferred check because it is only in gamepad
                if IsInGamepadPreferredMode() then 
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
            end,

            mustChoose = true,
            canQueue = true,
            allowShowOnDead = false,
            gamepadInfo = {
                dialogType = GAMEPAD_DIALOGS.BASIC,
            },
        })

        if not ZO_Dialogs_IsShowingDialog() then
            ZO_Dialogs_ShowPlatformDialog(dialogName)
        end
    end

end