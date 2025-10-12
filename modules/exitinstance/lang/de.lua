-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_EXITINSTANCE_FRIENDLYNAME = "Instanz verlassen",
    HR_MODULES_EXITINSTANCE_DESCRIPTION = "Ermöglicht es dir, Anfragen zum Verlassen der Instanz an deine Gruppe zu senden.",
    HR_MODULES_EXITINSTANCE_BINDING_SENDEXITINSTANCEREQUEST = "Gruppe rauswerfen",
    HR_MODULES_EXITINSTANCE_BINDING_EXITINSTANCE = "Instanz sofort verlassen",
    HR_MODULES_EXITINSTANCE_COMMAND_HELP = "Sendet eine Anfrage an deine Gruppe, die aktuelle Instanz zu verlassen.",
    HR_MODULES_EXITINSTANCE_NOT_LEADER = "Du musst Gruppenleiter sein, um eine Instanz-verlassen-Anfrage zu starten!",
    HR_MODULES_EXITINSTANCE_DIALOG_TITLE = "Gruppe rauswerfen",
    HR_MODULES_EXITINSTANCE_DIALOG_MAIN_TEXT = "Möchtest du, dass alle die Instanz verlassen (einschließlich dir selbst)?",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT = "Verlassen bestätigen",
    HR_MODULES_EXITINSTANCE_MENU_CONFIRM_EXIT_TT = "Wenn aktiviert, wirst du vor dem Verlassen der Instanz um Bestätigung gebeten.",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS = "Anfragen ignorieren",
    HR_MODULES_EXITINSTANCE_MENU_IGNORE_REQUESTS_TT = "Wenn aktiviert, ignorierst du alle Instanz-verlassen-Anfragen deines Gruppenleiters.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end