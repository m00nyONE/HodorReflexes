-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_READYCHECK_FRIENDLYNAME = "Bereitschaftscheck",
    HR_MODULES_READYCHECK_DESCRIPTION = "Erweitert den Bereitschaftscheck und zeigt wer bereit ist und wer nicht.",
    HR_MODULES_READYCHECK_TITLE = "Bereitschaftscheck",
    HR_MODULES_READYCHECK_READY = "Bereit",
    HR_MODULES_READYCHECK_NOT_READY = "Nicht bereit",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED = "UI sperren",
    HR_MODULES_READYCHECK_MENU_UI_LOCKED_TT = "Verhindert, dass das Bereitschaftscheck-Fenster verschoben oder in der Größe verändert werden kann.",
    HR_MODULES_READYCHECK_MENU_CHAT = "Chat-Ausgabe",
    HR_MODULES_READYCHECK_MENU_CHAT_TT = "Gibt die Bereitschaftscheck-Ergebnisse im Chat aus.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end