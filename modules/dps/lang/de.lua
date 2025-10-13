-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_DPS_FRIENDLYNAME = "Schaden",
    HR_MODULES_DPS_DESCRIPTION = "Ermöglicht es dir, die Schadensstatistiken deiner Gruppe zu sehen.",

    HR_MODULES_DPS_DAMAGE = "Schaden",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Gesamtschaden",
    HR_MODULES_DPS_DAMAGE_MISC = "Sonstiges",
    HR_MODULES_DPS_DPS_BOSS = "Boss DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Gesamt DPS",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end