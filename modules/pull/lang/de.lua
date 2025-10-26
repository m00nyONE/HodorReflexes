-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_PULL_FRIENDLYNAME = "Pull Countdown",
    HR_MODULES_PULL_DESCRIPTION = "Erlaubt es dir pull countdowns an deine Gruppe zu senden.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Pull Countdown",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Countdown Dauer",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Setzt die standard COuntdown Dauer in Sekunden.",
    HR_MODULES_PULL_NOT_LEADER = "Du musst der Gruppenleiter sein um einen Countdown zu starten!",
    HR_MODULES_PULL_COMMAND_HELP = "Startet einen Pull Countdown mit der angegebenen Dauer in Sekunden.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end