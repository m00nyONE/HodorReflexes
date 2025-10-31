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
        ZO_Dialogs_RegisterCustomDialog(dialogName, {
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
                        sw.libraryPopupDisabled = true
                    end,
                },
            },
            mustChoose = true,
            canQueue = true,
            allowShowOnDead = false,
            gamepadInfo = {
                dialogType = GAMEPAD_DIALOGS.BASIC,
            },
        })

        ZO_Dialogs_ShowPlatformDialog(dialogName)
    end

end