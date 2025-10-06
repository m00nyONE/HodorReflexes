-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    -------------------------
    -- HUD
    -------------------------
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Sperre das UI",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Entsperre das UI",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "UI gesperrt",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "UI entsperrt",
    -------------------------
    -- Group
    -------------------------
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Test starten/stoppen",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Test gestartet",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Test gestoppt",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "Du musst die Gruppe verlassen, um einen Test zu starten",
	-------------------------
	-- LibCheck
	-------------------------
    HR_MISSING_LIBS_TITLE = "Hol dir das volle HodorReflexes-Erlebnis!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomIcons|r und |cFFFF00LibCustomNames|r, um benutzerdefinierte Icons, Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomNames|r, um benutzerdefinierte Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
    HR_MISSING_LIBS_OK = "OK",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Nicht noch einmal anzeigen",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end