-- SPDX-FileCopyrightText: 2025 m00nyONE
-- SPDX-License-Identifier: Artistic-2.0

local strings = {
    HR_MODULES_PULL_FRIENDLYNAME = "Pull Countdown",
    HR_MODULES_PULL_DESCRIPTION = "Allows you to send pull countdowns to your group.",
    HR_MODULES_PULL_BINDING_COUNTDOWN = "Pull Countdown",
    HR_MODULES_PULL_COUNTDOWN_DURATION = "Countdown Duration",
    HR_MODULES_PULL_COUNTDOWN_DURATION_TT = "Set the duration of the pull countdown in seconds.",
    HR_MODULES_PULL_NOT_LEADER = "You must be a group leader to initiate a countdown!",
    HR_MODULES_PULL_COMMAND_HELP = "Starts a pull countdown.",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end