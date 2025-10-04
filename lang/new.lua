-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    -------------------------
    -- Missing Libraries
    -------------------------
    HR_MISSING_LIBS_TITLE = "Get the Full HodorReflexes Experience!",
    HR_MISSING_LIBS_TEXT = "|c00FF00You're missing out on the full HodorReflexes experience!|r\n\nInstall |cFFFF00LibCustomIcons|r and |cFFFF00LibCustomNames|r to see custom icons, nicknames, and styles from other Hodor users including your friends and guildmates. Transform the battlefield into something personal and full of character!\n\nThis is entirely optional and not required for HodorReflexes to function.",
    HR_MISSING_LIBS_OK = "OK",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Don't show again",

}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end