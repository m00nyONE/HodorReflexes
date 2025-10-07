-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Readycheck",
    HR_MODULES_READYCHECK_DESCRIPTION = "Enhances the readycheck by showing who voted what.",
    HR_MODULES_READYCHECK_TITLE = "Ready Check",
    HR_MODULES_READYCHECK_READY = "Ready",
    HR_MODULES_READYCHECK_NOT_READY = "Not Ready",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED = "lock ui",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED_TT = "Prevents the readycheck window from being moved or resized.",
    HR_MODULES_READYCHECK_MENU_CHAT = "chat output",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Outputs the readycheck results to chat.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end