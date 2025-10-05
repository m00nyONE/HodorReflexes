-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal
local core = internal.core

local LCN = LibCustomNames
local LCI = LibCustomIcons

function core.OptionalLibrariesCheck()
    local sw = core.sw
    local dialogName = string.format("%s_MISSING_LIBS", addon_name)

    if (not LCI or not LCN) and not sw.libraryPopupDisabled then
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
        }, nil, IsInGamepadPreferredMode())

        ZO_Dialogs_ShowDialog(dialogName)
    end

end