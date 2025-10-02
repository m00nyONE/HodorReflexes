local addon_name = "HodorReflexes2"
local addon = _G[addon_name]
local internal = addon.internal

local LCN = LibCustomNames
local LCI = LibCustomIcons

-- TODO: move into language files
local HR_MISSING_LIBS_TITLE = "Get the Full HodorReflexes Experience!"
local HR_MISSING_LIBS_TEXT = "|c00FF00You're missing out on the full HodorReflexes experience!|r\n\nInstall |cFFFF00LibCustomIcons|r and |cFFFF00LibCustomNames|r to see custom icons, nicknames, and styles from other Hodor users including your friends and guildmates. Transform the battlefield into something personal and full of character!\n\nThis is entirely optional and not required for HodorReflexes to function."
local HR_MISSING_LIBS_OK = "OK"
local HR_MISSING_LIBS_DONTSHOWAGAIN = "Don't show again"

function internal.OptionalLibrariesCheck()
    local sv = internal.sv

    if (not LCI or not LCN) and not sv.libraryPopupDisabled then
        ZO_Dialogs_RegisterCustomDialog("HODORREFLEXES_MISSING_LIBS", {
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
                        sv.libraryPopupDisabled = true
                    end,
                },
            },
            mustChoose = true,
            canQueue = true,
            allowShowOnDead = false,
        }, nil, IsInGamepadPreferredMode())

        ZO_Dialogs_ShowDialog("HODORREFLEXES_MISSING_LIBS")
    end

end