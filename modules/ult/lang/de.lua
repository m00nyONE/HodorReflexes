-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_ULT_FRIENDLYNAME = "Ultimates",
    HR_MODULES_ULT_DESCRIPTION = "Ermöglicht es dir, die Ultimate-Statistiken deiner Gruppe zu sehen.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end