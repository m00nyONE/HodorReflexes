-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_SKILLLINES_FRIENDLYNAME = "Skill Lines",
    HR_MODULES_SKILLLINES_DESCRIPTION = "Allows you to track which subclassing skill lines your group members use.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end