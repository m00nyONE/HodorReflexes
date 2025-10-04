-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

	-------------------------
	-- Missing Libraries
	-------------------------
    HR_MISSING_LIBS_TITLE = "Hol dir das volle HodorReflexes-Erlebnis!",
    HR_MISSING_LIBS_TEXT = "|c00FF00Du verpasst das volle HodorReflexes-Erlebnis!|r\n\nInstalliere |cFFFF00LibCustomIcons|r und |cFFFF00LibCustomNames|r, um benutzerdefinierte Icons, Spitznamen und Stile von anderen Hodor-Nutzern – einschließlich deiner Freunde und Gildenmitglieder – zu sehen. Verwandle das Schlachtfeld in etwas Persönliches und Charaktervolles!\n\nDas ist vollkommen optional und nicht erforderlich, damit HodorReflexes funktioniert.",
    HR_MISSING_LIBS_OK = "OK",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Nicht noch einmal anzeigen",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end