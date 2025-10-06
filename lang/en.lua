-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {

    -------------------------
    -- HUD
    -------------------------
    HR_CORE_HUD_COMMAND_LOCK_HELP = "Lock the addon UI",
    HR_CORE_HUD_COMMAND_UNLOCK_HELP = "Unlock the addon UI",
    HR_CORE_HUD_COMMAND_LOCK_ACTION = "UI locked",
    HR_CORE_HUD_COMMAND_UNLOCK_ACTION = "UI unlock",
    -------------------------
    -- Group
    -------------------------
    HR_CORE_GROUP_COMMAND_TEST_HELP = "Start/stop a test",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_START = "Test started",
    HR_CORE_GROUP_COMMAND_TEST_ACTION_STOP = "Test stopped",
    HR_CORE_GROUP_COMMAND_TEST_LEAVE_GROUP = "You must leave the group to start a test",
    -------------------------
    -- LibCheck
    -------------------------
    HR_MISSING_LIBS_TITLE = "Get the Full HodorReflexes Experience!",
    HR_MISSING_LIBS_TEXT = "|c00FF00You're missing out on the full HodorReflexes experience!|r\n\nInstall |cFFFF00LibCustomIcons|r and |cFFFF00LibCustomNames|r to see custom icons, nicknames, and styles from other Hodor users including your friends and guildmates. Transform the battlefield into something personal and full of character!\n\nThis is entirely optional and not required for HodorReflexes to function.",
    HR_MISSING_LIBS_TEXT_CONSOLE = "|c00FF00You're missing out on the full HodorReflexes experience!|r\n\nInstall |cFFFF00LibCustomNames|r to see custom nicknames, and styles from other Hodor users including your friends and guildmates. Transform the battlefield into something personal and full of character!\n\nThis is entirely optional and not required for HodorReflexes to function.",
    HR_MISSING_LIBS_OK = "OK",
    HR_MISSING_LIBS_DONTSHOWAGAIN = "Don't show again",

}

for id, val in pairs(strings) do
   ZO_CreateStringId(id, val)
   SafeAddVersion(id, 1)
end