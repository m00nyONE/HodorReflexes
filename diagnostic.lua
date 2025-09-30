-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local LCN = LibCustomNames
local LCI = LibCustomIcons
local localPlayer = "player"


local isIconsDiagDialogRegistered = false
local iconsDiagText = "LibCustomNames and LibCustomIcons diagnostic:\n\n"

local function RegisterIconsDiagDialog()
    ZO_Dialogs_RegisterCustomDialog("HODORREFLEXES_ICONS_DIAG", {
        title = {
            text = "LibCustomNames and LibCustomIcons Diagnostic",
        },
        mainText = {
            text = iconsDiagText,
        },
        buttons = {
            {
                text = "OK",
                keybind = "DIALOG_PRIMARY",
                callback = function() end,
            }
        },
        mustChoose = true,
        canQueue = true,
        allowShowOnDead = false,
    }, nil, IsInGamepadPreferredMode())

    isIconsDiagDialogRegistered = true
end

local function iconsDiag()
    local date = GetDate()
    local userId = GetUnitDisplayName(localPlayer)
    local lcn_enabled = LCN ~= nil
    local lcn_version = "unknown version"
    local lcn_entries = 0
    local lcn_userid_entry = "none"
    if lcn_enabled then
        lcn_version = LCN.version
        lcn_entries = LCN.GetCustomNameCount()
        lcn_userid_entry = LCN.Get(userId) or "none"
    end
    local lci_enabled = LCI ~= nil
    local lci_version = "unknown version"
    local lci_entries = 0
    local lci_userid_entry = "none"
    if lci_enabled then
        lci_version = LCI.version
        lci_entries = LCI.GetIconCount()
        lci_userid_entry = string.format("|t22:22:%s|t", LCI.GetStatic(userId) or "none")
    end

    local iconsDiagheader = zo_strformat("Date: <<1>>\nUserID: <<2>>\n\n", date, userId)
    local iconsDiagLCN = zo_strformat("LibCustomNames:\nEnabled: <<1>>\nVersion: <<2>>\nEntries: <<3>>\nUserEntry: <<4>>\n\n",
            lcn_enabled and "|c00FF00true|r" or "|cFF0000false|r",
            lcn_version,
            lcn_entries,
            lcn_userid_entry
    )
    local iconsDiagLCI = zo_strformat("LibCustomIcons:\nEnabled: <<1>>\nVersion: <<2>>\nEntries: <<3>>\nUserEntry: <<4>>\n",
            lci_enabled and "|c00FF00true|r" or "|cFF0000false|r",
            lci_version,
            lci_entries,
            lci_userid_entry
    )

    iconsDiagText = iconsDiagheader .. iconsDiagLCN .. iconsDiagLCI

    if not isIconsDiagDialogRegistered then
        RegisterIconsDiagDialog()
    end

    ZO_Dialogs_ShowDialog("HODORREFLEXES_ICONS_DIAG")
end

SLASH_COMMANDS["/hodor.diag"] = function(str)
    if str == "show" then iconsDiag() return end
end