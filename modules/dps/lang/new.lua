-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_DPS_FRIENDLYNAME = "Damage",
    HR_MODULES_DPS_DESCRIPTION = "Allows you to see damage statistics of your group.",

    HR_MODULES_DPS_DAMAGE = "Damage",
    HR_MODULES_DPS_DAMAGE_TOTAL = "Total Damage",
    HR_MODULES_DPS_DAMAGE_MISC = "Misc",
    HR_MODULES_DPS_DPS_BOSS = "Boss DPS",
    HR_MODULES_DPS_DPS_TOTAL = "Total DPS",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end