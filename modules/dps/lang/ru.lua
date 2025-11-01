-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_DPS_FRIENDLYNAME = "Damage",
    HR_MODULES_DPS_DESCRIPTION = "Позволяет видеть статистику наносимого группой урона.",

    HR_MODULES_DPS_DAMAGE = "Урон",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Общий урон",
    HR_MODULES_DPS_DAMAGE_MISC = "Разное",
    HR_MODULES_DPS_DPS_BOSS = "Босс DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Общий DPS",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end
